AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Crossing Gate Prop"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Stop Cars from getting fenderbent by trains"
ENT.Instructions = "Place in Hammer"
ENT.AutomaticFrameAdvance = true

if SERVER then
	ENT.KeyValueMap = {
		model = "string",
		angles = "angle",
		xing = "entity",
		skin = "number",
		skin2 = "number",
		bodygroups = "string",
		bodygroups2 = "string",
		anim_trans = "string",
		anim_trans2 = "string",
		anim_idle = "string",
		anim_idle2 = "string",
		bellsound = "string",
		bellmode = "number",
		warning = "number",
		OnLightsOn = "output",
		OnLightsOff = "output",
		OnGateOpen = "output",
		OnGateClose = "output"
	}
	
	
	
	--Disable Physgun
	function ENT:PhysgunPickup() return false end
	
	function ENT:Initialize()
		self:ValidateNumerics()
		self:RegisterEntity("xing",self.xing)
		
		--Prop Init Stuff
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		--self:SetSolid(SOLID_BSP)
		
		if self.skin then self:SetSkin(self.skin) end
		if self.bodygroups then self:SetBodygroups(self.bodygroups) end
		
		if self.anim_idle then self:ResetSequence(self.anim_idle) end
		
		--Wire Setup
		if WireLib then
			local names = {"Lights", "Gate", "ETA"}
			local types = {"NORMAL", "NORMAL", "NORMAL"}
			WireLib.CreateSpecialOutputs(self, names, types, nil)
		end
		
		if self.xing_valid then self.randomoffset = self.xing_ent:RequestDelay() else self.randomoffset = 0 end --Used for slightly desynchronizing the opening/closing action <3
		
		--print(self, self.anim_trans, self.anim_trans2, self.anim_idle, self.anim_idle2)
	end
	
	
	--Lights turn on
	function ENT:LightsOn()
		if self.skin2 then
			--Change Lights
			self:SetSkin(self.skin2)
		end
		
		--Hammer
		self:TriggerOutput("OnLightsOn",self)
		
		--Wire
		if WireLib then
			WireLib.TriggerOutput(self, "Lights", 1)
		end
		self.working = true
	end
	
	--Lights turn off
	function ENT:LightsOff()
		if self.skin then
			--Change Lights
			self:SetSkin(self.skin)
		end
		--Hammer
		self:TriggerOutput("OnLightsOff",self)
		
		--Wire
		if WireLib then
			WireLib.TriggerOutput(self, "Lights", 0)
		end
		self.working = false
	end
	
	--Gate starts moving down
	function ENT:GateClose()
		local timedelay = 0
		
		--Bodygroups
		if self.bodygroups2 then
			Trakpak3.SetBodygroups(self.bodygroups2)
		end
		
		--Close Gate Animation
		if self.anim_trans2 then
			self:ResetSequence(self.anim_trans2)
			timedelay = self:SequenceDuration(self:LookupSequence(self.anim_trans2)) or 0
		end
		
		--Setup the timer for Close Idle Animation
		timer.Simple(timedelay, function()
			if self.anim_idle2 then self:ResetSequence(self.anim_idle2) end
			if (self.bellmode==1) or (self.bellmode==4) then timer.Simple(self.randomoffset, function() self:BellStop() end) end --BM 1/4: Bell stops once gates are fully down
			self.working = false
		end)
		
		--Hammer
		self:TriggerOutput("OnGateClose",self)
		
		--Wire
		if WireLib then
			WireLib.TriggerOutput(self, "Gate", 1)
		end
	end
	
	--Gate starts moving back up
	function ENT:GateOpen()
		self.working = true
		local timedelay = 0
		
		--Bodygroups
		if self.bodygroups then
			Trakpak3.SetBodygroups(self.bodygroups)
		end
		
		--Open Gate Animation
		if self.anim_trans then
			self:ResetSequence(self.anim_trans)
			timedelay = self:SequenceDuration(self:LookupSequence(self.anim_trans)) or 0
		end
		
		--Setup timer for Idle Open Animation
		timer.Simple(timedelay, function()
			if self.anim_idle then self:ResetSequence(self.anim_idle) end
		end)
		
		--Bellmode 3
		if self.bellmode==3 then
			timer.Simple(self.randomoffset, function () self:BellStop() end)
		end
		
		--Hammer
		self:TriggerOutput("OnGateOpen",self)
		
		--Wire
		if WireLib then
			WireLib.TriggerOutput(self, "Gate", 0)
		end
	end
	
	function ENT:BellStart()
		if (self.bellmode > 0) and self.bellsound and (self.bellsound != "") then
			self.bell = CreateSound(self,self.bellsound)
			self.bell:SetSoundLevel(80)
			self.bell:Play()
		end
	end
	
	function ENT:BellStop()
		if not self.bell then return end
		self.bell:Stop()
		self.bell = nil
	end
	
	function ENT:Think()
		if not self.xing_valid then return end
		
		if not self.working then
			if self.trigger and not self.triggered then --Begin crossing sequence
				self.triggered = true
				
				self:LightsOn() --Lights
				
				if self.bellmode != 0 then timer.Simple(self.randomoffset, function() self:BellStart() end) end --Bell
				
				timer.Simple((self.warning or 0) + self.randomoffset, function() self:GateClose() end) --Gate
				
			elseif not self.trigger and self.triggered then --Release crossing sequence
				self.triggered = false
				
				local timedelay = 0
				if self.anim_trans then
					timedelay = self:SequenceDuration(self:LookupSequence(self.anim_trans)) or 0
				end
				
				if (self.bellmode==0) or (self.bellmode==1) then --BM0/1: No Bell ringing at this time
					timer.Simple(self.randomoffset, function() self:GateOpen() end) --Gate
					timer.Simple(timedelay + 0.5, function() self:LightsOff() end) --Lights
				elseif self.bellmode==2 then --BM 2: Bell stops once gates are fully up
					timer.Simple(self.randomoffset, function() self:GateOpen() end) --Gate
					timer.Simple(timedelay + 0.5, function() self:LightsOff() end) --Lights
					timer.Simple(timedelay + self.randomoffset + 0.5, function() self:BellStop() end) --Bell
				elseif self.bellmode==3 then --BM 3: Bell stops once gates begin to go up
					timer.Simple(self.randomoffset, function() self:BellStop() end) --Bell
					timer.Simple(timedelay + 0.5, function() self:LightsOff() end) --Lights
					timer.Simple(self.randomoffset + 0.5, function() self:GateOpen() end) --Gate
				elseif self.bellmode==4 then --BM 4: Bell rings while gates in motion
					timer.Simple(self.randomoffset, function() self:BellStart() end) --Bell
					timer.Simple(timedelay + self.randomoffset + 1, function() self:BellStop() end)
					timer.Simple(self.randomoffset + 0.5, function() self:GateOpen() end) --Gate
					timer.Simple(timedelay + self.randomoffset + 0.5, function() self:LightsOff() end) --Lights
				end
			end
		end
		
		if WireLib and self.xing_ent then
			local newETA = self.xing_ent.ETA or -1
			if newETA != self.ETA then
				self.ETA = newETA
				WireLib.TriggerOutput(self, "ETA", self.ETA)
			end
		end
		self:NextThink(CurTime())
		return true
	end
	
	--Receive update from crossings
	hook.Add("TP3_CrossingUpdate","Trakpak3_CrossingUpdateGates",function(xing_name, state)
		--print("Update Received, ",xing_name,state)
		for n, self in pairs(ents.FindByClass("tp3_crossing_gate")) do
			if xing_name==self.xing then self.trigger = state end
		end
	end)
	
	
	--Add offsets to controller
	hook.Add("InitPostEntity","Trakpak3_CrossingGateOffsets",function()
		for k, self in pairs(ents.FindByClass("tp3_crossing_gate")) do
			if self.xing_valid then
				local addoffset = 0
				if self.warning then addoffset = self.warning end
				if self.anim_trans2 then addoffset = addoffset + self:SequenceDuration(self:LookupSequence(self.anim_trans2)) end
				self.xing_ent:InputDelay(addoffset)
			else
				print("[Trakpak3] tp3_crossing_gate without a corresponding tp3_crossing: ["..self:EntIndex().."], "..self:GetModel())
			end
		end
	end)
end

if CLIENT then
	--Render Signal Sprites
	function ENT:Draw(flags)
		Trakpak3.SignalSprites.DrawSpriteSignal(self, flags)
	end
end