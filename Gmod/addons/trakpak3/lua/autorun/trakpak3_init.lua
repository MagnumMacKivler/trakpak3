if SERVER then
	
	Trakpak3 = {}
	Trakpak3.SwitchStandPlots = {}
	Trakpak3.SignalPlots = {}
	Trakpak3.Magenta = Color(255,0,255)
	Trakpak3.Net = {}
	
	
	include("trakpak3/tp3lib.lua") --
	include("trakpak3/nodesetup.lua") --
	include("trakpak3/signalsetup.lua") --
	include("trakpak3/switchstandplots.lua") --
	include("trakpak3/signalplots.lua") --
	include("trakpak3/signtext.lua") --
	include("trakpak3/dispatch.lua") --
	include("trakpak3/mapseats.lua") --
	include("trakpak3/remoteswitcher.lua") --
	include("trakpak3/pathconfig.lua") --
	include("trakpak3/shared.lua") --
	
	AddCSLuaFile("trakpak3/cl_autosave.lua") --
	AddCSLuaFile("trakpak3/cl_nodesetup.lua") --
	AddCSLuaFile("trakpak3/cl_sigedit.lua") --
	AddCSLuaFile("trakpak3/cl_signalvision.lua") --
	AddCSLuaFile("trakpak3/cl_signtext.lua") --
	AddCSLuaFile("trakpak3/cl_dispatch.lua") --
	AddCSLuaFile("trakpak3/3d2dvgui.lua") --
	AddCSLuaFile("trakpak3/cl_makespawnlist.lua") --
	AddCSLuaFile("trakpak3/cl_mapseats.lua") --
	AddCSLuaFile("trakpak3/cl_remoteswitcher.lua") --
	AddCSLuaFile("trakpak3/cl_pathconfig.lua") --
	AddCSLuaFile("trakpak3/cl_defect_detector.lua") --
	AddCSLuaFile("trakpak3/shared.lua") --
	
	--Macro for E2 limits for JH
	concommand.Add("tp3_jh_prep", function()
		if game.SinglePlayer() then
			RunConsoleCommand("wire_expression2_quotasoft", "1000000")
			RunConsoleCommand("wire_expression2_quotatick", "1000000")
			RunConsoleCommand("wire_expression2_quotahard", "2000000")
			RunConsoleCommand("wire_expression2_file_max_size", "3000")
			print("[Trakpak3] Set E2 limits to allow John Henry to run efficiently.")
		else
			print("[Trakpak3] You really shouldn't be doing this in multiplayer.")
		end
	end)
	
	util.AddNetworkString("trakpak3")
	
	--Net Message Handlers
	net.Receive("trakpak3",function(len,ply)
		local cmd = net.ReadString()
		local func = Trakpak3.Net[cmd]
		if func then func(len,ply) end
	end)
	
	--Usage: function Trakpak3.Net.<identifier> = function(len, ply) <function text> end
	--To create a net message that calls it:
	--net.Start("trakpak3")
	--net.WriteString(<identifier>)
	--<net message text>
	--net.Send()
	
end
if CLIENT then
	Trakpak3 = {}
	Trakpak3.Net = {}
	include("trakpak3/cl_autosave.lua")
	include("trakpak3/cl_nodesetup.lua")
	include("trakpak3/cl_sigedit.lua")
	include("trakpak3/cl_signalvision.lua")
	include("trakpak3/cl_signtext.lua")
	include("trakpak3/cl_dispatch.lua")
	include("trakpak3/3d2dvgui.lua")
	include("trakpak3/cl_makespawnlist.lua")
	include("trakpak3/cl_mapseats.lua")
	include("trakpak3/cl_remoteswitcher.lua")
	include("trakpak3/cl_pathconfig.lua")
	include("trakpak3/cl_defect_detector.lua")
	include("trakpak3/shared.lua")
	
	--Net Message Handler
	net.Receive("trakpak3",function(len,ply)
		local cmd = net.ReadString()
		local func = Trakpak3.Net[cmd]
		local subtract = 8*(#cmd + 1)--Number of bits to subtract from the message length
		if func then func(len - subtract,ply) end
	end)
	
	--Fix EyePos, EyeAngles, and EyeVector functions
	hook.Add("PreDrawTranslucentRenderables", "Trakpak3_FixEyeFunctions", function()
		EyePos()
		EyeVector()
		EyeAngles()
	end)
	
	--[[
	concommand.Add("+tp3_test", function()
		print("Button Down!")
	end)
	
	concommand.Add("-tp3_test", function()
		print("Button Up!")
	end)
	]]--
	
	--[[
	hook.Add("PopulatePropMenu", "TestMakeSpawnlists", function()
		
		local contents = { {type = "model", model = "models/editor/playerstart.mdl" } }
		
		spawnmenu.AddPropCategory("Test1", "Test Spawnlist 1", contents, "icon16/folder_table.png", 1000, 0)
		spawnmenu.AddPropCategory("Test2", "Test Spawnlist 2", contents, "icon16/folder_table.png", 1001, 0)
		spawnmenu.AddPropCategory("Test3", "Test Spawnlist 3", contents, "icon16/folder_table.png", 1002, 0)
		
	end)
	]]--
	
	--[[
	concommand.Add("orthocamtest",function()
		if Ortho then
			Ortho = false
			hook.Remove("CalcView", "Test Ortho")
		else
			Ortho = true
			hook.Add("CalcView", "Test Ortho", function(ply, origin, angles, fov)
				local data = {
					origin = origin + Vector(0,0,96),
					angles = Angle(90,0,0), --Straight Down
					fov = fov,
					drawviewer = true,
					ortho = { --I'm guessing this is the size of the rectangle to be projected?
						left = 64,
						right = 64,
						top = 64,
						bottom = 64
					}
				}
				return data
			end)
		end
	end)
	]]--
	
	
end

