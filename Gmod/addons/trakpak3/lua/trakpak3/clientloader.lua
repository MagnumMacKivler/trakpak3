--LOADA
--(Fires a massive stream of data in your face)

--[[

List of all things that get sent to the client on join:

nodesetup.lua:
	Blockpack, Signal Pack, Switchpack, Logic Gatepack, Pathconfigpack, Cabsignal Pospack (tp3_request_blockpack) from cl_nodesetup.lua. This is the big one!
	
signalsetup.lua
	Signal Systems Pack (trakpak3_getsignalsystems) from cl_signalvision.lua

dispatch.lua
	Dispatch Data (tp3_transmit_ds) from cl_dispatch.lua
	
signtext.lua
	Sign Data (Trakpak3_RequestSignData) from cl_signtext.lua


]]--


Trakpak3.Loada = {}
local Loada = Trakpak3.Loada

--The list of data packets to send to client. The elements are indexed numerically and consist of the callback that returns the data.
Loada.Schedule = {
	Trakpak3.GetBlockPack,	--1
	Trakpak3.GetSignalPack,	--2
	Trakpak3.GetCSPosPack,	--3
	Trakpak3.GetSwitchPack,	--4
	Trakpak3.GetGatePack,	--5
	Trakpak3.GetPathPack,	--6
	Trakpak3.GetSignalSystemPack,	--7
	Trakpak3.GetDSPack,		--8
	Trakpak3.GetDSBoards,	--9
	Trakpak3.GetSignPack,	--10
}
--[index] = Callback


--Convert an input table to a string and return it in <=60kB (61440 B) chunks
function Loada.PackageTable(tbl)
	if not tbl or table.IsEmpty(tbl) then return end
	
	local json = util.TableToJSON(tbl)
	local totalbytes = #json
	local numchunks = math.ceil(totalbytes/61440)
	local chunks = {}
	for n = 1, numchunks do
		local startpos = (n-1)*61440 + 1
		local endpos = n*61440
		chunks[n] = string.sub(json, startpos, math.min(endpos, totalbytes))
	end
	return chunks
end


Loada.COs = {} --Table of active coroutines, indexed by player.



--Send a data packet, chunk by chunk
local function SpewChunks(ply, chunks, packet)
	if not (ply and ply:IsValid()) then return false end --Exit and kill the coroutine if the player is gone
	if chunks then
		local currentpacket = packet --Store the data packet the client should be receiving
		local piece = 1
		while piece <= #chunks do --I can't believe I'm actually using a while loop but setting the index of a for loop outside the predefined range causes the loop to fail.
			if not (ply and ply:IsValid()) then return false end --Exit and kill the coroutine if the player is gone
			local chunk = chunks[piece]
			Trakpak3.NetStart("tp3_sendserverdata")
				net.WriteUInt(packet, 16) --Which data?
				net.WriteUInt(piece, 16) --Which piece?
				net.WriteUInt(#chunks, 16) --How many pieces to expect?
				net.WriteString(chunk) --The payload
			net.Send(ply)
			local recpacket, recpiece
			ply, recpacket, recpiece = coroutine.yield() --Pause this coroutine and wait for player receipt. Read the receipt data from the client.
			if not (ply and ply:IsValid()) then return false end --Exit and kill the coroutine if the player is gone
			if (recpacket != currentpacket) or (recpiece != piece) then --Client is reporting receipt of something other than the packet we just sent. Start over
				piece = 1
			else --Proceed normally
				piece = piece + 1
			end
		end
	end
	return true --All done!
end

--The master Spewing Function, send all the info to the client in order.
local function SpewMaster(ply)
	if not (ply and ply:IsValid()) then return end --Exit and kill the coroutine if the player is gone
	
	for packet, callback in ipairs(Loada.Schedule) do
		local chunks = Loada.PackageTable(callback()) --Retrieve the data table and split it into chunks
		if chunks then --There is data
			local result = SpewChunks(ply, chunks, packet) --Start sending it to client
			if not result then return end --SpewChunks returned false because the player is gone. Return and kill the coroutine.
		end
	end
	
	if not (ply and ply:IsValid()) then return end --Exit and kill the coroutine if the player is gone
	Trakpak3.NetStart("tp3_serverdata_finished") --Tell the client we're finished
	net.Send(ply)
	
end


--A player has requested the server data, set up the coroutine.
Trakpak3.Net["tp3_requestserverdata"] = function(len, ply)
	if IsValid(ply) and ( not Loada.COs[ply] or not coroutine.resume(Loada.COs[ply]) ) then --Player is real and is not currently requesting data
		Loada.COs[ply] = coroutine.create(SpewMaster) --Create a new coroutine for sending data to the player
		coroutine.resume(Loada.COs[ply], ply) --And start it, passing the player arg
	end
end

--A player has acknowledged receipt of a packet.
Trakpak3.Net["tp3_serverdata_receipt"] = function(len, ply) 
	if IsValid(ply) and Loada.COs[ply] then
		local lastpacket = net.ReadUInt(16) --The packet number the player received.
		local lastpiece = net.ReadUInt(16) --The piece number the player received.
		coroutine.resume(Loada.COs[ply], ply, lastpacket, lastpiece) --Restart the coroutine with the new data
	end
end