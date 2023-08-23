--AddCSLuaFile() --Turns out this just makes them appear as errors and there's really no reason to network them.
DEFINE_BASECLASS("tp3_base_entity")
ENT.PrintName = "Trakpak3 Collision Trigger"
ENT.Author = "Xayrga"
ENT.Purpose = "Collides with things"
ENT.Instructions = "Place in Hammer"
ENT.Type = "brush"

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
			--print("Collision Feeder ",self," Start Touch.")
			self.TouchRedirector:StartTouch(...) 
		end 
	end 
	
	function ENT:EndTouch(...) 
		if (self.TouchRedirector and self.TouchRedirector.EndTouch) then 
			--print("Collision Feeder ",self," End Touch.")
			self.TouchRedirector:EndTouch(...) 
		end 
	end

	function ENT:PlaceCollision(min, max) 
		self:SetCollisionBoundsWS(min, max)
	end
	
	function ENT:PlaceCollisionRelative(min, max)
		self:SetCollisionBounds(min,max)
	end 
	
	--[[
	function ENT:SetupConvexCollisions(convexes) --Called by a tp3_signal_block to give it convex collisions instead of the usual box, before Spawn()/Initialize()
		if convexes and next(convexes) then
			self.convexes = convexes
		else
			self.convexes = nil
		end
	end
	]]--
	
end