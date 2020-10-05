TP3Signals = { systems = {} }

--Speed Enums
Trakpak3.FULL = 5
Trakpak3.LIMITED = 4
Trakpak3.MEDIUM = 3
Trakpak3.SLOW = 2
Trakpak3.RESTRICTED = 1
Trakpak3.DANGER = 0

local map = game.GetMap()

--Run all signal generation scripts
for k, filename in pairs(file.Find("trakpak3/signalsystems/"..map.."/*.lua","LUA")) do
	local json = file.Read("trakpak3/signalsystems/"..map.."/"..filename, "LUA")
	if json then
		print("[TP3Signals] Found file "..map.."/"..filename)
		local currentsys = {}
		local ftable = util.JSONToTable(json)
		if ftable then --Valid table!
			print("[TP3Signals] Decoded Table.")
			local speed_dict = {
				["FULL"] = 5,
				["LIMITED"] = 4,
				["MEDIUM"] = 3,
				["SLOW"] = 2,
				["RESTRICTED"] = 1,
				["STOP/DANGER"] = 0 
			}
			local sysname = ftable.sysname
			print("[TP3Signals] System name is: "..sysname)
			currentsys.sysname = sysname
			currentsys.rules = {}
			for n = 1, #ftable.rules do
				local rtable = ftable.rules[n]
				local name = rtable.name
				currentsys.rules[name] = {speed = speed_dict[rtable.speed], desc = rtable.description, color = rtable.color}
				--print(name, rtable.speed, rtable.description)
			end
			currentsys.sigtypes = ftable.sigtypes
			if ftable.func_text then
				RunString("TP3Signals.TempLogic = "..ftable.func_text)
				--print("TP3Signals.TempLogic = "..ftable.func_text) 
				currentsys.logic = TP3Signals.TempLogic
				TP3Signals.systems[sysname] = currentsys
				print("[TP3Signals] Loaded signal system '"..sysname.."' successfully!")
			end
		else
			print("[TP3Signals] Could not decode table from file.")
		end
	else
		print("[TP3Signals] could not find signal system file 'trakpak3/signalsystems/"..map.."/"..filename)
	end
end

--Total System Setup in order and shit
hook.Add("InitPostEntity","Trakpak3_SystemSetup",function()
	
	--Get Signal Block states out there
	for _, block in pairs(ents.FindByClass("tp3_signal_block")) do
		block:InitialBroadcast()
	end
	
end)