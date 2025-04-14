--Set up all the signal blocks
--MsgC(Trakpak3.Magenta,"Running Node Setup\n")

function Trakpak3.LOAD_NODES()
	
	--print("\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA")

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
end


--hook.Add("InitPostEntity","TP3_NodeLoad",load_nodes) 
--hook.Add("PostCleanupMap","TP3_NodeLoad", load_nodes)


function Trakpak3.GetBlockPack() --Return the table of blocks and nodes, aka "The Blockpack"
	if Trakpak3.BlockPack then return Trakpak3.BlockPack end --Skip the rest of the function if the data already exists
	
	Trakpak3.BlockPack = {BlockData = {}, NodeList = Trakpak3.NodeList}
	local blockpack = Trakpak3.BlockPack
	
	--key: name
	--value: pos
	
	local allblocks = ents.FindByClass("tp3_signal_block")
	if allblocks then
		for k, block in pairs(allblocks) do
			--Project the block's position down onto the map so the player can click a surface and select it.
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
	
	if table.IsEmpty(blockpack.BlockData) then --There were no blocks. Return nil
		return nil
	else
		return blockpack
	end
	
end

function Trakpak3.GetSignalPack() --Return the table of all signals. Must be executed before Trakpak3.GetCSPosPack!
	if Trakpak3.SignalPack then return Trakpak3.SignalPack end
	Trakpak3.SignalPack = {}
	Trakpak3.CSPosPack = {}
	local signals = Trakpak3.SignalPack
	local positions = Trakpak3.CSPosPack
	
	local allsigs = ents.FindByClass("tp3_signal_master")
	if allsigs then
		for _, signal in pairs(allsigs) do
			table.insert(positions, signal.cs_pos)
			
			local name = signal:GetName()
			if name and (name!="") then
				signals[name] = signal:GetPos()
			end
		end
	end
	
	if table.IsEmpty(signals) then --There were no signals. Return nil
		return nil
	else
		return signals
	end
end

function Trakpak3.GetCSPosPack() --Return the table of all cab signal positions, this is evaluated in Trakpak3.GetSignalPack.
	if Trakpak3.CSPosPack then
		if table.IsEmpty(Trakpak3.CSPosPack) then
			return nil
		else
			return Trakpak3.CSPosPack
		end
	else
		return nil
	end
end

function Trakpak3.GetSwitchPack() --Switch Stands
	if Trakpak3.SwitchPack then return Trakpak3.SwitchPack end
	
	Trakpak3.SwitchPack = {}
	local switches = Trakpak3.SwitchPack
	
	local allswitches = ents.FindByClass("tp3_switch_lever_anim")
	if allswitches then
		for _, switch in pairs(allswitches) do
			local name = switch:GetName()
			if name and (name!="") then
				switches[name] = switch:GetPos()
			end
		end
	end
	
	if table.IsEmpty(switches) then --There were no switches. Return nil
		return nil
	else
		return switches
	end
end

function Trakpak3.GetGatePack() --Logic Gates
	if Trakpak3.GatePack then return Trakpak3.GatePack end
	
	Trakpak3.GatePack = {}
	local gates = Trakpak3.GatePack
	local allgates = ents.FindByClass("tp3_logic_gate")
	
	if allgates then
		for _, gate in pairs(allgates) do
			local name = gate:GetName()
			if name and (name!="") then
				gates[name] = {pos = gate:GetPos(), occupied = gate.occupied}
			end
		end
	end
	
	if table.IsEmpty(gates) then --There were no gates. Return nil
		return nil
	else
		return gates
	end
end

function Trakpak3.GetPathPack() --Path Configs
	if Trakpak3.PathPack then return Trakpak3.PathPack end
	
	Trakpak3.PathPack = {}
	local psignals = Trakpak3.PathPack
	
	if Trakpak3.PathConfig.Signals then
		for signame, paths in pairs(Trakpak3.PathConfig.Signals) do
			local signal, valid = Trakpak3.FindByTargetname(signame)
			if valid then psignals[signame] = paths end
		end
	end
	
	if table.IsEmpty(psignals) then --There were no path signals. Return nil
		return nil
	else
		return psignals
	end
	
end

function Trakpak3.GetProxyPack() --Dispatch Proxies
	if Trakpak3.ProxyPack then return Trakpak3.ProxyPack end
	
	Trakpak3.ProxyPack = {}
	local proxies = Trakpak3.ProxyPack
	
	local allproxies = ents.FindByClass("tp3_dispatch_proxy")
	if allproxies then
		for _, proxy in pairs(allproxies) do
			local name = proxy:GetName()
			if name and (name!="") then
				proxies[name] = proxy:GetPos()
			end
		end
	end
	
	if table.IsEmpty(proxies) then --There were no proxies. Return nil
		return nil
	else
		return proxies
	end
end

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
