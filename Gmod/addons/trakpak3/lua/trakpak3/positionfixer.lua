--Script to fix the positions of entities that somehow get moved.
if not Trakpak3.PositionFixer then Trakpak3.PositionFixer = {} end

local PosFix = Trakpak3.PositionFixer

if not PosFix.Registry then PosFix.Registry = {} end --Table of entities to check

local lastfix = 0

local postolerance = 0.25
local angtolerance = 0.5

--Scan through all entities in the registry and fix their positions if necessary
hook.Add("Think","Trakpak3_PositionFixer",function()
	local ct = CurTime()
	if (ct - lastfix) > 60 then --Scan every 60 seconds
		lastfix = ct
		--print("Scanning...")
		for ent, data in pairs(PosFix.Registry) do
			if ent:IsValid() then
				if not (ent:GetParent() and ent:GetParent():IsValid()) then --Don't check positions for parented entities since they are probably going to be moving anyway
					local snd = false
					if data.pos then --Check position
						local mypos = ent:GetPos()
						if not mypos:IsEqualTol(data.pos, postolerance) then --Reposition
							ent:SetPos(data.pos)
							local phys = ent:GetPhysicsObject()
							if phys and phys:IsValid() then phys:SetPos(data.pos, true) end
							print("[Trakpak3] Repositioning entity ",ent)
							snd = true
						end
					end
					if data.ang then --Check angle
						local myang = ent:GetAngles()
						if not myang:IsEqualTol(data.ang, angtolerance) then --Reorient
							ent:SetAngles(data.ang)
							local phys = ent:GetPhysicsObject()
							if phys and phys:IsValid() then phys:SetAngles(data.ang) end
							print("[Trakpak3] Reorienting entity ",ent)
							snd = true
						end
					end
					if snd then ent:EmitSound("physics/metal/crowbar_impact1.wav",85) end
				end
			else --Entity is invalid, wipe it.
				PosFix.Registry[ent] = nil
			end
		end
	end
end)