WireToolSetup.setCategory( "Trakpak3" )
WireToolSetup.open( "tp3_cabsignal_box", "Trakpak3 Cab Signal Box", "gmod_wire_tp3_cabsignal_box", nil, "Trakpak3 Cab Signal Boxes" )
WireToolSetup.SetupMax( 30 )
WireToolSetup.BaseLang()

if CLIENT then
	language.Add( "tool.wire_tp3_cabsignal_box.name", "Trakpak3 Cab Signal Box Tool (Wire)" )
	language.Add( "tool.wire_tp3_cabsignal_box.desc", "Spawns Trakpak3 Cab Signal Box for use with the Wire system." )
	--language.Add( "WireParticleSystemTool_Model", "Model:" )
	language.Add("Tool.wire_tp3_cabsignal_box.left", "Spawn/Update Trakpak3 Cab Signal Box.")
	language.Add("Tool.wire_tp3_cabsignal_box.right", "Copy Information.")
	TOOL.Information = {"left","right"}
end

TOOL.ClientConVar = {
	model = "models/gsgtrainprops/parts/cabsignals/cab_signal_box.mdl",
	spadspeed = "10",
	--restrictedspeed = "15",
	units = "mph",
	lw = "96",
	h = "192"
}

if SERVER then
	function TOOL:GetConVars()
		--return self:GetClientInfo("spadspeed"), self:GetClientInfo("restrictedspeed"), self:GetClientInfo("units"), self:GetClientInfo("lw"), self:GetClientInfo("h")
		return self:GetClientInfo("spadspeed"), self:GetClientInfo("units"), self:GetClientInfo("lw"), self:GetClientInfo("h")
	end
end

function TOOL.BuildCPanel(panel)
	--Preset Menu
	WireToolHelpers.MakePresetControl(panel, "wire_tp3_cabsignal_box")
	
	--Model Selector
	local standardmodels = {
		--HL2
		"models/props_lab/harddrive02.mdl",
		"models/props_lab/reciever01a.mdl",
		"models/props_lab/reciever01b.mdl",
		"models/props_lab/reciever01d.mdl",
		
		--Wire/PHX
		"models/beer/wiremod/gps.mdl",
		"models/beer/wiremod/targetfinder.mdl",
		"models/jaanus/wiretool/wiretool_controlchip.mdl",
		"models/hunter/plates/plate025x025.mdl",
		
		--GSG Train Props
		"models/gsgtrainprops/parts/cabsignals/cab_signal_box.mdl",
		"models/gsgtrainprops/parts/antennae/sinclair.mdl",
		"models/gsgtrainprops/parts/antennae/firecracker.mdl",
		
		--Linnie
		"models/parts/radio.mdl",
		"models/parts/radio_msa.mdl",
		--WestAusMan
		"models/wam98_trainparts/radios/radio_double_din_headunit.mdl",
		--Titus
		"models/titus's_propper_model_pack_2.4/propper/cabradios/cabradionew.mdl",
		--Goomz
		"models/goomzmodels/details/radiorack.mdl"
	}
	
	
	local models = {}
	
	for k, modelname in pairs(standardmodels) do
		--models[modelname] = {["wire_tp3_cabsignal_box_model"] = modelname}
		models[modelname] = {}
	end
	--local msel = vgui.Create("DModelSelect", panel)
	--msel:SetModelList( models, "", false, false)
	--panel:AddPanel(msel)

	WireDermaExts.ModelSelect(panel,"wire_tp3_cabsignal_box_model", models, 4, true)
	
	local black = Color(0,0,0)
	
	local label = vgui.Create("DLabel",panel)
	label:SetText("Tip: you can set custom models for your cab signal box using the console command 'wire_tp3_cabsignal_box_model'!")
	--label:SetContentAlignment(5)
	label:SetSize(1,32)
	label:SetTextColor(black)
	label:SetWrap(true)
	panel:AddPanel(label)
	
	--SPAD Speed Selector
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetText("SPAD Speed:")
	slider:SetMin(0)
	slider:SetMax(1000)
	slider:SetDecimals(0)
	slider:SetConVar("wire_tp3_cabsignal_box_spadspeed")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
	local label = vgui.Create("DLabel",panel)
	label:SetText("(Signal Passed At Danger)")
	label:SetContentAlignment(5)
	label:SetTextColor(black)
	panel:AddPanel(label)
	
	--SPAR Speed Selector
	--[[
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetText("Restricted Speed:")
	slider:SetMin(0)
	slider:SetMax(1000)
	slider:SetDecimals(0)
	slider:SetConVar("wire_tp3_cabsignal_box_restrictedspeed")
	slider:SetDark(true)
	panel:AddPanel(slider)
	]]--
	
	--Unit Selector
	local cbox = vgui.Create("DComboBox",panel)
	cbox:AddChoice("mph",nil, true)
	cbox:AddChoice("kph")
	cbox:AddChoice("ins")
	cbox.OnSelect = function(self, index, value)
		LocalPlayer():ConCommand("wire_tp3_cabsignal_box_units "..value)
	end
	panel:AddPanel(cbox)
	
	--Box Controls
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetText("Scan Width:")
	slider:SetMin(32)
	slider:SetMax(128)
	slider:SetDecimals(0)
	slider:SetConVar("wire_tp3_cabsignal_box_lw")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetText("Scan Height:")
	slider:SetMin(32)
	slider:SetMax(256)
	slider:SetDecimals(0)
	slider:SetConVar("wire_tp3_cabsignal_box_h")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
	local label = vgui.Create("DLabel",panel)
	label:SetText("By default, the cab signal box will check for signals on the leading edge of the 'root' entity (the topmost parent). If you parent the box to the locomotive body or to something parented to the locomotive body, it will work correctly. If for some reason you CAN'T parent it to the locomotive body, wire the BasePropOverride [ENTITY] input to the locomotive's base prop.")
	label:SetTextColor(black)
	label:SetSize(1,128)
	label:SetWrap(true)
	panel:AddPanel(label)
end

--duplicator.RegisterEntityClass("gmod_wire_tp3_cabsignal_box", WireLib.MakeWireEnt, "Data", "spadspeed", "restrictedspeed", "units", "lw", "h")
duplicator.RegisterEntityClass("gmod_wire_tp3_cabsignal_box", WireLib.MakeWireEnt, "Data", "spadspeed", "units", "lw", "h")