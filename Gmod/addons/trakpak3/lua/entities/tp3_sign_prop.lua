AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_prop" )
ENT.PrintName = "Trakpak3 Sign (Prop)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Displays Text"
ENT.Instructions = "Place in Hammer"

if SERVER then
	ENT.KeyValueMap = {
		text_pos = "vector",
		model = "string",
		skin = "number",
		bodygroups = "string",
		angles = "angle",
		text = "string",
		text_align_h = "number",
		text_align_v = "number",
		text_font = "string",
		text_size = "number",
		text_res = "number",
		text_offset = "number",
		text_weight = "number",
		text_color = "color",
		text_color2 = "color",
		text_outw = "number",
		spawnflags = "flags"
	}
	ENT.NumFlags = 7
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		local pos = self.text_pos + self.text_offset*self:GetForward()
		local dx = -self.angles:Right()
		local dy = -self.angles:Up()
		local ang = dx:AngleEx(dx:Cross(-dy))
		local scale = self.text_size / self.text_res --inches per pixel?
		
		--Text alignment
		local h_align = TEXT_ALIGN_CENTER
		local v_align = TEXT_ALIGN_CENTER
		if self.text_align_h==-1 then h_align = TEXT_ALIGN_LEFT elseif self.text_align_h==1 then h_align = TEXT_ALIGN_RIGHT end
		if self.text_align_v==-1 then v_align = TEXT_ALIGN_BOTTOM elseif self.text_align_v==1 then v_align = TEXT_ALIGN_TOP end
		
		--Spawn Flags
		local italic = self.spawnflags[1]
		local underline = self.spawnflags[2]
		local strike = self.spawnflags[3]
		local glow = self.spawnflags[4]
		--local nocull = self.spawnflags[5]
		
		self.text_data_1 = {
			id = self:EntIndex(),
			--World Placement
			pos = pos,
			angle = ang,
			scale = scale,
			--Text Info
			text = self.text,
			text_font = self.text_font,
			text_size = self.text_size,
			text_res = self.text_res,
			text_weight = self.text_weight,
			text_it = italic,
			text_un = underline,
			text_st = strike,
			text_sh = shadow,
			h_align = h_align,
			v_align = v_align,
			color = self.text_color,
			outline = outline,
			outw = self.text_outw,
			color2 = self.text_color2,
			--Rendering Options
			glow = glow,
			--nocull = nocull
		}
		
		Trakpak3.SignText.UpdateSign(self, self.text_data_1, 1)
		
		--Set the prop stuff
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		if self.skin then self:SetSkin(self.skin) end
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	
	function ENT:AcceptInput(iname, activator, caller, data)
		local update = false
		if iname=="SetText" then
			self.text_data.text = data
			update = true
		elseif iname=="SetColor" then
			self.text_data.color = Trakpak3.HammerStringToColor(data)
			update = true
		elseif iname=="SetColor2" then
			self.text_data.color2 = Trakpak3.HammerStringToColor(data)
			update = true
		elseif iname=="SetGlow" then
			self.text_data.glow = (data=="1")
			update = true
		end
		
		if update then
			Trakpak3.SignText.UpdateSign(self, self.text_data_1, 1)
			Trakpak3.SignText.SyncSign(self, self.text_data_1, 1)
		end
	end
end

if CLIENT then
	function ENT:DrawTranslucent(flags)
		self:Draw(flags)
		Trakpak3.SignText.DrawSign(self,1)
	end
end