AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Crossing Gate Prop"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Stop Cars from getting fenderbent by trains"
ENT.Instructions = "Place in Hammer"

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
	
	ENT.AutomaticFrameAdvance = true
	
	function ENT:Initialize()
		
		self:RegisterEntity("xing",self.xing)
		
		--Prop Init Stuff
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		
		if self.skin then self:SetSkin(self.skin) end
		if self.bodygroups then Trakpak3.SetBodygroups(self, bodygroups) end
		
		if self.anim_idle then self:ResetSequence(self.anim_idle) end
		
		--Wire Setup
		if WireLib then
			local names = {"Lights", "Gate", "ETA"}
			local types = {"NORMAL", "NORMAL", "NORMAL"}
			WireLib.CreateSpecialOutputs(self, names, types, nil)
		end
	end
	
	
	function ENT:LightsOn()
		if self.skin2 then
			--Change Lights
			self:SetSkin(self.skin2)
		end
		
		--Setup Gate Delay
		if self.warning then timer.Simple(self.warning, function() self:GateClose() end) end
		
		--Bell
		self:BellStart()
		
		--Hammer
		self:TriggerOutput("OnLightsOn",self)
		
		--Wire
		if WireLib then
			WireLib.TriggerOutput(self, "Lights", 1)
		end
		self.working = true
	end
	
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
	
	function ENT:GateClose()
		local timedelay = 0
		
		--Bodygroups
		if self.bodygroups2 then
			Trakpak3.SetBodygroups(self.bodygroups2)
		end
		
		--Animations
		if self.anim_trans2 then
			self:ResetSequence(self.anim_trans2)
			timedelay = self:SequenceDuration(self:LookupSequence(self.anim_trans2)) or 0
		end
		
		timer.Simple(timedelay, function()
			if self.anim_idle2 then self:ResetSequence(self.anim_idle2) end
			if self.bellmode==1 then self:BellStop() end
			self.working = false
		end)
		
		--Hammer
		self:TriggerOutput("OnGateClose",self)
		
		--Wire
		if WireLib then
			WireLib.TriggerOutput(self, "Gate", 1)
		end
	end
	
	function ENT:GateOpen()
		self.working = true
		local timedelay = 0
		
		--Bodygroups
		if self.bodygroups then
			Trakpak3.SetBodygroups(self.bodygroups)
		end
		
		--Animations
		if self.anim_trans then
			self:ResetSequence(self.anim_trans)
			timedelay = self:SequenceDuration(self:LookupSequence(self.anim_trans)) or 0
		end
		
		timer.Simple(timedelay, function()
			if self.anim_idle then self:ResetSequence(self.anim_idle) end
			if self.bellmode==2 then self:BellStop() end
			self:LightsOff()
		end)
		
		--Hammer
		self:TriggerOutput("OnGateOpen",self)
		
		--Wire
		if WireLib then
			WireLib.TriggerOutput(self, "Gate", 0)
		end
	end
	
	function ENT:BellStart()
		if self.bellmode>0 and self.bellsound then
			self.bell = CreateSound(self,self.bellsound)
			self.bell:SetSoundLevel(75)
			self.bell:Play()
		end
	end
	
	function ENT:BellStop()
		if not self.bell then return end
		self.bell:Stop()
		self.bell = nil
	end
	
	function ENT:Think()
		if not self.working then
			if self.trigger and not self.triggered then
				self.triggered = true
				self:LightsOn()
			elseif not self.trigger and self.triggered then
				self.triggered = false
				self:GateOpen()
			end
		end
		
		if WireLib and self.xing_ent then
			local newETA = self.xing_ent.ETA or -1
			if newETA != self.ETA then
				self.ETA = newETA
				WireLib.TriggerOutput(self, "ETA", self.ETA)
			end
		end
	end
	
	--Receive update from crossings
	hook.Add("TP3_CrossingUpdate","Trakpak3_CrossingUpdateGates",function(xing_name, state)
		--print("Updated Received, ",xing_name,state)
		for n, self in pairs(ents.FindByClass("tp3_crossing_gate")) do
			if xing_name==self.xing then self.trigger = state end
		end
	end)
	
	
	--Add offsets to controller
	hook.Add("InitPostEntity","Trakpak3_CrossingGateOffsets",function()
		for k, self in pairs(ents.FindByClass("tp3_crossing_gate")) do
			local addoffset = 0
			if self.warning then addoffset = self.warning end
			if self.anim_trans2 then addoffset = addoffset + self:SequenceDuration(self:LookupSequence(self.anim_trans2)) end
			self.xing_ent:InputDelay(addoffset)
		end
	end)
end