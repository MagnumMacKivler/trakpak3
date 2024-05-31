--LOADA
--(Gets hit in the face with a ton of data)
Trakpak3.Loada = {}
local Loada = Trakpak3.Loada

local LoadStartTime = 0
	
--Console Variable for moderating the packet size Trakpak3 sends to clients
local kb_cvar = CreateClientConVar("tp3_loada_packetsize", 10, true, false, "The maximum packet size, in kilobytes, for the server to send map data to the client. Must be an integer between 1 and 60. Lowering this value can help mitigate 'Reliable Channel Overflow' errors.",1,60)

--Ask for Trakpak3 data from server after joining. See clientloader.lua for details.
hook.Add("InitPostEntity","Trakpak3_RequestServerData",function()
	Trakpak3.NetStart("tp3_requestserverdata")
		net.WriteUInt(kb_cvar:GetInt(),6)
		--print(kb_cvar:GetInt(),"Kilobytes")
	net.SendToServer()
	LoadStartTime = SysTime()
	MsgC(Trakpak3.Magenta, "[Trakpak3] Initiating Client Loading...\n")
end)

Loada.PacketDestinations = {
	Trakpak3.ReceiveBlockPack,	--1
	Trakpak3.ReceiveSignalPack,	--2
	Trakpak3.ReceiveCSPosPack,	--3
	Trakpak3.ReceiveSwitchPack,	--4
	Trakpak3.ReceiveGatePack,	--5
	Trakpak3.ReceivePathPack,	--6
	Trakpak3.ReceiveSignalSystemPack,	--7
	Trakpak3.ReceiveDSPack,		--8
	Trakpak3.ReceiveDSBoards,	--9
	Trakpak3.ReceiveSignPack	--10
}


local ChunkBuffer = {} --Table containing all received chunks prior to assembly.
local ChunkRequirements = {} --Table containing the expected number of chunks prior to assembly.

--Receive a packet from the server
Trakpak3.Net["tp3_sendserverdata"] = function(len, ply)
	local packet = net.ReadUInt(16)
	local piece = net.ReadUInt(16)
	local maxpieces = net.ReadUInt(16)
	local chunk = net.ReadString()
	
	if not ChunkBuffer[packet] or not ChunkRequirements[packet] then --New data packet!
		ChunkBuffer[packet] = {}
		ChunkRequirements[packet] = maxpieces
	end
	
	ChunkBuffer[packet][piece] = chunk
	
	--Evaluate whether you've got everything or not
	local JSON = ""
	for n=1,ChunkRequirements[packet] do
		if not ChunkBuffer[packet][n] then
			JSON = false
			break
		end
	end
	
	--Create complete string, if ready.
	if JSON then
		for n=1,ChunkRequirements[packet] do
			JSON = JSON..ChunkBuffer[packet][n]
		end
		ChunkBuffer[packet] = nil
		ChunkRequirements[packet] = nil
		local tbl = util.JSONToTable(JSON)
		
		
		--Execute the destination function with the received data!
		local callback = Loada.PacketDestinations[packet]
		callback(tbl)
		
		--Print Progress
		local progress = math.Round(100*packet/#Loada.PacketDestinations)
		MsgC(Trakpak3.Magenta,"[Trakpak3] Loading... "..progress.."%, "..maxpieces.." Packets\n")
		
		if packet==#Loada.PacketDestinations then --You're Done!
			local load_duration = SysTime()-LoadStartTime
			MsgC(Trakpak3.Magenta,"[Trakpak3] Loading Complete! Took "..math.Round(load_duration,6).." seconds.\n")
			LoadStartTime = nil
			Trakpak3.InitPostEntity = true
		end
	end
	
	--Send a receipt message back to the server.
	Trakpak3.NetStart("tp3_serverdata_receipt")
		net.WriteUInt(packet,16)
		net.WriteUInt(piece,16)
	net.SendToServer()
end

--Server tells you that you're done
Trakpak3.Net["tp3_serverdata_finished"] = function()
	if LoadStartTime then
		local load_duration = SysTime()-LoadStartTime
		MsgC(Trakpak3.Magenta,"[Trakpak3] Loading Complete! Took "..math.Round(load_duration,6).." seconds.\n")
		LoadStartTime = nil
		Trakpak3.InitPostEntity = true
	end
end