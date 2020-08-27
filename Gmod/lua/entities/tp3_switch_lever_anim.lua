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
		OnUse = "output",
		OnThrownMain = "output",
		OnThrownDiverging = "output"
	}
	
	function ENT:Initialize()
		
		--Model/Physics Init
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		self:SetSkin(self.skin)
		if self.bodygroups then for n, p in pairs(string.Explode(" ",self.bodygroups)) do self:SetBodygroup(n,tonumber(p)) end end
		
		--transform sequences into ID numbers for faster usage
		self.seq_idle_close = self:LookupSequence(self.seq_idle_close)
		self.seq_idle_open = self:LookupSequence(self.seq_idle_open)
		self.seq_throw_open, self.dur_throw_open = self:LookupSequence(self.seq_throw_open)
		self.seq_throw_close, self.dur_throw_close = self:LookupSequence(self.seq_throw_close)
		
		timer.Simple(1,function() self:ResetSequence(self.seq_idle_close) end)
		
		self.state = false
		self.animating = false
		
		self:SetUseType(SIMPLE_USE)
		
		--Store old pos and ang
		self.originalpos = self:GetPos()
		self.originalang = self:GetAngles()
		
		--find max frame for animation plot
		if Trakpak3.SwitchStandPlots and Trakpak3.SwitchStandPlots[self.model] then
			self.Plot = Trakpak3.SwitchStandPlots[self.model]
			self.MaxFrame = self.Plot[#self.Plot][1] or 0
		end
		
		--Wire I/O
		if WireLib then
			local names = {"ThrowMain","ThrowDiverging","ThrowToggle","Throw"}
			local types = {"NORMAL","NORMAL","NORMAL","NORMAL"}
			local descs = {}
			WireLib.CreateSpecialInputs(self, names, types, descs)
			
			local names = {"Main","Diverging","Blocked"}
			local types = {"NORMAL","NORMAL","NORMAL"}
			WireLib.CreateSpecialOutputs(self, names, types, descs)
			
			WireLib.TriggerOutput(self,"Main",1)
			WireLib.TriggerOutput(self,"Diverging",0)
			WireLib.TriggerOutput(self,"Blocked",0)
		end
		
		--Initial Broadcast
		hook.Run("TP3_SwitchUpdate",self:GetName(),false)
	end
	
	--Functions called by the switch
	
	--Initial Handshake to link the entities
	function ENT:StandSetup(ent)
		print("Stand "..self:GetName().." set up with switch "..ent:EntIndex().." with behavior mode "..self.behavior)
		self.switch = ent
		ent:SwitchSetup(self.behavior or 1)
	end
	
	--Force the switch stand to throw to the specified state (a result of trailing)
	function ENT:StandThrowTo(state)
		self:Actuate(state)
	end
	
	--Break the switch stand temporarily (a result of trailing)
	function ENT:StandBreak(state, vel)
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
		hook.Run("TP3_SwitchUpdate",self:GetName(),state,true)
		
		--print("AAAA")
		
		timer.Simple(60,function()
			self.broken = false
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:PhysicsInitStatic(SOLID_VPHYSICS)
			self:SetPos(self.originalpos)
			self:SetAngles(self.originalang)
			
			local p1 = math.random(1,3)
			local s_table = {"physics/wood/wood_box_impact_hard1.wav","physics/wood/wood_box_impact_hard2.wav","physics/wood/wood_box_impact_hard3.wav"}
			self:EmitSound(s_table[p1])
			
			if state then self:CompleteThrowDV() else self:CompleteThrowMN() end
		end)
	end
	
	--Receive occupancy status
	function ENT:StandSetOccupied(occ)
		self.occupied = occ
		local occn = 0
		if occ then occn = 1 end
		WireLib.TriggerOutput(self,"Blocked",occn)
		if self.autoreset and self.state then
			self:RegularThrow(false)
		end
	end
	
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	--Do these when the throw is completed
	function ENT:CompleteThrowMN()
		self.state = false
		self.animating = false
		self:ResetSequence(self.seq_idle_close)
		if WireLib then
			WireLib.TriggerOutput(self,"Main",1)
			WireLib.TriggerOutput(self,"Diverging",0)
		end
		self:TriggerOutput("OnThrownMain",self)
		if self.switch then self.switch:Switch(false) end
		--Broadcast
		hook.Run("TP3_SwitchUpdate",self:GetName(),false)
		print("Completed Throw MN", self.switch)
	end
	
	function ENT:CompleteThrowDV()
		self.state = true
		self.animating = false
		self:ResetSequence(self.seq_idle_open)
		if WireLib then
			WireLib.TriggerOutput(self,"Main",0)
			WireLib.TriggerOutput(self,"Diverging",1)
		end
		self:TriggerOutput("OnThrownDiverging",self)
		if self.switch then self.switch:Switch(true) end
		--Broadcast
		hook.Run("TP3_SwitchUpdate",self:GetName(),true)
		print("Completed Throw DV", self.switch)
	end
	
	--Animate Yourself - should be called after all other state-dependent logic is done!
	function ENT:Actuate(state)

		if state then --throw it open
			self.state = true
			self.animating = true
			self:ResetSequence(self.seq_throw_open)
			
			WireLib.TriggerOutput(self,"Main",0)
			WireLib.TriggerOutput(self,"Diverging",0)
			
			--When throw animation is done:
			timer.Simple(self:SequenceDuration(self.seq_throw_open), function() self:CompleteThrowDV() end)
		else --throw it closed
			self.state = false
			self.animating = true
			self:ResetSequence(self.seq_throw_close)
			
			WireLib.TriggerOutput(self,"Main",0)
			WireLib.TriggerOutput(self,"Diverging",0)
			
			--when throw animation is done:
			timer.Simple(self:SequenceDuration(self.seq_throw_close), function() self:CompleteThrowMN() end)
		end
	end
	
	--Handle animations and throw functions normally
	function ENT:RegularThrow(state)
		if not self.animating and not self.occupied and (state != self.state) then
			self.switch:SwitchThrow(state)
			self:Actuate(state)
		end
	end
	function ENT:Use()
		if not self.broken then self:RegularThrow(not self.state) end
	end
	
	function ENT:Think()
		self:NextThink(CurTime())
		return true
	end
	
	--Hammer Input Handler
	function ENT:AcceptInput( inputname, activator, caller, data )
		if inputname=="ThrowToggle" then
			self:RegularThrow(not self.state)
		elseif inputname=="ThrowMain" then
			self:RegularThrow(false)
		elseif inputname=="ThrowDiverging" then
			self:RegularThrow(true)
		end
	end
	
	--Wire input handler
	function ENT:TriggerInput(iname, value)
		if iname=="ThrowToggle" and value>0 then
			self:RegularThrow(not self.state)
		elseif iname=="ThrowMain" and value>0 then
			self:RegularThrow(false)
		elseif iname=="ThrowDiverging" and value>0 then
			self:RegularThrow(true)
		elseif iname=="Throw" then
			local new = (value>0)
			self:RegularThrow(new)
		end
	end
end