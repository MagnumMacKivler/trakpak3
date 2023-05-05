DEFINE_BASECLASS("tp3_base_prop")
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
	end	
	
	function ENT:StartTouch(...)
		if (self.TouchRedirector and self.TouchRedirector.StartTouch) then 
			self.TouchRedirector:StartTouch(...) 
		end 
	end 
	
	function ENT:EndTouch(...) 
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