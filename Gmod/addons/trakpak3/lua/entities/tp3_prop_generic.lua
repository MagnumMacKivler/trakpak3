AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Generic Prop"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Basically a prop_dynamic but with AutomaticFrameAdvance turned off."
ENT.Instructions = "Spawn from Entities"

if SERVER then
	function ENT:Initialize()
		
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	function ENT:Think()
		self:NextThink(CurTime())
		return true
	end
end