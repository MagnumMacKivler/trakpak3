AddCSLuaFile()
DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Switch Stand (Animated)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Change Switches/Squash Toes"
ENT.Instructions = "Place in Hammer"
ENT.AutomaticFrameAdvance = true

if SERVER then
	ENT.KeyValueMap = {
		model = "string",
		bodygroups = "string",
		skin = "number",
		seq_idle_close = "string",
		seq_idle_open = "string",
		seq_throw_close = "string",
		seq_throw_open = "string",
		behavior = "number",
		autoscan = "boolean",
		mytrigger = "entity",
		autoreset = "boolean",
		targetstate = "boolean",
		
		bodygroups_closed = "string",
		bodygroups_motion = "string",
		bodygroups_open = "string",
		
		collision_mn = "boolean",
		collision_dv = "boolean",
		levertype = "number",
		
		linked_stand = "entity",
		locked = "boolean",
		nowire = "boolean",
		
		OnUse = "output",
		OnThrownMain = "output",
		OnThrownDiverging = "output"
	}
	
	local function NotifySwitchBlocked(condition, ply, blocker) --All in one for sending chat messages to client trying to throw a switch.
		if not condition or not ply then return end
		--Valid conditions are "blocked" "interlocked" or "locked". Try saying that three times fast...
		
		local ent = "Null Entity"
		local model = "No Model"
		if blocker and blocker:IsValid() then
			ent = tostring(blocker)
			model = blocker:GetModel()
		end
		
		net.Start("trakpak3")
		net.WriteString("tp3_switchblocked_notify")
			net.WriteString(condition)
			net.WriteString(ent)
			net.WriteString(model)
		net.Send(ply)
	end
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		--Model/Physics Init
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		--self:SetSolid(SOLID_BSP)
		self:SetSkin(self.skin)
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		if self.collision_mn then self:SetCollisionGroup(COLLISION_GROUP_NONE) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
		
		--transform sequences into ID numbers for faster usage
		self.sname_open = self.seq_throw_open
		self.sname_close = self.seq_throw_close
		
		self.seq_idle_close = self:LookupSequence(self.seq_idle_close)
		self.seq_idle_open = self:LookupSequence(self.seq_idle_open)
		self.seq_throw_open, self.dur_throw_open = self:LookupSequence(self.seq_throw_open)
		self.seq_throw_close, self.dur_throw_close = self:LookupSequence(self.seq_throw_close)
		
		timer.Simple(1,function() self:ResetSequence(self.seq_idle_close) end)
		
		self.animate = self.seq_idle_close and self.seq_idle_open and self.seq_throw_close and self.seq_throw_open
		self.state = false
		self.targetstate = self.targetstate or false
		self.animating = false
		
		self:SetUseType(SIMPLE_USE)
		
		if self.levertype==2 then
			self:SetTrigger(true)
		end
		
		--Interlocks Table
		self.interlocks = {}
		
		--Store old pos and ang
		self.originalpos = self:GetPos()
		self.originalang = self:GetAngles()
		
		--Register your linked stand. The handshake is performed in InitPostEntity below.
		self:RegisterEntity("linked_stand",self.linked_stand)
		
		--Auto Setup Hammer Outputs to Trigger
		self:RegisterEntity("mytrigger",self.mytrigger)
		
		
		--Wire I/O
		if WireLib then
			if not self.nowire then
				local names = {"ThrowMain","ThrowDiverging","ThrowToggle","Throw"}
				local types = {"NORMAL","NORMAL","NORMAL","NORMAL"}
				local descs = {}
				WireLib.CreateSpecialInputs(self, names, types, descs)
			end
			
			local names = {"Main","Diverging","AutomaticOnly","Blocked","Broken"}
			local types = {"NORMAL","NORMAL","NORMAL","NORMAL","NORMAL"}
			WireLib.CreateSpecialOutputs(self, names, types, descs)
			
			WireLib.TriggerOutput(self,"Main",1)
			WireLib.TriggerOutput(self,"Diverging",0)
			WireLib.TriggerOutput(self,"AutomaticOnly",Trakpak3.FIF(self.locked, 1, 0))
			WireLib.TriggerOutput(self,"Blocked",0)
			WireLib.TriggerOutput(self,"Broken",0)
		end
		
		--Initial Broadcast
		hook.Run("TP3_SwitchUpdate",self:GetName(),0)
		
		self:SetNWInt("state",0)
		self:SetNWBool("locked",self.locked)
		self:SetNWBool("blocked",false)
		self:SetNWBool("broken",false)
		self:SetNWInt("levertype",self.levertype)
		if self:GetName() then self:SetNWString("Targetname",self:GetName()) end
	end
	
	--Set this model's animation plot and find the max frame
	function ENT:SetAnimationPlot(sequence)
		local ssp = Trakpak3.SwitchStandPlots
		if ssp and ssp[self.model] then --Entry exists for this model
			if ssp[self.model][sequence] then --This specific sequence has an override
				self.Plot = Trakpak3.SwitchStandPlots[self.model][sequence]
			else
				self.Plot = Trakpak3.SwitchStandPlots[self.model] --Only one for the whole model
			end			
			self.MaxFrame = self.Plot[#self.Plot][1] or 0
		else
			self.Plot = {{0,0},{1,1}}
			self.MaxFrame = 1
		end
	end
	
	--util.AddNetworkString("tp3_request_polyswitches")
	
	--Receive request for switch assignments from player
	--[[
	net.Receive("tp3_request_polyswitches",function(length, ply)
		local standtable = {}
		for k, stand in pairs(ents.FindByClass("tp3_switch_lever_anim")) do
			if stand.switches and (#stand.switches > 0) then
				local lintable = {}
				for l, switch in pairs(stand.switches) do
					table.insert(lintable, {stand:GetPos(), switch:GetPos()})
				end
				standtable[stand:EntIndex()] = lintable
			end
		end
		net.Start("tp3_request_polyswitches")
		net.WriteTable(standtable)
		net.Send(ply)
	end)
	]]--
	Trakpak3.Net.tp3_request_polyswitches = function(len,ply)
		local standtable = {}
		for k, stand in pairs(ents.FindByClass("tp3_switch_lever_anim")) do
			if stand.switches and (#stand.switches > 0) then
				local lintable = {}
				for l, switch in pairs(stand.switches) do
					table.insert(lintable, {stand:GetPos(), switch:GetPos()})
				end
				standtable[stand:EntIndex()] = lintable
			end
		end
		--net.Start("tp3_request_polyswitches")
		net.Start("trakpak3")
		net.WriteString("tp3_request_polyswitches")
		net.WriteTable(standtable)
		net.Send(ply)
	end
	
	--Functions called by the switch
	
	--Initial Handshake to link the entities
	function ENT:StandSetup(ent)
		if not self.switches then self.switches = {} end
		table.insert(self.switches,ent)
		if #self.switches==1 then --First Switch
			self.switch = ent
			ent:SwitchSetup(self.behavior or 1, self.autoscan)
		else --Second or More Switch
			if not self.overflow then
				self.overflow = true
				ErrorNoHalt("[Trakpak3] Switch Stand '"..self:GetName().."' linked by multiple switches! Use the command 'tp3_switch_debug' to identify the links.\n")
			end
		end
	end
	
	--Force the switch stand to throw to the specified state (only via trailing a Safety Throw switch)
	function ENT:StandThrowTo(state)
		self.targetstate = state
		self:Actuate(state)
	end
	
	--Break the switch stand temporarily (a result of trailing)
	function ENT:StandBreak(state, vel)
		--self:SetTargetState(state)
		self.targetstate = state --Calling this instead of self:SetTargetState to prevent the stand from going through its throw cycle.
		if state then self:CompleteThrowDV() else self:CompleteThrowMN() end
		--self.state = state
		self.broken = true
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		
		vel = vel or 0
		
		local p1 = math.random(1,2)
		local s_table = {"physics/metal/metal_box_break1.wav", "physics/metal/metal_box_break2.wav"}
		self:EmitSound(s_table[p1])
		
		p1 = math.random(1,4)
		s_table = {"physics/wood/wood_plank_break1.wav","physics/wood/wood_plank_break2.wav","physics/wood/wood_plank_break3.wav","physics/wood/wood_plank_break4.wav"}
		self:EmitSound(s_table[p1])
		--print("Broken switch at "..vel)
		local po = self:GetPhysicsObject()
		po:ApplyForceCenter(po:GetMass()*(Vector(0,0,1) + VectorRand(-0.5,0.5))*vel*0.5)
		po:ApplyTorqueCenter(po:GetMass()*VectorRand()*math.min(vel,200)*0.0625)
		
		--Broadcast
		hook.Run("TP3_SwitchUpdate",self:GetName(),2,true)
		Trakpak3.Dispatch.SendInfo(self:GetName(),"broken",1)
		
		if WireLib then WireLib.TriggerOutput(self,"Broken",1) end
		
		timer.Simple(60,function()
			if self.broken then self:StandFix() end
		end)
		self:SetNWBool("broken",true)
	end
	
	function ENT:StandFix()
		self.broken = false
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		--self:SetSolid(SOLID_BSP)
		self:SetPos(self.originalpos)
		self:SetAngles(self.originalang)
		
		local p1 = math.random(1,3)
		local s_table = {"physics/wood/wood_box_impact_hard1.wav","physics/wood/wood_box_impact_hard2.wav","physics/wood/wood_box_impact_hard3.wav"}
		self:EmitSound(s_table[p1])
		
		if WireLib then WireLib.TriggerOutput(self,"Broken",0) end
		Trakpak3.Dispatch.SendInfo(self:GetName(),"broken",0)
		
		if self.state then self:CompleteThrowDV() else self:CompleteThrowMN() end
		self:SetNWBool("broken",false)
	end
	
	--Receive occupancy status
	function ENT:StandSetOccupied(occ)
		self.my_occ = occ
		if self.linked_stand_valid then
			self.linked_stand_ent.linked_occ = occ
			self.linked_stand_ent:EvaluateOccupancy()
		end
		self:EvaluateOccupancy()
	end
	
	function ENT:EvaluateOccupancy()
		
		self.occupied = self.my_occ or self.linked_occ or false
		--print(self.occupied)
		if self.occupied then
			Trakpak3.Dispatch.SendInfo(self:GetName(),"blocked",1)
		else
			Trakpak3.Dispatch.SendInfo(self:GetName(),"blocked",0)
			
		end
		local occn = 0
		if self.occupied then occn = 1 end
		if WireLib then WireLib.TriggerOutput(self,"Blocked",occn) end
		if self.autoreset and self.targetstate and not self.broken then
			self:SetTargetState(false)
		end
		self:SetNWBool("blocked",self.occupied)
	end
	
	--Functions called by Signals
	
	--A signal forces this switch stand to be interlocked.
	function ENT:ApplyInterlock(signal)
		
		if signal and signal:IsValid() then
			self.interlocks[signal:EntIndex()] = true
			if self.linked_stand_valid then self.linked_stand_ent.interlocks[signal:EntIndex()] = true end
		end
	end
	
	--A signal releases this switch from interlock.
	function ENT:ReleaseInterlock(signal)
		
		if signal and signal:IsValid() then
			self.interlocks[signal:EntIndex()] = false
			if self.linked_stand_valid then self.linked_stand_ent.interlocks[signal:EntIndex()] = false end
		end
		
	end
	
	--All applications/releases are done, now re-evaluate the interlock state.
	function ENT:EvaluateInterlock()
		local ilocked = false
		for k, v in pairs(self.interlocks) do
			if v then
				ilocked = true
				break
			end
		end
		
		if ilocked and not self.interlocked then
			self.interlocked = true
			Trakpak3.Dispatch.SendInfo(self:GetName(),"interlocked",1)
			self:SetNWBool("interlocked",true)
		elseif not ilocked and self.interlocked then
			self.interlocked = false
			Trakpak3.Dispatch.SendInfo(self:GetName(),"interlocked",0)
			self:SetNWBool("interlocked",false)
		end
		
		if self.linked_stand_valid then --Repeat the process for linked stands
			local ilocked = false
			for k, v in pairs(self.linked_stand_ent.interlocks) do
				if v then
					ilocked = true
					break
				end
			end
			
			if ilocked and not self.linked_stand_ent.interlocked then
				self.linked_stand_ent.interlocked = true
				Trakpak3.Dispatch.SendInfo(self.linked_stand_ent:GetName(),"interlocked",1)
				self.linked_stand_ent:SetNWBool("interlocked",true)
			elseif not ilocked and self.linked_stand_ent.interlocked then
				self.linked_stand_ent.interlocked = false
				Trakpak3.Dispatch.SendInfo(self.linked_stand_ent:GetName(),"interlocked",0)
				self.linked_stand_ent:SetNWBool("interlocked",false)
			end
		end
	end
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	--Do these when the throw is completed
	function ENT:CompleteThrowMN()
		self.state = false
		if self.animate then
			self.animating = false
			self:ResetSequence(self.seq_idle_close)
		end
		if WireLib then
			WireLib.TriggerOutput(self,"Main",1)
			WireLib.TriggerOutput(self,"Diverging",0)
		end
		if self.bodygroups_closed then self:SetBodygroups(self.bodygroups_closed) end
		if self.collision_mn then self:SetCollisionGroup(COLLISION_GROUP_NONE) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
		self:TriggerOutput("OnThrownMain",self)
		if self.switch then self.switch:Switch(false) end
		--Broadcast
		hook.Run("TP3_SwitchUpdate",self:GetName(),0)
		Trakpak3.Dispatch.SendInfo(self:GetName(),"state",0)
		
		self:SetNWInt("state",0)
	end
	
	function ENT:CompleteThrowDV()
		self.state = true
		if self.animate then
			self.animating = false
			self:ResetSequence(self.seq_idle_open)
		end
		if WireLib then
			WireLib.TriggerOutput(self,"Main",0)
			WireLib.TriggerOutput(self,"Diverging",1)
		end
		if self.bodygroups_open then self:SetBodygroups(self.bodygroups_open) end
		if self.collision_dv then self:SetCollisionGroup(COLLISION_GROUP_NONE) else self:SetCollisionGroup(COLLISION_GROUP_WORLD) end
		self:TriggerOutput("OnThrownDiverging",self)
		if self.switch then self.switch:Switch(true) end
		--Broadcast
		hook.Run("TP3_SwitchUpdate",self:GetName(),1)
		Trakpak3.Dispatch.SendInfo(self:GetName(),"state",1)
		
		self:SetNWInt("state",1)
	end
	
	--Begin animations. This function is called on the switch's Think cycle when current state =/= target state.
	function ENT:Actuate(state)
		--self:SetTargetState(state)
		if state then --throw it open
			self.state = true
			if self.animate then
				self.animating = true
				self:SetAnimationPlot(self.sname_open)
				self:ResetSequence(self.seq_throw_open)
				if WireLib then
					WireLib.TriggerOutput(self,"Main",0)
					WireLib.TriggerOutput(self,"Diverging",0)
				end
				
				--Broadcast
				hook.Run("TP3_SwitchUpdate",self:GetName(),2)
				Trakpak3.Dispatch.SendInfo(self:GetName(),"state",2)
				
				self:SetNWInt("state",2)
				
				if self.bodygroups_motion then self:SetBodygroups(self.bodygroups_motion) end
				--When throw animation is done:
				timer.Simple(self:SequenceDuration(self.seq_throw_open), function() self:CompleteThrowDV() end)
			else
				self:CompleteThrowDV()
			end
			
			
		else --throw it closed
			self.state = false
			if self.animate then
				self.animating = true
				self:SetAnimationPlot(self.sname_close)
				self:ResetSequence(self.seq_throw_close)
				if WireLib then
					WireLib.TriggerOutput(self,"Main",0)
					WireLib.TriggerOutput(self,"Diverging",0)
				end
				
				--Broadcast
				hook.Run("TP3_SwitchUpdate",self:GetName(),2)
				Trakpak3.Dispatch.SendInfo(self:GetName(),"state",2)
				
				self:SetNWInt("state",2)
				
				if self.bodygroups_motion then self:SetBodygroups(self.bodygroups_motion) end
				--when throw animation is done:
				timer.Simple(self:SequenceDuration(self.seq_throw_close), function() self:CompleteThrowMN() end)
			else
				self:CompleteThrowMN()
			end
		end
	end
	
	--Set your (and your linked stand's) target state to prevent race conditions. This is the primary control step that throws the switch. Player arg is optional for sending "this switch is blocked!" notification.
	function ENT:SetTargetState(state, ply)
		--Check occupancy/interlock on the local and linked switches before changing anything
		if self.interlocked then return end
		if self.linked_stand_valid and self.linked_stand_ent.interlocked then return end
		
		local me_occupied
		local linked_occupied
		local me_blocker
		local linked_blocker
		
		if self.switch then me_occupied, me_blocker = self.switch:QuickOccupancyCheck() end
		if self.linked_stand_valid and self.linked_stand_ent.switch then linked_occupied, linked_blocker = self.linked_stand_ent.switch:QuickOccupancyCheck() end
		
		local b = me_blocker or linked_blocker
		
		if not me_occupied and not linked_occupied then --Set your self.targetstate for the stand code to pick up automatically
			self.targetstate = state
			if self.linked_stand_valid then self.linked_stand_ent.targetstate = state end --Update linked stand
		elseif ply and b then --Notify player of the blocking entity
			NotifySwitchBlocked("blocked", ply, b)
			
		end
	end
	
	--On +Use
	function ENT:Use(ply)
		if self.broken then
			self:StandFix()
		elseif self.locked and ply then --Switch is Locked, notify player.
			NotifySwitchBlocked("locked", ply)
		elseif self.interlocked and ply then --Switch is Interlocked, notify player.
			NotifySwitchBlocked("interlocked", ply)
		elseif self.occupied and ply then --Switch is blocked, notify player
				
			if self.switch and self.switch.blocking_ent then
				NotifySwitchBlocked("blocked", ply, self.switch.blocking_ent)
			else
				NotifySwitchBlocked("blocked", ply) --This indicates a bug
			end
				
		elseif not self.animating then --Switch is clear, unlocked, and not interlocked, throw it normally!
			self:SetTargetState(not self.targetstate)
		end
	end
	
	function ENT:Think()
		if Trakpak3.InitPostEntity then
			
			--Try to set up trigger outputs
			if not self.tryoutput then
				self.tryoutput = true
				--print(self.mytrigger, self.mytrigger_valid, self:GetName())
				if self.mytrigger_valid and self:GetName() and (self:GetName()!="") then
					--print("Yeah we trying to set this shit up!")
					self.mytrigger_ent:Fire("AddOutput", "OnStartTouchAll "..self:GetName()..":SetOccupancy:1:0:-1",0,self,self)
					self.mytrigger_ent:Fire("AddOutput", "OnEndTouchAll "..self:GetName()..":SetOccupancy:0:0:-1",0,self,self)
				else
					--print("Definitely not working.")
				end
			end
			
			--Begin actuation if current state does not match target state
			if not self.animating and not self.occupied and (self.state != self.targetstate) then
				if self.switch then self.switch:SwitchThrow(self.targetstate) end
				self:Actuate(self.targetstate)
			end
			self:NextThink(CurTime())
			return true
		end
	end
	
	--Hammer Input Handler
	function ENT:AcceptInput( inputname, activator, caller, data )
		if inputname=="ThrowToggle" then
			self:SetTargetState(not self.targetstate)
		elseif inputname=="ThrowMain" then
			self:SetTargetState(false)
		elseif inputname=="ThrowDiverging" then
			self:SetTargetState(true)
		elseif inputname=="SetAutoOnly" then
			self.locked = true
			self:SetNWBool("locked",true)
			if WireLib then WireLib.TriggerOutput(self,"AutomaticOnly",1) end
		elseif inputname=="SetAllowManual" then
			self.locked = false
			self:SetNWBool("locked",false)
			if WireLib then WireLib.TriggerOutput(self,"AutomaticOnly",0) end
		elseif inputname=="SetOccupancy" and self.switch then
			self.switch:SwitchSetOccupied(data=="1")
		end
	end
	
	--Wire input handler
	function ENT:TriggerInput(iname, value)
		if iname=="ThrowToggle" and value>0 then
			self:SetTargetState(not self.targetstate)
		elseif iname=="ThrowMain" and value>0 then
			self:SetTargetState(false)
		elseif iname=="ThrowDiverging" and value>0 then
			self:SetTargetState(true)
		elseif iname=="Throw" then
			local new = (value>0)
			self:SetTargetState(new)
		end
	end
	
	--Derail Mode (Levertype 2) Trigger
	function ENT:StartTouch(ent)
		
		if not self.touchents then
			self.touchents = {}
			self.hastouchers = false
		end
		
		if not (self:GetCollisionGroup() == COLLISION_GROUP_NONE) then return end --only process if the entity actually has collisions
		
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
				
				--Apply a surface prop to slow the train down
				local physobj = ent:GetPhysicsObject()
				local physprop = {GravityToggle = true, Material = "metal"}
				if physobj:IsValid() then construct.SetPhysProp(nil,ent,0,physobj,physprop) end
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
	
	function ENT:StartTouchAll() end
	function ENT:EndTouchAll() end
	
	
	--Receive DS commands
	hook.Add("TP3_Dispatch_Command", "Trakpak3_DS_Switches", function(name, cmd, val)
		for _, stand in pairs(ents.FindByClass("tp3_switch_lever_anim")) do --For Each Stand,
			--print(stand:GetName(), cmd, val)
			if (name==stand:GetName()) and (cmd=="throw") then
				if val==1 then
					stand:SetTargetState(true)
				else
					stand:SetTargetState(false)
				end
			end
		end
	end)
	
	--Perform "handshake" with linked stand to link the linked stand back to this one
	function Trakpak3.STAND_HANDSHAKES()
		for _, stand in pairs(ents.FindByClass("tp3_switch_lever_anim")) do
			if stand.linked_stand_valid then --Auto Link the other stand to this one
				stand.linked_stand_ent:RegisterEntity("linked_stand",stand:GetName())
			end
		end
	end
	--hook.Add("InitPostEntity","Trakpak3_Link_Stands",handshakes)
	--hook.Add("PostCleanupMap","Trakpak3_Link_Stands",handshakes)
end

if CLIENT then
	local chatBasic = Color(191,223,255)
	local chatEmphasis = Color(255,255,127)
	
	Trakpak3.Net.tp3_switchblocked_notify = function(len,ply)
		local condition = net.ReadString()
		local ent = net.ReadString()
		local model = net.ReadString()
		if condition=="blocked" then
			if ent and model then
				chat.AddText(chatBasic, "[Trakpak3] The switch you are attempting to throw is blocked by "..ent, chatEmphasis, " ("..model..").")
			else
				chat.AddText(chatBasic, "[Trakpak3] The switch you are attempting to throw is blocked by something unknown. ", chatEmphasis, "This is probably a bug!")
			end
		LocalPlayer():EmitSound("buttons/button16.wav")
		elseif condition=="locked" then
			chat.AddText(chatBasic, "[Trakpak3] The switch you are attempting to throw is locked, and cannot be thrown by hand. ", chatEmphasis, "Try the dispatch board instead!")
			LocalPlayer():EmitSound("buttons/button16.wav")
		elseif condition=="interlocked" then
			chat.AddText(chatBasic, "[Trakpak3] The switch you are attempting to throw is interlocked by one or more signals. ", chatEmphasis, "Drop the signals in the dispatch board first!")
			LocalPlayer():EmitSound("buttons/button16.wav")
		end
	end
	
	concommand.Add("tp3_switch_debug",function(ply, cmd, args)
		--Trakpak3.SwitchDebug = not Trakpak3.SwitchDebug
		local v = args[1]
		if (not v) or v=="" then
			if not Trakpak3.SwitchDebug then
				Trakpak3.SwitchDebug = 1
			elseif Trakpak3.SwitchDebug and (Trakpak3.SwitchDebug>0) then
				Trakpak3.SwitchDebug = nil
			end
		else
			local n = tonumber(v)
			if (n == 1) or (n == 2) then
				Trakpak3.SwitchDebug = n
			else
				Trakpak3.SwitchDebug = nil
			end
		end
		if Trakpak3.SwitchDebug then
			--net.Start("tp3_request_polyswitches")
			net.Start("trakpak3")
			net.WriteString("tp3_request_polyswitches")
			net.SendToServer()
			local regcolor = Color(0,127,255)
			MsgC(regcolor,"[Trakpak3] Switch Debug Enabled. ",Color(0,255,0),"Green Lines ",regcolor,"indicate monogamous switches (set up correctly). ",Color(255,0,0),"Red Lines ",regcolor,"indicate polygamous switches (will not work, causes the error).")
		end
	end)
	
	--[[
	net.Receive("tp3_request_polyswitches",function()
		Trakpak3.PolySwitchStands = net.ReadTable()
	end)
	]]--
	Trakpak3.Net.tp3_request_polyswitches = function()
		Trakpak3.PolySwitchStands = net.ReadTable()
	end
	
	hook.Add("PostDrawTranslucentRenderables","Trakpak3_RenderSwitchLinks",function()
		if Trakpak3.SwitchDebug and Trakpak3.PolySwitchStands then
			for k, stand in pairs(Trakpak3.PolySwitchStands) do
				local lcolor = Color(0,255,0)
				if #stand > 1 then lcolor = Color(255,0,0) end
				for l, line in pairs(stand) do
					render.DrawLine(line[1],line[2],lcolor)
				end
			end
		end
	end)
	
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