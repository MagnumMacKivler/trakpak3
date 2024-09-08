AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Turntable"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "You spin me right round baby right round"
ENT.Instructions = "Place in Hammer"

if SERVER then
	ENT.KeyValueMap = {
		model = "string",
		angles = "angle",
		skin = "number",
		bodygroups = "string",
		
		pod = "entity",
		exitpoint = "vector",
		
		stops = "string",
		maxspeed = "number",
		acceleration = "number",
		
		key_ccw = "string",
		key_cw = "string",
		
		sound_start = "string",
		sound_stop = "string"
	}
	
	function ENT:EnableMover(duration)
		local savetable = self:GetSaveTable()
		self:SetSaveValue("m_flMoveDoneTime", savetable.ltime + (duration or 1))
		self:StopFixerPos()
	end
	
	function ENT:DisableMover()
		local savetable = self:GetSaveTable()
		self:SetSaveValue("m_flMoveDoneTime", savetable.ltime)
		self:SetLocalAngularVelocity(Angle(0,0,0))
		self:SetFixerPos(self.fixerpos, self:GetAngles())
	end
	
	--util.AddNetworkString("TP3_TurnTable_ControlInfo")
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		self:SetModel(self.model)
		self:SetSkin(self.skin or 0)
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		
		--Make me a mover, like func_tracktrain or func_movelinear
		self:PhysicsInit(SOLID_VPHYSICS)
		self:MakePhysicsObjectAShadow(false, false)
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SetMoveType(MOVETYPE_PUSH)
		
		--Variable Inits
		self.speed = 0
		self.targetangle = nil
		self.synctime = nil
		self.locked = true
		
		self.startangle = self.angles.yaw
		
		self.pushers = {}
		
		self.soundstage = false
		--Process Stop Angles
		if self.stops then
			local stoparray = string.Explode(" ",self.stops)
			self.stops = {0,180}
			
			for k, ang in pairs(stoparray) do
				ang = math.NormalizeAngle(tonumber(ang))
				local ang2 = math.NormalizeAngle(ang + 180)
				
				local placed = false
				if ang!=-180 then
					for n=1,table.Count(self.stops) do
						if ang < self.stops[n] then
							table.insert(self.stops,n,ang)
							placed = true
							break
						elseif ang==self.stops[n] then
							placed = true
							break
						end
					end
					if not placed then table.insert(self.stops,nil,ang) end
				end
				
				
				
				placed = false
				if ang2!=-180 then
					for n=1,table.Count(self.stops) do
						if ang2 < self.stops[n] then
							table.insert(self.stops,n,ang2)
							placed = true
							break
						elseif ang2==self.stops[n] then
							placed = true
							break
						end
					end
					if not placed then table.insert(self.stops,nil,ang) end
				end
				
			end
			--print("\nAngle Stops:")
			--PrintTable(self.stops)
		end
		
		--Control Seat
		self:RegisterEntity("pod",self.pod)
		self.exitpoint = self:WorldToLocal(self.exitpoint)
		
		--Process controls
		self.enumccw = 0
		if self.key_ccw=="+forward" then
			self.enumccw = IN_FORWARD
		elseif self.key_ccw=="+back" then
			self.enumccw = IN_BACK
		elseif self.key_ccw=="+moveleft" then
			self.enumccw = IN_MOVELEFT
		elseif self.key_ccw=="+moveright" then
			self.enumccw = IN_MOVERIGHT
		end
		
		self.enumcw = 0
		if self.key_cw=="+forward" then
			self.enumcw = IN_FORWARD
		elseif self.key_cw=="+back" then
			self.enumcw = IN_BACK
		elseif self.key_cw=="+moveleft" then
			self.enumcw = IN_MOVELEFT
		elseif self.key_cw=="+moveright" then
			self.enumcw = IN_MOVERIGHT
		end
		
	end
	
	function ENT:TT_Driver()
		if not self.pod_valid then return nil end
		local driver = self.pod_ent:GetDriver()
		if driver:IsValid() then
			return driver
		else
			return nil
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
	
	--Find the next stop angle based on current angle and direction
	function ENT:GetNextStop(stops, ang, direction)
		if direction>0 then
			
			for n=1, table.Count(stops) do
				if ang<stops[n] then
					return stops[n]
				end
			end
			return stops[1]
			
		elseif direction<0 then
			
			local rstops = table.Reverse(stops)
			
			for n=1, table.Count(rstops) do
				if ang>rstops[n] then
					return rstops[n]
				end
			end
			return rstops[1]
		end
	end
	
	function ENT:DoStopSound()
		if self.soundstage and self.sound then
			self.soundstage = false
			self.sound:Stop()
			if self.sound_stop then
				self.sound = CreateSound(self,self.sound_stop)
				self.sound:Play()
			end
		end
	end
	
	function ENT:Think()
		
		--Get relative angle
		self.angrelative = self:GetAngles().yaw - self.startangle
		
		local ct = CurTime()
		if (not self.synctime) or (self.synctime and (ct>self.synctime)) then
			self.synctime = ct + 0.1
			--Execute 10Hz code
			
			--On/Off
			self.driver = self:TT_Driver()
			if self.driver and not self.active then
				self.active = true
				--net.Start("TP3_TurnTable_ControlInfo")
				net.Start("trakpak3")
					net.WriteString("tp3_turntable_controlinfo")
					net.WriteTable({
						ccw = self.key_ccw,
						cw = self.key_cw,
						stop = "+jump"
					})
				net.Send(self.driver)
				--print("Enabled.")
			elseif not self.driver and self.active and (self.speed==0) then
				self.active = false
				self:DisableMover()
				--print("Disabled.")
			end
			
			--Motion!
			if true then
				local throttle = 0
				local maxspeedmul = 1
				
				--Control Input
				if self.driver then
					
					if self.driver:KeyDown(IN_WALK) then --Eject player
						self.driver:ExitVehicle()
					end
					
					if not self.locked then
						local move_fwd = self.driver:KeyDown(self.enumccw)
						local move_rev = self.driver:KeyDown(self.enumcw)
						local stop_move = self.driver:KeyDown(IN_JUMP)
						
						if move_fwd then
							throttle = 1
						elseif move_rev then
							throttle = -1
						end
						
						if not self.forcestop and (math.abs(self.speed)>0) and stop_move then
							self.forcestop = true
						end
						--start sound
						if (throttle!=0) and not self.soundstage then
							self.soundstage = true
							if self.sound_start then
								self.sound = CreateSound(self,self.sound_start)
								self.sound:Play()
								self.sound:ChangePitch(50)
								self.sound:ChangeVolume(0.5)
							end
						end
					elseif self.locked then
						--Play a locked sound if you try to drive the turntable while it's locked
						local move_fwd = self.driver:KeyDown(IN_FORWARD)
						local move_rev = self.driver:KeyDown(IN_BACK)
						
						if (move_fwd or move_rev) and not self.lockq then
							self.lockq = true
							self.pod_ent:EmitSound("doors/door_locked2.wav")
						elseif not (move_fwd or move_rev) and self.lockq then
							self.lockq = false
						end
					end
				elseif not self.locked then --WE MUST POOSH LEETLE TURNTABLE
					
					for k, ply in pairs(self.pushers) do
						if ply:KeyDown(IN_USE) then --Player in the zone is pressing +use
							local eyevec = (ply:GetAimVector() * Vector(1,1,0)):GetNormalized()
							local dir2ply = ( (ply:GetPos() - self:GetPos())*Vector(1,1,0) ):GetNormalized()
							
							local tfactor = (dir2ply:Cross(eyevec)).z
							
							
							throttle = throttle + 0.25*tfactor
						end
						
						maxspeedmul = math.min(math.abs(throttle),0.5)
					end
					
				end
				
				
				local mspeed = self.maxspeed*maxspeedmul
				
				--Acceleration
				if (throttle==0) and self.forcestop then --decelerate to a stop
					if self.speed>0 then
						self.speed = self.speed - self.acceleration/10
						if self.speed<=0 then
							self.speed = 0
							self.forcestop = false
							self:DoStopSound()
						end
					elseif self.speed<0 then
						self.speed = self.speed + self.acceleration/10
						if self.speed>=0 then
							self.speed = 0
							self.forcestop = false
							self:DoStopSound()
						end
					end
					self.targetangle = nil
				elseif (throttle==0) and (math.abs(self.speed)>0) and not self.forcestop then --coast
					--Get target angle
					if not self.targetangle then
						local stopdist = self:GetStoppingDistance(self.speed, self.acceleration)*Trakpak3.Sign(self.speed)
						self.targetangle = self:GetNextStop(self.stops, math.NormalizeAngle(self.angrelative + stopdist), self.speed)
						self.maxlandingspeed = math.abs(self.speed)
					end
				elseif (throttle > 0) and (self.speed < (mspeed)) then --accel forward
					self.speed = self.speed + throttle*self.acceleration/10
					if self.speed > mspeed then self.speed = mspeed end
					self.targetangle = nil
				elseif (throttle < 0) and (self.speed > -mspeed) then --accel backwards
					self.speed = self.speed + throttle*self.acceleration/10
					if self.speed<-mspeed then self.speed = -mspeed end
					self.targetangle = nil
				end
				
				--sound processing
				if self.soundstage and self.sound then
					local sval = 0.5*math.abs(self.speed)/self.maxspeed + 0.5
					self.sound:ChangePitch(100*sval,0.1)
					self.sound:ChangeVolume(sval,0.1)
				end
				
				--Continue Movement
				if not self.targetangle then self:SetLocalAngularVelocity(Angle(0,self.speed,0)) end
				if self.speed != 0 then self:EnableMover() end
			end
		end
		
		--auto-stop
		if self.targetangle then
			local angdist = math.NormalizeAngle(self.targetangle - self.angrelative)
			self.speed = Trakpak3.Sign(angdist)*math.Clamp(math.abs(angdist)/self.acceleration, 0.5, self.maxlandingspeed)
			if math.abs(angdist) < 0.01 then --Close enough
				self.speed = 0
				self.targetangle = nil
				self:DoStopSound()
			end
			self:SetLocalAngularVelocity(Angle(0,self.speed,0))
		end
		
		--do the gofast
		self:NextThink(CurTime())
		return true
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	--Hammer Input Handler
	function ENT:AcceptInput( iname, activator, caller, data )
		if iname=="Lock" then
			self.locked = true
			self.pushers = {}
		elseif iname=="Unlock" then
			self.locked = false
		elseif iname=="AddPusher" then
			if activator and activator:IsPlayer() then 
				local newply = true
				for _, ply in pairs(self.pushers) do
					if activator == ply then newply = false end
				end
				if newply then table.insert(self.pushers, activator) end
			end
		elseif iname=="RemovePusher" then
			if activator and activator:IsPlayer() then
				for index, ply in pairs(self.pushers) do
					if activator==ply then
						table.remove(self.pushers, index)
						break
					end
				end
			end
		end
	end
	
	--Teleport player to exit point
	hook.Add("PlayerLeaveVehicle","Trakpak3_TurnTableExit", function(ply, veh)
		timer.Simple(0,function()
			if ply and veh then
				for k, self in pairs(ents.FindByClass("tp3_turntable")) do
					if self.pod_valid and self.exitpoint and (veh==self.pod_ent) then
						ply:SetPos(self:LocalToWorld(self.exitpoint))
						--print("Player Exit!")
					end
				end
			end
		end)
	end)
	
