AddCSLuaFile()

DEFINE_BASECLASS( "base_point" )
ENT.Spawnable = false
ENT.Editable = false
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.RenderGroup = RENDERGROUP_BOTH

if SERVER then
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
		elseif datatype=="color" then
			if patterned then self.pkvs[key] = Trakpak3.HammerStringToColor(value) else self[key] = Trakpak3.HammerStringToColor(value) end
		elseif datatype=="flags" then
			--Cannot be patterned
			local flags = {}
			local flagint = tonumber(value)
			for n = 1, (self.NumFlags or 0) do
				local power = math.pow(2,n-1)
				flags[n] = bit.band(flagint,power)==power
			end
			self[key] = flags
		elseif datatype=="output" then
			self:StoreOutput(key, value)
		end		
	end
	
	--Validate Entity KVs
	function ENT:RegisterEntity(varname, targetname)
		local ent, valid = Trakpak3.FindByTargetname(targetname)
		self[varname.."_valid"] = valid
		if valid then
			self[varname.."_ent"] = ent
		end
	end
	
	--Validate Numeric KVs (in case hammer neglects to set 0's to anything)
	function ENT:ValidateNumerics()
		local KVM = self.KeyValueMap
		if KVM and not table.IsEmpty(KVM) then
			for key, dtype in pairs(KVM) do
				if dtype=="number" then
					self[key] = self[key] or 0
				elseif dtype=="flags" then
					self[key] = self[key] or {}
				end
			end
		end
	end
	
end