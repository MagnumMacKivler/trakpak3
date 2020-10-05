WireToolSetup.setCategory( "Trakpak3" )
WireToolSetup.open( "tp3_cabsignal_box", "Trakpak3 Cab Signal Box", "gmod_wire_tp3_cabsignal_box", nil, "Trakpak3 Cab Signal Boxes" )
WireToolSetup.SetupMax( 20 )
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
	spadspeed = "5",
	restrictedspeed = "15",
	units = "mph",
	lw = "96",
	h = "192"
}

if SERVER then
	function TOOL:GetConVars()
		return self:GetClientInfo("spadspeed"), self:GetClientInfo("restrictedspeed"), self:GetClientInfo("units"), self:GetClientInfo("lw"), self:GetClientInfo("h")
	end
end

function TOOL.BuildCPanel(panel)
	--Preset Menu
	WireToolHelpers.MakePresetControl(panel, "wire_tp3_cabsignal_box")
	
	--Model Selector
	local standardmodels = {
		"models/gsgtrainprops/parts/cabsignals/cab_signal_box.mdl",
		"models/gsgtrainprops/parts/antennae/sinclair.mdl",
		"models/gsgtrainprops/parts/antennae/firecracker.mdl",
		"models/props_lab/harddrive02.mdl",
		"models/props_lab/reciever01a.mdl",
		"models/props_lab/reciever01b.mdl",
		"models/props_lab/reciever01d.mdl",
		"models/beer/wiremod/gps.mdl",
		"models/beer/wiremod/targetfinder.mdl",
		"models/jaanus/wiretool/wiretool_controlchip.mdl",
		"models/hunter/plates/plate025x025.mdl"
	}
	
	local models = {}
	
	for k, modelname in pairs(standardmodels) do
		models[modelname] = {["wire_tp3_cabsignal_box_model"] = modelname}
	end
	local msel = vgui.Create("DModelSelect", panel)
	msel:SetModelList( models, "", false, false)
	panel:AddPanel(msel)
	
	
	--SPAD Speed Selector
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetText("SPAD (Signal Passed At Danger) Speed:")
	slider:SetMin(0)
	slider:SetMax(1000)
	slider:SetDecimals(0)
	slider:SetConVar("wire_tp3_cabsignal_box_spadspeed")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
	--SPAR Speed Selector
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetText("Restricted Speed:")
	slider:SetMin(0)
	slider:SetMax(1000)
	slider:SetDecimals(0)
	slider:SetConVar("wire_tp3_cabsignal_box_restrictedspeed")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
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
	label:SetTextColor(Color(63,63,63))
	label:SetSize(1,128)
	label:SetWrap(true)
	panel:AddPanel(label)
end

duplicator.RegisterEntityClass("gmod_wire_tp3_cabsignal_box", WireLib.MakeWireEnt, "Data", "spadspeed", "restrictedspeed", "units", "lw", "h")