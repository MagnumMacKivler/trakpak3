AddCSLuaFile()

DEFINE_BASECLASS( "base_wire_entity" )
--DEFINE_BASECLASS( "base_gmodentity" )
ENT.PrintName = "Trakpak3 Cab Signal Box"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Receiver for Cab Signal and ATS indications"
ENT.Instructions = "Spawn with the tool and use wiremod"
ENT.RenderGroup = RENDERGROUP_BOTH

if SERVER then
	
	--This function is called on creation?
	function ENT:Setup(spadspeed, units, lw, h, radius)
		self:SetupSpeedInfo(spadspeed, units, lw, h, radius)
	end
	
	--Sanity check the speed/scan values, assign default otherwise 
	function ENT:SetupSpeedInfo(s,u,lw,h,r) 
		local s_good = s and (tonumber(s)>=0)
		local u_good = (u=="mph") or (u=="kph") or (u=="ins")
		
		local lw_good = lw and tonumber(lw)>0
		local h_good = h and tonumber(h)>0
		
		if s_good and u_good and lw_good and h_good then
			self.spadspeed = tonumber(s)
			self.units = u
			
			self.lw = tonumber(lw)
			self.h = tonumber(h)
			
		else
			self.spadspeed = 10
			--self.restrictedspeed = 15
			self.units = "mph"
			
			self.lw = 128
			self.h = 256
		end
		
		self.scansize = Vector(self.lw/2, self.lw/2, self.h/2)
		
		self.radius = r or 2048
		
		self:SetupOverlay()
	end
	
	function ENT:SetupOverlay()
		local tag = ""
		if self.Trakpak3_TrainTag then tag = self.Trakpak3_TrainTag.."\n" end
		self:SetOverlayText(tag.."SPAD Trip: "..self.spadspeed.." "..self.units.."\nScan Size: "..self.lw.."x"..self.lw.."x"..self.h.."\nDefect Detector Receiver Radius: "..self.radius)
	end
	
	Trakpak3.speedmul = {mph = 17.6, kph = 10.93, ins = 1.0}
	
	function ENT:Initialize()
		--Prop stuff
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:SetUseType(SIMPLE_USE)
		
		--Wire I/O
		
		local inputs = {
			"Enable",
			"Reset",
			"BasePropOverride [ENTITY]",
			"TrainTag [STRING]",
			"ApplyTag"
		}
		
		local outputs = {
			"LastSignalAspect [STRING]",
			"LastSignalSpeed [STRING]",
			"LastSignalSpeedNum",
			"LastSignalDescription [STRING]",
			"LastSignal [ENTITY]",
			"NextSignalAspect [STRING]",
			"NextSignalSpeed [STRING]",
			"NextSignalSpeedNum",
			"NextSignalDescription [STRING]",
			"NextSignal [ENTITY]",
			"EmBrake",
			"TrainTag [STRING]"
		}
		
		WireLib.CreateInputs(self, inputs)
		WireLib.CreateOutputs(self, outputs)
			
		
		WireLib.TriggerOutput(self,"LastSignalAspect","None")
		WireLib.TriggerOutput(self,"LastSignalSpeed","FULL")
		WireLib.TriggerOutput(self,"LastSignalSpeedNum",Trakpak3.FULL)
		WireLib.TriggerOutput(self,"LastSignalDescription","No Description")
		WireLib.TriggerOutput(self,"LastSignal",NULL)
		
		WireLib.TriggerOutput(self,"NextSignalAspect","None")
		WireLib.TriggerOutput(self,"NextSignalSpeed","FULL")
		WireLib.TriggerOutput(self,"NextSignalSpeedNum",Trakpak3.FULL)
		WireLib.TriggerOutput(self,"NextSignalDescription","No Description")
		WireLib.TriggerOutput(self,"NextSignal",NULL)
		
		--Variable Init
		self.nextsignal = nil
		self.nextsignal_ent = NULL
		self.enabled = false
		self:SetNWBool("enabled",false)
		
		--Apply a default Train Tag, use the player's name
		
		timer.Simple(0.5,function()
			if self.CPPIGetOwner then
				local creator = self:CPPIGetOwner()
				if creator and creator:IsValid() then
					local name = creator:GetName()
					Trakpak3.ApplyTrainTag(self,name)
				end
			end
		end)

	end
	
	
	
	--Train Tag Dialog Net Traffic
	--Player pressed E on it
	function ENT:Use(ply)
		if ply:IsPlayer() then
			net.Start("trakpak3")
				net.WriteString("trakpak3_traintagdialog")
				net.WriteEntity(self)
			net.Send(ply)
		end
	end
	
	--Player Entered a New Train Tag
	Trakpak3.Net.trakpak3_traintagdialog = function(len,ply)
		local ent = net.ReadEntity()
		local newtag = net.ReadString()
		
		if newtag=="" then newtag = nil end
		
		if ent and ent:IsValid() and (ent:GetClass()=="gmod_wire_tp3_cabsignal_box") then
			Trakpak3.ApplyTrainTag(ent, newtag)
			ent:SetupOverlay()
		end
	end
	
	--Hook into signaling system to receive live updates
	hook.Add("TP3_SignalUpdate","Trakpak3_UpdateCabSignals",function(signalname, aspect)
		for _, box in pairs(ents.FindByClass("gmod_wire_tp3_cabsignal_box")) do
			box:UpdateSignalState(signalname, aspect)
		end
	end)
	
	--Wire Input Handler
	function ENT:TriggerInput(iname, value)
		if iname=="Enable" then
			if value>0 then
				self.enabled = true
				self:SetNWBool("enabled",true)
			else
				self.enabled = false
				self:SetNWBool("enabled",false)
			end
			--print("Enabled: ",self.enabled)
		elseif iname=="Reset" then
			if value>0 then
				self.nextsignal = nil
				--self.nextsignalent = nil
				
				WireLib.TriggerOutput(self,"LastSignalAspect","None")
				WireLib.TriggerOutput(self,"LastSignalSpeed","FULL")
				WireLib.TriggerOutput(self,"LastSignalSpeedNum",Trakpak3.FULL)
				WireLib.TriggerOutput(self,"LastSignalDescription","No Description")
				WireLib.TriggerOutput(self,"LastSignal",NULL)
				
				WireLib.TriggerOutput(self,"NextSignalAspect","None")
				WireLib.TriggerOutput(self,"NextSignalSpeed","FULL")
				WireLib.TriggerOutput(self,"NextSignalSpeedNum",Trakpak3.FULL)
				WireLib.TriggerOutput(self,"NextSignalDescription","No Description")
				WireLib.TriggerOutput(self,"NextSignal",NULL)
				
				WireLib.TriggerOutput(self,"EmBrake",0)
			end
		elseif iname=="BasePropOverride" then
			if value:IsValid() then
				self.override = value
			else
				self.override = nil
			end
		elseif iname=="TrainTag" then
			if value!="" then self.wiretag = value else self.wiretag = nil end
		elseif (iname=="ApplyTag") and (value>=1) then
			Trakpak3.ApplyTrainTag(self, self.wiretag)
			self:SetupOverlay()
		end
	end
	
	--Update next signal state
	function ENT:UpdateSignalState(signalname)
		--Is this my signal?
		if signalname==self.nextsignal then
			local nextsig, valid = Trakpak3.FindByTargetname(signalname)
			if valid then
				local aspect = nextsig.aspect
				WireLib.TriggerOutput(self,"NextSignalAspect",nextsig.aspect or "None")
				
				local system = nextsig.system
				if aspect and system then
					local speedcode = system.rules[aspect].speed
					local speedname = Trakpak3.SpeedDictionary[speedcode]
					local desc = system.rules[aspect].desc
					
					WireLib.TriggerOutput(self,"NextSignalSpeed",speedname or "FULL")
					WireLib.TriggerOutput(self,"NextSignalSpeedNum",speedcode or Trakpak3.FULL)
					WireLib.TriggerOutput(self,"NextSignalDescription",desc or "No Description")
					WireLib.TriggerOutput(self,"NextSignal",nextsig or NULL)
				end
			end
		end
	end

	function ENT:Think()
		--Scan all signals and find if you're passing one
		if self.enabled and self.signals then
			local root
			if self.override then root = self.override else root = Trakpak3.GetRoot(self) end
			
			local vel = root:GetVelocity()
			local rf = root:GetForward()
			local rr = root:GetRight()
			
			local dforward = vel:Dot(rf)
			local dleft = -vel:Dot(rr)
			local pos
			local scan = true
			if math.abs(dforward) >= math.abs(dleft) then
				if dforward>0 then
					pos = root:GetPos() + root:OBBMaxs().x*rf
				elseif dforward<0 then
					pos = root:GetPos() + root:OBBMins().x*rf
				end
			else
				if dleft>0 then
					pos = root:GetPos() + root:OBBMins().y*rr
				elseif dleft<0 then
					pos = root:GetPos() + root:OBBMaxs().y*rr
				end
			end
			
			if pos then
				local scanmax = pos + self.scansize
				local scanmin = pos - self.scansize
				for k, signal in pairs(self.signals) do
					local sigpos = signal.cs_pos
					if sigpos and sigpos:WithinAABox(scanmin, scanmax) then --signal's position is within the scan box
						
						if vel:GetNormalized():Dot(-signal:GetForward()) > 0.707 then --moving in the correct direction
							self:PassSignal(signal:GetName(), signal.nextsignal)
							break
						end
					end
				end
			end
			
			--Automatically apply train tag, if there is one
			local mytag = self.Trakpak3_TrainTag
			local speed2 = vel:LengthSqr()
			local threshold = 5/17.6
			
			if mytag and not self.moving then --Train tag exists and the box is "standing still"
				
				if speed2 > 4*threshold*threshold then --CS Box has exceeded 10 mph
					self.moving = true
					
					Trakpak3.ApplyTrainTag(self, mytag)
				end
			elseif mytag and self.moving then --Train tag exists and the box is "moving"
				if speed2 < threshold*threshold then self.moving = false end --CS Box less than 5 mph
			end
			
		elseif not self.signals then
			self.signals = ents.FindByClass("tp3_signal_master")
		end
		
		--Turbo Think
		self:NextThink(CurTime())
		return true
	end

	--Function called when the train passes a new signal
	function ENT:PassSignal(home_signal, next_signal)
		--Get the signal entity we just passed
		local homesig, homevalid = Trakpak3.FindByTargetname(home_signal)
		
		local speedcode = Trakpak3.FULL
		local clear = false
		if homevalid then
			--Get Aspect Info
			local aspect = homesig.aspect_delayed
			WireLib.TriggerOutput(self,"LastSignalAspect",aspect or "None")
			
			local system = homesig.system
			if aspect and system then
				speedcode = system.rules[aspect].speed
				local speedname = Trakpak3.SpeedDictionary[speedcode]
				local desc = system.rules[aspect].desc
				
				WireLib.TriggerOutput(self,"LastSignalSpeed",speedname or "FULL")
				WireLib.TriggerOutput(self,"LastSignalSpeedNum",speedcode or Trakpak3.FULL)
				WireLib.TriggerOutput(self,"LastSignalDescription",desc or "No Description")
				WireLib.TriggerOutput(self,"LastSignal",homesig or NULL)
			else
				clear = true
			end
		else
			clear = true
		end
		
		if clear then 
			WireLib.TriggerOutput(self,"LastSignalAspect","None")
			WireLib.TriggerOutput(self,"LastSignalSpeed","FULL")
			WireLib.TriggerOutput(self,"LastSignalSpeedNum",Trakpak3.FULL)
			WireLib.TriggerOutput(self,"LastSignalDescription","No Description")
			WireLib.TriggerOutput(self,"LastSignal",NULL)
		end
		
		--Get Next signal
		local nextsig, nextvalid = Trakpak3.FindByTargetname(next_signal)
		local clear = false
		if nextvalid then
		
			self.nextsignal = next_signal
		
			--Get Aspect Info
			local aspect = nextsig.aspect_delayed
			WireLib.TriggerOutput(self,"NextSignalAspect",aspect or "None")
			
			local system = nextsig.system
			if aspect and system then
				local n_speedcode = system.rules[aspect].speed
				local speedname = Trakpak3.SpeedDictionary[n_speedcode]
				local desc = system.rules[aspect].desc
				
				WireLib.TriggerOutput(self,"NextSignalSpeed",speedname or "FULL")
				WireLib.TriggerOutput(self,"NextSignalSpeedNum",n_speedcode or Trakpak3.FULL)
				WireLib.TriggerOutput(self,"NextSignalDescription",desc or "No Description")
				WireLib.TriggerOutput(self,"NextSignal",nextsig or NULL)
			else
				clear = true
			end
		else
			clear = true
		end
		
		if clear then 
			self.nextsignal = nil
			WireLib.TriggerOutput(self,"NextSignalAspect","None")
			WireLib.TriggerOutput(self,"NextSignalSpeed","FULL")
			WireLib.TriggerOutput(self,"NextSignalSpeedNum",Trakpak3.FULL)
			WireLib.TriggerOutput(self,"NextSignalDescription","No Description")
			WireLib.TriggerOutput(self,"NextSignal",NULL)
		end
		
		--Test overspeed trips
		if speedcode==0 then --test SPAD
			local root = Trakpak3.GetRoot(self)
			local speed = root:GetVelocity():Length()
			
			if speed > self.spadspeed*Trakpak3.speedmul[self.units] then
				WireLib.TriggerOutput(self,"EmBrake",1) --Dump the air!
				timer.Simple(1,function()
					WireLib.TriggerOutput(self,"EmBrake",0) --Reset after 1 second
				end)
			end
		end
		
	end
	
	--Receive Defect Detector Ping/Broadcast from EDD. Receiver function is in cl_defect_detector.lua.
	function ENT:DetectorQueue(soundfont, sentence)
		Trakpak3.NetStart("tp3_edd_broadcast")
			net.WriteEntity(self)
			net.WriteString(soundfont)
			net.WriteString(sentence)
		net.Broadcast()
	end
	
	