end

if CLIENT then
	--[[
	net.Receive("TP3_TurnTable_ControlInfo",function()
		local binds = net.ReadTable()
		
		local ccw = string.upper(input.LookupBinding(binds.ccw))
		local cw = string.upper(input.LookupBinding(binds.cw))
		local stop = string.upper(input.LookupBinding(binds.stop))
		
		local message = "Turntable Controls:\n"..ccw.." - Move Counterclockwise\n"..cw.." - Move Clockwise\n"..stop.." - Manual Stop"
		
		chat.AddText(Color(0,191,255),"[TRAKPAK3] ",Color(255,223,0),message)
	end)
	]]--
	Trakpak3.Net.tp3_turntable_controlinfo = function(len,ply)
		local binds = net.ReadTable()
		
		local ccw = string.upper(input.LookupBinding(binds.ccw))
		local cw = string.upper(input.LookupBinding(binds.cw))
		local stop = string.upper(input.LookupBinding(binds.stop))
		local eject = string.upper(input.LookupBinding("+walk"))
		
		local message = "Turntable Controls:\n"..ccw.." - Move Counterclockwise\n"..cw.." - Move Clockwise\n"..stop.." - Manual Stop".."\n"..eject.." - Force Exit"
		
		chat.AddText(Color(0,191,255),"[TRAKPAK3] ",Color(255,223,0),message)
	end
end