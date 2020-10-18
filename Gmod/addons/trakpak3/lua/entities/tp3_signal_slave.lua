AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Signal Prop (Slave)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Stop trains, annoy kids"
ENT.Instructions = "Place in Hammer"

if SERVER then
	
	ENT.KeyValueMap = {
		model = "string",
		angles = "string",
		skin = "number",
		bodygroups = "string",
		up_powered = "number",
		dn_powered = "number",
		OnChangedColor = "output",
	}
	
	function ENT:Initialize()
		self:ValidateNumerics()
	
		--Prop Init Stuff
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		
		if self.skin then self:SetSkin(self.skin) end
		if self.bodygroups then
			local bga = string.Explode(" ",self.bodygroups)
			for n, p in pairs(bga) do self:SetBodygroup(n,tonumber(p)) end
		end
		
		if not self.up_powered then self.up_powered = 0 end
		if not self.dn_powered then self.dn_powered = 0 end
		
		self.effectivecolor = 0
		self.cycle = 0
		self.target_cycle = 0
		self.cycle_vel = 0
		self.max_vel = 0.25
		self.min_vel = -2
		self.first_anim = true
		self.anim_power = math.Rand(0.875,1.125)
		
		--Wire Setup
		if WireLib then
			local names = {"ColorCode"}
			local types = {"NORMAL"}
			WireLib.CreateSpecialOutputs(self, names, types, nil)
		end
		
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	--Animation
	function ENT:Think()
		if self.cycle!=self.target_cycle then
			
			if not self.animating then
				self.animating = true
				self:ResetSequence("range")
			end
			
			local ascend_rate = 0.25
			local descend_rate = 2
			local ticktime = engine.TickInterval()
			
			Trakpak3.AnimateSignal(self)
			
			if (self.cycle==self.target_cycle) then --target has been reached -> apply skins and bodygroups
				if self.target_bg then
					for k, v in pairs(self.target_bg) do self:SetBodygroup(k, v) end
				end
				if self.target_skin then
					self:SetSkin(self.target_skin)
				end
			else --target has not yet been reached, apply interim bodygroups
				local sigplot = Trakpak3.SignalPlots[self.model]
				if sigplot then
					local maxframe = sigplot[#sigplot][1] or 0
					local frame = self.cycle*maxframe
					local mindist = maxframe
					local mindex
					for k, v in pairs(sigplot) do
						local d = math.abs(frame - sigplot[k][1])
						if d<mindist then
							mindist = d
							mindex = k
						end
					end
					
					if mindex then --found a match
						local bga = sigplot[mindex][2]
						for k, v in pairs(bga) do self:SetBodygroup(k, v) end
					end
				end
			end
			
			self:SetCycle(self.cycle)
			
			self:NextThink(CurTime())
			return true
		end
	end
	
	--Handle new color
	function ENT:HandleNewColor(skin, bg, cycle)
		local oldcolor = self.effectivecolor
		
		--Set Self
		if bg then
			local bga = string.Explode(" ",bg)
			if bga then
				if cycle and not self.first_anim then --save for later
					self.target_bg = bga
				else --apply now
					for k, v in pairs(bga) do self:SetBodygroup(k,tonumber(v)) end
				end
				
				self.effectivecolor = tonumber(bga[1]) or 0
			end
		end
		if cycle then
			self.old_target = self.target_cycle
			self.anim_stage = 0
			self.anim_power = math.Rand(0.75,1.25)
			self.target_cycle = cycle
			self.effectivecolor = cycle
		end
		if skin and not self.first_anim then
			if cycle then --save for later
				self.target_skin = skin
			else --apply now
				self:SetSkin(skin)
			end
			self.effectivecolor = skin
		end
		self.first_anim = false
		
		if self.effectivecolor != oldcolor then
			self:TriggerOutput("OnChangedColor",self,self.effectivecolor)
		
			if WireLib then
				WireLib.TriggerOutput(self,"ColorCode",self.effectivecolor)
			end
		end
		
	end
	
	function ENT:AcceptInput(iname, activator, caller, data)
		if iname=="SetSkin" then
			if data and data!="" then
				self:HandleNewColor(tonumber(data))
			end
		elseif iname=="SetBodygroups" then
			if data and data!="" then
				self:HandleNewColor(nil, data)
			end
		elseif iname=="SetCycle" then
			if data and data!="" then
				self:HandleNewColor(nil, nil, tonumber(data))
			end
		end
	end
	
end