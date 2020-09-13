Trakpak3.Dispatch = {}
Trakpak3.Dispatch.InitData = {}

hook.Add("InitPostEntity","TP3_DispLoad",function()
	local json = file.Read("trakpak3/dispatch/"..game.GetMap()..".lua","LUA")

	if json then --Found a file!
		local ftable = util.JSONToTable(json)
		if ftable then
			print("[Trakpak3] Dispatch Board file trakpak3/dispatch/"..game.GetMap()..".lua loaded successfully!")
			Trakpak3.Dispatch.MapBoards = ftable
			
			for id, ent in pairs(ents.FindByClass("tp3_signal_master")) do
				Trakpak3.Dispatch.InitData[ent:GetName()] = { ctc_state = ent.ctc_state }
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_switch_lever_anim")) do
				local st
				if ent.state then st = 1 else st = 0 end
				Trakpak3.Dispatch.InitData[ent:GetName()] = { state = st, broken = 0, blocked = 0 }
			end
			
			for id, ent in pairs(ents.FindByClass("tp3_signal_block")) do
				local occ
				if ent.occupied then occ = 1 else occ = 0 end
				Trakpak3.Dispatch.InitData[ent:GetName()] = { occupied = occ }
			end
		end
	else
		print("[Trakpak3] Could not locate a suitable Dispatch Board file (trakpak3/dispatch/"..game.GetMap()..".lua).")
	end
end)

--Send Dispatch Board data to Client
util.AddNetworkString("tp3_transmit_ds")
util.AddNetworkString("tp3_transmit_dsdata")
net.Receive("tp3_transmit_ds",function(len, ply)
	print("[Trakpak3] Received dispatch board data request.")
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
end)

util.AddNetworkString("tp3_dispatch_comm")
--Send Parameter to Clients
function Trakpak3.Dispatch.SendInfo(entname, parm, value)
	Trakpak3.Dispatch.InitData[entname][parm] = value
	net.Start("tp3_dispatch_comm")
		net.WriteString(entname)
		net.WriteString(parm)
		net.WriteUInt(value,2)
	net.Broadcast()
end

--Receive Command from a DS board
net.Receive("tp3_dispatch_comm", function(mlen, ply)
	
	local entname = net.ReadString()
	local cmd = net.ReadString()
	local arg = net.ReadUInt(2)
	print("DS Command received: ",entname,cmd, arg)
	hook.Run("TP3_Dispatch_Command", entname, cmd, arg)
end)