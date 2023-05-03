AddCSLuaFile()
DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Switch (Simple)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Multi Track Drifting"
ENT.Instructions = "Place in Hammer"
--ENT.AutomaticFrameAdvance = true --Not needed for manual animation sync

if SERVER then

	--print("AAAAAAAAAAAA")

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
		--usetrigger = "boolean"
	}

	function ENT:Initialize()
		self:ValidateNumerics()
		local invalid = false
		
		--Figure out if it's a slip
		if string.find(self.model, "slip") then
			self.slip = true
			
			--Find the paired slip switch
			for k, ent in pairs(ents.FindInBox(self:GetPos() + Vector(-1,-1,-1), self:GetPos() + Vector(1,1,1))) do
				if (ent != self) and (ent:GetClass()=="tp3_switch") and string.find(ent.model, "slip") then
					self.paired_slip = ent
					--if string.find(self.paired_slip.model, "_dv.mdl") then paired_inverted = true else paired_inverted = false end
					
					break
				end
			end
			
			if not self.paired_slip then
				invalid = true
				ErrorNoHalt("Slip Switch "..self:EntIndex().." without paired slip switch model!")
			else
			
				--Simplify the model in case they picked one of the specialized ones, and store the four model options
				
				local self_dv
				if string.find(self.model, "_mn.mdl") then
					self_dv = false
				elseif string.find(self.model, "_dv.mdl") then
					self_dv = true
				end
				
				local paired_dv
				if string.find(self.paired_slip.model, "_mn.mdl") then
					paired_dv = false
				elseif string.find(self.paired_slip.model, "_dv.mdl") then
					paired_dv = true
				end
				
				
				if (self_dv==false) and (paired_dv==false) then --Both MN
					self.model = string.Replace(self.model, "_mn_mn.mdl", "_mn.mdl")
					self.model = string.Replace(self.model, "_dv_mn.mdl", "_mn.mdl")
					
					local basemodel = string.Replace(self.model, "_mn.mdl", "*")
					
					self.model_mn_mn = string.Replace(basemodel, "*", "_mn_mn.mdl")
					self.model_dv_mn = string.Replace(basemodel, "*", "_dv_mn.mdl")
					self.model_mn_dv = string.Replace(basemodel, "*", "_mn_dv.mdl")
					self.model_dv_dv = string.Replace(basemodel, "*", "_dv_dv.mdl")
					
					--Set default models
					self.model = self.model_mn_mn
					self.model_div = self.model_mn_dv
					--print(self, self.model, self.model_div)
				elseif (self_dv==true) and (paired_dv==true) then --Both DV
					self.model = string.Replace(self.model, "_mn_dv.mdl", "_dv.mdl")
					self.model = string.Replace(self.model, "_dv_dv.mdl", "_dv.mdl")
					
					local basemodel = string.Replace(self.model, "_dv.mdl", "*")
					
					self.model_mn_mn = string.Replace(basemodel, "*", "_dv_dv.mdl")
					self.model_dv_mn = string.Replace(basemodel, "*", "_mn_dv.mdl")
					self.model_mn_dv = string.Replace(basemodel, "*", "_dv_mn.mdl")
					self.model_dv_dv = string.Replace(basemodel, "*", "_mn_mn.mdl")
					
					--Set default models
					self.model = self.model_mn_mn
					self.model_div = self.model_mn_dv
					--print(self, self.model, self.model_div)
				elseif (self_dv==false) and (paired_dv==true) then --You are MN, other is DV
					self.model = string.Replace(self.model, "_mn_mn.mdl", "_mn.mdl")
					self.model = string.Replace(self.model, "_dv_mn.mdl", "_mn.mdl")
					
					local basemodel = string.Replace(self.model, "_mn.mdl", "*")
					
					self.model_mn_mn = string.Replace(basemodel, "*", "_dv_mn.mdl")
					self.model_dv_mn = string.Replace(basemodel, "*", "_mn_mn.mdl")
					self.model_mn_dv = string.Replace(basemodel, "*", "_dv_dv.mdl")
					self.model_dv_dv = string.Replace(basemodel, "*", "_mn_dv.mdl")
					
					--Set default models
					self.model = self.model_mn_mn
					self.model_div = self.model_mn_dv
					--print(self, self.model, self.model_div)
				elseif (self_dv==true) and (paired_dv==false) then --You are DV, other is MN
					self.model = string.Replace(self.model, "_mn_dv.mdl", "_dv.mdl")
					self.model = string.Replace(self.model, "_dv_dv.mdl", "_dv.mdl")
					
					local basemodel = string.Replace(self.model, "_dv.mdl", "*")
					
					self.model_mn_mn = string.Replace(basemodel, "*", "_mn_dv.mdl")
					self.model_dv_mn = string.Replace(basemodel, "*", "_dv_dv.mdl")
					self.model_mn_dv = string.Replace(basemodel, "*", "_mn_mn.mdl")
					self.model_dv_dv = string.Replace(basemodel, "*", "_dv_mn.mdl")
					
					--Set default models
					self.model = self.model_mn_mn
					self.model_div = self.model_mn_dv
					--print(self, self.model, self.model_div)
				else
					ErrorNoHalt("Slip Switch "..self:EntIndex().." or "..self.paired_slip:EntIndex().." does not have a valid model!")
					invalid = true
				end
				
				
				self.paired_state = false
			
			end
			
		else --It's a regular switch
		
			--Auto-calculate DV if needed
			--local invalid = false
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
			
		end

		--Prop Init Stuff
		self:Switch(false,true)
		--self:SetTrigger(true)
		self.trigger_ents = {}

		if invalid then self:SetColor(Color(255,0,0)) end --color it red if no valid DV is found

		self:RegisterEntity("lever",self.lever) --self.lever_valid & self.lever_ent

		if self.lever_valid then
			self.lever_ent:StandSetup(self)
			self:SetNWEntity("lever",self.lever_ent)
		end

		self.behavior = self.behavior or 0 --Will be set later by switch stand
	end

	--Functions called by switch stand

	--Set local parameters
	function ENT:SwitchSetup(behavior, autoscan)
		self.behavior = behavior
		if self.slip then self.behavior = 0 end --Force slip switches to be dumb due to the complexity
		self.autoscan = autoscan
		if (self.behavior==-1) or not self.autoscan then self:SetNWBool("dumb",true) end
		--print("Behavior setup: "..behavior)
	end

	--Instruct the switch to throw
	function ENT:SwitchThrow(state)
		if self.animated then --Smoothly animate; otherwise, do nothing and wait for the switch stand to finish
			self:BeginSwitching(state)
		end
	end
	
	--Hammer Trigger Occupancy from Switch Stand
	function ENT:SwitchSetOccupied(occ)
		if occ and not self.forceoccupied then
			self.forceoccupied = true
			self:SetNWBool("occupied",true)
		elseif not occ and self.forceoccupied then
			self.forceoccupied = false
			self:SetNWBool("occupied",false)
			
			if self.trailing then
				self:Switch(self.switchstate, true)
			end

			if self.hardoccupied then
				self.hardoccupied = false
				if self.lever_valid then self.lever_ent:StandSetOccupied(false) end
			end
			
		end
	end
	
	--Do a one-time scan when a switch stand is attempting to throw this switch; block it if there's something on it. True for Occupied, False for Empty.
	function ENT:QuickOccupancyCheck()
		if not self.rangerpoint1 and self.rangerpoint2 then return false end
		
		local trace = {
			start = self.rangerpoint1,
			endpos = self.rangerpoint2,
			filter = Trakpak3.GetBlacklist(),
			ignoreworld = true,
			mins = Vector(-48,-48,-8),
			maxs = Vector(48,48,2)
		}

		local tr = util.TraceHull(trace)
		local ent
		if tr.Hit then ent = tr.Entity end
		
		return tr.Hit, ent
		
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end

	--DIY Triggering based on AABB
	function ENT:ScanTrigger(prop, idx, pos, unfrozen)
		local mins = self.abmins
		local maxs = self.abmaxs
		
		if (not mins) or (not maxs) then return end
		
		--print("Scanning ",mins,maxs)
		
		--local idx = prop:EntIndex()
		--local phys = prop:GetPhysicsObject()
		--local unfrozen = phys:IsMotionEnabled()
		
		if pos:WithinAABox(mins, maxs) and unfrozen then
			if not self.trigger_ents[idx] then
				self.trigger_ents[idx] = true
				self:StartTouch(prop)
			end
		else
			if self.trigger_ents[idx] then
				self.trigger_ents[idx] = nil
				self:EndTouch(prop)
			end
		end
		
	end

	--Scan for auto-switching and frogs
	function ENT:Think()

		--Trigger
		--[[
		if not self.next_trigger then self.next_trigger = CurTime() + 0.5 end
		if CurTime() > self.next_trigger then
			self.next_trigger = CurTime() + 0.5
			self:ScanTrigger()
		end
		]]--

		--Detect approach of incoming trailing props
		if (self.softoccupied or self.forceoccupied) and (self.behavior>0) and not self.animating and self.autopoint and self.frogpoint and self.bladepoint then

			local trace = {
				start = self.autopoint,
				endpos = self.autopoint + Vector(0,0,64),
				filter = Trakpak3.GetBlacklist(),
				ignoreworld = true,
				mins = Vector(-4,-4,-8),
				maxs = Vector(4,4,8)
			}
			local tr = util.TraceHull(trace)

			--Auto Throw
			if tr.Hit then
				self.clicker = tr.Entity
				local vel = self.clicker:GetVelocity()
				local pos = self.clicker:GetPos()
				if vel:Dot(self.frogpoint - pos) > 0 then --wheels are moving towards frog
					if self.animated then
						self:BeginSwitching(not self.switchstate, true)
						--self:EmitSound("vo/npc/alyx/uggh02.wav")
					else
						self.trailing = true
						self.against = true
					end
					self.measuredistance = 16384 + self.bladepoint:DistToSqr(self.clicker:GetPos())
					--print("Trailing Wheels Approaching!")
				end
			end
		end

		--Frog Sounds (Moved to Client)
		--[[
		if self.softoccupied and self.frogpoint then

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
		]]--

		local turbothink = false

		--Better Occupancy Detection
		--rangerpoint1 = blade or origin
		--rangerpoint2 = frog
		if (self.softoccupied or self.forceoccupied) and self.rangerpoint1 and self.rangerpoint2 then
			local trace = {
				start = self.rangerpoint1,
				endpos = self.rangerpoint2,
				filter = Trakpak3.GetBlacklist(),
				ignoreworld = true,
				mins = Vector(-48,-48,-8),
				maxs = Vector(48,48,2)
			}

			local tr = util.TraceHull(trace)
			if tr.Hit then self.clicker = tr.Entity end
			--print(tr.Hit)
			if tr.Hit then self.blocking_ent = tr.Entity else self.blocking_ent = nil end
			if tr.Hit and not self.hardoccupied then
				self.hardoccupied = true
				if self.lever_valid then self.lever_ent:StandSetOccupied(true) end
			elseif not tr.Hit and self.hardoccupied then
				self.hardoccupied = false
				if self.lever_valid then self.lever_ent:StandSetOccupied(false) end
			end

			if self.trailing then

				if self.behavior==1 and self.against then --Breakable: throw, but fuck the switch stand for a little bit.

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
					local dist2 = 16384
					if self.clicker:IsValid() then
						dist2 = self.bladepoint:DistToSqr(self.clicker:GetPos())
						dot = (self.clicker:GetPos()-passpoint):Dot(facing_axis)
					end
					if (dist2>(self.measuredistance)) or (dot<0) then --backed out or passed through completely
						self:Switch(self.switchstate, true)
						--PrintMessage(HUD_PRINTTALK, "Trailing Canceled")
						--PrintMessage(HUD_PRINTTALK, tostring(dist2).." "..tostring(self.measuredistance).." "..tostring(dot).." "..tostring(self.clicker))
						--self:EmitSound("vo/npc/alyx/ohgod01.wav")
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
				--self:NextThink(CurTime())
				--return true
				turbothink = true
			end
		end
		if not self.trailing and self.animating then --Normal Animated Stand throwing, follow the stand cycle
			--get current frame
			--print("AAA")
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

			turbothink = true
		end

		if turbothink then
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
		if self.slip and self.paired_slip then self.paired_slip:UpdatePairedSlipState(state) end
		timer.Simple(0,function()

			--Begin Animation
			self.animating = true
			self:ResetSequence("throw")

			--Set flags
			self.trailing = trailing
			self.against = trailing

			--print("AA")
		end)
	end

	--Instantly set new physics mesh (for trailing switches)
	function ENT:QuickPhys(model)
		local oldmodel = self:GetModel()
		self:SetModel(model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		self:SetModel(oldmodel)
	end
	
	
	
	
	--Function called by the paired slip switch model
	function ENT:UpdatePairedSlipState(state)
		if not self.slip then return end
		
		--if self.inverted then state = not state end
		
		if state != self.paired_state then
			self.paired_state = state
			if state then --Paired Switch is DV
				self.model = self.model_dv_mn
				self.model_div = self.model_dv_dv
			else --Paired Switch is MN
				self.model = self.model_mn_mn
				self.model_div = self.model_mn_dv
			end
			
			if not self.animating then self:Switch(self.switchstate, true) end
		end
	end
	
	
	--Change Switch Full (Model and Physics, Reset all state data)
	function ENT:Switch(state, force)
		if state and (not self.switchstate or force) then --Throw DV
			self.switchstate = true
			self:SetModel(self.model_div)
			if self.collision_dv then self:SetCollisionGroup(COLLISION_GROUP_NONE) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
			if self.slip and self.paired_slip then self.paired_slip:UpdatePairedSlipState(true) end
		elseif not state and (self.switchstate or force) then --Throw MN
			self.switchstate = false
			self:SetModel(self.model)
			if self.collision_mn then self:SetCollisionGroup(COLLISION_GROUP_NONE) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
			if self.slip and self.paired_slip then self.paired_slip:UpdatePairedSlipState(false) end
		end
		self.animating = false
		self.trailing = false
		self.against = false
		self:SetAutomaticFrameAdvance(false)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		--self:SetSolid(SOLID_BSP)
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		if self.skin then self:SetSkin(self.skin) end
		--print("Switch ",state)
		self.abmins, self.abmaxs = self:WorldSpaceAABB()
		self.abmins = self.abmins + Vector(-64,-64,0)
		self.abmaxs = self.abmaxs + Vector(64,64,40)
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

		--Attachment Points for Better Occupancy Detection
		if self.frogpoint then
			self.rangerpoint2 = self.frogpoint
			if self.bladepoint then self.rangerpoint1 = self.bladepoint else self.rangerpoint1 = self:GetPos() end
			self:SetNWVector("frogpoint",self.frogpoint)
			--print("Yes Better Points")
		else
			self.rangerpoint1 = nil
			self.rangerpoint2 = nil
			self:SetNWVector("frogpoint",nil)
			--print("No Better Points")
		end
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
		self.softoccupied = true
		self:SetNWBool("occupied",true)
		--if self.usetrigger and self.lever_valid then self.lever_ent:StandSetOccupied(true) end
		--self:SetColor(Color(255,0,0))
	end
	function ENT:EndTouchAll()
		self.softoccupied = false
		self:SetNWBool("occupied",false)

		if self.trailing then
			self:Switch(self.switchstate, true)
		end

		if self.hardoccupied then
			self.hardoccupied = false
			if self.lever_valid then self.lever_ent:StandSetOccupied(false) end
		end
		--self:SetColor(Color(255,255,255))
	end

	--DIY Triggering Take #3
	CreateConVar("tp3_switch_scanrate", 5, FCVAR_NONE, "The max number of switches that will be tested for occupancy per tick.", 1, 20)
	cvars.AddChangeCallback("tp3_switch_scanrate", function(cname, old, new)
		if Trakpak3.SwitchMaxIndex then
			local val = tonumber(new)
			local t = math.Round(math.ceil(Trakpak3.SwitchMaxIndex/val)*engine.TickInterval(),2)
			print("\n[Trakpak3] Switch Scan Time: "..t.." seconds for "..Trakpak3.SwitchMaxIndex.." switches.\n")
		end
	end)

	--Find all the switches initially
	hook.Add("InitPostEntity","Trakpak3_InitFindSwitches",function()
		if Trakpak3 then
			local allswitches = ents.FindByClass("tp3_switch")

			--Filter OUT all dumb switches
			Trakpak3.Switches = {}
			for n=1,#allswitches do
				local sw = allswitches[n]
				if (sw.behavior > -1) and sw.autoscan then
					table.insert(Trakpak3.Switches,sw)
				end
			end

			Trakpak3.SwitchMaxIndex = #Trakpak3.Switches
			if Trakpak3.SwitchMaxIndex > 0 then
				Trakpak3.SwitchScanIndex = 1

				local convar = GetConVar("tp3_switch_scanrate")
				local t = math.Round(math.ceil(Trakpak3.SwitchMaxIndex/(convar:GetInt() or 5))*engine.TickInterval(),2)
				print("\n[Trakpak3] Switch Scan Time: "..t.." seconds for "..Trakpak3.SwitchMaxIndex.." non-dumb switches.\n")
			else
				print("\n[Trakpak3] Map has no non-dumb switches.\n")
			end
		end
	end)

	hook.Add("Think","Trakpak3_SwitchTriggerScan",function()
		if Trakpak3 and Trakpak3.SwitchScanIndex and Trakpak3.SwitchMaxIndex then

			local convar = GetConVar("tp3_switch_scanrate")
			local rate = 5
			if convar then
				rate = convar:GetInt() or 5
			end

			local sw_start = Trakpak3.SwitchScanIndex
			local sw_end = Trakpak3.SwitchScanIndex + rate
			local reset = false
			if sw_end >= Trakpak3.SwitchMaxIndex then
				sw_end = Trakpak3.SwitchMaxIndex
				reset = true
			end

			for k, prop in pairs(ents.FindByClass("prop_physics")) do
				local idx = prop:EntIndex()
				local phys = prop:GetPhysicsObject()
				local pos = prop:GetPos()
				local unfrozen = false

				if phys:IsValid() then unfrozen = phys:IsMotionEnabled() end

				for n=sw_start, sw_end do
					local switch = Trakpak3.Switches[n]
					switch:ScanTrigger(prop, idx, pos, unfrozen)
				end

			end

			if reset then
				Trakpak3.SwitchScanIndex = 1
			else
				Trakpak3.SwitchScanIndex = sw_end + 1
			end



		end
	end)

	--[[
	hook.Add("Think","Trakpak3_SwitchTriggerScan",function()
		if Trakpak3 then
			if not Trakpak3.NextSwitchTrigger then
				Trakpak3.NextSwitchTrigger = CurTime() + 0.5
			elseif CurTime() > Trakpak3.NextSwitchTrigger then
				Trakpak3.NextSwitchTrigger = Trakpak3.NextSwitchTrigger + 0.5

				local switches = ents.FindByClass("tp3_switch")

				if #switches > 0 then

					for k, prop in pairs(ents.FindByClass("prop_physics")) do
						local idx = prop:EntIndex()
						local phys = prop:GetPhysicsObject()
						local pos = prop:GetPos()
						local unfrozen = false

						if phys:IsValid() then unfrozen = phys:IsMotionEnabled() end

						for m, switch in pairs(switches) do
							switch:ScanTrigger(prop, idx, pos, unfrozen)
						end

					end

				end

			end

		end
	end)
	]]--
	hook.Add("EntityRemoved","Trakpak3_SwitchTriggerDeleteProp",function(ent)
		if ent:GetClass()=="prop_physics" then
			local idx = ent:EntIndex()
			for k, switch in pairs(ents.FindByClass("tp3_switch")) do
				if switch.trigger_ents[idx] then
					switch.trigger_ents[idx] = nil
					switch:EndTouch(ent)
				end
			end
		end
	end)
end

if CLIENT then

	--Draw trigger wireframe boxes around all the switches. tp3_switch_debug is in the switch lever anim file.

	hook.Add("PostDrawTranslucentRenderables","Trakpak3_SwitchAABB",function()
		if Trakpak3.SwitchDebug==2 then
			for k, self in pairs(ents.FindByClass("tp3_switch")) do
				local mins, maxs = self:WorldSpaceAABB()
				mins = mins + Vector(-64,-64,0)
				maxs = maxs + Vector(64,64,40)
				local center = maxs/2 + mins/2

				local color = Color(0,255,0)

				if self:GetNWBool("occupied",false) then color = Color(255,0,0) end
				if self:GetNWBool("dumb",false) then color = Color(143,143,143) end

				render.DrawWireframeBox(center, Angle(), center - mins, center - maxs, color, true)
				--render.DrawLine(mins, maxs)
			end
		end
	end)


	function ENT:Think()

		--Clientside Frog Sounds

		--local occupied = self:GetNWBool("occupied",false)
		local frogpoint = self:GetNWVector("frogpoint",nil)
		local pdist

		if frogpoint then pdist = LocalPlayer():GetPos():DistToSqr(self:GetPos()) end

		--if occupied and frogpoint and pdist and (pdist < 2048*2048) then
		if frogpoint and pdist and (pdist < 3072*3072) then

			local trace = {
				start = frogpoint,
				endpos = frogpoint + Vector(0,0,8),
				filter = self,
				ignoreworld = true
			}
			local tr = util.TraceLine(trace)

			--Clickety Clack
			if tr.Hit and not Trakpak3.IsBlacklisted(tr.Entity) and not self.froccupied then
				self.froccupied = true
				self.clicker = tr.Entity
				if self.clicker:IsValid() then self.clicker:EmitSound("Trakpak3.tracksounds.frog1") end
			elseif not tr.Hit and self.froccupied then
				self.froccupied = false
				if self.clicker:IsValid() then self.clicker:EmitSound("Trakpak3.tracksounds.frog1") end
			end

			self:NextThink(CurTime() + 0.1)
			return true

		else
			self.froccupied = false
			self:NextThink(CurTime() + 0.5)
			return true
		end

	end
end