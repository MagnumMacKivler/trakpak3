--SHARED First:
Trakpak3 = {} --The Holy Table
Trakpak3.Magenta = Color(255,63,255)

--Net Code
Trakpak3.Net = {} --List of net message handlers

Trakpak3.NetStart = function(cmd) --Initiate a net message with the channel "trakpak3" (used for all TP3 net messages) and the given command.
	net.Start("trakpak3")
	net.WriteString(cmd)
end

--Net Message Handler
net.Receive("trakpak3",function(len,ply)
	local cmd = net.ReadString()
	local func = Trakpak3.Net[cmd]
	local subtract = 8*(#cmd + 1)--Number of bits to subtract from the message length
	if func then func(len - subtract,ply) end
end)

--Usage: function Trakpak3.Net.<cmd> = function(len, ply) <function text> end
--To create a net message that calls it:
--Trakpak3.NetStart(<cmd>)
--<net message text>
--net.Send()

--SERVER Initialization
if SERVER then
	
	util.AddNetworkString("trakpak3")
	
	Trakpak3.SwitchStandPlots = {}
	Trakpak3.SignalPlots = {}
	
	
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
	include("trakpak3/signalsprites.lua") --
	include("trakpak3/clientloader.lua")
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
	AddCSLuaFile("trakpak3/cl_signalsprites.lua") --
	AddCSLuaFile("trakpak3/cl_clientloader.lua") --
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
	
	
	
end

--CLIENT Initialization
if CLIENT then
	
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
	include("trakpak3/cl_signalsprites.lua")
	include("trakpak3/cl_clientloader.lua")
	include("trakpak3/shared.lua")
	
	--Fix EyePos, EyeAngles, and EyeVector functions
	hook.Add("PreDrawTranslucentRenderables", "Trakpak3_FixEyeFunctions", function()
		EyePos()
		EyeVector()
		EyeAngles()
	end)
	
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

