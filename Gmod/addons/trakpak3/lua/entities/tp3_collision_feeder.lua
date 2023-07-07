--AddCSLuaFile() --Turns out this just makes them appear as errors and there's really no reason to network them.
DEFINE_BASECLASS("tp3_base_entity")
ENT.PrintName = "Trakpak3 Collision Trigger"
ENT.Author = "Xayrga"
ENT.Purpose = "Collides with things"
ENT.Instructions = "Place in Hammer"

if SERVER then

	ENT.KeyValueMap = {

	}
	
 
	
	 
	function ENT:Initialize()
		self:SetSolid(SOLID_BBOX)
		self:SetNotSolid(true)
		self:SetTrigger(true) 
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		--print(self, "Initialized!")
	end	
	
	function ENT:StartTouch(...)
		--print("Collision Feeder Start Touch.")
		if (self.TouchRedirector and self.TouchRedirector.StartTouch) then 
			self.TouchRedirector:StartTouch(...) 
		end 
	end 
	
	function ENT:EndTouch(...) 
		--print("Collision Feeder End Touch.")
		if (self.TouchRedirector and self.TouchRedirector.EndTouch) then 
			self.TouchRedirector:EndTouch(...) 
		end 
	end

	function ENT:PlaceCollision(min, max) 
		self:SetCollisionBoundsWS(min, max)
	end
	
	function ENT:PlaceCollisionRelative(min, max)
		self:SetCollisionBounds(min,max)
	end 
	
end