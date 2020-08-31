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

if SERVER then
	ENT.KeyValueMap = {
		homesignal = "entity",
		angles = "angle",
		angtolerance = "number"
	}
	
	--Assign keyvalues to the entity and do some basic validation/processing
	function ENT:KeyValue(key, value)
		local datatype = self.KeyValueMap[key]
		local patterned = false
		if not datatype then
			for kvpattern, dt in pairs(self.KeyValueMap) do
				if string.Right(kvpattern,1)=="*" then
					if string.Left(kvpattern, #kvpattern-1)==string.Left(key, #key-1) then
						datatype = dt
						patterned = true
						break
					end
				end
			end
		end
		
		if patterned and not self.pkvs then self.pkvs = {} end
		
		if not datatype then datatype = "string" end
		
		if datatype=="number" then
			if patterned then self.pkvs[key] = tonumber(value) or 0 else self[key] = tonumber(value) or 0 end
		elseif datatype=="boolean" then
			if value=="1" or string.lower(value)=="true" then
				if patterned then self.pkvs[key] = true else self[key] = true end
			else
				if patterned then self.pkvs[key] = false else self[key] = false end
			end
		elseif datatype=="string" or datatype=="entity" then
			if patterned then self.pkvs[key] = value or "" else self[key] = value or "" end
		elseif datatype=="vector" then
			if patterned then self.pkvs[key] = Trakpak3.HammerStringToVector(value) else self[key] = Trakpak3.HammerStringToVector(value) end
		elseif datatype=="angle" then
			if patterned then self.pkvs[key] = Trakpak3.HammerStringToAngle(value) else self[key] = Trakpak3.HammerStringToAngle(value) end
		elseif datatype=="output" then
			self:StoreOutput(key, value)
		end		
	end
	
	function ENT:RegisterEntity(varname, targetname)
		local ent, valid = Trakpak3.FindByTargetname(targetname)
		self[varname.."_valid"] = valid
		if valid then
			self[varname.."_ent"] = ent
		end
	end
	
	function ENT:Initialize()
		--Variable Init/Validation
		self:RegisterEntity("homesignal",self.homesignal)
		self.trigger_axis = self.angles:Forward()
		self.angtolerance = math.Clamp(self.angtolerance or 45, 5, 175)
		self:ValidateNumerics()
		
		--Reset since the angles KV actually rotates the entity
		self:SetAngles(Angle())
	end
	
	function ENT:StartTouch(ent)
		if (not self.homesignal_valid) or (ent:GetClass()!="gmod_wire_tp3_cabsignal_box") then return end --Only trigger for cab signal boxes and you have to be valid obviously
		local root = Trakpak3.GetRoot(ent) --Get the root entity in case it's parented
		
		local vel = root:GetVelocity():GetNormalized()
		local dot = vel:Dot(self.trigger_axis)
		
		if dot<=0 then return end --If the entity isn't going the way we need it to, don't trigger
		
		local theta = math.acos(dot) --Theta in Radians
		theta = theta*180/math.pi --In Degrees
		if theta<=self.angtolerance then --Going in the right direction... trigger it!
			ent:PassSignal(self.homesignal,self.homesignal_ent.nextsignal or nil)
		end
		
	end
end