AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Movable Bridge"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "F@#$ing tugboat!"
ENT.Instructions = "Place in Hammer"

if SERVER then
	ENT.KeyValueMap = {
		model = "string",
		angles = "angle",
		skin = "number",
		bodygroups = "string",
		
		pod = "entity",
		exitpoint = "vector",
		
		maxcycle = "number",
		maxspeed = "number",
		acceleration = "number",
		
		deck1 = "entity",
		deck2 = "entity",
		deck3 = "entity",
		deck4 = "entity",
		
		key_open = "string",
		key_close = "string",
		
		sound_start = "string",
		sound_stop = "string",
		
		sound_crank_start = "string",
		sound_crank_stop = "string",
		
		phystoggle = "boolean",
		nowire = "boolean",
		
		OnFullyOpen = "output",
		OnFullyClosed = "output",
		OnBridgeStarted = "output",
		OnBridgeStopped = "output",
		OnInitialize = "output"
	}
	
	util.AddNetworkString("TP3_MoveBridge_ControlInfo")
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		self:SetModel(self.model)
		self:SetSkin(self.skin or 0)
		self:SetBodygroups(self.bodygroups)
		
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		
		--Variable Inits
		self.speed = 0
		self.cycle = 0
		self.fullyclosed = true
		
		self.cranking = false
		
		self.movementq = false
		
		self.targetcycle = nil
		self.direction = 0
		
		self.pushers = {}
		
		self.soundstage = 0
		
		self.initfired = false
		
		self.oldcycle = self.cycle
		
		--Control Seat
		self:RegisterEntity("pod",self.pod)
		self.exitpoint = self:WorldToLocal(self.exitpoint)
		
		--Process controls
		self.enumo = 0
		if self.key_open=="+forward" then
			self.enumo = IN_FORWARD
		elseif self.key_open=="+back" then
			self.enumo = IN_BACK
		elseif self.key_open=="+moveleft" then
			self.enumo = IN_MOVELEFT
		elseif self.key_open=="+moveright" then
			self.enumo = IN_MOVERIGHT
		end
		
		self.enumc = 0
		if self.key_close=="+forward" then
			self.enumc = IN_FORWARD
		elseif self.key_close=="+back" then
			self.enumc = IN_BACK
		elseif self.key_close=="+moveleft" then
			self.enumc = IN_MOVELEFT
		elseif self.key_close=="+moveright" then
			self.enumc = IN_MOVERIGHT
		end
		
		--Deck
		
		for n=1,4 do
			local dkey = "deck"..n
			self:RegisterEntity(dkey,self[dkey])
			local leafid = self:LookupAttachment("leaf"..n)
			if leafid <=0 then leafid = self:LookupAttachment("leaf1") end
			
			if self[dkey.."_valid"] and (leafid>0) then 
				--print(self[dkey.."_valid"])
				self:SetNWInt("attachment"..n,leafid)
				local att = self:GetAttachment(leafid)
				local apos = att.Pos
				local aang = att.Ang
				
				local ent = self[dkey.."_ent"]
				
				local v, a = WorldToLocal( ent:GetPos(), ent:GetAngles(), apos, aang )
				self:SetNWString("deckmodel"..n,ent:GetModel())
				self:SetNWVector("deckpos"..n,v)
				self:SetNWAngle("deckang"..n,a)
				self:SetNWInt("deckskin"..n,ent:GetSkin())
				
				ent:SetNoDraw(true)
			elseif (leafid<1) then
				ErrorNoHalt("[Trakpak3] Movable Bridge "..self.model.." with invalid attachment name (needs 'leaf1', 'leaf2', 'leaf3', or 'leaf4')!")
			end
		end
		
		--Wire I/O
		if WireLib then
			if not self.nowire then
				local names = {"Open", "Close", "TargetCycle", "Stop"}
				local types = {"NORMAL","NORMAL","NORMAL","NORMAL"}
				local descs = {}
				WireLib.CreateSpecialInputs(self, names, types, descs)
			end
			
			local names = {"Cycle", "Locked", "FullyClosed"}
			local types = {"NORMAL","NORMAL","NORMAL"}
			WireLib.CreateSpecialOutputs(self, names, types, descs)
			
			WireLib.TriggerOutput(self,"FullyClosed",1)
		end
		
		--Auto-play animation
		timer.Simple(1,function() self:ResetSequence("range") end)
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
	
	function ENT:DoStopSound(final)
		if (self.soundstage==1) and self.sound then --Powered Stop Sound
			self.soundstage = 0
			self.sound:Stop()
			if self.sound_stop then
				self.sound = CreateSound(self,self.sound_stop)
				self.sound:Play()
			end
		elseif (self.soundstage==2) and self.sound then
			
			self.soundstage = 0
			self.sound:Stop()
			
			if final then
				if self.sound_crank_stop then
					self.sound = CreateSound(self,self.sound_crank_stop)
					self.sound:Play()
				end
			end
		end
	end
	
	--Control solidity of track
	function ENT:SetTrackPhysics(solid)
		self:SetNotSolid(not solid)
		for n=1,4 do
			if self["deck"..n.."_valid"] then self["deck"..n.."_ent"]:SetNotSolid(not solid) end
		end
	end
	
	--Designate Move Direction for Automatic Control
	function ENT:AnalyzeDirection(set)
		if set and self.targetcycle then
			if self.targetcycle > self.cycle then
				self.direction = 1
			elseif self.targetcycle < self.cycle then
				self.direction = -1
			else
				self.direction = 0
			end
		else
			self.direction = 0
		end
	end
	
	--Handle Throttle, acceleration, movement
	function ENT:Think()
		
		local ct = CurTime()
		if (not self.synctime) or (self.synctime and (ct>self.synctime)) then
			self.synctime = ct + 0.1
			--Execute 10Hz code
			
			--On/Off
			self.driver = self:TT_Driver()
			if self.driver and not self.active then
				self.active = true
				net.Start("TP3_MoveBridge_ControlInfo")
					net.WriteTable({
						open = self.key_open,
						close = self.key_close,
						stop = "+jump"
					})
				net.Send(self.driver)
				self.targetcycle = nil
				--print("Enabled.")
			elseif not self.driver and self.active and (self.speed==0) then
				self.active = false
				--self:DisableMover()
				--print("Disabled.")
			end
			
			--Motion!
			if true then
				local throttle = 0
				local maxspeedmul = 1
				
				local atmin = self.cycle==0
				local atmax = self.cycle==self.maxcycle
				
				--Control Input
				if self.driver then

					local move_fwd = self.driver:KeyDown(self.enumo)
					local move_rev = self.driver:KeyDown(self.enumc)
					--local stop_move = self.driver:KeyDown(IN_JUMP)
					
					if not (atmin and self.locked) then
					
						if move_fwd and not atmax then
							throttle = 1
						elseif move_rev and not atmin then
							throttle = -1
						end
						
						--Power start sound
						if (throttle!=0) and  (self.soundstage!=1) then
							self.soundstage = 1
							if self.sound then self.sound:Stop() end
							if self.sound_start then
								self.sound = CreateSound(self,self.sound_start)
								self.sound:Play()
								--self.sound:ChangePitch(50)
								self.sound:ChangeVolume(0.75)
							end
						end
					else
						--Play a locked sound if you try to drive the turntable while it's locked
						
						if (move_fwd or move_rev) and not self.lockq then
							self.lockq = true
							self.pod_ent:EmitSound("doors/door_locked2.wav")
						elseif not (move_fwd or move_rev) and self.lockq then
							self.lockq = false
						end
					end

				else --WE MUST POOSH LEETLE bridge / automatic Control
				
					local using = false
					
					if not (atmin and self.locked) then
						for k, ply in pairs(self.pushers) do
						
							if ply:KeyDown(IN_USE) then --Player in the zone is pressing +use
							
								using = true
								
								if not self.cranking then
									local tfactor = ply:GetAimVector().z
									if tfactor > 0 then tfactor = 1 elseif tfactor < 0 then tfactor = -1 end
									self.cranking = tfactor
								end
								
							end
						end
					end
					
					if using then
						throttle = 0.25*self.cranking
						
						if atmin and (throttle<0) then throttle = 0 end
						if atmax and (throttle>0) then throttle = 0 end
						
						--Lever Sound
						if (throttle!=0) and (self.soundstage==0) then
							self.soundstage = 2
							if self.sound then self.sound:Stop() end
							if self.sound_crank_start then
								self.sound = CreateSound(self,self.sound_crank_start)
								self.sound:Play()
								self.sound:ChangeVolume(0.75)
							end
						end
						
						maxspeedmul = math.abs(throttle) --math.min(math.abs(throttle),0.5)
						
					else
						self.cranking = false
					end
					
					
					
					--Automatic Control
					if self.targetcycle then
						if throttle!=0 then
							self.targetcycle = nil
						else
							if self.targetcycle > self.cycle then
								throttle = 1
							elseif self.targetcycle < self.cycle then
								throttle = -1
							end
							
							if (throttle!=0) and (self.soundstage!=1) then
								--Start Sound
								self.soundstage = 1
								if self.sound then self.sound:Stop() end
								if self.sound_start then
									self.sound = CreateSound(self,self.sound_start)
									self.sound:Play()
									--self.sound:ChangePitch(50)
									self.sound:ChangeVolume(0.75)
								end
							end
							
						end
					end
					
				end
				
				
				local mspeed = self.maxspeed*maxspeedmul
				
				--Acceleration
				if (throttle==0) then --decelerate to a stop
					if self.speed>0 then
						self.speed = self.speed - self.acceleration/10
						if self.speed<=0 then
							self.speed = 0
							self.forcestop = false
							self:DoStopSound()
							self.movementq = false
							self:TriggerOutput("OnBridgeStopped",self,tostring(self.cycle))
						end
					elseif self.speed<0 then
						self.speed = self.speed + self.acceleration/10
						if self.speed>=0 then
							self.speed = 0
							self.forcestop = false
							self:DoStopSound()
							self.movementq = false
							self:TriggerOutput("OnBridgeStopped",self,tostring(self.cycle))
						end
					end
					self.targetangle = nil
				elseif (throttle > 0) and (self.speed < (mspeed)) then --accel forward
					self.speed = self.speed + throttle*self.acceleration/10
					if self.speed > mspeed then self.speed = mspeed end
				elseif (throttle < 0) and (self.speed > -mspeed) then --accel backwards
					self.speed = self.speed + throttle*self.acceleration/10
					if self.speed<-mspeed then self.speed = -mspeed end
				end
				
				--Handle Solidity
				if self.phystoggle then
					if (throttle==0) and (self.speed==0) then
						if (self.cycle==0) and not self.fullyclosed then
							self.fullyclosed = true
							self:SetTrackPhysics(true)
						end
					elseif self.fullyclosed then
						self.fullyclosed = false
						self:SetTrackPhysics(false)
					end
				end
				
			end
			
		end
		
		--Animotion
		if self.speed != 0 then
			
			if not self.movementq then
				self.movementq = true
				self:TriggerOutput("OnBridgeStarted",self)
				--print("Bridge Started Moving!")
			end
			
			self.cycle = self.cycle + self.speed*engine.TickInterval()
			
			if self.targetcycle then --Automatic
				if (self.direction>0) and (self.cycle >= self.targetcycle) then
					self.speed = 0
					self.cycle = self.targetcycle
					self.targetcycle = nil
					local atmax = self.cycle==self.maxcycle
					--print(self.cycle, self.maxcycle)
					self:DoStopSound(atmax)
					self.movementq = false
					self:AnalyzeDirection(false)
					self:TriggerOutput("OnBridgeStopped",self,tostring(self.cycle))
					if atmax then
						self:TriggerOutput("OnFullyOpen",self)
						--print("Bridge Fully Open!")
					end
					
				elseif (self.direction<0) and (self.cycle <= self.targetcycle) then
					self.speed = 0
					self.cycle = self.targetcycle
					self.targetcycle = nil
					local atmin = self.cycle==0
					--print(self.cycle, 0)
					self:DoStopSound(atmin)
					self.movementq = false
					self:AnalyzeDirection(false)
					self:TriggerOutput("OnBridgeStopped",self,tostring(self.cycle))
					if atmin then
						self:TriggerOutput("OnFullyClosed",self)
						--print("Bridge Fully Closed!")
					end
					
				end
			else --Piloted Movement
			
				if self.cycle >= self.maxcycle then
					self.speed = 0
					self.cycle = self.maxcycle
					self:DoStopSound(true)
					self.movementq = false
					self:AnalyzeDirection(false)
					self:TriggerOutput("OnFullyOpen",self)
					self:TriggerOutput("OnBridgeStopped",self,"1")
				elseif self.cycle <= 0 then
					self.speed = 0
					self.cycle = 0
					self:DoStopSound(true)
					self.movementq = false
					self:AnalyzeDirection(false)
					self:TriggerOutput("OnFullyClosed",self)
					self:TriggerOutput("OnBridgeStopped",self,"0")
					if WireLib then WireLib.TriggerOutput(self,"FullyClosed",1) end
				end
			end
			self:SetCycle(self.cycle)
			
			if self.cycle != self.oldcycle then
				self.oldcycle = self.cycle
				if WireLib then WireLib.TriggerOutput(self,"Cycle",self.cycle) end
			end
		end
		
		--Fire Init thing
		if not self.initfired and Trakpak3.InitPostEntity then
			self.initfired = true
			self:TriggerOutput("OnInitialize",self)
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
			--self.pushers = {}
			if WireLib then WireLib.TriggerOutput(self,"Locked",1) end
		elseif iname=="Unlock" then
			self.locked = false
			if WireLib then WireLib.TriggerOutput(self,"Locked",0) end
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
		elseif (iname=="Open") and ((self.cycle > 0) or not self.locked) then
			self.targetcycle = 1
			self:AnalyzeDirection(true)
		elseif (iname=="Close") and (self.cycle>0) then
			self.targetcycle = 0
			self:AnalyzeDirection(true)
		elseif (iname=="GoToCycle") and ((self.cycle > 0) or not self.locked) then
			self.targetcycle = math.Clamp(tonumber(data),0,1)
			self:AnalyzeDirection(true)
		elseif (iname=="Stop") then
			self.targetcycle = nil
			self:AnalyzeDirection()
		end
	end
	
	--Wire input handler
	function ENT:TriggerInput(iname, value)
		if iname=="Open" and value>0 and ((self.cycle>0) or not self.locked) then
			self.targetcycle = 1
			self:AnalyzeDirection(true)
		elseif iname=="Close" and value>0 and (self.cycle>0) then
			self.targetcycle = 0
			self:AnalyzeDirection(true)
		elseif iname=="TargetCycle" and value>0 then
			self.targetcycle = math.Clamp(value,0,1)
			self:AnalyzeDirection(true)
		elseif iname=="Stop" then
			self.targetcycle = nil
			self:AnalyzeDirection(false)
		end
	end
	
	--Teleport player to exit point
	hook.Add("PlayerLeaveVehicle","Trakpak3_BridgeExit", function(ply, veh)
		timer.Simple(0,function()
			if ply and veh then
				for k, self in pairs(ents.FindByClass("tp3_movable_bridge")) do
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
	net.Receive("TP3_MoveBridge_ControlInfo",function()
		local binds = net.ReadTable()
		
		local open = string.upper(input.LookupBinding(binds.open))
		local close = string.upper(input.LookupBinding(binds.close))
		
		local message = "Movable Bridge Controls:\n"..open.." - Open Bridge\n"..close.." - Close Bridge"
		
		chat.AddText(Color(0,191,255),"[TRAKPAK3] ",Color(255,223,0),message)
	end)
	
	function ENT:Draw(flags)
		self:DrawModel(flags)
		for n=1,4 do
			local pos = self:GetNWVector("deckpos"..n,false)
			local ang = self:GetNWAngle("deckang"..n,false)
			local leafid = self:GetNWInt("attachment"..n,false)
			
			--Create Clientside Model
			if not self["deckmodel"..n] then
				local model = self:GetNWString("deckmodel"..n,false)
				local skin = self:GetNWInt("deckskin"..n,0)
				
				
				if leafid and model and pos and ang then
					self["deckmodel"..n] = ents.CreateClientProp()
					self["deckmodel"..n]:SetModel(model)
					self["deckmodel"..n]:SetSkin(skin)
					
					self["deckmodel"..n]:SetMoveType(MOVETYPE_NONE)
					
					self["deckmodel"..n]:SetPos(Vector())
					self["deckmodel"..n]:SetAngles(Angle())
					
					self["deckmodel"..n]:Spawn()
					
					--self.deckmodel:SetColor(Color(255,0,0))
					
				end
				
			end
			
			--Position clientside model
			if self["deckmodel"..n] then
				
				local att = self:GetAttachment(leafid)
				local apos = att.Pos
				local aang = att.Ang
				
				--local v, a = LocalToWorld( pos, ang, apos, aang )
				
				self["deckmodel"..n]:SetPos(apos)
				self["deckmodel"..n]:SetAngles(-aang)
			end
		end
	end
	
	--[[
	concommand.Add("printang",function()
		for k, self in pairs(ents.FindByClass("tp3_movable_bridge")) do
			local att = self:GetAttachment(1)
			print(self:GetAngles(),att.Ang)			
		end
	end)
	]]--
end

