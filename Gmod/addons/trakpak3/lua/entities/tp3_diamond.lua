AddCSLuaFile()
DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Diamond"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Causing Fender Benders"
ENT.Instructions = "Place in Hammer"
--ENT.AutomaticFrameAdvance = true --Not needed for manual animation sync

if SERVER then
	
	ENT.KeyValueMap = {
		model = "string",
		angles = "string",
		skin = "number"
	}
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		--Prop Init Stuff
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		self:SetTrigger(true)
		
		if string.find(self.model,"_alt.mdl") then --Model already has '_alt' for some reason
			self.model_alt = string.Replace(self.model, "_alt.mdl", ".mdl")
		else --Add _alt to the alt model
			self.model_alt = string.Replace(self.model, ".mdl", "_alt.mdl")
		end
		
		self:FindAttachments()
		
	end
	
	--Find all attachments
	function ENT:FindAttachments()
		
		local frog1 = self:LookupAttachment("frog1")
		if frog1 > 0 then self.frog1 = self:GetAttachment(frog1)["Pos"] else self.frog1 = nil end
		local frog2 = self:LookupAttachment("frog2")
		if frog2 > 0 then self.frog2 = self:GetAttachment(frog2)["Pos"] else self.frog2 = nil end
		local frog3 = self:LookupAttachment("frog3")
		if frog3 > 0 then self.frog3 = self:GetAttachment(frog3)["Pos"] else self.frog3 = nil end
		local frog4 = self:LookupAttachment("frog4")
		if frog4 > 0 then self.frog4 = self:GetAttachment(frog4)["Pos"] else self.frog4 = nil end
		
		local autopoint1 = self:LookupAttachment("autopoint1")
		if autopoint1 > 0 then self.autopoint1 = self:GetAttachment(autopoint1)["Pos"] else self.autopoint1 = nil end
		local autopoint2 = self:LookupAttachment("autopoint2")
		if autopoint2 > 0 then self.autopoint2 = self:GetAttachment(autopoint2)["Pos"] else self.autopoint2 = nil end
		
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	function ENT:Switch()
		if self.alt then --Throw to main
			self.alt = false
			
			self:SetModel(self.model)
			self:PhysicsInitStatic(SOLID_VPHYSICS)
			self:FindAttachments()
			self.cooldown = true
		else --Throw diverging
			self.alt = true
			
			self:SetModel(self.model_alt)
			self:PhysicsInitStatic(SOLID_VPHYSICS)
			self:FindAttachments()
			self.cooldown = true
		end
	end
	
	--Scan for auto-switching
	function ENT:Think()
		
		local blist = Trakpak3.GetBlacklist()
		
		local fast = false
		
		if self.autopoint1 or self.autopoint2 then
			
			local tr1 = {}
			local tr2 = {}
			
			if self.autopoint1 then
				local trace = {
					start = self.autopoint1,
					endpos = self.autopoint1 + Vector(0,0,64),
					filter = blist,
					ignoreworld = true,
					mins = Vector(-4,-4,-8),
					maxs = Vector(4,4,8)
				}
				tr1 = util.TraceHull(trace)
			end
			
			if self.autopoint2 then
				local trace = {
					start = self.autopoint2,
					endpos = self.autopoint2 + Vector(0,0,64),
					filter = blist,
					ignoreworld = true,
					mins = Vector(-4,-4,-8),
					maxs = Vector(4,4,8)
				}
				tr2 = util.TraceHull(trace)
			end
			
			if tr1.Hit or tr2.Hit then
				if not self.cooldown then self:Switch() end
			else
				self.cooldown = false
			end
			
			fast = true
			
		end
		
		--Frog Noises
		if self.scanning then
			
			for n = 1, 4 do
				if self["frog"..n] then
					local tr = {
						start = self["frog"..n],
						endpos = self["frog"..n] + Vector(0,0,8),
						filter = blist,
						ignoreworld = true
					}
					local trace = util.TraceLine(tr)
					local ent = trace.Entity
					--Seems to exceed the upper limit for sounds playing on a specific entity... need shorter sound?
					if (ent and ent:IsValid()) and (ent != self["clicker"..n]) then
						--print("play "..n)
						self["clicker"..n] = ent
						ent:EmitSound("gsgtrainsounds/wheels/wheels_random4.wav",75,math.random(95,105))
					elseif not ent:IsValid() and self["clicker"..n] then
						--if self["clicker"..n] then self["clicker"..n]:EmitSound("gsgtrainsounds/wheels/wheels_random4.wav",75,math.random(95,105)) end
						self["clicker"..n] = nil
					end
				end
			end
			fast = true
		end
		
		if fast then
			self:NextThink(CurTime()+0.1)
			return true
		end
		
	end
	
	--Trigger Functions
	--By the way, an interesting quirk about how prop triggers work - apparently it works great with trains because in addition to sitting on top of the rails, the flanges go down into the switch model's space a bit. With props that just sit on top of a surface, it doesn't work as well.
	function ENT:StartTouch(ent)
		if not self.touchents then
			self.touchents = {}
			self.hastouchers = false
		end
		
		if ent:IsValid() and ent:GetClass()=="prop_physics" then
			self.touchents[ent:EntIndex()] = true
			if not self.hastouchers then
				self:StartTouchAll()
				self.hastouchers = true
			end
		end
	end
	
	function ENT:EndTouch(ent)
		if ent:IsValid() and ent:GetClass()=="prop_physics" then
			self.touchents[ent:EntIndex()] = nil
			
			local stillhas = false
			for index, touching in pairs(self.touchents) do
				if Entity(index):IsValid() and touching then
					stillhas = true
				else
					self.touchents[index] = nil
				end
			end
			if not stillhas then
				self.hastouchers = false
				self:EndTouchAll()
			end
		end
		
	end
	
	function ENT:StartTouchAll()
		self.scanning = true
		for n = 1,4 do self["clicker"..n] = nil end
	end
	function ENT:EndTouchAll()
		self.scanning = false
		for n = 1,4 do self["clicker"..n] = nil end
	end
end