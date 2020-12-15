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
		autoreset = "boolean",
		targetstate = "boolean",
		
		bodygroups_closed = "string",
		bodygroups_motion = "string",
		bodygroups_open = "string",
		
		linked_stand = "entity",
		locked = "boolean",
		nowire = "boolean",
		
		OnUse = "output",
		OnThrownMain = "output",
		OnThrownDiverging = "output"
	}
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		--Model/Physics Init
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		self:SetSkin(self.skin)
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		
		--transform sequences into ID numbers for faster usage
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
		
		--Store old pos and ang
		self.originalpos = self:GetPos()
		self.originalang = self:GetAngles()
		
		--Link Stands
		self:RegisterEntity("linked_stand",self.linked_stand)
		
		--find max frame for animation plot
		if Trakpak3.SwitchStandPlots and Trakpak3.SwitchStandPlots[self.model] then
			self.Plot = Trakpak3.SwitchStandPlots[self.model]
			self.MaxFrame = self.Plot[#self.Plot][1] or 0
		end
		
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
	end
	
	util.AddNetworkString("tp3_request_polyswitches")
	
	--Receive request for switch assignments from player
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
	
	--Functions called by the switch
	
	--Initial Handshake to link the entities
	function ENT:StandSetup(ent)
		if not self.switches then self.switches = {} end
		table.insert(self.switches,ent)
		if #self.switches==1 then --First Switch
			self.switch = ent
			ent:SwitchSetup(self.behavior or 1)
		else --Second or More Switch
			if not self.overflow then
				self.overflow = true
				ErrorNoHalt("[Trakpak3] Switch Stand '"..self:GetName().."' linked by multiple switches! Use the command 'tp3_switch_debug' to identify the links.\n")
			end
		end
	end
	
	--Force the switch stand to throw to the specified state (a result of trailing)
	function ENT:StandThrowTo(state)
		self:Actuate(state)
	end
	
	--Break the switch stand temporarily (a result of trailing)
	function ENT:StandBreak(state, vel)
		self:SetTargetState(state)
		self.state = state
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
		if occ then
			Trakpak3.Dispatch.SendInfo(self:GetName(),"blocked",1)
		else
			Trakpak3.Dispatch.SendInfo(self:GetName(),"blocked",0)
		end
		self.occupied = occ
		local occn = 0
		if occ then occn = 1 end
		if WireLib then WireLib.TriggerOutput(self,"Blocked",occn) end
		if self.autoreset and self.targetstate then
			self:SetTargetState(false)
		end
		self:SetNWBool("blocked",occ)
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
		self:TriggerOutput("OnThrownDiverging",self)
		if self.switch then self.switch:Switch(true) end
		--Broadcast
		hook.Run("TP3_SwitchUpdate",self:GetName(),1)
		Trakpak3.Dispatch.SendInfo(self:GetName(),"state",1)
		
		self:SetNWInt("state",1)
	end
	
	--Animate Yourself - should be called after all other state-dependent logic is done!
	function ENT:Actuate(state)
		self:SetTargetState(state)
		if state then --throw it open
			self.state = true
			if self.animate then
				self.animating = true
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
	
	--Set your (and your linked switch's) target state to prevent race conditions
	function ENT:SetTargetState(state)
		self.targetstate = state
		if self.linked_stand_valid then self.linked_stand_ent.targetstate = state end --Update linked stand
	end
	
	util.AddNetworkString("tp3_switchblocked_notify")

	
	--On +Use
	function ENT:Use(ply)
		if self.broken then
			self:StandFix()
		elseif not self.locked then
			if not self.animating and self.occupied then
				net.Start("tp3_switchblocked_notify")
				net.Send(ply)
			elseif not self.animating then
				self:SetTargetState(not self.targetstate)
			end
		end
	end
	
	function ENT:Think()
		if Trakpak3.InitPostEntity then
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
	
	--Link up other stands
	hook.Add("InitPostEntity","Trakpak3_Link_Stands",function()
		for _, stand in pairs(ents.FindByClass("tp3_switch_lever_anim")) do
			if stand.linked_stand_valid then --Auto Link the other stand to this one
				stand.linked_stand_ent:RegisterEntity("linked_stand",stand:GetName())
			end
		end
	end)
end

if CLIENT then
	net.Receive("tp3_switchblocked_notify", function()
		chat.AddText("[Trakpak3] The switch you are attempting to throw is blocked.")
	end)
	
	concommand.Add("tp3_switch_debug",function(ply, cmd, args)
		Trakpak3.SwitchDebug = not Trakpak3.SwitchDebug
		if Trakpak3.SwitchDebug then
			net.Start("tp3_request_polyswitches")
			net.SendToServer()
			local regcolor = Color(0,127,255)
			MsgC(regcolor,"[Trakpak3] Switch Debug Enabled. ",Color(0,255,0),"Green Lines ",regcolor,"indicate monogamous switches (set up correctly). ",Color(255,0,0),"Red Lines ",regcolor,"indicate polygamous switches (will not work, causes the error).")
		end
	end)
	
	net.Receive("tp3_request_polyswitches",function()
		Trakpak3.PolySwitchStands = net.ReadTable()
	end)
	
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
	
end