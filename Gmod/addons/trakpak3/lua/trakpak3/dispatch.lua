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
			
			--Sift through the dispatch data and enable train tag recording for all blocks on the dispatch board
			for _, page in pairs(ftable) do --For each page:
				if page.elements then
					for __, element in pairs(page.elements) do --For each element in the page:
						if element.type=="block" and element.block and element.block!="" then --If it's a valid block with a valid value
							local block, valid = Trakpak3.FindByTargetname(element.block)
							if valid then block.RecordTrainTags = true end
						end
					end
				end
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

--Return the dispatch entity status data
Trakpak3.GetDSPack = function()
	if not Trakpak3.Dispatch.InitData or table.IsEmpty(Trakpak3.Dispatch.InitData) then
		return nil
	else
		return Trakpak3.Dispatch.InitData
	end
end

--Return the dispatch board configuration data
Trakpak3.GetDSBoards = function()
	if not Trakpak3.Dispatch.MapBoards or table.IsEmpty(Trakpak3.Dispatch.MapBoards) then
		return nil
	else
		return Trakpak3.Dispatch.MapBoards
	end
end


--Send Parameter to Clients
function Trakpak3.Dispatch.SendInfo(entname, parm, value, dtype)
	if Trakpak3.Dispatch.Loaded and entname and (entname!="") then
		
		if not dtype then dtype = "int" end
		
		Trakpak3.Dispatch.InitData[entname][parm] = value
		--net.Start("tp3_dispatch_comm")
		Trakpak3.NetStart("tp3_dispatch_comm")
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
	local isname = net.ReadBool()
	local pos
	if isname then --String targetname
		local ent, valid = Trakpak3.FindByTargetname(net.ReadString())
		if valid then
			if ent:GetClass()=="tp3_signal_block" then
				if ent.occupied and ent.HitEntity and ent.HitEntity:IsValid() then
					pos = ent.HitEntity:GetPos()
				else
					pos = ent:GetPos()
				end
			end
		end
	else --Vector Target
		pos = net.ReadVector()
	end
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

--Global Signal/Switch CTC Controls (Admin Only)
local function AdminCommand(ply, cmd, arg)
	if cmd=="setsignals" then
	
		for _, Board in pairs(Trakpak3.Dispatch.MapBoards) do --For every dispatch board page...
			for __, Element in pairs(Board.elements) do --For every element on that dispatch board...
				if Element.signal and (Element.type=="signal") then --Element is a signal and it is valid
					local signal, valid = Trakpak3.FindByTargetname(Element.signal)
					if valid then
						hook.Run("TP3_Dispatch_Command", Element.signal, "set_ctc", arg)
					end --Set CTC State
				end
			end
		end
		
		Trakpak3.NetStart("tp3_dispatch_admin")
			net.WriteString(ply and ply:GetName() or "A Remote Admin")
			net.WriteString(cmd)
			net.WriteUInt(arg,8)
		net.Broadcast()
		
	elseif cmd=="resetswitches" then
	
		if arg==0 then --CTC Switches Only
			for _, Board in pairs(Trakpak3.Dispatch.MapBoards) do --For every dispatch board page...
				for __, Element in pairs(Board.elements) do --For every element on that dispatch board...
					if Element.switch and (Element.type=="switch") then --Element is a signal and it is valid
						local switch, valid = Trakpak3.FindByTargetname(Element.switch)
						if valid then
							switch:SetTargetState(false)
						end 
					end
				end
			end
			
		elseif arg==1 then --All switches in the map
			for _, switch in pairs(ents.FindByClass("tp3_switch_lever_anim")) do
				if switch.levertype and (switch.levertype!=3) then --Include all switches and derails but not "generic" levers like those for turntable locks
					switch:SetTargetState(false)
				end
			end
		end
		
		Trakpak3.NetStart("tp3_dispatch_admin")
			net.WriteString(ply and ply:GetName() or "A Remote Admin")
			net.WriteString(cmd)
			net.WriteUInt(arg,8)
		net.Broadcast()
		
	end
end

--From Client
Trakpak3.Net.tp3_dispatch_admin = function(len, ply)
	if ply and ply:IsValid() and ply:IsAdmin() then
		local cmd = net.ReadString()
		local arg = net.ReadUInt(8)
		AdminCommand(ply, cmd, arg)
	end
end

--Serverside Commands
local function setsignals(ply, cmd, args)
	if not args[1] then
		print("Set all CTC signals (the ones on the dispatch board) to Hold or Allow. Accepted arguments are 'hold' and 'allow'. Only works for Admins.")
		return nil
	end
	
	args[1] = string.lower(args[1])
	
	local state
	if args[1]=="hold" then
		state = 0
	elseif args[1]=="allow" then
		state = 2
	end
	
	if state then
		AdminCommand(nil,"setsignals",state)
		print("Asking the server to set all signals to "..args[1]..".")
	else
		print("Set all CTC signals (the ones on the dispatch board) to Hold or Allow. Accepted arguments are 'hold' and 'allow'. Only works for Admins.")
	end
end
local function autocomplete(cmd, args)
	return {"hold", "allow"}
end
concommand.Add("tp3_dispatch_setsignals", setsignals, autocomplete, "Set all CTC signals (the ones on the dispatch board) to Hold or Allow. Accepted arguments are 'hold' and 'allow'. Only works for Admins.")

--Mass Switch Reset
local function resetswitches(ply, cmd, args)
	if not args[1] then
		print("Resets all CTC switches (the ones on the dispatch board) or all switches in the map. Accepted arguments are 'ctc' and 'map'. Only works for Admins.")
		return nil
	end
	
	args[1] = string.lower(args[1])
	
	local state
	if args[1]=="ctc" then
		state = 0
	elseif args[1]=="map" then
		state = 1
	end
	
	if state then
		AdminCommand("resetswitches",state)
		print("Asking the server to reset all "..args[1].." switches.")
	else
		print("Resets all CTC switches (the ones on the dispatch board) or all switches in the map. Accepted arguments are 'ctc' and 'map'. Only works for Admins.")
	end
end
local function autocomplete2(cmd, args)
	return {"ctc", "map"}
end
concommand.Add("tp3_dispatch_resetswitches", setswitches, autocomplete2, "Resets all CTC switches (the ones on the dispatch board) or all switches in the map. Accepted arguments are 'ctc' and 'map'. Only works for Admins.")

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