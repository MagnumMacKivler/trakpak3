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
		if self.skin then self:SetSkin(self.skin) end
		if self.bodygroups then for n, p in pairs(string.Explode(" ",self.bodygroups)) do self:SetBodygroup(n,tonumber(p)) end end
		
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
		local nocull = self.spawnflags[5]
		
		
		
		for n = 1, 4 do
			
			--Check if text and attachments are valid
			local text = self["text_"..n]
			local att = self:LookupAttachment("text"..n)
			--print("SIGN SHIT", att, text)
			if text and (text!="") and (att>0) then
				
				att = self:GetAttachment(att)
				
				local apos = att.Pos
				local aang = att.Ang
				
				local pos = apos + self.text_offset*aang:Forward()
				local dx = -aang:Right()
				local dy = -aang:Up()
				local ang = dx:AngleEx(dx:Cross(-dy))
				local scale = self["text_size_"..n] / self.text_res --inches per pixel?
				
				self["text_data_"..n] = {
					id = self:EntIndex() + n*0.1,
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
					nocull = nocull
				}
			end
		end
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	function ENT:UpdateSign(ply,index)
		if index then
			local JSON = util.TableToJSON(self["text_data_"..index])
			JSON = util.Compress(JSON)
			net.Start("tp3_register_sign")
			net.WriteData(JSON,#JSON)
			net.Send(ply)
		else
			for n = 1, 4 do
				if self["text_data_"..n] then
					local JSON = util.TableToJSON(self["text_data_"..n])
					JSON = util.Compress(JSON)
					net.Start("tp3_register_sign")
					net.WriteData(JSON,#JSON)
					net.Send(ply)
				end
			end
		end
	end
	
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
			for _, ply in pairs(player.GetAll()) do self:UpdateSign(ply,index) end
		end
	end
end