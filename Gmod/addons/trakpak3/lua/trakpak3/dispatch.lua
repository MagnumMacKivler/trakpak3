--MsgC(Trakpak3.Magenta,"Running Dispatch Library\n")

Trakpak3.Dispatch = {}
Trakpak3.Dispatch.InitData = {}
Trakpak3.Dispatch.MapBoards = {}
Trakpak3.Dispatch.Loaded = false
Trakpak3.Dispatch.Attempted = false

hook.Add("InitPostEntity","TP3_DispLoad",function()
	--MsgC(Trakpak3.Magenta,"InitPostEntity! Looking for file trakpak3/dispatch/"..game.GetMap()..".lua")
	local json = file.Read("trakpak3/dispatch/"..game.GetMap()..".lua","LUA")

	if json then --Found a file!
		--MsgC(Trakpak3.Magenta,"Found a file! Converting contents to a table.")
		local ftable = util.JSONToTable(json)
		if ftable then
			print("[Trakpak3] Dispatch Board file trakpak3/dispatch/"..game.GetMap()..".lua loaded successfully!")
			Trakpak3.Dispatch.MapBoards = ftable
			
			for id, ent in pairs(ents.FindByClass("tp3_signal_master")) do
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[name] = { ctc_state = ent.ctc_state } end
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_switch_lever_anim")) do
				local st
				if ent.state then st = 1 else st = 0 end
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[ent:GetName()] = { state = st, broken = 0, blocked = 0 } end
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_signal_block")) do
				local occ
				if ent.occupied then occ = 1 else occ = 0 end
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[ent:GetName()] = { occupied = occ } end
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_logic_gate")) do
				local occ
				if ent.occupied then occ = 1 else occ = 0 end
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[ent:GetName()] = { occupied = occ } end
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_dispatch_proxy")) do
				local state = ent.state or 0
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[ent:GetName()] = { setstate = state } end
			end
			
			Trakpak3.Dispatch.Loaded = true
		else
			--MsgC(Trakpak3.Magenta,"Could not convert JSON to Table correctly!")
			print("[Trakpak3] Could not convert JSON to Table correctly!")
		end
	else
		print("[Trakpak3] Could not locate a suitable Dispatch Board file (trakpak3/dispatch/"..game.GetMap()..".lua).")
	end
	Trakpak3.Dispatch.Attempted = true
end)

--Receive DS Board request from client
--Send Dispatch Board data to Client
util.AddNetworkString("tp3_transmit_ds")
util.AddNetworkString("tp3_transmit_dsdata")

net.Receive("tp3_transmit_ds",function(len, ply)
	print("[Trakpak3] Received dispatch board data request.")
	Trakpak3.Dispatch.SendDSData(ply)
end)

function Trakpak3.Dispatch.SendDSData(ply)
	if Trakpak3.Dispatch.Loaded then
		local JSON = util.TableToJSON(Trakpak3.Dispatch.InitData)
		JSON = util.Compress(JSON)
		net.Start("tp3_transmit_dsdata")
		net.WriteData(JSON,#JSON)
		net.Send(ply)
		
		local JSON = util.TableToJSON(Trakpak3.Dispatch.MapBoards)
		JSON = util.Compress(JSON)
		net.Start("tp3_transmit_ds")
		net.WriteData(JSON,#JSON)
		net.Send(ply)
	elseif not Trakpak3.Dispatch.Attempted then --Didn't succeed or fail yet, wait 1 second and try again
		timer.Simple(1,function() Trakpak3.Dispatch.SendDSData(ply) end)
	end
end



util.AddNetworkString("tp3_dispatch_comm")
--Send Parameter to Clients
function Trakpak3.Dispatch.SendInfo(entname, parm, value)
	if Trakpak3.Dispatch.Loaded and entname and (entname!="") then
		--if Trakpak3.Dispatch then print("Dispatch") end
		--if Trakpak3.Dispatch.InitData then print("InitData") end
		--if Trakpak3.Dispatch.InitData[entname] then print("Entname") end
		Trakpak3.Dispatch.InitData[entname][parm] = value
		--print("Sending to Client: ",entname, parm, value)
		net.Start("tp3_dispatch_comm")
			net.WriteString(entname)
			net.WriteString(parm)
			net.WriteUInt(value,3)
		net.Broadcast()
	end
end

Trakpak3.Dispatch.CommandLog = {}

--Receive Command from a DS board
net.Receive("tp3_dispatch_comm", function(mlen, ply)
	
	local entname = net.ReadString()
	local cmd = net.ReadString()
	local arg = net.ReadUInt(3)
	
	--print("Update from map: ", entname, cmd, arg)
	
	local tt = string.FormattedTime(CurTime()) --time table
	
	table.insert(Trakpak3.Dispatch.CommandLog, "[" .. tt.h .. "h:" .. tt.m .."m:" .. tt.s .. "s] " .. ply:GetName() .. " ENT " .. entname .. " CMD " .. cmd .. " ARG " .. arg)
	
	hook.Run("TP3_Dispatch_Command", entname, cmd, arg)
end)

concommand.Add("tp3_dispatch_printlog", function(ply, cmd, args)

	if ply:IsAdmin() then
		print("Trakpak3 Dispatch Log:\n")
		for n = 1, #Trakpak3.Dispatch.CommandLog do
			print(Trakpak3.Dispatch.CommandLog[n])
		end
		
		local tt = string.FormattedTime(CurTime())
		print("\nThe current time is [" .. tt.h .. "h:" .. tt.m .."m:" .. tt.s .. "s]")
	end
	
end)