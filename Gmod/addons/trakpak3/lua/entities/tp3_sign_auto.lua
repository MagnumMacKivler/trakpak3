AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_prop" )
ENT.PrintName = "Trakpak3 Sign (Auto)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Displays Text"
ENT.Instructions = "Place in Hammer"

if SERVER then
	ENT.KeyValueMap = {
		model = "string",
		skin = "number",
		bodygroups = "string",
		angles = "angle",
		text_1 = "string",
		text_2 = "string",
		text_3 = "string",
		text_4 = "string",
		text_align_h = "number",
		text_align_v = "number",
		text_font = "string",
		text_size_1 = "number",
		text_size_2 = "number",
		text_size_3 = "number",
		text_size_4 = "number",
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
		
		--Set the prop stuff
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		--self:SetSolid(SOLID_BSP)
		if self.skin then self:SetSkin(self.skin) end
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		
		--Text alignment
		local h_align = TEXT_ALIGN_CENTER
		local v_align = TEXT_ALIGN_CENTER
		if self.text_align_h==-1 then h_align = TEXT_ALIGN_LEFT elseif self.text_align_h==1 then h_align = TEXT_ALIGN_RIGHT end
		if self.text_align_v==-1 then v_align = TEXT_ALIGN_BOTTOM elseif self.text_align_v==1 then v_align = TEXT_ALIGN_TOP end
		
		--Spawn Flags
		local italic = self.spawnflags[1]
		local underline = self.spawnflags[2]
		local outline = self.spawnflags[3]
		local glow = self.spawnflags[4]
		--local nocull = self.spawnflags[5] --Deprecated
		--local strike = self.spawnflags[6] --Doesn't work at all
		--local shadow = self.spawnflags[7] --Only shows 1 pixel, useless for map signs
		
		
		for n = 1, 4 do
			
			--Check if text and attachments are valid
			local text = self["text_"..n]
			local att = self:LookupAttachment("text"..n)
			--print("SIGN SHIT", att, text)
			if text and (text!="") and (att>0) then
				
				self:SetNWBool("sign"..n,true)
				
				att = self:GetAttachment(att)
				
				local apos = att.Pos
				local aang = att.Ang
				
				local pos = apos + self.text_offset*aang:Forward()
				local dx = -aang:Right()
				local dy = -aang:Up()
				local ang = dx:AngleEx(dx:Cross(-dy))
				local scale = self["text_size_"..n] / self.text_res --inches per pixel?
				
				self["text_data_"..n] = {
					id = self:EntIndex(),
					--World Placement
					pos = pos,
					angle = ang,
					scale = scale,
					--Text Info
					text = text,
					text_font = self.text_font,
					text_size = self["text_size_"..n],
					text_res = self.text_res,
					text_weight = self.text_weight,
					text_it = italic,
					text_un = underline,
					--text_st = strike,
					--text_sh = shadow,
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
				Trakpak3.SignText.UpdateSign(self, self["text_data_"..n], n)
			end
		end
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	function ENT:AcceptInput(iname, activator, caller, data)
		local update = false
		local index
		if iname=="SetText1" and self.text_data_1 then
			self.text_data_1.text = data
			index = 1
			update = true
		elseif iname=="SetText2" and self.text_data_2 then
			self.text_data_2.text = data
			index = 2
			update = true
		elseif iname=="SetText3" and self.text_data_3 then
			self.text_data_3.text = data
			index = 3
			update = true
		elseif iname=="SetText4" and self.text_data_4 then
			self.text_data_4.text = data
			index = 4
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
			if index then
				Trakpak3.UpdateSign(self, self["text_data_"..index], index)
			else
				for index = 1,4 do
					if self["text_data_"..index] then
						Trakpak3.SignText.UpdateSign(self, self["text_data_"..index], index)
						Trakpak3.SignText.SyncSign(self, self["text_data_"..index], index)
					end
				end
			end
		end
		
	end
end

if CLIENT then
	function ENT:DrawTranslucent(flags)
		self:Draw(flags)
		for index = 1,4 do
			if self:GetNWBool("sign"..index) then
				Trakpak3.SignText.DrawSign(self,index)
			end
		end
	end
end