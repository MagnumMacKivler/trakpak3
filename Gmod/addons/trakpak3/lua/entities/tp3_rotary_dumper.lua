AddCSLuaFile()
DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Rotary Dumper"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Emptying open-top cars."
ENT.Instructions = "Place in Hammer"
--ENT.AutomaticFrameAdvance = false --Not needed for manual animation sync

if SERVER then
	
	local V2D = Vector(1,1,0)
	local tick = engine.TickInterval()
	
	ENT.KeyValueMap = {
		model = "string",
		angles = "angle",
		skin = "number",
		bodygroups = "string",
		
		dumpangle = "number",
		maxspeed = "number",
		acceleration = "number",
		
		clamp_model = "string",
		clamp_max = "number",
		clamp_min = "number",
		axis_height = "number",
		
		sound_start = "string",
		sound_stop = "string",
		sound_dump = "string",
		sound_clamp = "string",
		
		motor_model = "string",
		motor_f = "number",
		motor_r = "number",
		
		positioner_enabled = "boolean",
		
		OnCarEmptied = "output",
		OnCycleFinished = "output"
	}
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		--Model/Physics Init
		self:SetModel(self.model)
		self:SetSkin(self.skin)
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		
		--Make me a mover, like func_tracktrain or func_movelinear
		self:PhysicsInit(SOLID_VPHYSICS)
		--self:MakePhysicsObjectAShadow(false, false)
		self:MakePhysicsObjectAShadow(true, true)
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SetMoveType(MOVETYPE_PUSH)
		
		self.moving = false
		self.dumpstage = 0
		self.roll = 0
		self.targetangle = 0
		self.speed = 0
		self.creepspeed = 2 --Minimum speed, used for stopping
		
		self.carheight = 0
		self.carlength = 0
		self.clamp_cycle = 0
		
		self.dumpangle = math.NormalizeAngle(self.dumpangle)
		
		self.stopdist = self:GetStoppingDistance(self.maxspeed, self.acceleration)
		
		self.att_motor_f = self:LookupAttachment("gear_front")
		self.att_motor_r = self:LookupAttachment("gear_rear")
		
		if self.att_motor_f == -1 then self.att_motor_f = nil end
		if self.att_motor_r == -1 then self.att_motor_r = nil end
		
		self.mul_motorf = 12
		self.mul_motorr = 12
		if self.motor_f==2 then self.mul_motorf = -12 end
		if self.motor_r==2 then self.mul_motorr = -12 end
		
		
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	--Sound Controls
	function ENT:DoStartSound()
		if self.sound then
			self.sound:Stop()
			self.sound = nil
		end
		if self.sound_start then
			self.soundstage = true
			self.sound = CreateSound(self,self.sound_start)
			self.sound:SetSoundLevel(90)
			self.sound:PlayEx(0.5,50)
		end
	end
	
	function ENT:DoStopSound()
		if self.sound then
			self.sound:Stop()
			self.sound = nil
		end
		self.soundstage = false
		if self.sound_stop then
			self.sound = CreateSound(self,self.sound_stop)
			self.sound:SetSoundLevel(90)
			self.sound:Play()
		end
	end
	
	function ENT:DoClampSound()
		if self.sound_clamp then self:EmitSound(self.sound_clamp) end
	end
	
	function ENT:DoDumpSound()
		if self.sound_dump then
			self:EmitSound(self.sound_dump, 90)
		end
	end
	
	--Mover Functions
	function ENT:EnableMover(duration)
		local savetable = self:GetSaveTable()
		self:SetSaveValue("m_flMoveDoneTime", savetable.ltime + (duration or 1))
	end
	
	function ENT:DisableMover()
		local savetable = self:GetSaveTable()
		self:SetSaveValue("m_flMoveDoneTime", savetable.ltime)
		self:SetLocalAngularVelocity(Angle(0,0,0))
	end
	
	function ENT:MoveToRoll(target, speed)
		local savetable = self:GetSaveTable()
		local angdiff = math.NormalizeAngle(target - self:GetAngles().roll)
		local duration = math.abs(angdiff)/math.abs(speed)
		
		self:SetSaveValue("m_flMoveDoneTime", savetable.ltime + duration)
		self:SetLocalAngularVelocity(Angle(0,0,speed))
		
		return duration
	end
	
	--Measure car height and internal length, weld it
	function ENT:MeasureCar()
		--Measure Car Height
		self.carheight = 0
		self.carlength = 0
		self.hascar = nil
		local ht = {
			start = self:GetPos() + Vector(0,0,self.clamp_max - self.axis_height + 8),
			endpos = self:GetPos(),
			maxs = Vector(64,64,1),
			mins = Vector(-64,-64,1),
			filter = Trakpak3.TraceFilter
		}
		
		local tr = util.TraceHull(ht)
		if tr.Hit then --There is a car!
			self.hascar = tr.Entity
			self.carheight = math.Clamp(tr.HitPos.z - self:GetPos().z + self.axis_height, self.clamp_min, self.clamp_max)
			
			--Weld the car
			if self.hascar and self.hascar:IsValid() then constraint.Weld(self, self.hascar, 0, 0, 0, false, false) end
			
			--Initialize the clamp animation
			if self.clamp and self.clamp:IsValid() then
				if not self.clamp_target then
					self.clamp:ResetSequence("clamp")
					--print("clamp")
				end
				
				self.clamp_target = math.Round(math.Remap(self.carheight, self.clamp_max, self.clamp_min, 0, 1), 2)
			end
			
			--Measure Internal Car Length
			local fwd = self:GetForward()
			local dbox = self:GetModelBounds().x
			
			local startpos = self:GetPos() + Vector(0,0,self.carheight - self.axis_height)
			
			ht = {
				start = startpos,
				endpos = startpos + fwd*dbox,
				maxs = Vector(4,4,4),
				mins = Vector(-4,-4,-4),
				filter = Trakpak3.TraceFilter
			}
			
			local trf = util.TraceHull(ht)
			
			ht.endpos = startpos - fwd*dbox
			
			local trb = util.TraceHull(ht)
			
			if trf.Hit and trb.Hit then
				self.carlength = trf.HitPos:Distance(trb.HitPos)
			end
			--print(self.carheight, self.carlength, self.clamp_cycle, self.clamp_target)
		end
	end
	
	--Calculate the minimum stopping distance given a current speed and decel rate
	function ENT:GetStoppingDistance(speed, acceleration)
		local dist = 0
		speed = math.abs(speed)
		acceleration = math.abs(acceleration)
		while speed>0 do
			speed = speed - acceleration/10
			if speed<0 then speed = 0 end
			
			dist = dist + speed/10
		end
		
		return dist
	end
	
	--Hammer Input Handler
	function ENT:AcceptInput( inputname, activator, caller, data )
		if (inputname=="Dump") then
			self:StartDump()
		elseif (inputname=="EnablePositioner") then
			self.positioner_enabled = true
		elseif (inputname=="DisablePositioner") then
			self.positioner_enabled = false
			self.positioning_ent = nil
		end
	end
	
	--Kick off the dump cycle
	function ENT:StartDump()
		if not self.moving then
			self.moving = true
			self.dumpstage = 1
			self:MeasureCar()
			self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
			self:DoStartSound()
		end
	end
	
	function ENT:Think()
		
		--Get the angle, relative to target. This is different from the tp3_turntable implementation
		self.angrelative = math.NormalizeAngle(self.dumpangle - self:GetAngles().roll)
		
		
		--Execute 10Hz code for managing speeds
		local ct = CurTime()
		if (not self.synctime) or (self.synctime and (ct>self.synctime)) then
			self.synctime = ct + 0.1
			
			if self.dumpstage==1 then --Initial Acceleration
			
				if math.abs(self.speed) < self.maxspeed then
					self.speed = math.Approach(self.speed, Trakpak3.Sign(self.dumpangle)*self.maxspeed, self.acceleration/10)
					self:SetLocalAngularVelocity(Angle(0,0,self.speed))
					self:EnableMover()
				else --Reached top speed
					self.dumpstage = 2
				end
				
			elseif self.dumpstage==2 then --Coasting, approaching decel point
			
				if math.abs(self.angrelative) < (self.stopdist + self.maxspeed/2) then --Start slowing down
					self.dumpstage = 3
				end
				self:EnableMover()
				
			elseif self.dumpstage==3 then --Slowing down
			
				if math.abs(self.speed) > self.creepspeed then
					self.speed = math.Approach(self.speed, Trakpak3.Sign(self.dumpangle)*self.creepspeed, self.acceleration/10)
					self:SetLocalAngularVelocity(Angle(0,0,self.speed))
				else --Reached creep speed; creep to stopping point, and schedule the return
					self.dumpstage = 4
				end
				self:EnableMover()
			elseif self.dumpstage==4 then --Creeping to stop
				local angdist = math.NormalizeAngle(self.dumpangle - self:GetAngles().roll)
				self.speed = Trakpak3.Sign(angdist)*math.Clamp(10*math.abs(angdist)/self.acceleration, 0.5, self.creepspeed)
				if math.abs(angdist) < 0.25 then --Close enough
					self:DoStopSound()
					self:DisableMover()
					self.speed = 0
					self.dumpstage = 5
					if self.hascar and self.hascar:IsValid() then self:TriggerOutput("OnCarEmptied",self) end
					timer.Simple(2, function()
						self.dumpstage = 6
						self:DoStartSound()
					end)
				else
					self:SetLocalAngularVelocity(Angle(0,0,self.speed))
					self:EnableMover()
				end
			elseif self.dumpstage==6 then --Return Acceleration
			
				if math.abs(self.speed) < self.maxspeed then
					self.speed = math.Approach(self.speed, -Trakpak3.Sign(self.dumpangle)*self.maxspeed, self.acceleration/10)
					self:SetLocalAngularVelocity(Angle(0,0,self.speed))
					self:EnableMover()
				else --Reached top speed
					self.dumpstage = 7
				end
				
			elseif self.dumpstage==7 then --Coasting
			
				if math.abs(self:GetAngles().roll) < (self.stopdist + self.maxspeed/2) then --Start slowing down
					self.dumpstage = 8
					if self.clamp_target then self.clamp_target = 0 end
				end
				self:EnableMover()
				
			elseif self.dumpstage==8 then --Slowing down
			
				if math.abs(self.speed) > self.creepspeed then
					self.speed = math.Approach(self.speed, -Trakpak3.Sign(self.dumpangle)*self.creepspeed, self.acceleration/10)
					self:SetLocalAngularVelocity(Angle(0,0,self.speed))
				else --Reached creep speed; creep to stopping point, and schedule the return
					--local duration = self:MoveToRoll(0, self.speed)
					self.dumpstage = 9
					--[[
					timer.Simple(duration, function()
						self:DoStopSound()
						self.speed = 0
						self.dumpstage = 0
						self.moving = false
						self:TriggerOutput("OnCycleFinished",self)
						self:SetCollisionGroup(COLLISION_GROUP_NONE)
						constraint.RemoveConstraints(self,"Weld") --Unweld the car
						self.hascar = nil
					end)
					]]--
				end
				self:EnableMover()
			elseif self.dumpstage==9 then --Creeping to a stop
				local angdist = math.NormalizeAngle(-self:GetAngles().roll)
				self.speed = Trakpak3.Sign(angdist)*math.Clamp(10*math.abs(angdist)/self.acceleration, 0.5, self.creepspeed)
				if math.abs(angdist) < 0.25 then --Close enough
					self:DoStopSound()
					self:DisableMover()
					self:SetAngles(self.angles) --Make sure it snaps. The angular difference between the car and the dumper should be negligible here.
					self.speed = 0
					self.dumpstage = 0
					self.moving = false
					self:TriggerOutput("OnCycleFinished",self)
					self:SetCollisionGroup(COLLISION_GROUP_NONE)
					constraint.RemoveConstraints(self,"Weld") --Unweld the car
					self.hascar = nil
				else
					self:SetLocalAngularVelocity(Angle(0,0,self.speed))
					self:EnableMover()
				end
			end
			
			--Spin Sound Modulation
			if self.soundstage and self.sound then
				self.sound:ChangePitch(math.Remap(math.abs(self.speed), 0, self.maxspeed, 50, 100),0.1)
				self.sound:ChangeVolume(math.Remap(math.abs(self.speed), 0, self.maxspeed, 0.5, 1),0.1)
			end
			
			--Dump Sound
			if self.hascar and (math.abs(self:GetAngles().roll) > 30) and not self.dumpin then
				self.dumpin = true
				self:DoDumpSound()
			elseif (math.abs(self:GetAngles().roll) < 5) and self.dumpin then
				self.dumpin = false
			end
			
		end --End 10Hz code
		
		--Adjust clamps
		if self.clamp_target and self.clamp_cycle then
			if self.clamp_cycle != self.clamp_target then
				self.clamp_cycle = math.Approach(self.clamp_cycle, self.clamp_target, engine.TickInterval()/8)
				
				--print(self.clamp_cycle)
				if self.clamp_cycle==self.clamp_target then --Finally reached it
					self:DoClampSound()
					if self.clamp_target==0 then
						self.clamp_target = nil
						if self.clamp and self.clamp:IsValid() then self.clamp:ResetSequence("idle") end
						--print("idle")
					end
				end
			end
			
		end
		
		--Spawn clamp model
		if Trakpak3.InitPostEntity then
		
			if not self.triedclamp then
				self.triedclamp = true
				if self.clamp_model and self.clamp_model != "" then
					self.clamp = ents.Create("tp3_prop_generic")
					self.clamp:SetModel(self.clamp_model)
					self.clamp:SetAngles(self:GetAngles())
					self.clamp:SetPos(self:GetPos())
					self.clamp:Spawn()
					self.clamp:SetParent(self)
					self.clamp:SetSkin(self.skin)
					--self.clamp:SetAutomaticFrameAdvance(false)
				end
			end
			
			--Spawn Motors
			if not self.triedmotors then
				self.triedmotors = true
				--0 none, 1 outside, 2 inside
				if self.motor_model and self.motor_model != "" and self.att_motor_f and self.att_motor_r then
					if self.motor_f != 0 then
						self.motor1 = ents.Create("tp3_prop_generic")
						self.motor1:SetModel(self.motor_model)
						self.motor1:SetPos(self:GetAttachment(self.att_motor_f).Pos)
						local a
						if self.motor_f==1 then
							a = self:LocalToWorldAngles(Angle(0,180,0))
						elseif self.motor_f==2 then
							a = self:GetAngles()
						end
						
						self.motor1:SetAngles(a)
						self.motor1:Spawn()
						self.motor1:SetSkin(self.skin)
						--self.motor1:PhysicsInitStatic(SOLID_VPHYSICS)
						self.motor1:SetAutomaticFrameAdvance(true)
					end
					
					if self.motor_r != 0 then
						self.motor2 = ents.Create("tp3_prop_generic")
						self.motor2:SetModel(self.motor_model)
						self.motor2:SetPos(self:GetAttachment(self.att_motor_r).Pos)
						local a
						if self.motor_f==2 then
							a = self:LocalToWorldAngles(Angle(0,180,0))
						elseif self.motor_f==1 then
							a = self:GetAngles()
						end
						
						self.motor2:SetAngles(a)
						self.motor2:Spawn()
						self.motor2:SetSkin(self.skin)
						--self.motor2:PhysicsInitStatic(SOLID_VPHYSICS)
						self.motor2:SetAutomaticFrameAdvance(true)
					end
					
				end
				
			end
			
			--Create Trigger Feeder for car positioner
			if not self.triedtrigger then
				self.triedtrigger = true
				self.trigger = ents.Create("tp3_collision_feeder")
				self.trigger:SetPos(self:GetPos())
				self.trigger:SetAngles(self:GetAngles())
				self.trigger:Spawn()
				self.trigger.TouchRedirector = self
				self.trigger:SetParent(self) 
				
				local abmins, abmaxs = self:WorldSpaceAABB()
				self.trigger:PlaceCollision(abmins,abmaxs)
			end
			
		end --End initpostentity
		
		--Control Gears
		if self.speed != 0 and not self.gearsmoving then
			self.gearsmoving = true
			
			if self.motor1 and self.motor1:IsValid() then
				local mspeed = self.speed*self.mul_motorf
				if mspeed < 0 then
					self.motor1:ResetSequence("turn_cw")
				else
					self.motor1:ResetSequence("turn_ccw")
				end
			end
			
			if self.motor2 and self.motor2:IsValid() then
				local mspeed = self.speed*self.mul_motorr
				if mspeed > 0 then
					self.motor2:ResetSequence("turn_cw")
				else
					self.motor2:ResetSequence("turn_ccw")
				end
			end
		
		elseif self.speed==0 and self.gearsmoving and self.dumpstage==0 then
			self.gearsmoving = false
			
			if self.motor1 and self.motor1:IsValid() then self.motor1:ResetSequence("idle") end
			if self.motor2 and self.motor2:IsValid() then self.motor2:ResetSequence("idle") end
		end
		
		--Modulate gear speed
		if self.gearsmoving then
			--Default speed is 1 Rev/sec = 360 DPS
			local mspeed = self.speed*math.abs(self.mul_motorf)
			if self.motor1 and self.motor1:IsValid() then self.motor1:SetPlaybackRate(mspeed/360) end
			if self.motor2 and self.motor2:IsValid() then self.motor2:SetPlaybackRate(mspeed/360) end
		end
		
		--Auto Positioner
		if self.positioner_enabled and (self.dumpstage==0) and self.positioning_ent and self.positioning_ent:IsValid() then
			local physobj = self.positioning_ent:GetPhysicsObject()
			local disp = (self:GetPos() - self.positioning_ent:GetPos())*V2D
			local vel = physobj:GetVelocity()
			local dist2 = disp:LengthSqr()
			local towards = (disp:Dot(vel)) > 0
			
			local distance = disp:Length()
			local disp_n = disp/distance
			local speedtowards = vel:Dot(disp_n)
			
			if vel:LengthSqr() < (200*200) then --If the car is moving at a reasonable pace:
				if (dist2 < 16*16) then --Car is close to center
					physobj:ApplyForceCenter((disp - vel)*0.5*physobj:GetMass()*tick*20)
				elseif towards then --Car is moving towards the dumper center
					local targetspeed = math.max(distance/4, 32) --The speed setpoint, will slow the car down to at or below this
					
					--Apply braking force
					if speedtowards > targetspeed then
						--local speed_err = speedtowards - targetspeed
						physobj:ApplyForceCenter(-disp_n*physobj:GetMass()*tick*200)
					end
					
				end
			end
			
		end
		
		--Execute Think every tick for smooth movement
		if self.clamp_target and self.clamp and self.clamp:IsValid() then self.clamp:SetCycle(self.clamp_cycle) end
		self:NextThink(CurTime())
		return true
	end
	
	--Trigger mirroring functions
	function ENT:StartTouch(ent)
		if not (ent and ent:IsValid()) then return end
		if self.positioner_enabled and not (self.positioning_ent and self.positioning_ent:IsValid()) and not Trakpak3.IsBlacklisted(ent) then --Positioning is enabled and there is no entity already being positioned, and it's not blacklisted
			local root = Trakpak3.GetRoot(ent) --Get the root in case it's parented
			self.positioning_ent = root
			print("Dumper locked on to entity ",root)
		end
		
		
	end
	
	function ENT:EndTouch(ent)
		if not (ent and ent:IsValid()) then return end
		if ent==self.positioning_ent then
			self.positioning_ent = nil
		end
	end
	
end