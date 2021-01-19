AddCSLuaFile()
DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Switch (Simple)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Multi Track Drifting"
ENT.Instructions = "Place in Hammer"
--ENT.AutomaticFrameAdvance = true --Not needed for manual animation sync

if SERVER then
	
	ENT.KeyValueMap = {
		model = "string",
		model_div = "string",
		angles = "string",
		--switchstate = "boolean",
		skin = "number",
		lever = "entity",
		animated = "boolean",
		collision_mn = "boolean",
		collision_dv = "boolean",
		derail = "boolean"
		
	}
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		--Auto-calculate DV if needed
		local invalid = false
		if not self.model_div or (self.model_div=="") then
			if string.find(self.model,"_mn.mdl") then
				self.model_div = string.Replace(self.model,"_mn.mdl","_dv.mdl")
			elseif string.find(self.model,"_dv.mdl") then
				self.model_div = string.Replace(self.model,"_dv.mdl","_mn.mdl")
			else
				ErrorNoHalt("Switch "..self:EntIndex().." without valid Diverging model!")
				invalid = true
			end
		end
		
		--Prop Init Stuff
		self:Switch(false,true)
		self:SetTrigger(true)
		
		if invalid then self:SetColor(Color(255,0,0)) end --color it red if no valid DV is found
		
		self:RegisterEntity("lever",self.lever) --self.lever_valid & self.lever_ent
		
		if self.lever_valid then self.lever_ent:StandSetup(self) end
		
		self.behavior = self.behavior or 0 --Will be set later by switch stand
	end
	
	--Functions called by switch stand
	
	--Set local parameters
	function ENT:SwitchSetup(behavior)
		self.behavior = behavior
		--print("Behavior setup: "..behavior)
	end
	
	--Instruct the switch to throw
	function ENT:SwitchThrow(state)
		if self.animated then --Smoothly animate; otherwise, do nothing and wait for the switch stand to finish
			self:BeginSwitching(state)
		end
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	--Scan for auto-switching and frogs
	function ENT:Think()
		
		--Detect approach of incoming trailing props
		if (self.behavior>0) and not self.animating and self.autopoint and self.frogpoint and self.bladepoint then
			
			local trace = {
				start = self.autopoint,
				endpos = self.autopoint + Vector(0,0,64),
				filter = Trakpak3.GetBlacklist(),
				ignoreworld = true
			}
			local tr = util.TraceLine(trace)
			
			--Auto Throw
			if tr.Hit then
				self.clicker = tr.Entity
				local vel = self.clicker:GetVelocity()
				local pos = self.clicker:GetPos()
				if vel:Dot(self.frogpoint - pos) > 0 then --wheels are moving towards frog
					if self.animated then
						self:BeginSwitching(not self.switchstate, true)
					else
						self.trailing = true
						self.against = true
					end
					self.measuredistance = 16384 + self.bladepoint:DistToSqr(self.clicker:GetPos())
					--print("Trailing Wheels Approaching!")
				end
			end
		end
		
		--Frog Sounds
		if self.frogpoint then
			
			local trace = {
				start = self.frogpoint,
				endpos = self.frogpoint + Vector(0,0,8),
				filter = Trakpak3.GetBlacklist(),
				ignoreworld = true
			}
			local tr = util.TraceLine(trace)
			
			--Clickety Clack
			if tr.Hit and not self.froccupied then
				self.froccupied = true
				self.clicker = tr.Entity
				if self.clicker:IsValid() then self.clicker:EmitSound("gsgtrainsounds/wheels/wheels_random4.wav",75,math.random(95,105)) end
			elseif not tr.Hit and self.froccupied then
				self.froccupied = false
				if self.clicker:IsValid() then self.clicker:EmitSound("gsgtrainsounds/wheels/wheels_random4.wav",75,math.random(95,105)) end
			end
		end
		
		if self.trailing then
			
			if self.behavior==1 and self.against then --Breakable: throw, but fuck the switch stand for a little bit.
				local midpoint = 0.5*self.bladepoint + 0.5*self.frogpoint -- used for throwing the points open
				local trace = {
					start = self.bladepoint,
					endpos = self.frogpoint,
					maxs = Vector(16,16,0),
					mins = Vector(-16,-16,-8),
					filter = Trakpak3.GetBlacklist(),
					ignoreworld = true
				}
				local tr = util.TraceHull(trace)
				local dist2 = 16384
				if self.clicker:IsValid() then
					dist2 = self.bladepoint:DistToSqr(self.clicker:GetPos())
				end
				
				if dist2>(self.measuredistance) then --backed out the way it came
				
					self:Switch(self.switchstate, true)
					--print("Trailing Canceled")
					--self:EmitSound("buttons/blip1.wav")
					
				elseif tr.Hit and (tr.Fraction<0.25) then --complete the throw
				
					self.against = false
					
					if self.animated then --Play and Terminate the animation
						self:SetAutomaticFrameAdvance(true)

					else --Just insta-throw it
						self:Switch(not self.switchstate)
					end
					local vel = 0
					
					if tr.Entity:IsValid() then vel = tr.Entity:GetVelocity():Length() end
					if self.lever_valid then self.lever_ent:StandBreak(not self.switchstate, vel) end
					
				end
			elseif self.behavior==2 and self.against then --Safety Throw: throw when something approaches the blades
				local midpoint = 0.5*self.bladepoint + 0.5*self.frogpoint -- used for throwing the points open
				local trace = {
					start = self.bladepoint,
					endpos = self.frogpoint,
					maxs = Vector(16,16,0),
					mins = Vector(-16,-16,-8),
					filter = Trakpak3.GetBlacklist(),
					ignoreworld = true
				}
				local tr = util.TraceHull(trace)
				local dist2 = 16384
				if self.clicker:IsValid() then
					dist2 = self.bladepoint:DistToSqr(self.clicker:GetPos())
				end
				
				if dist2>(self.measuredistance) then --backed out the way it came
				
					self:Switch(self.switchstate, true)
					--print("Trailing Canceled")
					--self:EmitSound("buttons/blip1.wav")
					
				elseif tr.Hit and (tr.Fraction<0.25) then --complete the throw
				
					self.against = false
					
					if self.animated then --Play and Terminate the animation
						self:SetAutomaticFrameAdvance(true)
						if self.lever_valid then self.lever_ent:StandThrowTo(not self.switchstate) end
						--print("Throwing completely")

					else --Just insta-throw it
						if self.lever_valid then self.lever_ent:StandThrowTo(not self.switchstate) end
						self:Switch(not self.switchstate)
					end
				end
				
			elseif self.behavior==3 then --Spring Switch: throw partially and then reset
				local cycle = 0
				local facing_axis = self.frogpoint - self.bladepoint
				local passpoint = self.bladepoint - facing_axis
				local dot = 1
				
				local trace = {
					start = self.bladepoint,
					endpos = self.frogpoint,
					maxs = Vector(16,16,0),
					mins = Vector(-16,-16,-8),
					filter = Trakpak3.GetBlacklist(),
					ignoreworld = true
				}
				local tr = util.TraceHull(trace)
				local dist2 = 16384
				if self.clicker:IsValid() then
					dist2 = self.bladepoint:DistToSqr(self.clicker:GetPos())
					dot = (self.clicker:GetPos()-passpoint):Dot(facing_axis)
				end
				if (dist2>(self.measuredistance)) or (dot<0) then --backed out or passed through completely
					self:Switch(self.switchstate, true)
					--print("Trailing Canceled")
					--self:EmitSound("buttons/bell1.wav")
				elseif tr.Hit then
					if self.animated and tr.Fraction<0.75 then --Animated, modulate
						local springpos = 1 - tr.Fraction/0.75
						if self.springpos and (self.springpos > springpos) then
							if (self.springpos>0) then
								self.springpos = self.springpos - 2*engine.TickInterval()
								if self.springpos<0 then self.springpos = 0 end
							end
							
						elseif (not self.springpos) or (self.springpos < springpos) then
							self.springpos = springpos
						end
						self:SetCycle(self.springpos or 0)
					elseif self.animated then --Animated, don't modulate
						if self.springpos and (self.springpos>0) then
							self.springpos = self.springpos - 2*engine.TickInterval()
							if self.springpos<0 then self.springpos = 0 end
						end
						self:SetCycle(self.springpos or 0)
					elseif tr.Fraction<0.5 then --not animated, show opened
						if self.switchstate and self:GetModel()==self.model then
							self:SetModel(self.model_div)
						elseif not self.switchstate and self:GetModel()==self.model_div then
							self:SetModel(self.model)
						end
					else --not animated, show closed
						if self.switchstate and self:GetModel()==self.model_div then
							self:SetModel(self.model)
						elseif not self.switchstate and self:GetModel()==self.model then
							self:SetModel(self.model_div)
						end
					end
				else --Nothing on the switch, though still trailing
					if self.animated then
						if self.springpos and (self.springpos>0) then
							self.springpos = self.springpos - 2*engine.TickInterval()
							if self.springpos<0 then self.springpos = 0 end
						end
						self:SetCycle(self.springpos or 0)
						--print(0)
					else
						if self.switchstate and self:GetModel()==self.model_div then
							self:SetModel(self.model)
						elseif not self.switchstate and self:GetModel()==self.model then
							self:SetModel(self.model_div)
						end
					end
				end
			end
			self:NextThink(CurTime())
			return true
		elseif self.animating then --Normal Animated Stand throwing, follow the stand cycle
			--get current frame
			local stand = self.lever_ent
			local frame = stand:GetCycle()*stand.MaxFrame
			frame = math.Clamp(frame,0,stand.MaxFrame)
			local plot = stand.Plot
			--get piecewise region of plot
			local lastpoint = 1
			for n = 1, #plot do
				if frame <= plot[n][1] then
					lastpoint = n-1
					break
				end
			end
			if lastpoint<1 then lastpoint = 1 end
			
			--interpolate
			local t1 = plot[lastpoint][1]
			local t2 = plot[lastpoint+1][1]
			local c1 = plot[lastpoint][2]
			local c2 = plot[lastpoint+1][2]
			
			local prog = (frame - t1) / (t2 - t1)
			local cycle = c1 + prog*(c2 - c1)
			
			--Set cycle
			self:SetCycle(cycle)
		
			self:NextThink(CurTime())
			return true
		else --Not trailing, not animating at all
			self:NextThink(CurTime() + 0.1)
			return true
		end
	end
	
	--Start Animation
	function ENT:BeginSwitching(state, trailing)
		--set the new physics instantly
		if state then self:QuickPhys(self.model_div) else self:QuickPhys(self.model) end
		timer.Simple(0,function()
			
			--Begin Animation
			self.animating = true
			self:ResetSequence("throw")
			
			--Set flags
			self.trailing = trailing
			self.against = trailing
		end)
	end
	
	--Instantly set new physics mesh (for trailing switches)
	function ENT:QuickPhys(model)
		local oldmodel = self:GetModel()
		self:SetModel(model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		self:SetModel(oldmodel)
	end
	
	--[[
	concommand.Add("tp3_switch",function(ply, cmd, args)
		local id = tonumber(args[1])
		local state = args[2]
		
		if id and state then
			Entity(id):Switch(state=="1")
		end
	end)
	
	hook.Add("tp3_switch","Trakpak3_OhGodHelp",function(ent,state)
		ent:Switch(state)
	end)
	]]--
	
	--Change Switch Full (Model and Physics, Reset all state data)
	function ENT:Switch(state, force)
		if state and (not self.switchstate or force) then --Throw DV
			self.switchstate = true
			self:SetModel(self.model_div)
			if self.collision_dv then self:SetCollisionGroup(COLLISION_GROUP_NONE) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
		elseif not state and (self.switchstate or force) then --Throw MN
			self.switchstate = false
			self:SetModel(self.model)
			if self.collision_mn then self:SetCollisionGroup(COLLISION_GROUP_NONE) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
		end
		self.animating = false
		self.trailing = false
		self.against = false
		self:SetAutomaticFrameAdvance(false)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		if self.skin then self:SetSkin(self.skin) end
		--print("Switch ",state)
		self:FindAttachments()
	end
	
	--Get attachment points for frog/autothrow
	function ENT:FindAttachments()
		
		local ap_idx = self:LookupAttachment("autopoint1")
		local fp_idx = self:LookupAttachment("frog1")
		local bp_idx = self:LookupAttachment("bladecenter1")
		
		if ap_idx>0 then self.autopoint = self:GetAttachment(ap_idx).Pos else self.autopoint = nil end
		if fp_idx>0 then self.frogpoint = self:GetAttachment(fp_idx).Pos else self.frogpoint = nil end
		if bp_idx>0 then self.bladepoint = self:GetAttachment(bp_idx).Pos else self.bladepoint = nil end
		
	end
	
	--Trigger Functions
	--By the way, an interesting quirk about how prop triggers work - apparently it works great with trains because in addition to sitting on top of the rails, the flanges go down into the switch model's space a bit. With props that just sit on top of a surface, it doesn't work as well.
	function ENT:StartTouch(ent)
		if not self.touchents then
			self.touchents = {}
			self.hastouchers = false
		end
		
		if ent:IsValid() and ent:GetClass()=="prop_physics" then
			self.touchents[ent:EntIndex()] = true
			if not self.hastouchers then
				self:StartTouchAll()
				self.hastouchers = true
			end
		end
	end
	
	function ENT:EndTouch(ent)
		if ent:IsValid() and ent:GetClass()=="prop_physics" then
			if self.touchents[ent:EntIndex()] then
				self.touchents[ent:EntIndex()] = nil
				if self.derail and not self.switchstate then
					--Apply a surface prop to slow the train down
					local physobj = ent:GetPhysicsObject()
					local physprop = {GravityToggle = true, Material = "metal"}
					if physobj:IsValid() then construct.SetPhysProp(nil,ent,0,nil,physprop) end
				end
			end
			
			local stillhas = false
			for index, touching in pairs(self.touchents) do
				if Entity(index):IsValid() and touching then
					stillhas = true
				else
					self.touchents[index] = nil
				end
			end
			if not stillhas then
				self.hastouchers = false
				self:EndTouchAll()
			end
		end
		
	end
	
	function ENT:StartTouchAll()
		self.lever_ent:StandSetOccupied(true)
	end
	function ENT:EndTouchAll()
		self.lever_ent:StandSetOccupied(false)
	end
end