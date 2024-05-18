Trakpak3.PathConfig = {}
local PathConfig = Trakpak3.PathConfig

--PathConfig.Signals
	--signame1
		--[1]
			--speed
			--divergence
			--block
			--nextsignal
			--switchlist
				--stand1
			


function  PathConfig.IPE() --InitPostEntity
	local filepath = "trakpak3/pathconfig/"..game.GetMap()..".lua"
	local json = file.Read(filepath,"LUA")
	if json then --found a file!
		local ftable = util.JSONToTable(json)
		if ftable then
			
			PathConfig.Signals = ftable
			for signame, paths in pairs(PathConfig.Signals) do --For each signal that has paths
				PathConfig.ProcessLogic(signame, paths)
				--PathConfig.EvaluateLogic(signame, paths)
			end
			
		end
	end
end 

--hook.Add("InitPostEntity","TP3_PathLoad",load_path_configs) 
--hook.Add("PostCleanupMap","TP3_PathLoad", load_path_configs)

function PathConfig.ProcessLogic(signame, paths) --Set Up Signal with Path Info
	local signal, valid = Trakpak3.FindByTargetname(signame)
	--print(signal, valid)
	if not valid then return end
	
	--ENT:AddPath(pathname, diverging, speed, block, nextsignal, active)
	for pindex, path in pairs(paths) do --For each path in the signal:
		--if signal.AddPath then print("Signal ",signal," AddPath OK") else print("Signal ",signal," AddPath Failed") end
		signal:AddPath(pindex, path.divergence, path.speed, path.block, path.nextsignal, false, path.switchlist) --Add path
		
	end
	
	PathConfig.EvaluateLogic(signame, paths)
	
	signal:SetCTCState() --Force the signal to apply interlocks if applicable
end

function PathConfig.EvaluateLogic(signame, paths) --Evaluate the path state for a specific signal
	local signal, valid = Trakpak3.FindByTargetname(signame)
	if not valid then return end
	
	--local found = false
	
	for pindex, path in pairs(paths) do --For each path in the signal:
		local swlist = path.switchlist
		local condition = true
		for ssname, reqstate in pairs(swlist) do --For each switch STAND in the path switchlist:
			local sw, valid = Trakpak3.FindByTargetname(ssname)
			if (not valid) or sw.animating or (sw.state != reqstate) then
				condition = false
				if not valid then ErrorNoHalt("[Trakpak3] Error, Signal '"..signame.."' with path '"..pindex.."' has invalid switch stand '"..ssname.."'!\n") end
				break
			end
		end

		signal:SetPathState(pindex,condition)
		
	end
end

--Update on switch change
hook.Add("TP3_SwitchUpdate","Trakpak3_PathConfig_Update",function(ssname, switchstate, broken)
	if PathConfig.Signals then
		for signame, paths in pairs(PathConfig.Signals) do --For each signal:
			PathConfig.EvaluateLogic(signame, paths)
		end
	end
	
end)