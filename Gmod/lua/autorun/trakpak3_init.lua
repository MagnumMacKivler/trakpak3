if SERVER then
	--print("\nINCLUDING TP3LIB\n")
	include("trakpak3/tp3lib.lua")
	--print("\nINCLUDING NODESETUP\n")
	include("trakpak3/nodesetup.lua")
	--print("\nINCLUDING SIGNALSETUP\n")
	include("trakpak3/signalsetup.lua")
	--print("\nINCLUDING SWITCHSTANDS\n")
	include("trakpak3/switchstands.lua")
	--print("\nINCLUDING SIGNTEXT\n")
	include("trakpak3/signtext.lua")
	--print("\nINCLUDING DISPATCH\n")
	include("trakpak3/dispatch.lua")
	
	AddCSLuaFile("trakpak3/cl_nodesetup.lua")
	AddCSLuaFile("trakpak3/cl_sigedit.lua")
	AddCSLuaFile("trakpak3/cl_signalvision.lua")
	AddCSLuaFile("trakpak3/cl_signtext.lua")
	AddCSLuaFile("trakpak3/cl_dispatch.lua")
	AddCSLuaFile("trakpak3/3d2dvgui.lua")
end
if CLIENT then
	Trakpak3 = {}
	include("trakpak3/cl_nodesetup.lua")
	include("trakpak3/cl_sigedit.lua")
	include("trakpak3/cl_signalvision.lua")
	include("trakpak3/cl_signtext.lua")
	include("trakpak3/cl_dispatch.lua")
	include("trakpak3/3d2dvgui.lua")
	
	--[[
	concommand.Add("+tp3_test", function()
		print("Button Down!")
	end)
	
	concommand.Add("-tp3_test", function()
		print("Button Up!")
	end)
	]]--
end