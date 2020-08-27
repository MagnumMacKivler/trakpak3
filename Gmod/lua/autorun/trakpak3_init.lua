if SERVER then
	include("trakpak3/tp3lib.lua")
	include("trakpak3/nodesetup.lua")
	include("trakpak3/signalsetup.lua")
	include("trakpak3/switchstands.lua")
	
	AddCSLuaFile("trakpak3/cl_nodesetup.lua")
	AddCSLuaFile("trakpak3/cl_sigedit.lua")
	AddCSLuaFile("trakpak3/cl_signalvision.lua")
end
if CLIENT then
	Trakpak3 = {}
	include("trakpak3/cl_nodesetup.lua")
	include("trakpak3/cl_sigedit.lua")
	include("trakpak3/cl_signalvision.lua")
	
	--[[
	concommand.Add("+tp3_test", function()
		print("Button Down!")
	end)
	
	concommand.Add("-tp3_test", function()
		print("Button Up!")
	end)
	]]--
end