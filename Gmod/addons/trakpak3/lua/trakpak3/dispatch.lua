--MsgC(Trakpak3.Magenta,"Running Dispatch Library\n")

Trakpak3.Dispatch = {}
Trakpak3.Dispatch.InitData = {}
Trakpak3.Dispatch.MapBoards = {}
Trakpak3.Dispatch.Loaded = false
Trakpak3.Dispatch.Attempted = false

local function tryDispatch()
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
				if name and (name!="") then Trakpak3.Dispatch.InitData[name] = { ctc_state = ent.ctc_state, pos = ent:GetPos() } end
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_switch_lever_anim")) do
				local st
				if ent.state then st = 1 else st = 0 end
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[ent:GetName()] = { state = st, broken = 0, blocked = 0, interlocked = 0, pos = ent:GetPos() } end
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_signal_block")) do
				local occ
				if ent.occupied then occ = 1 else occ = 0 end
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[ent:GetName()] = { occupied = occ, pos = ent:GetPos() } end
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_logic_gate")) do
				local occ
				if ent.occupied then occ = 1 else occ = 0 end
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[ent:GetName()] = { occupied = occ, pos = ent:GetPos() } end
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_dispatch_proxy")) do
				local state = ent.state or 0
				local name = ent:GetName()
				if name and (name!="") then Trakpak3.Dispatch.InitData[ent:GetName()] = { setstate = state, pos = ent:GetPos() } end
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
end

hook.Add("InitPostEntity","TP3_DispLoad", tryDispatch)
hook.Add("PostCleanUpMap","TP3_DispLoad", tryDispatch)

--Receive DS Board request from client
--Send Dispatch Board data to Client
--util.AddNetworkString("tp3_transmit_ds")
--util.AddNetworkString("tp3_transmit_dsdata")
--[[
net.Receive("tp3_transmit_ds",function(len, ply)
	print("[Trakpak3] Received dispatch board data request.")
	Trakpak3.Dispatch.SendDSData(ply)
end)
]]--
Trakpak3.Net.tp3_transmit_ds = function(len,ply)
	print("[Trakpak3] Received dispatch board data request.")
	Trakpak3.Dispatch.SendDSData(ply)
end

function Trakpak3.Dispatch.SendDSData(ply)
	if Trakpak3.Dispatch.Loaded then
		--local JSON = util.TableToJSON(Trakpak3.Dispatch.InitData)
		--JSON = util.Compress(JSON)
		--net.Start("tp3_transmit_dsdata")
		net.Start("trakpak3")
		net.WriteString("tp3_transmit_dsdata")
		--net.WriteData(JSON,#JSON)
		net.WriteTable(Trakpak3.Dispatch.InitData)
		net.Send(ply)
		
		--local JSON = util.TableToJSON(Trakpak3.Dispatch.MapBoards)
		--JSON = util.Compress(JSON)
		--net.Start("tp3_transmit_ds")
		net.Start("trakpak3")
		--net.WriteData(JSON,#JSON)
		net.WriteString("tp3_transmit_ds")
		net.WriteTable(Trakpak3.Dispatch.MapBoards)
		net.Send(ply)
	elseif not Trakpak3.Dispatch.Attempted then --Didn't succeed or fail yet, wait 1 second and try again
		timer.Simple(1,function() Trakpak3.Dispatch.SendDSData(ply) end)
	end
end



--util.AddNetworkString("tp3_dispatch_comm")
--Send Parameter to Clients
function Trakpak3.Dispatch.SendInfo(entname, parm, value, dtype)
	if Trakpak3.Dispatch.Loaded and entname and (entname!="") then
		
		if not dtype then dtype = "int" end
		
		Trakpak3.Dispatch.InitData[entname][parm] = value
		--net.Start("tp3_dispatch_comm")
		net.Start("trakpak3")
			net.WriteString("tp3_dispatch_comm")
			net.WriteString(entname)
			net.WriteString(parm)
			net.WriteString(dtype)
			if dtype=="int" then
				net.WriteUInt(value,16)
			elseif dtype=="string" then
				net.WriteString(value)
			end
		net.Broadcast()
		--print(entname, parm, value)
	end
end

Trakpak3.Dispatch.CommandLog = {}

--Receive Command from a DS board
Trakpak3.Net.tp3_dispatch_comm = function(len,ply)
	local entname = net.ReadString()
	local cmd = net.ReadString()
	local arg = net.ReadUInt(3)
	local tt = string.FormattedTime(CurTime()) --time table
	table.insert(Trakpak3.Dispatch.CommandLog, "[" .. tt.h .. "h:" .. tt.m .."m:" .. tt.s .. "s] " .. ply:GetName() .. " ENT " .. entname .. " CMD " .. cmd .. " ARG " .. arg)
	hook.Run("TP3_Dispatch_Command", entname, cmd, arg)
end

--Teleport Player to Element
Trakpak3.Net.tp3_dispatch_teleport = function(len,ply)
	local pos = net.ReadVector()
	ply:SetPos(pos + Vector(0,0,64))
	if ply:GetMoveType()==MOVETYPE_WALK then
		--ply:ConCommand("noclip")
		ply:SetMoveType(MOVETYPE_NOCLIP)
	end
end

--Received Dispatch Command Log request from player
Trakpak3.Net.tp3_dispatch_printlog = function(len, ply)
	--Make the list as a bigass string
	local tt = string.FormattedTime(CurTime())
	local commandlog = "Dispatch Command Log:\n\nThe current time is [" .. tt.h .. "h:" .. tt.m .."m:" .. tt.s .. "s]\n"
	local count = #Trakpak3.Dispatch.CommandLog
	for n = 0, count-1 do
		commandlog = commandlog.."\n"..Trakpak3.Dispatch.CommandLog[count - n] --Add log to message, starting with most recent.
		if #commandlog > 65000 then
			commandlog = commandlog.."\nMaximum Net Message Length Reached!"
			break
		end --Terminate the loop if the string is too long
	end
	
	
	--Compress it
	--local data = util.Compress(commandlog)
	--local dlen = #data --Number of bytes
	net.Start("trakpak3") --Send it
		net.WriteString("tp3_dispatch_printlog")
		--net.WriteUInt(dlen,16)
		--net.WriteData(data)
		net.WriteString(commandlog)
	net.Send(ply)
end

--[[
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
]]--