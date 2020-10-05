if SERVER then
	
	Trakpak3 = {}
	Trakpak3.SwitchStandPlots = {}
	Trakpak3.SignalPlots = {}
	
	include("trakpak3/tp3lib.lua")
	include("trakpak3/nodesetup.lua")
	include("trakpak3/signalsetup.lua")
	include("trakpak3/switchstandplots.lua")
	include("trakpak3/signalplots.lua")
	include("trakpak3/signtext.lua")
	include("trakpak3/dispatch.lua")
	
	AddCSLuaFile("trakpak3/cl_nodesetup.lua")
	AddCSLuaFile("trakpak3/cl_sigedit.lua")
	AddCSLuaFile("trakpak3/cl_signalvision.lua")
	AddCSLuaFile("trakpak3/cl_signtext.lua")
	AddCSLuaFile("trakpak3/cl_dispatch.lua")
	AddCSLuaFile("trakpak3/3d2dvgui.lua")
	AddCSLuaFile("trakpak3/cl_makespawnlist.lua")
	
	--Macro for E2 limits for JH
	concommand.Add("tp3_jh_prep", function()
		if game.SinglePlayer() then
			RunConsoleCommand("wire_expression2_quotasoft", "1000000")
			RunConsoleCommand("wire_expression2_quotatick", "1000000")
			RunConsoleCommand("wire_expression2_quotahard", "2000000")
			print("[Trakpak3] Set E2 limits to allow John Henry to run efficiently.")
		else
			print("[Trakpak3] You really shouldn't be doing this in multiplayer.")
		end
	end)
end
if CLIENT then
	Trakpak3 = {}
	include("trakpak3/cl_nodesetup.lua")
	include("trakpak3/cl_sigedit.lua")
	include("trakpak3/cl_signalvision.lua")
	include("trakpak3/cl_signtext.lua")
	include("trakpak3/cl_dispatch.lua")
	include("trakpak3/3d2dvgui.lua")
	include("trakpak3/cl_makespawnlist.lua")
	
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
	
end