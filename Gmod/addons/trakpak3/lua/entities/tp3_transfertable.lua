AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Turntable"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Sliiiide to the Left. Sliiiide to the Right. Cha Cha Real Smooth."
ENT.Instructions = "Place in Hammer"

if SERVER then
	ENT.KeyValueMap = {
		model = "string",
		angles = "angle",
		skin = "number",
		
		pod = "entity",
		exitpoint = "vector",
		table_axis = "vector",
		stops = "string",
		maxspeed = "number",
		acceleration = "number",
		
		sound_start = "string",
		sound_stop = "string",
		sound_crash = "string"
	}
	
	function ENT:EnableMover(duration)
		local savetable = self:GetSaveTable()
		self:SetSaveValue("m_flMoveDoneTime", savetable.ltime + (duration or 1))
	end
	
	function ENT:DisableMover()
		local savetable = self:GetSaveTable()
		self:SetSaveValue("m_flMoveDoneTime", savetable.ltime)
		self:SetLocalVelocity(Vector(0,0,0))
	end
	
	util.AddNetworkString("TP3_TransTable_ControlInfo")
	
	function ENT:Initialize()
		self:ValidateNumerics()
	
		self:SetModel(self.model)
		self:SetSkin(self.skin or 0)
		
		--Make me a mover, like func_tracktrain or func_movelinear
		self:PhysicsInit(SOLID_VPHYSICS)
		self:MakePhysicsObjectAShadow(false, false)
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SetMoveType(MOVETYPE_PUSH)
		
		--Variable Inits
		self.speed = 0
		self.targetpos = nil
		self.synctime = nil
		
		self.zeropos = self:GetPos()
		self.pos = 0
		
		self.soundstage = false
		--Process Stop Positions
		if self.stops then
			local stoparray = string.Explode(" ",self.stops)
			self.stops = {}
			
			for k, pos in pairs(stoparray) do
				pos = tonumber(pos)
				self.stops[k] = pos
			end
			--print("\nLinear Stops:")
			--PrintTable(self.stops)
		end
		
		self.minpos = self.stops[1]
		self.maxpos = self.stops[#self.stops]
		
		--Control Seat
		self:RegisterEntity("pod",self.pod)
		self.exitpoint = self:WorldToLocal(self.exitpoint)
	end
	
	--Get numeric position of transfer table
	function ENT:GetTransPos()
		local disp = self:GetPos() - self.zeropos
		return disp:Dot(self.table_axis)/self.table_axis:LengthSqr()
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
		--print("Minimum Stopping Distance: ",dist)
		--print("Current Pos: ",self.pos)
		return dist
	end
	
	--Find the next stop pos based on current position and direction
	function ENT:GetNextStop(stops, pos, direction)
		if direction>0 then
			
			for n=1, table.Count(stops) do
				if pos<stops[n] then
					return stops[n], nil
				end
			end
			return stops[#stops], true
			
		elseif direction<0 then
			
			local rstops = table.Reverse(stops)
			
			for n=1, table.Count(rstops) do
				if pos>rstops[n] then
					return rstops[n], nil
				end
			end
			return stops[table.Count(rstops)], true
		end
	end
	
	function ENT:DoStopSound(hard)
		if self.soundstage and self.sound then
			self.soundstage = false
			self.sound:Stop()
			if self.sound2 then self.sound2:Stop() end
			if self.sound_stop then
				self.sound = CreateSound(self,self.sound_stop)
				self.sound:Play()
				if hard and self.sound_crash then
					self.sound2 = CreateSound(self,self.sound_crash)
					self.sound2:Play()
					--util.ScreenShake(self:GetPos(),5,5,1,2048)
				end
			end
		end
	end
	
	function ENT:Think()
		--Get Current Position
		self.pos = self:GetTransPos()
		
		local ct = CurTime()
		if (not self.synctime) or (self.synctime and (ct>self.synctime)) then
			self.synctime = ct + 0.1
			--Execute 10Hz code
			
			--On/Off
			self.driver = self:TT_Driver()
			if self.driver and not self.active then
				self.active = true
				net.Start("TP3_TransTable_ControlInfo")
					net.WriteTable({left="+moveleft",right="+moveright",stop="+jump"})
				net.Send(self.driver)
				print("Enabled.")
			elseif not self.driver and self.active and (self.speed==0) then
				self.active = false
				self:DisableMover()
				print("Disabled.")
			end
			
			--Motion!
			if self.active then
				
				--Control Input
				local throttle = 0
				if self.driver then
					local move_fwd = self.driver:KeyDown(IN_MOVERIGHT) and (self.pos<self.maxpos)
					local move_rev = self.driver:KeyDown(IN_MOVELEFT) and (self.pos>self.minpos)
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
				end
				
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
					self.targetpos = nil
				elseif (throttle==0) and (math.abs(self.speed)>0) and not self.forcestop then
					--Get target angle
					if not self.targetpos then
						local stopdist = self:GetStoppingDistance(self.speed, self.acceleration)*Trakpak3.Sign(self.speed)
						self.targetpos, self.hard = self:GetNextStop(self.stops, self.pos + stopdist, self.speed)
						self.maxlandingspeed = math.abs(self.speed)
					end
					
				elseif (throttle==1) and (self.speed<self.maxspeed) then --accel forward
					self.speed = self.speed + self.acceleration/10
					if self.speed>self.maxspeed then self.speed = self.maxspeed end
					self.targetpos = nil
				elseif (throttle==-1) and (self.speed>-self.maxspeed) then --accel backwards
					self.speed = self.speed - self.acceleration/10
					if self.speed<-self.maxspeed then self.speed = -self.maxspeed end
					self.targetpos = nil
				end
				
				--sound processing
				if self.soundstage and self.sound then
					local sval = 0.5*math.abs(self.speed)/self.maxspeed + 0.5
					self.sound:ChangePitch(100*sval,0.1)
					self.sound:ChangeVolume(sval,0.1)
				end
				
				--Continue Movement
				if not self.targetpos then
					self:SetLocalVelocity(self.table_axis*self.speed)
				end
				self:EnableMover()
			end
		end
		
		
		--End Detection
		local dir = Trakpak3.Sign(self.speed)
		if ((dir==-1) and (self.pos < (self.minpos-2))) or ((dir==1) and (self.pos > (self.maxpos+2))) then
			self.speed = 0
			self.targetpos = nil
			self:DoStopSound(true)
		end
		--auto-stop
		if self.targetpos and not self.hard then
			local posdist = self.targetpos - self.pos
			self.speed = Trakpak3.Sign(posdist)*math.Clamp(4*math.abs(posdist)/self.acceleration, 1, self.maxlandingspeed)
			if math.abs(posdist) < 0.01 then --Close enough
				self.speed = 0
				self.targetpos = nil
				self:DoStopSound()
			end
			self:SetLocalVelocity(self.table_axis*self.speed)
		end
		
		--do the gofast
		self:NextThink(CurTime())
		return true
	end
	
	--Teleport player to exit point
	hook.Add("PlayerLeaveVehicle","Trakpak3_TransferTableExit", function(ply, veh)
		if ply and veh then
			for k, self in pairs(ents.FindByClass("tp3_transfertable")) do
				if self.pod_valid and self.exitpoint and (veh==self.pod_ent) then
					ply:SetPos(self:LocalToWorld(self.exitpoint))
					--print("Player Exit!")
				end
			end
		end
	end)
	
end

if CLIENT then
	net.Receive("TP3_TransTable_ControlInfo",function()
		local binds = net.ReadTable()
		local left = string.upper(input.LookupBinding(binds.left))
		local right = string.upper(input.LookupBinding(binds.right))
		local stop = string.upper(input.LookupBinding(binds.stop))
		
		local message = "Transfer Table Controls:\n"..left.." - Move Left\n"..right.." - Move Right\n"..stop.." - Manual Stop"
		
		chat.AddText(Color(0,191,255),"[TRAKPAK3] ",Color(255,223,0),message)
	end)
end