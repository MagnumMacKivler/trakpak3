AddCSLuaFile()

DEFINE_BASECLASS( "base_brush" )
ENT.Spawnable = false
ENT.Editable = false
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.RenderGroup = RENDERGROUP_OTHER

ENT.PrintName = "Trakpak3 Cab Signal Trigger"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Updates Cab Signal Boxes"
ENT.Instructions = "Place in Hammer"

local function FindByTargetname(name)
	if name and name!="" then
		local result = ents.FindByName(name)[1]
		if IsValid(result) then
			return result, true
		else
			return nil, false
		end
	else
		return nil, false
	end
end
local function fif(condition, result_true, result_false)
	if condition then
		return result_true
	else
		return result_false
	end
end
local function GetRoot(ent) --Finds the root (master parent) entity in a chain
	while IsValid(ent:GetParent()) do
		ent = ent:GetParent()
	end
	return ent
end

function ENT:KeyValue(key, value) --Assign KeyValues (all string) to entity for later processing
	if CLIENT then return end
	if string.Left(key, 2)=="On" then --Keyvalue is an output
		self:StoreOutput(key, value)
	else --Keyvalue is a regular keyvalue
		self[key] = value 
	end
end

--KVs: homesignal, trigger_axis(vector), angtolerance
function ENT:Initialize()
	if CLIENT then return end
	self.homesignalent, self.valid = FindByTargetname(self.homesignal)
	local angles = string.Explode(" ",self.angles)
	for k, v in pairs(angles) do v = tonumber(v) end
	angles = Angle(angles[1], angles[2], angles[3])
	self.trigger_axis = angles:Forward()
	self.angtolerance = tonumber(self.angtolerance) or 45
	self.angtolerance = math.Clamp(self.angtolerance,5,175)
	self:SetAngles(Angle()) --Reset since the angles keyvalue actually rotates the entity
	--print(self:GetName().." Angle :",self.angles," Axis: ",self.trigger_axis)
end
function ENT:StartTouch(ent)
	--print(self:GetName(),self.valid)
	if (not self.valid) or (ent.ClassName!="tp3_cabsignal_box") then return end --Only trigger for cab signal boxes and you have to be valid obviously
	--print("Made it!")
	local root = GetRoot(ent) --Get the root entity in case it's parented
	
	local vel = root:GetVelocity():GetNormalized()
	local dot = vel:Dot(self.trigger_axis)
	
	--print(self:GetName().." Dot: "..math.Round(dot,2))
	
	if dot<=0 then return end --If the entity isn't going the way we need it to, don't trigger
	
	local theta = math.acos(dot) --Theta in Radians
	theta = theta*180/math.pi --In Degrees
	if theta<=self.angtolerance then --Going in the right direction... trigger it!
		ent:PassSignal(self.homesignal,self.homesignalent.nextsignal or nil)
	end
	
end