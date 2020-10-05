--Set up all the signal blocks

hook.Add("InitPostEntity","TP3_NodeLoad",function()
	local json = file.Read("trakpak3/nodes/"..game.GetMap()..".lua","LUA")

	if json then --Found a file!
		local ftable = util.JSONToTable(json)
		if ftable then
			Trakpak3.NodeList = ftable.NodeList
			Trakpak3.NodeChainList = ftable.NodeChainList
		end
		if Trakpak3.NodeList and Trakpak3.NodeChainList then
			print("[Trakpak3] Node file trakpak3/nodes/"..game.GetMap()..".lua loaded successfully! Block Report:\n")
			
			for block_name, chain in pairs(Trakpak3.NodeChainList) do
				local block_ent, valid = Trakpak3.FindByTargetname(block_name)
				if valid then
					block_ent:SetupNodes(chain)
				else
					print("[Trakpak3] Signal Block '"..block_name.."' in node file does not exist in map!")
				end
			end
			
		else
			print("[Trakpak3] Error loading node file trakpak3/nodes/"..game.GetMap()..".lua!")
		end
	else
		print("[Trakpak3] Could not locate a suitable node file (trakpak3/nodes/"..game.GetMap()..".lua), the signals are probably not going to work!")
	end
end)

util.AddNetworkString("tp3_request_blockpack")

--Send all the block entity info to the client so they can actually bind the blocks - should only be useful in singleplayer. Also does signal Cabsignal Points.
--Also does Signals and Switches for DS boards
net.Receive("tp3_request_blockpack", function(length, ply)
	
	print("[Trakpak3] Received Blockpack Request from player.")
	
	local blockpack = {BlockData = {}, NodeList = Trakpak3.NodeList}
	
	--key: name
	--value: pos
	
	local allblocks = ents.FindByClass("tp3_signal_block")
	if allblocks then
		for k, block in pairs(allblocks) do
			local pos
			local tr = {
				start = block:GetPos(),
				endpos = block:GetPos() + Vector(0,0,-512)
			}
			local trace = util.TraceLine(tr)
			if trace.Hit then pos = trace.HitPos else pos = tr.endpos end
			
			blockpack.BlockData[block:GetName()] = {
				pos = pos,
				nodes = block.nodes,
				skips = block.skips,
				lw = block.hull_lw,
				h = block.hull_h,
				offset = block.hull_offset,
				occupied = block.occupied
			}
		end
	end
	
	if table.IsEmpty(blockpack) then
		print("[Trakpak3] There are no Trakpak3 signal blocks on this map to send to client.")
	else
		--print("The table is NOT empty.")
		local JSON = util.TableToJSON(blockpack)
		JSON = util.Compress(JSON)
		util.AddNetworkString("tp3_blockpack")
		net.Start("tp3_blockpack")
		net.WriteData(JSON,#JSON)
		net.Send(ply)
	end
	
	--Signals and Cab Signal Positions
	local allsigs = ents.FindByClass("tp3_signal_master")
	local positions = {}
	local signals = {}
	if allsigs then
	
		for _, signal in pairs(allsigs) do
			table.insert(positions, signal.cs_pos)
			
			local name = signal:GetName()
			if name and (name!="") then
				signals[name] = signal:GetPos()
			end
		end
		
		--CS Pos
		local JSON = util.TableToJSON(positions)
		JSON = util.Compress(JSON)
		util.AddNetworkString("tp3_cabsignal_pospack")
		net.Start("tp3_cabsignal_pospack")
		net.WriteData(JSON,#JSON)
		net.Send(ply)
		
		--Signal Pos
		local JSON = util.TableToJSON(signals)
		JSON = util.Compress(JSON)
		util.AddNetworkString("tp3_signalpack")
		net.Start("tp3_signalpack")
		net.WriteData(JSON,#JSON)
		net.Send(ply)
	end
	
	--Switches
	local allswitches = ents.FindByClass("tp3_switch_lever_anim")
	local switches = {}
	if allswitches then
		for _, switch in pairs(allswitches) do
			local name = switch:GetName()
			if name and (name!="") then
				switches[name] = switch:GetPos()
			end
		end
		
		--Switch Pos
		local JSON = util.TableToJSON(switches)
		JSON = util.Compress(JSON)
		util.AddNetworkString("tp3_switchpack")
		net.Start("tp3_switchpack")
		net.WriteData(JSON,#JSON)
		net.Send(ply)
		
	end
	
end)

--Clipboard
--[[
util.AddNetworkString("tp3_clipboard")
net.Receive("tp3_clipboard",function(len, ply)
	local text = net.ReadString() or ""
	ply:SetNWString("tp3_clipboard",text)
end)
hook.Add("KeyPress","Trakpak3_Clipboard",function(ply, key)
	if key==IN_USE then
		local cbt = ply:GetNWString("tp3_clipboard")
		print(ply, cbt)
		if cbt and (cbt!="") then
			net.Start("tp3_clipboard")
			net.Send(ply)
		end
	end
end)
]]--
