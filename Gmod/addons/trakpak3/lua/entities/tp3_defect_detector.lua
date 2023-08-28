AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Equipment Defect Detector"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Checks for Derailments"
ENT.Instructions = "Place in Hammer"

if SERVER then
	
	ENT.KeyValueMap = {
		boxsize = "number",
		boxdepth = "number",
		line1 = "string",
		line2 = "string",
		
		trigger = "entity",
		minspeed = "number",
		mintemp = "number",
		maxtemp = "number",
		
		soundfont = "string",
		speakintro = "boolean",
		instantreport = "boolean",
		
		s_intro = "string",
		s_nodefects = "string",
		s_dragging_equipment = "string",
		s_hotbox = "string",
		s_outro = "string",
		
		s_generic1 = "string",
		s_generic2 = "string",
		s_generic3 = "string",
		s_generic4 = "string"
	}
	
	--util.AddNetworkString("tp3_edd_broadcast") --Received in cl_defect_detector
	
	local function StringToAxis(axis)
		local nums = string.Explode(" ",axis)
		if #nums == 6 then
			local v1 = Vector(tonumber(nums[1]), tonumber(nums[2]), tonumber(nums[3]))
			local v2 = Vector(tonumber(nums[4]), tonumber(nums[5]), tonumber(nums[6]))
			return v1, v2
		end
	end
	local function DFormatNumber(num)
		local str = tostring(num)
		local ary = string.Explode("",str)
		str = ""
		for n = 1, #ary do
			local c = ary[n]
			if c=="." then
				c = "point"
			elseif c=="-" then
				c = "minus"
			end
			str = str..c
			if n < #ary then
				str = str.." "
			end
		end
		return str
	end
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		self.start1, self.end1 = StringToAxis(self.line1)
		self.start2, self.end2 = StringToAxis(self.line2)
		
		self:RegisterEntity("trigger",self.trigger) --self.trigger_valid & self.trigger_ent
		
		if self.soundfont then self.soundfont = string.lower(self.soundfont) end
		if self.s_intro then self.s_intro = string.lower(self.s_intro) end
		if self.s_outro then self.s_outro = string.lower(self.s_outro) end
		if self.s_nodefects then self.s_nodefects = string.lower(self.s_nodefects) end
		if self.s_dragging_equipment then self.s_dragging_equipment = string.lower(self.s_dragging_equipment) end
		if self.s_generic1 then self.s_generic1 = string.lower(self.s_generic1) end
		if self.s_generic2 then self.s_generic2 = string.lower(self.s_generic2) end
		if self.s_generic3 then self.s_generic3 = string.lower(self.s_generic3) end
		if self.s_generic4 then self.s_generic4 = string.lower(self.s_generic4) end
		
		--self.temp = math.random(self.mintemp, self.maxtemp) --For some reason, putting this here always comes up with the maximum number.
		
	end
	
	
	function ENT:Think()
		--Auto-Wire the Trigger
		if Trakpak3.InitPostEntity then
			if not self.tryoutput then
				self.tryoutput = true
				if self.trigger_valid and self:GetName() and (self:GetName()!="") then
					self.trigger_ent:Fire("AddOutput", "OnStartTouch "..self:GetName()..":AddProp:0:0:-1",0,self,self)
					--self.trigger_ent:Fire("AddOutput", "OnEndTouch "..self:GetName()..":RemoveProp:0:0:-1",0,self,self)
				end
			end
		end
		
		--Dragging Equipment Scan
		if self.running and self.endtime then
			if CurTime() < self.endtime then --Scan
				local blist = Trakpak3.TraceFilter
				
				local mins = Vector(-self.boxsize/2, -self.boxsize/2, -self.boxdepth)
				local maxs = Vector(self.boxsize/2, self.boxsize/2, 0)
				
				local tr1 = {
					start = self.start1,
					endpos = self.end1,
					maxs = maxs,
					mins = mins,
					filter = blist,
					ignoreworld = true
				}
				local tr2 = {
					start = self.start2,
					endpos = self.end2,
					maxs = maxs,
					mins = mins,
					filter = blist,
					ignoreworld = true
				}
				
				--Test Dragging Equipment
				local trace1 = util.TraceHull(tr1)
				local trace2 = util.TraceHull(tr2)
				
				if trace1.Hit or trace2.Hit then
					self.defect_axle = self.trainaxles
					self.defect_car = self.traincars
					self.dtype = "dragging_equipment"
					
					--Broadcast defect alarm immediately
					if self.instantreport and not self.ireported then
						self.ireported = true
						local sentence = self.s_dragging_equipment
						
						sentence = self:SubstituteVars(sentence)
						
						--print("DEFECT")
						
						--Broadcast Sentence
						--net.Start("tp3_edd_broadcast")
						net.Start("trakpak3")
							net.WriteString("tp3_edd_broadcast")
							net.WriteString(self.soundfont)
							net.WriteString(sentence)
						net.Broadcast()
					end
				end
				
				self:NextThink(CurTime() + 0.1)
				return true
			else --Detector Timed Out: Broadcast Results
				self.running = false
				self.ireported = false
				local sentence
				
				if self.dtype=="dragging_equipment" then --Dragging Equipment
					sentence = self.s_dragging_equipment.." "..self.s_outro
				elseif self.dtype=="hotbox" then --Hot Box
					sentence = self.s_hotbox.." "..self.s_outro
				else --No Defects
					sentence = self.s_nodefects.." "..self.s_outro
				end
				
				sentence = self:SubstituteVars(sentence)
				
				--Broadcast Sentence
				--net.Start("tp3_edd_broadcast")
				net.Start("trakpak3")
					net.WriteString("tp3_edd_broadcast")
					net.WriteString(self.soundfont)
					net.WriteString(sentence)
				net.Broadcast()
				
			end
		end
		
	end
	
	--Substitute/Plug-In Sentence Variables
	function ENT:SubstituteVars(sentence)
		--%intro %generic1 %generic2 %generic3 %generic4
		--%def_axle %def_car %axles %cars %feet %meters %mph %kph %temp
				
		sentence = string.Replace(sentence, "%intro", self.s_intro) --Intro
		sentence = string.Replace(sentence, "%generic1", self.s_generic1) --Generic 1
		sentence = string.Replace(sentence, "%generic2", self.s_generic2) --Generic 2
		sentence = string.Replace(sentence, "%generic3", self.s_generic3) --Generic 3
		sentence = string.Replace(sentence, "%generic4", self.s_generic4) --Generic 4
		--sentence = string.Replace(sentence, "%outro", self.s_outro) --Outro
		
		sentence = string.Replace(sentence, "%def_axle", DFormatNumber(self.defect_axle or 0)) --Defective Axle
		sentence = string.Replace(sentence, "%def_car", DFormatNumber(self.defect_car or 0)) --Defective Car
		
		sentence = string.Replace(sentence, "%axles", DFormatNumber(self.trainaxles)) --Axle Count
		sentence = string.Replace(sentence, "%cars", DFormatNumber(self.traincars)) --Car Count
		
		sentence = string.Replace(sentence, "%feet", DFormatNumber(math.ceil(self.trainlength/12))) --Length (ft)
		sentence = string.Replace(sentence, "%meters", DFormatNumber(math.ceil(self.trainlength/39.37))) --Length (m)
		
		sentence = string.Replace(sentence, "%mph", DFormatNumber(math.Round(self.trainspeed/17.6,1))) --Speed (MPH)
		sentence = string.Replace(sentence, "%kph", DFormatNumber(math.Round(self.trainspeed/10.94,1))) --Speed (KPH)
		
		sentence = string.Replace(sentence, "%temp", DFormatNumber(self.temp)) --Temperature
		
		return sentence
	end
	
	--Hammer Input Handler
	function ENT:AcceptInput( iname, activator, caller, data )
		if iname=="AddProp" then
			
			local phys = activator:GetPhysicsObject()
			local velv = phys:GetVelocity()
			local vel2 = velv:LengthSqr()
			if vel2 >= (self.minspeed^2) then --It passes the speed threshold
			
				if not self.running then
					self.running = true
					self.lastent = nil
					self.trainaxles = 0
					self.ropes = 0
					self.traincars = 0
					self.trainlength = 0
					self.trainspeed = 0
					self.defect_axle = nil
					self.defect_car = nil
					self.dtype = nil
					
					if not self.temp then self.temp = math.random(self.mintemp, self.maxtemp) end --Do this once the first time a train rolls over it
					
					--Broadcast intro when train first drives over
					if self.speakintro then
						--net.Start("tp3_edd_broadcast")
						net.Start("trakpak3")
							net.WriteString("tp3_edd_broadcast")
							net.WriteString(self.soundfont)
							net.WriteString(self.s_intro)
							net.WriteBool(false)
						net.Broadcast()
					end
				end
				
				--Determine number of axles based on length
				local vx = math.abs(velv:Dot(activator:GetForward()))
				local vy = math.abs(velv:Dot(activator:GetRight()))
				local vz = math.abs(velv:Dot(activator:GetUp()))
				local mins = activator:OBBMins()
				local maxs = activator:OBBMaxs()
				
				local proplength
				if (vy > vx) and (vy > vz) then --Moving in Local Y
					proplength = maxs.y - mins.y
					self.trainspeed = vy
				elseif (vz > vx) and (vz > vy) then --Moving in Local Z
					proplength = maxs.z - mins.z
					self.trainspeed = vz
				else --Moving in Local X
					proplength = maxs.x - mins.x
					self.trainspeed = vx
				end
				
				if proplength<100 then
					self.trainaxles = self.trainaxles + 1
				elseif proplength<200 then
					self.trainaxles = self.trainaxles + 2
				elseif proplength<240 then
					self.trainaxles = self.trainaxles + 3
				else
					self.trainaxles = self.trainaxles + 4
				end
				
				--Determine if this truck/axle is coupled or not
				
				local coupled = constraint.FindConstraint(activator, "Rope")
				--PrintTable(coupled)
				
				if coupled then
					self.ropes = self.ropes + 1
					
					self.traincars = math.floor(self.ropes/2) + 1
				end
				
				--Measure Distance to previous prop
				if self.lastent and self.lastent:IsValid() then
					self.trainlength = self.trainlength + activator:GetPos():Distance(self.lastent:GetPos())
				end
				
				self.lastent = activator
				
				--Test for Hot Box
				if activator:IsOnFire() then
					self.defect_axle = self.trainaxles
					self.defect_car = self.traincars
					self.dtype = "hotbox"
					
					--Broadcast defect alarm immediately
					if self.instantreport and not self.ireported then
						self.ireported = true
						local sentence = self.s_hotbox
						
						sentence = self:SubstituteVars(sentence)
						
						--print("DEFECT")
						
						--Broadcast Sentence
						--net.Start("tp3_edd_broadcast")
						net.Start("trakpak3")
							net.WriteString("tp3_edd_broadcast")
							net.WriteString(self.soundfont)
							net.WriteString(sentence)
						net.Broadcast()
					end
				end
				
				
				self.endtime = CurTime() + 5 --If another prop doesn't enter the trigger by this time, the detector will consider the train finished.
			end
			
		end
	end
	
end