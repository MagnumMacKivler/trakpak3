if SERVER then
	
	Trakpak3 = {}
	Trakpak3.SwitchStandPlots = {}
	Trakpak3.SignalPlots = {}
	Trakpak3.Magenta = Color(255,0,255)
	
	include("trakpak3/tp3lib.lua")
	include("trakpak3/nodesetup.lua")
	include("trakpak3/signalsetup.lua")
	include("trakpak3/switchstandplots.lua")
	include("trakpak3/signalplots.lua")
	include("trakpak3/signtext.lua")
	include("trakpak3/dispatch.lua")
	include("trakpak3/mapseats.lua")
	include("trakpak3/remoteswitcher.lua")
	
	AddCSLuaFile("trakpak3/cl_nodesetup.lua")
	AddCSLuaFile("trakpak3/cl_sigedit.lua")
	AddCSLuaFile("trakpak3/cl_signalvision.lua")
	AddCSLuaFile("trakpak3/cl_signtext.lua")
	AddCSLuaFile("trakpak3/cl_dispatch.lua")
	AddCSLuaFile("trakpak3/3d2dvgui.lua")
	AddCSLuaFile("trakpak3/cl_makespawnlist.lua")
	AddCSLuaFile("trakpak3/cl_mapseats.lua")
	AddCSLuaFile("trakpak3/cl_remoteswitcher.lua")
	
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
	include("trakpak3/cl_mapseats.lua")
	include("trakpak3/cl_remoteswitcher.lua")
	
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
	
	--Material Test
	
	concommand.Add("testmat", function(ply)
		--Cache material & texture from png
		local png_mat = Material("test_logo.png", "vertexlitgeneric smooth noclamp")
		local tex = png_mat:GetTexture("$basetexture")
		print("PNG Material name: ", png_mat:GetName())
		print("PNG Material shader: ", png_mat:GetShader())
		print("PNG Material $basetexture: ", tex, tex:GetName())
		
	end)
	
	concommand.Add("testmat2", function(ply)
		local png_mat = Material("!1000110test_logo")
		local tex = png_mat:GetTexture("$basetexture")
		print("Check PNG $basetexture: ",tex)
		
		--Create material that can be used by Entity:SetMaterial()
		local params = {
			["$basetexture"] = tex:GetName(),
			["$model"] = 1,
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1
		}
		local new_mat = CreateMaterial("pootis", "VertexLitGeneric", params)
		--new_mat:SetTexture("$basetexture", tex)
		print("NEW Material name: ", new_mat:GetName())
		print("NEW Material shader: ", new_mat:GetShader())
		print("NEW Material $basetexture: ", new_mat:GetTexture("$basetexture"))
		
		--Apply the material to the entity under the player's crosshair
		local ent = ply:GetEyeTrace().Entity
		if ent and ent:IsValid() then ent:SetMaterial("!pootis") end
	end)
	
	concommand.Add("testmat3", function(ply)
		local png_mat = Material("!1000110test_logo")
		local tex = png_mat:GetTexture("$basetexture")
		local new_mat = Material("!pootis")
		
		new_mat:SetTexture("$basetexture", tex)
		new_mat:Recompute()
		
		print("NEW Material name: ", new_mat:GetName())
		print("NEW Material shader: ", new_mat:GetShader())
		print("NEW Material $basetexture: ", new_mat:GetTexture("$basetexture"))
		
		--Apply the material to the entity under the player's crosshair
		local ent = ply:GetEyeTrace().Entity
		if ent and ent:IsValid() then ent:SetMaterial("!pootis") end
	end)
	
	concommand.Add("testmat4", function(ply)
		local png_mat = Material("test_logo.png", "vertexlitgeneric smooth noclamp alphatest")
		local name = png_mat:GetName()
		
		local params = {}
		local new_mat = CreateMaterial("pootis", "VertexLitGeneric", params)
		
		timer.Simple(0.1,function()
			local png_mat = Material("!"..name)
			local new_mat = Material("!pootis")
			local tex = png_mat:GetTexture("$basetexture")
			
			new_mat:SetTexture("$basetexture", tex)
			new_mat:Recompute()
			
			--Apply the material to the entity under the player's crosshair
			local ent = ply:GetEyeTrace().Entity
			if ent and ent:IsValid() then ent:SetMaterial("!pootis") end
		end)
	end)
	
	concommand.Add("testmat5", function(ply)
		local params = {
			["$basetexture"] = "test_logo.vtf"
		}
		local new_mat = CreateMaterial("pootis", "VertexLitGeneric", params)
		
		timer.Simple(0.1,function()
			local new_mat = Material("!pootis")
			new_mat:Recompute()
			
			print(new_mat:GetTexture("$basetexture"))
			
			--Apply the material to the entity under the player's crosshair
			local ent = ply:GetEyeTrace().Entity
			if ent and ent:IsValid() then ent:SetMaterial("!pootis") end
		end)
	end)
	
end

--SHARED

--Custom Vehicles

--Footprint
local function HandleStandingAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_IDLE ) 
end

local V = {
	Name = "Trakpak3 Footprints",
	Model = "models/trakpak3_common/vehicles/footprints.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = "Trakpak3",

	Author = "Magnum",
	Information = "Used for standing and operating stuff.",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleStandingAnimation
	}
}
list.Set( "Vehicles", "tp3_footprints", V )

--Sound Scripts
sound.Add({
	name="Trakpak3.switchstand.latch_lift",
	sound = "trakpak3/switchstands/manual/latch_lift.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.latch_drop",
	sound = "trakpak3/switchstands/manual/latch_drop.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.latch_contact",
	sound = "trakpak3/switchstands/manual/latch_contact.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.latch_close",
	sound = "trakpak3/switchstands/manual/latch_close.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})

sound.Add({
	name="Trakpak3.switchstand.lever_hittop",
	sound = "trakpak3/switchstands/manual/latch_close.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.lever_hitbottom",
	sound = "trakpak3/switchstands/manual/latch_lift.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})

sound.Add({
	name="Trakpak3.switchstand.blades_close_a",
	sound = {
		"trakpak3/switchstands/manual/manualjunctiona01.wav",
		"trakpak3/switchstands/manual/manualjunctiona02.wav",
		"trakpak3/switchstands/manual/manualjunctiona03.wav",
		"trakpak3/switchstands/manual/manualjunctiona04.wav",
		"trakpak3/switchstands/manual/manualjunctiona05.wav",
		"trakpak3/switchstands/manual/manualjunctiona06.wav",
		"trakpak3/switchstands/manual/manualjunctiona07.wav",
		"trakpak3/switchstands/manual/manualjunctiona08.wav",
		"trakpak3/switchstands/manual/manualjunctiona09.wav"
	},
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.blades_close_b",
	sound = {
		"trakpak3/switchstands/manual/manualjunctionb01.wav",
		"trakpak3/switchstands/manual/manualjunctionb02.wav",
		"trakpak3/switchstands/manual/manualjunctionb03.wav",
		"trakpak3/switchstands/manual/manualjunctionb04.wav",
		"trakpak3/switchstands/manual/manualjunctionb05.wav",
		"trakpak3/switchstands/manual/manualjunctionb06.wav",
		"trakpak3/switchstands/manual/manualjunctionb07.wav",
		"trakpak3/switchstands/manual/manualjunctionb08.wav"
	},
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})

