AddCSLuaFile()

DEFINE_BASECLASS( "base_wire_entity" )
--DEFINE_BASECLASS( "base_gmodentity" )
ENT.PrintName = "Trakpak3 Cab Signal Box"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Receiver for Cab Signal and ATS indications"
ENT.Instructions = "Spawn with the tool and use wiremod"
ENT.RenderGroup = RENDERGROUP_BOTH

if CLIENT then
	function ENT:Draw()
		if not WireLib then return end
		self:DoNormalDraw(true,false)
		if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then
			self:DrawEntityOutline()
			
		end
		Wire_Render(self)
	end
end

if SERVER then
	
	--This function is called on creation?
	function ENT:Setup(spadspeed, restrictedspeed, units, lw, h)
		print("Setup Cabsignal Box!")
		self:SetupSpeedInfo(spadspeed,restrictedspeed,units, lw, h)
	end

	function ENT:SetupSpeedInfo(s,r,u,lw,h) --Sanity check the speed/scan values, assign default otherwise
		local s_good = s and (tonumber(s)>=0)
		local r_good = r and (tonumber(r)>=0)
		local u_good = (u=="mph") or (u=="kph") or (u=="ins")
		
		local lw_good = lw and tonumber(lw)>0
		local h_good = h and tonumber(h)>0
		
		if s_good and r_good and u_good and lw_good and h_good then
			self.spadspeed = tonumber(s)
			self.restrictedspeed = tonumber(r)
			self.units = u
			
			self.lw = tonumber(lw)
			self.h = tonumber(h)
			
		else
			self.spadspeed = 5
			self.restrictedspeed = 15
			self.units = "mph"
			
			self.lw = 128
			self.h = 256
		end
		
		self.scansize = Vector(self.lw/2, self.lw/2, self.h/2)
		self:SetOverlayText("SPAD Trip: "..self.spadspeed.." "..self.units.."\nRestricting Trip: "..self.restrictedspeed.." "..self.units.."\nScan Size: "..self.lw.."x"..self.lw.."x"..self.h)
	end
	
	Trakpak3.speedmul = {mph = 17.6, kph = 10.93, ins = 1.0}
	
	function ENT:Initialize()
		--Prop stuff
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		
		--Wire Input Creation
		local names = {"Enable","Reset","BasePropOverride"}
		local types = {"NORMAL","NORMAL","ENTITY"}
		local descs = {"Required","",""}
		WireLib.CreateSpecialInputs(self, names, types, descs)
		
		--Wire Output Creation
		local names = {"LastSignalAspect",	"LastSignalSpeed",	"LastSignalSpeedNum",	"LastSignalDescription",	"NextSignalAspect",	"NextSignalSpeed",	"NextSignalSpeedNum",	"NextSignalDescription",	"EmBrake"}
		local types = {"STRING",			"STRING",			"NORMAL",				"STRING",					"STRING",			"STRING",			"NORMAL",				"STRING",					"NORMAL"}
		local descs = {}
		WireLib.CreateSpecialOutputs(self, names, types, descs)
		WireLib.TriggerOutput(self,"LastSignalAspect","None")
		WireLib.TriggerOutput(self,"LastSignalSpeed","FULL")
		WireLib.TriggerOutput(self,"LastSignalSpeedNum",Trakpak3.FULL)
		WireLib.TriggerOutput(self,"LastSignalDescription","No Description")
		
		WireLib.TriggerOutput(self,"NextSignalAspect","None")
		WireLib.TriggerOutput(self,"NextSignalSpeed","FULL")
		WireLib.TriggerOutput(self,"NextSignalSpeedNum",Trakpak3.FULL)
		WireLib.TriggerOutput(self,"NextSignalDescription","No Description")
		
		--Variable Init
		self.nextsignal = nil
		self.nextsignal_ent = NULL
		self.enabled = false
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
			else
				self.enabled = false
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
				
				WireLib.TriggerOutput(self,"NextSignalAspect","None")
				WireLib.TriggerOutput(self,"NextSignalSpeed","FULL")
				WireLib.TriggerOutput(self,"NextSignalSpeedNum",Trakpak3.FULL)
				WireLib.TriggerOutput(self,"NextSignalDescription","No Description")
				
				WireLib.TriggerOutput(self,"EmBrake",0)
			end
		elseif iname=="BasePropOverride" then
			if value:IsValid() then
				self.override = value
			else
				self.override = nil
			end
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
		elseif not self.signals then
			self.signals = ents.FindByClass("tp3_signal_master")
		end
	
		--Calculate the rough distance between the box and the next signal (straight line)
		--[[
		if self.nextsignal and self.nextsignal_ent and self.nextsignal_ent:IsValid() then
			local Dist = (self:GetPos() - self.nextsignal_ent:GetPos()):Length()
			WireLib.TriggerOutput(self,"Distance",math.Round(Dist))
		end
		]]--
		
		--Turbo Think
		self:NextThink(CurTime())
		return true
	end

	
	function ENT:PassSignal(home_signal, next_signal)
		--Get the signal entity we just passed
		local homesig, homevalid = Trakpak3.FindByTargetname(home_signal)
		
		local speedcode = Trakpak3.FULL
		local clear = false
		if homevalid then
			--Get Aspect Info
			local aspect = homesig.aspect
			WireLib.TriggerOutput(self,"LastSignalAspect",homesig.aspect or "None")
			
			local system = homesig.system
			if aspect and system then
				speedcode = system.rules[aspect].speed
				local speedname = Trakpak3.SpeedDictionary[speedcode]
				local desc = system.rules[aspect].desc
				
				WireLib.TriggerOutput(self,"LastSignalSpeed",speedname or "FULL")
				WireLib.TriggerOutput(self,"LastSignalSpeedNum",speedcode or Trakpak3.FULL)
				WireLib.TriggerOutput(self,"LastSignalDescription",desc or "No Description")
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
		end
		
		--Get Next signal
		local nextsig, nextvalid = Trakpak3.FindByTargetname(next_signal)
		local clear = false
		if nextvalid then
		
			self.nextsignal = next_signal
		
			--Get Aspect Info
			local aspect = nextsig.aspect
			WireLib.TriggerOutput(self,"NextSignalAspect",nextsig.aspect or "None")
			
			local system = nextsig.system
			if aspect and system then
				local n_speedcode = system.rules[aspect].speed
				local speedname = Trakpak3.SpeedDictionary[n_speedcode]
				local desc = system.rules[aspect].desc
				
				WireLib.TriggerOutput(self,"NextSignalSpeed",speedname or "FULL")
				WireLib.TriggerOutput(self,"NextSignalSpeedNum",n_speedcode or Trakpak3.FULL)
				WireLib.TriggerOutput(self,"NextSignalDescription",desc or "No Description")
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
		elseif speedcode==1 then --test SPAR
			local root = Trakpak3.GetRoot(self)
			local speed = root:GetVelocity():Length()
			
			if speed > self.restrictedspeed*Trakpak3.speedmul[self.units] then
				WireLib.TriggerOutput(self,"EmBrake",1) --Dump the air!
				timer.Simple(1,function()
					WireLib.TriggerOutput(self,"EmBrake",0) --Reset after 1 second
				end)
			end
		end
		
	end
end