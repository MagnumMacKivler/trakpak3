AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Signal Prop (Master)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Stop trains, annoy kids"
ENT.Instructions = "Place in Hammer"

if SERVER then
	
	local Dispatch = Trakpak3.Dispatch
	
	ENT.KeyValueMap = {
		model = "string",
		angles = "string",
		nickname = "string",
		slave_1 = "entity",
		slave_2 = "entity",
		block = "entity",
		nextsignal = "entity",
		sysname = "string",
		sigtype = "string",
		tags = "string",
		automatic = "boolean",
		skin = "number",
		bodygroups = "string",
		up_powered = "number",
		dn_powered = "number",
		ctc_state = "number",
		interlock = "boolean",
		cs_pos = "vector",
		OnChangedColor = "output",
		OnChangedAspect = "output"
	}
	
	local ctc_dict = {
		[0] = 0,
		[1] = 1,
		[2] = 1,
		[3] = 2
	}
	
	function ENT:Initialize()
		--Prop Init Stuff
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		--self:SetSolid(SOLID_BSP)
		
		if self.skin then self:SetSkin(self.skin) end
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		
		--Keyvalue Validation
		self:ValidateNumerics()
		self:RegisterEntity("slave_1",self.slave_1)
		self:RegisterEntity("slave_2",self.slave_2)
		self:RegisterEntity("block",self.block)
		self:RegisterEntity("nextsignal",self.nextsignal)
		
		--Process tags from a string to a key table
		if self.tags and (self.tags!="") then
			local taglist = string.Explode(" ",self.tags)
			self.tags = {}
			for k, v in pairs(taglist) do self.tags[v] = true end
		else
			self.tags = {}
		end
		
		self:SetScript(self.sysname, self.sigtype)
		--Default aspect assignment
		self.aspect = self:CalculateAspect(false, false, nil, nil, nil, self.tags)
		
		self.my_occupied = false
		self.my_nextaspect = "none"
		self.my_nextspeed = Trakpak3.FULL
		self.my_nextdiv = false
		self.my_diverging = false
		self.my_speed = Trakpak3.FULL
		
		if self.nickname then self:SetNWString("Nickname",self.nickname) end
		if self:GetName() then self:SetNWString("Targetname",self:GetName()) end
		
		if not self.up_powered then self.up_powered = 0 end
		if not self.dn_powered then self.dn_powered = 0 end
		
		self.effectivecolor = 0
		self.cycle = 0
		self.target_cycle = 0
		self.cycle_vel = 0
		self.first_anim = true
		self.anim_power = math.Rand(0.875,1.125)
		
		--Wire Setup
		if WireLib then
			local names = {"Aspect","Diverging","Speed","ColorCode","CabSignalAspect"}
			local types = {"STRING","NORMAL","NORMAL","NORMAL","STRING"}
			WireLib.CreateSpecialOutputs(self, names, types, descs)
			--print("YAAAAAAAA")
		end
		
		--Trakpak3.Dispatch.SendInfo(self:GetName(),"ctc_state",self.ctc_state)
	end
	
	function ENT:SetScript(sysname, sigtype)
		--Grab the default signal system
		if TP3Signals then
			
			if TP3Signals.systems[sysname] then
				self.system = TP3Signals.systems[sysname]
				if self.system.sigtypes[sigtype] then
					self.signaltype = sigtype
				else
					ErrorNoHalt("[Trakpak3] Signal ",self," has an invalid signal type '"..sigtype.."'! This may cause problems until fixed in the map!")
				end
				--self.signaltype = sigtype
			elseif sysname then
				ErrorNoHalt("[Trakpak3] Signal ",self," has an invalid signal system name '"..sysname.."'! This may cause problems until fixed in the map!")
			else
				ErrorNoHalt("[Trakpak3] Signal ",self," has no signal system set! This may cause problems until fixed in the map!")
			end
		else
			ErrorNoHalt("[Trakpak3] Signal ",self," tried to initialize, but the TP3Signals table does not exist!")
		end
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	--Animation
	function ENT:Think()
		if self.cycle!=self.target_cycle then
			if not self.animating then
				self.animating = true
				self:ResetSequence("range")
				--print("Signal Start Animation")
			end
			
			Trakpak3.AnimateSignal(self)
			
			if (self.cycle==self.target_cycle) then --target has been reached -> apply skins and bodygroups
				if self.target_bg then
					for k, v in pairs(self.target_bg) do self:SetBodygroup(k, v) end
				end
				if self.target_skin then
					--print("Setting ",self," Skin to ",self.target_skin)
					self:SetSkin(self.target_skin)
				end
			else --target has not yet been reached, apply interim bodygroups
				local sigplot = Trakpak3.SignalPlots[self.model]
				if sigplot then
					local maxframe = sigplot[#sigplot][1] or 0
					local frame = self.cycle*maxframe
					local mindist = maxframe
					local mindex
					for k, v in pairs(sigplot) do
						local d = math.abs(frame - sigplot[k][1])
						if d<mindist then
							mindist = d
							mindex = k
						end
					end
					
					if mindex then --found a match
						--print(frame, mindex)
						local bga = sigplot[mindex][2]
						for k, v in pairs(bga) do
							self:SetBodygroup(k, v)
						end
					end
				end
			end
			
			self:SetCycle(self.cycle)
			
			self:NextThink(CurTime())
			return true
		end
	end
	
	--Accidentally marked as a slave signal
	function ENT:HandleNewColor()
		--self:SetColor(Color(255,0,0))
		self:SetMaterial("models/error/new light1")
		ErrorNoHalt("[Trakpak3] Error: MASTER Signal '"..self:GetName().."' ("..tostring(self)..") is marked as a slave signal by another signal! Signal has been marked with the flashing red error material.\n")
	end
	
	--Macro for doing the below two functions
	function ENT:GetNewAspect(init) --Init is only fired by the Block/Gate initial broadcast.
		if self.automatic then
			local newaspect = self:CalculateAspect(self.my_occupied, self.my_diverging, self.my_speed, self.my_nextaspect, self.my_nextspeed, self.tags, self.ctc_state, self.my_nextdiv)
			if newaspect then self:HandleNewAspect(newaspect, init) end
		end
	end
	
	--Handle New Aspect if applicable
	function ENT:HandleNewAspect(aspect, force) --aspect is string. Force is fired only by the Block/Gate initial broadcast.
		if aspect then
			--print("Signal "..self:EntIndex().." aspect "..aspect)
			if force or (aspect != self.aspect) or self.first_anim then
				
				
				--Check if aspect is defined for this signal type
				local colordata = self.system.sigtypes[self.signaltype][aspect]
				if colordata then
					self.aspect = aspect
					
					timer.Simple(5,function()
						self.aspect_delayed = aspect
						if WireLib then
							WireLib.TriggerOutput(self,"CabSignalAspect",aspect)
						end
					end)
					
					local data = {}
					if colordata.skin1!="" then data.skin1 = tonumber(colordata.skin1) end
					if colordata.skin2!="" then data.skin2 = tonumber(colordata.skin2) end
					if colordata.skin3!="" then data.skin3 = tonumber(colordata.skin3) end
					
					if colordata.bg1!="" then data.bg1 = colordata.bg1 end
					if colordata.bg2!="" then data.bg2 = colordata.bg2 end
					if colordata.bg3!="" then data.bg3 = colordata.bg3 end
					
					if colordata.cycle1!="" then data.cycle1 = tonumber(colordata.cycle1) end
					if colordata.cycle2!="" then data.cycle2 = tonumber(colordata.cycle2) end
					if colordata.cycle3!="" then data.cycle3 = tonumber(colordata.cycle3) end
					
					local oldcolor = self.effectivecolor
					
					--Set Self
					
					if data.bg1 then
						--print(data.bg1)
						local bga = string.Explode(" ",data.bg1)
						if bga then
							if data.cycle1 and not self.first_anim then --store for later
								self.target_bg = bga
							else --apply now
								for k, v in pairs(bga) do
									self:SetBodygroup(k,tonumber(v))
								end
							end
							self.effectivecolor = tonumber(bga[1]) or 0
						end
					end
					if data.cycle1 then
						self.old_target = self.target_cycle
						self.target_cycle = data.cycle1
						self.anim_stage = 0
						self.anim_power = math.Rand(0.75,1.25)
						self.effectivecolor = data.cycle1
						--print(data.cycle1)
					end
					if data.skin1 and not self.first_anim then
						if data.cycle1 then --store for later
							self.target_skin = data.skin1
						else --apply now
							self:SetSkin(data.skin1)
						end
						self.effectivecolor = data.skin1
					end
					
					self.first_anim = false
					
					if self.effectivecolor != oldcolor then
						self:TriggerOutput("OnChangedColor",self,self.effectivecolor)
					
						if WireLib then
							WireLib.TriggerOutput(self,"ColorCode",self.effectivecolor)
						end
					end
					
					--Slave 1
					if self.slave_1_valid and (data.skin2 or data.bg2 or data.cycle2) then self.slave_1_ent:HandleNewColor(data.skin2, data.bg2, data.cycle2) end
					
					--Slave 2
					if self.slave_2_valid and (data.skin3 or data.bg3 or data.cycle3) then self.slave_2_ent:HandleNewColor(data.skin3, data.bg3, data.cycle3) end
					
					--Wire
					if WireLib then
						WireLib.TriggerOutput(self,"Aspect",aspect or "error")
						--WireLib.TriggerOutput(self,"Colors",colortable) --doesn't seem to work
						local db = 0
						if self.my_diverging then db = 1 end
						WireLib.TriggerOutput(self,"Diverging",db)
						WireLib.TriggerOutput(self,"Speed",self.system.rules[aspect].speed)
						WireLib.TriggerOutput(self,"ColorCode",self.effectivecolor)
					end
					
					--Broadcast Update & Fire Hammer Output
					self:TriggerOutput("OnChangedAspect",self,aspect)
					hook.Run("TP3_SignalUpdate",self:GetName(),aspect)
					
					--Network Vars for Signal Vision
					self:SetNWString("Aspect",aspect)
					self:SetNWInt("Speed",self.system.rules[aspect].speed)
					self:SetNWString("Description",self.system.rules[aspect].desc)
					self:SetNWString("Color",self.system.rules[aspect].color)
				else
					error("[Trakpak3] Error! Aspect "..aspect.." is not defined for signal type "..self.signaltype.."!")
					self.aspect_delayed = nil
				end
			end
		end
	end
	
	--Returns aspect and appearance tables, or nil
	function ENT:CalculateAspect(occupied, diverging, speed, nextrule, nextspeed, tags, ctc, nextdiv)
		if self.system and self.signaltype then
			local aspname = self.system.logic(occupied, diverging, speed or Trakpak3.FULL, nextrule, nextspeed or Trakpak3.FULL, tags, ctc_dict[ctc or 2], nextdiv) --aspect to request
			if self.system.rules[aspname] then --if rule exists in rulebook
				local data = self.system.sigtypes[self.sigtype][aspname]
				if data then --This aspect is defined for this sigtype
					return data.override or aspname
				else ErrorNoHalt("[Trakpak3] Signal ",self," was assigned aspect '"..aspname.."' which is not defined for sigtype '"..self.signaltype.."'!") return end
			else ErrorNoHalt("[Trakpak3] Signal ",self," was assigned rule '"..aspname.."' which is not defined for system '"..self.system.sysname.."'!") return end
		else ErrorNoHalt("[Trakpak3] Signal ",self," has a missing or invalid system name or signal type!") return end
	end
	
	--Set CTC State, Handle Interlocks
	
	function ENT:SetCTCState(state, init) --Init is only fired by the Block/Gate initial broadcast.
		if not state then state = self.ctc_state end --Default to current if no parameter is provided. 
		
		if self.interlock and self.paths then --Signal has paths and is interlocked
			if self.pindex then --There is a valid path lined up
				
				--Apply/Release Interlocks
				local path = self.paths[self.pindex]
				local switchlist = path.switchlist
				for name, req in pairs(switchlist) do
					local stand = Trakpak3.FindByTargetname(name)
					if (state==0) or (state==3) then --Hold or Force
						stand:ReleaseInterlock(self)
					elseif (state==1) or (state==2) then --Once or Allow
						stand:ApplyInterlock(self)
					end
					stand:EvaluateInterlock()
				end
			else -- There is no valid path lined up
				if (state==1) or (state==2) then --Default any Allows/Onces to Hold. Force will still be allowed in this state however.
					state = 0
				end 
			end
		end
		
		--Change the state
		if state != self.ctc_state then
			self.ctc_state = state
			Dispatch.SendInfo(self:GetName(),"ctc_state",state)
		end
		
		--Calculate and Set new aspect if applicable
		self:GetNewAspect(init)
		
	end
	
	--Update when block occupancy changes
	hook.Add("TP3_BlockUpdate","Trakpak3_BlockUpdateMasters",function(blockname,occupied,force)
		for k, signal in pairs(ents.FindByClass("tp3_signal_master")) do
			if signal.block_valid and signal.block==blockname then
				--CTC Trip Once to Hold
				if (signal.ctc_state==1) and occupied and (not signal.my_occupied) then
					signal.my_occupied = occupied
					signal:SetCTCState(0)
				else
					signal.my_occupied = occupied
					signal:SetCTCState() --Calculate new Aspect
				end
			end
		end
	end)
	
	--Update when next signal changes
	hook.Add("TP3_SignalUpdate","Trakpak3_SignalUpdateMasters",function(signalname,aspect)
		for k, signal in pairs(ents.FindByClass("tp3_signal_master")) do
			if signal.nextsignal_valid and signal.nextsignal==signalname then
				--Update next signal's aspect name and speed
				signal.my_nextaspect = aspect
				signal.my_nextspeed = signal.system.rules[aspect].speed
				signal.my_nextdiv = signal.nextsignal_ent.my_diverging
				
				signal:GetNewAspect()
			end
		end
	end)
	
	--Update when the active path changes as determined by SetPathState.
	function ENT:ChangePathInfo(diverging, speed, block, nextsignal, pindex)
		--print("Yo we got a signal update up in this bitch")
		--if script then self:SetScript(script) end
		if diverging==true or diverging==false then self.my_diverging = diverging end
		if speed then self.my_speed = speed end
		if block then
			self.block = block
			self.block_ent = nil
			self:RegisterEntity("block",block)
		else
			self.block = nil
			self.block_ent = nil
			self.block_valid = false
		end
		if nextsignal then
			self.nextsignal = nextsignal
			self.nextsignal_ent = nil
			self:RegisterEntity("nextsignal",nextsignal)
		else
			self.nextsignal = nil
			self.nextsignal_ent = nil
			self.nextsignal_valid = false
		end
		
		if self.block_valid then self.my_occupied = self.block_ent.occupied else self.my_occupied = false end
		if self.nextsignal_valid and self.nextsignal_ent.system then
			self.my_nextaspect = self.nextsignal_ent.aspect
			self.my_nextspeed = self.nextsignal_ent.system.rules[self.my_nextaspect].speed
			self.my_nextdiv = self.nextsignal_ent.my_diverging
		else
			self.my_nextaspect = nil
			self.my_nextspeed = nil
			self.my_nextdiv = nil
		end
		
		
		--Send "No-Path" state to dispatch board
		if self.interlock then
			
			if pindex and not self.pindex then
				Dispatch.SendInfo(self:GetName(),"nopath",0)
			elseif not pindex and self.pindex then
				Dispatch.SendInfo(self:GetName(),"nopath",1)
			end
			--self.pindex is set at the end of this function
		end
		
		--If for some reason the active path changes when it's supposed to be interlocked, release the old interlocks before applying the new ones. This can happen if an interlocked switch stand has its initial state set to DV.
		if (pindex != self.pindex) and self.interlock and self.paths and ((self.ctc_state==1) or (self.ctc_state==2)) then
			if self.pindex then --Release the old ones
				local switchlist = self.paths[self.pindex].switchlist
				for name, req in pairs(switchlist) do
					local stand, valid = Trakpak3.FindByTargetname(name)
					if valid then
						stand:ReleaseInterlock(self)
						stand:EvaluateInterlock()
					end
				end
			end
		end
		
		self.pindex = pindex 
		self:SetCTCState()
		
	end
	
	--Register/Update alternate path
	function ENT:AddPath(pindex, diverging, speed, block, nextsignal, active, switchlist)
		if not self.paths then self.paths = {} end
		self.paths[pindex] = {
			active = active,
			diverging = diverging,
			speed = speed,
			block = block,
			nextsignal = nextsignal,
			switchlist = switchlist
		}
		
	end
	
	--Update path state. Every time a switch changes, this gets run on each signal once for each path.
	function ENT:SetPathState(pindex,active)
		--print("SetPathState",self:GetName(),pindex,active)
		if(self.paths) then
			self.paths[pindex]["active"] = active

			if active then --This path is the new active one
				local pdata = self.paths[pindex]
				self:ChangePathInfo(pdata.diverging, pdata.speed, pdata.block, pdata.nextsignal, pindex)
			else --It may be a different one
				local invalid = true
				for pname, pdata in pairs(self.paths) do
					if pdata.active then --It was another path after all
						invalid = false
						--self:ChangePathInfo(pdata.diverging, pdata.speed, pdata.block, pdata.nextsignal, pindex)
					end
					--print(pdata.active)
				end
				if invalid then --If no other path claims validity, revert to default
					--print("Yo this should be doing something")
					self:ChangePathInfo(false,Trakpak3.DANGER,nil,nil,nil)
					--print(self:GetName().." Setting to aspect:")
					--PrintTable(self.system.aspects[self.defaultaspect])
				end
			end
		end
	end
	
	--Hammer Input Handler
	function ENT:AcceptInput(iname,activator,caller,data)
		if iname=="SetManual" then
			self.automatic = false
			if data and data!="" then self:HandleNewAspect(data) end
		elseif iname=="SetAutomatic" then
			self.automatic = true
			self:GetNewAspect()
		elseif iname=="SetCTC_Hold" then
			self:SetCTCState(0)
		elseif iname=="SetCTC_Once" then
			self:SetCTCState(1)
		elseif iname=="SetCTC_Allow" then
			self:SetCTCState(2)
		elseif iname=="SetCTC_Force" then
			self:SetCTCState(3)
		end
	end
	
	--Signal Animation function
	function Trakpak3.AnimateSignal(ent)
		local ticktime = engine.TickInterval()

		if ent.target_cycle>ent.cycle then --Moving Up
		
			if ent.up_powered==0 then --Motorized
			
				if ent.cycle_vel<0.25 then
					ent.cycle_vel = ent.cycle_vel + 0.25*ent.anim_power*ticktime
				end
				
			elseif ent.up_powered==1 then --Magnetized
				
				ent.cycle_vel = ent.cycle_vel + 0.5*ent.anim_power*ticktime
				
			elseif ent.up_powered==2 then --Damped Jerk
			
				local dtt = ent.target_cycle - ent.cycle
				local tdist = ent.target_cycle - ent.old_target
				if ent.anim_stage<2 then --initial rise
					ent.cycle_vel = ent.cycle_vel + (8 - 9*(1-dtt) - 4*ent.cycle_vel)*ent.anim_power*ticktime
					if (ent.anim_stage==0) and (ent.cycle_vel<=0) then
						ent.anim_stage = 1
					elseif (ent.anim_stage==1) and (ent.cycle_vel>=0) then
						ent.anim_stage = 2
					end
				else --slow fall into place
					if ent.cycle_vel < 0.375 then
						ent.cycle_vel = ent.cycle_vel + 0.1875*ent.anim_power*ticktime
					end
				end
				
			elseif ent.up_powered==3 then --Bouncy Jerk
				
				ent.cycle_vel = ent.cycle_vel + 1*ent.anim_power*ticktime
				if (ent.anim_stage<2) and ((ent.cycle + ent.cycle_vel*ticktime) >= ent.target_cycle) then
					ent.cycle_vel = -ent.cycle_vel*0.375
					ent.anim_stage = ent.anim_stage + 1
				end
				
			end
			
			--Update Position
			ent.cycle = ent.cycle + ent.cycle_vel*ticktime
			
			if ent.cycle>=ent.target_cycle then
				ent.cycle = ent.target_cycle
				ent.cycle_vel = 0
			end
		elseif ent.target_cycle<ent.cycle then --Moving Down
		
			if ent.dn_powered==0 then --Motorized
			
				if ent.cycle_vel>-0.25 then
					ent.cycle_vel = ent.cycle_vel - 0.25*ent.anim_power*ticktime
				end
				
			elseif ent.dn_powered==1 then --Magnetized
				
				ent.cycle_vel = ent.cycle_vel - 0.5*ent.anim_power*ticktime
				
			elseif ent.dn_powered==2 then --Damped Jerk
			
			
				local dtt = ent.cycle - ent.target_cycle
				local tdist = ent.old_target - ent.target_cycle
				if ent.anim_stage<2 then --initial fall
					ent.cycle_vel = ent.cycle_vel + (-8 + 9*(1-dtt) - 4*ent.cycle_vel)*ent.anim_power*ticktime
					if (ent.anim_stage==0) and (ent.cycle_vel>=0) then
						ent.anim_stage = 1
					elseif (ent.anim_stage==1) and (ent.cycle_vel<=0) then
						ent.anim_stage = 2
					end
				else --slow fall into place
					if ent.cycle_vel > -0.375 then
						ent.cycle_vel = ent.cycle_vel - 0.1875*ent.anim_power*ticktime
					end
				end
			
			elseif ent.dn_powered==3 then --Bouncy Jerk
				
				ent.cycle_vel = ent.cycle_vel - 1*ent.anim_power*ticktime
				if (ent.anim_stage<2) and ((ent.cycle + ent.cycle_vel*ticktime) <= ent.target_cycle) then
					ent.cycle_vel = -ent.cycle_vel*0.375
					ent.anim_stage = ent.anim_stage + 1
				end
				
			end
			
			--Update Position
			ent.cycle = ent.cycle + ent.cycle_vel*ticktime
			if ent.cycle<=ent.target_cycle then
				ent.cycle = ent.target_cycle
				ent.cycle_vel = 0
			end
		end
	end
	
	--Receive DS commands
	hook.Add("TP3_Dispatch_Command","Trakpak3_DS_Signals", function(name, cmd, val)
		for _, signal in pairs(ents.FindByClass("tp3_signal_master")) do --For Each Signal,
			if (name==signal:GetName()) and (cmd=="set_ctc") then
				if val<=3 then
					--signal.ctc_state = val
					signal:SetCTCState(val)
					if signal.automatic then
						local newaspect = signal:CalculateAspect(signal.my_occupied, signal.my_diverging, signal.my_speed, signal.my_nextaspect, signal.my_nextspeed, signal.tags, signal.ctc_state, signal.my_nextdiv)
						if newaspect then signal:HandleNewAspect(newaspect) end
					end
				end
			end
		end
	end)
end

if CLIENT then
	--Allow targetname clientside
	function ENT:GetName()
		local name = self:GetNWString("Targetname")
		if name=="" then name = nil end
		return name
	end
	
	--Render signal sprites
	function ENT:Draw(flags)
		Trakpak3.SignalSprites.DrawSpriteSignal(self, flags)
	end
end
