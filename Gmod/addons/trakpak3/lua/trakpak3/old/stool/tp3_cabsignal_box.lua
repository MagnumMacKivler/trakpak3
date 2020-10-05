
TOOL.Category = "Trakpak3"
TOOL.Name = "Cab Signal Box"
TOOL.Command = nil
TOOL.Configname = ""
--Establish convar for spawn limit
if not ConVarExists("sbox_max_tp3_cabsignal_boxes") then
	CreateConVar("sbox_max_tp3_cabsignal_boxes", 16, FCVAR_NONE, "Max number of Trakpak3 Cab Signal Boxes", 0)
end
function TOOL:LeftClick( trace )
	if SERVER then
		if trace.Entity.ClassName=="tp3_cabsignal_box" then --Update existing
			local box = trace.Entity
			box:SetupSpeedInfo( self:GetClientInfo("spadspeed"), self:GetClientInfo("restrictingspeed"), self:GetClientInfo("units") ) --Configure Box
		else --Create new
			--local count = self:GetOwner():GetNWInt("tp3_cabsignal_box_count")
			--local limit = GetConVar("sbox_max_tp3_cabsignal_boxes"):GetInt() or 16
			--if count<limit then
			if true then
				local box = ents.Create("tp3_cabsignal_box")
				local ang = trace.HitNormal:Angle()
				ang.pitch = ang.pitch + 90
				
				box:SetPos(trace.HitPos)
				box:SetAngles(ang)
				box:SetModel(self:GetClientInfo("model"))
				box:SetPlayer(self:GetOwner())
				box:SetupSpeedInfo( self:GetClientInfo("spadspeed"), self:GetClientInfo("restrictingspeed"), self:GetClientInfo("units") ) --Configure Box
				box:Spawn()
				
				local offset = -box:OBBMins().z --Adjust position
				box:SetPos(trace.HitPos + offset*trace.HitNormal)
				
				self:GetOwner():AddCount("tp3_cabsignal_boxes",box)
				
				undo.Create("Cab Signal Box")
					undo.AddEntity(box)
					undo.SetPlayer(self:GetOwner())
				undo.Finish()
				cleanup.Add(self:GetOwner(),"Cab Signal Boxes",box)
			else
				self:GetOwner():ChatPrint("You've reached the spawn limit for Trakpak3 Cab Signal Boxes ("..limit..")!")
				return false
			end
		end
	end
	return true
end

TOOL.ClientConVar["model"] = "models/gsgtrainprops/parts/cabsignals/cab_signal_box.mdl" --Model to use for the new cab signal box
TOOL.ClientConVar["spadspeed"] = "5" --Max speed you can pass a red signal
TOOL.ClientConVar["restrictingspeed"] = "15" --Max speed you can pass a restricting signal
TOOL.ClientConVar["units"] = "mph" --Speed Units for converting units
function TOOL.BuildCPanel(panel)
	
	local Label = vgui.Create("DLabel",panel)
	Label:SetText("A cab signal box that picks up signal info from the map as it passes by a signal. Also provides Automatic Train Stop capability.")
	Label:SetTextColor(Color(0,0,0))
	Label:SetSize(64,64)
	Label:Dock(TOP)
	Label:DockMargin(4,4,4,4)
	
	Label:SetWrap(true)
	Label:SetContentAlignment(8)
	
	local Label = vgui.Create("DLabel",panel)
	Label:SetText("Pick a model:")
	Label:SetTextColor(Color(0,0,0))
	Label:Dock(TOP)
	Label:DockMargin(4,4,4,4)
	
	local BG = vgui.Create("DPanel",panel)
	BG:SetSize(256,384)
	BG:Dock(TOP)
	BG:DockMargin(4,4,4,4)
	
	--local Scroll = vgui.Create("DScrollPanel",panel)
	--Scroll:SetSize(256,384)
	--Scroll:Dock(TOP)
	
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
		models[modelname] = {["tp3_cabsignal_box_model"] = modelname}
	end
	local Msel = BG:Add("DModelSelect")
	Msel:SetModelList( models, "", false, false)
	Msel:Dock(FILL)
	
	--SPAD Speed Selector
	local Slider = vgui.Create("DNumSlider",panel)
	Slider:SetText("SPAD Speed")
	Slider:SetDark(true)
	Slider:SetSize(48,32)
	Slider:SetMin(0)
	Slider:SetMax(1024)
	Slider:SetDecimals(0)
	Slider:SetConVar("tp3_cabsignal_box_spadspeed")
	Slider:Dock(TOP)
	Slider:DockMargin(4,4,4,4)
	
	--REST Speed Selector
	local Slider = vgui.Create("DNumSlider",panel)
	Slider:SetText("Restricting Speed")
	Slider:SetDark(true)
	Slider:SetSize(48,32)
	Slider:SetMin(0)
	Slider:SetMax(1024)
	Slider:SetDecimals(0)
	Slider:SetConVar("tp3_cabsignal_box_restrictingspeed")
	Slider:Dock(TOP)
	Slider:DockMargin(4,4,4,4)
	
	--Units Selector
	local CBox = vgui.Create("DComboBox",panel)
	CBox:SetSize(64,32)
	CBox:SetValue("Speed Units")
	CBox:AddChoice("MPH (Miles per Hour)","mph") --17.6
	CBox:AddChoice("KPH (Kilometers per Hour)","kph") --10.93
	CBox:AddChoice("In/S (Source Units per Second)","ins") --1.0
	function CBox:OnSelect(index, text, data)
		LocalPlayer():ConCommand("tp3_cabsignal_box_units "..data)
	end
	
	CBox:Dock(TOP)
	CBox:DockMargin(4,4,4,4)
	
	local Label = vgui.Create("DLabel",panel)
	Label:SetText("All speeds are in Player Scale.")
	Label:SetTextColor(Color(0,0,0))
	Label:Dock(TOP)
	Label:DockMargin(4,4,4,4)
end

--Add tool HUD Info that tells the user what this shit does
if CLIENT then
	language.Add("Tool.tp3_cabsignal_box.name", "Cab Signal Box Tool")
	language.Add("Tool.tp3_cabsignal_box.desc", "Spawns a box that reads map signals for Cab Signaling and Automatic Train Stop.")
	language.Add("Tool.tp3_cabsignal_box.left", "Spawn or Update a Cab Signal Box.")
	TOOL.Information = {"left"}
end

--Shamelessly stolen and paraphrased from Garry
function TOOL:UpdateGhostBox( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( not trace.Hit or (IsValid( trace.Entity ) and ( (trace.Entity:GetClass() == "tp3_cabsignal_box") or trace.Entity:IsPlayer() ) ) ) then

		ent:SetNoDraw( true )
		return

	end

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch + 90

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( ang )

	ent:SetNoDraw( false )

end
function TOOL:Think()

	local mdl = self:GetClientInfo( "model" )
	--if ( !IsValidThrusterModel( mdl ) ) then self:ReleaseGhostEntity() return end

	if ( not IsValid( self.GhostEntity ) or self.GhostEntity:GetModel() != mdl ) then
		self:MakeGhostEntity( mdl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostBox( self.GhostEntity, self:GetOwner() )

end