end

if CLIENT then
	local LP = LocalPlayer
	
	
	--Wire Entity Draw Functions
	function ENT:Draw()
		if not WireLib then return end
		self:DoNormalDraw(true,false)
		if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then
			self:DrawEntityOutline()
			
		end
		Wire_Render(self)
	end
	
	--Open Train Tag Dialog
	function ENT:OpenTrainTagDialog()
		local e = self
	
		local frame = vgui.Create("DFrame")
		local sx = 256
		local sy = 144
		frame:SetSize(sx, sy)
		frame:SetPos(ScrW()/2 - sx/2, ScrH()/2 - sy/2)
		frame:SetTitle("Enter Train Tag")
		frame:MakePopup()
		
		local label = vgui.Create("DLabel",frame)
		label:SetText("Enter/Edit a Train Tag here. Train Tags appear on the Dispatch Board and are used to convey destination information.")
		label:SetSize(1,48)
		label:SetContentAlignment(4)
		label:SetWrap(true)
		label:Dock(TOP)
		
		--Get current Train Tag from NWString
		local mytag = self:GetNWString("Trakpak3_TrainTag")
		
		local text = vgui.Create("DTextEntry",frame)
		text:SetSize(1,24)
		text:SetValue(mytag or "")
		text:Dock(TOP)
		function text:OnEnter(value)
			net.Start("trakpak3")
				net.WriteString("trakpak3_traintagdialog")
				net.WriteEntity(e)
				local newtag = value or ""
				net.WriteString(newtag)
			net.SendToServer()
			frame:Close()
			if newtag!="" then
				chat.AddText("[Trakpak3 Cab Signal Box] Set Train Tag to '"..newtag.."'.")
				surface.PlaySound("ambient/machines/keyboard_fast1_1second.wav")
			else
				chat.AddText("[Trakpak3 Cab Signal Box] Cleared Train Tag.")
				surface.PlaySound("ambient/machines/keyboard7_clicks_enter.wav")
			end
			
		end
		
		local button = vgui.Create("DButton",frame)
		button:SetSize(64,1)
		button:Dock(LEFT)
		button:DockMargin(24,2,2,2)
		button:SetText("Apply")
		function button:DoClick()
			net.Start("trakpak3")
				net.WriteString("trakpak3_traintagdialog")
				net.WriteEntity(e)
				local newtag = text:GetValue() or ""
				net.WriteString(newtag)
			net.SendToServer()
			frame:Close()
			if newtag!="" then
				chat.AddText("[Trakpak3 Cab Signal Box] Set Train Tag to '"..newtag.."'.")
				surface.PlaySound("ambient/machines/keyboard_fast1_1second.wav")
			else
				chat.AddText("[Trakpak3 Cab Signal Box] Cleared Train Tag.")
				surface.PlaySound("ambient/machines/keyboard7_clicks_enter.wav")
			end
			
		end
		
		local button = vgui.Create("DButton",frame)
		button:SetSize(64,1)
		button:Dock(RIGHT)
		button:DockMargin(2,2,24,2)
		button:SetText("Clear")
		function button:DoClick()
			net.Start("trakpak3")
				net.WriteString("trakpak3_traintagdialog")
				net.WriteEntity(e)
				net.WriteString("")
			net.SendToServer()
			frame:Close()
			chat.AddText("[Trakpak3 Cab Signal Box] Cleared Train Tag.")
			surface.PlaySound("ambient/machines/keyboard7_clicks_enter.wav")
		end
	--end)
	end
	
	--User pressed E to enter a Train Tag
	Trakpak3.Net.trakpak3_traintagdialog = function(len,ply)
		local ent = net.ReadEntity()
		if ent and ent:IsValid() then
			ent:OpenTrainTagDialog()
		end
	end
	
	--Defect Detector Queue - called from cl_defect_detector.lua
	function ENT:DetectorQueue(font,sentence)
		if self:GetNWBool("enabled") then
			--Add to Queue
			if not self.edd_queue then self.edd_queue = {} end
			table.insert(self.edd_queue,{font, sentence})
			--PrintTable(self.edd_queue)
			if not self.speaking then self:DetectorSpeak() end
		end
	end
	
	--Defect Detector Start Playback
	function ENT:DetectorSpeak()
		
		local volvar = GetConVar("tp3_defect_detector_volume")
		local vol = 0
		if volvar then vol = volvar:GetFloat() end
		
		if vol==0 then return end
		
		local q_item = self.edd_queue[1]
		local font = q_item[1]
		local sentence = q_item[2]
		
		table.remove(self.edd_queue,1)
		
		self.speaking = true
		self.edd_schedule = {}
		local soundfont = Trakpak3.EDD.SoundFonts[font]
		if soundfont then
			local staticloop = soundfont.staticloop or "trakpak3/defect_detectors/static.wav"
			local delay = soundfont.delay or 0.25
			local words = string.Explode(" ",sentence)
			local t = CurTime() + 0.5
			
			--Initialize Static Sound (if not already playing)
			if not self.edd_static then
				self.edd_static = CreateSound(self, staticloop)
			end
			
			
			for n=1, #words do
				local wdata = soundfont[words[n]]
				if wdata then --Word exists in soundfont
					table.insert(self.edd_schedule, {t,wdata[1]} )
					t = t + wdata[2] + delay
				end
			end
			table.insert(self.edd_schedule, {t,nil} ) --Add final event for end time
			
			
			if #self.edd_schedule > 0 then --Sounds actually made it in
				self.edd_static:Play()
				self.edd_static:ChangeVolume(vol)
			else --No valid words
				self.speaking = false
				self.edd_schedule = nil
			end
		else --SoundFont doesn't exist
			self.speaking = false
			self.edd_schedule = nil
		end
	end
	
	local clicking = false
	
	function ENT:Think()
		--"Allow Buttons" Interaction, apparently the default wire Allow buttons functionality already works with it
		
		if((not game.SinglePlayer()) and LP():InVehicle() and (LP():GetPos():DistToSqr(self:EyePos()) < 96*96) ) and LP():KeyDown(IN_ATTACK) and LP():GetEyeTrace().Entity==self and not clicking then
			clicking = true
			self:OpenTrainTagDialog()
			--print("Bepis")
		elseif clicking and not LP():KeyDown(IN_ATTACK) then
			clicking = false
		end
		
		
		--Play Defect Detector Sounds
		if self:GetNWBool("enabled") then
			if self.speaking and self.edd_schedule then
				
				local volvar = GetConVar("tp3_defect_detector_volume")
				local vol = 0
				if volvar then vol = volvar:GetFloat() end
				
				local nextevent = self.edd_schedule[1][1]
				local nextsound = self.edd_schedule[1][2]
				
				if CurTime() > nextevent then
					if nextsound then --Play the sound
						self:EmitSound(nextsound,nil,nil,vol)
						table.remove(self.edd_schedule,1)
					else --End of Sentence
						self.edd_schedule = nil
						if self.edd_queue and self.edd_queue[1] then --Prepare to speak the next sentence in the queue
							timer.Simple(1.0,function()
								self:DetectorSpeak()
							end)
						else --Detector is done speaking
							self.speaking = false
							if self.edd_static then
								self.edd_static:Stop()
								self.edd_static = nil
							end
						end
					end
				end
			end
		else --Disabled
			if self.speaking then --Cancel Speech
				self.speaking = false
				self.edd_schedule = nil
				if self.edd_static then
					self.edd_static:Stop()
					self.edd_static = nil
				end
			end
		end
		
		self:NextThink(CurTime())
		return true
	end
	
	
	function ENT:OnRemove()
		if self.edd_static then
			self.edd_static:Stop()
			self.edd_static = nil
		end
	end
	
	CreateClientConVar("tp3_defect_detector_volume","1",true,false,"The decimal volume to play defect detector sounds at. 1 is full, 0 disables playback.",0,1)
	
end