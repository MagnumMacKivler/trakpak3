AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Equipment Defect Detector"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Checks for Derailments"
ENT.Instructions = "Place in Hammer"

if SERVER then
	
	-- RSG
	list.Set("Trakpak3_AxleCountOverride", "models/anthonysmodels/uk/12t van/lner 12t van.mdl", 2)
	
	list.Set("Trakpak3_AxleCountOverride", "models/bogies/emd_htc_rsg.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/bogies/emd_htcr-e_rsg.mdl", 3)
	
	list.Set("Trakpak3_AxleCountOverride", "models/battle/centipede/centipede_truck_d_front.mdl", 4)
	list.Set("Trakpak3_AxleCountOverride", "models/battle/centipede/centipede_truck_d_rear.mdl", 4)
	
	list.Set("Trakpak3_AxleCountOverride", "models/bobsters_trains_2/wheels/standard/double_108.mdl", 1)
	list.Set("Trakpak3_AxleCountOverride", "models/bobsters_trains_2/wheels/standard/double_96.mdl", 1)
	list.Set("Trakpak3_AxleCountOverride", "models/bobsters_trains_2/wheels/standard/double_90.mdl", 1)
	
	list.Set("Trakpak3_AxleCountOverride", "models/bobsters_trains_2/stock/uk/chassis/12t_10ft_wb_chassis_rtr.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/bobsters_trains_2/stock/uk/chassis/12t_9ft_wb_chassis_rtr.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/bobsters_trains_2/stock/uk/wagons/6t_3_plank.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/bobsters_trains_2/stock/uk/wagons/standard_1_plank.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/bobsters_trains_2/stock/uk/wagons/standard_5_plank.mdl", 2)

	list.Set("Trakpak3_AxleCountOverride", "models/daylight/cw3axletender_cbq118.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/daylight/delta2w.mdl", 1)
	
	list.Set("Trakpak3_AxleCountOverride", "models/joe/bogies/arch_bar_truck.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/joe/bogies/arch_bar_truck_2.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/joe/bogies/wood_beam_truck.mdl", 2)
	
	list.Set("Trakpak3_AxleCountOverride", "models/phantom_one/fox_pressed_truck_30in.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/phantom_one/heavyweight_sixwheeler.mdl", 3)
	
	list.Set("Trakpak3_AxleCountOverride", "models/gsgtrainprops/trains/propper/trucks/dofasco_hi-ad.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/gsgtrainprops/trains/propper/trucks/dofasco_hi-ad_42in.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/rika/truck/alco_freight_a1a_late.mdl", 3)
	
	-- yes this is in fact too short to be a 3 axle
	list.Set("Trakpak3_AxleCountOverride", "models/rod's_stuff/bogie_sliders/3axle/hyperslider_rsg3axle.mdl", 3)
	
	list.Set("Trakpak3_AxleCountOverride", "models/buckeye/buckeye.mdl", 3)
	
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/doggard/ge_hiad_40in_a1a_late.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/doggard/ge_hiad_40in_c_late.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/doggard/ge_hiad_42in_a1a_late.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/doggard/ge_hiad_42in_c_late.mdl", 3)
	
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/trucks/aar_b_westinghouse.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/trucks/aar_b_westinghouse_40inch.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/trucks/commonwealth_a1a_long.mdl", 3)
	
	list.Set("Trakpak3_AxleCountOverride", "models/iore/bogie_iore_tp3.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/nhff/bogie_gloucester_dca.mdl", 2)
	
	list.Set("Trakpak3_AxleCountOverride", "models/bruss/lima_trailing_truck.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/bruss/trucks/usra_50t_archbar.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/parkmanpack/pullmans/heavytruck.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/parkmanpack/trucks/battleship_buckeye_truck_hyperslider.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/parkmanpack/trucks/gs2trailer.mdl", 2)
	
	list.Set("Trakpak3_AxleCountOverride", "models/zexciv_train_stuff/usa/bogies/baldwin_commonwealth_truck.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/zexciv_train_stuff/usa/bogies/buckeye_truck.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/zexciv_train_stuff/usa/bogies/pichler_truck.mdl", 3)
	
	
	list.Set("Trakpak3_AxleCountOverride", "models/zexciv_train_stuff/uk/br/class_31_bogie.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/zexciv_train_stuff/uk/br/class_58_bogie.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/zexciv_train_stuff/usa/alco/alco_pa_a1a_bogie.mdl", 3)
	
	-- 3ft
	list.Set("Trakpak3_AxleCountOverride", "models/rod's_stuff/bogie_sliders/3ft/hyperslider_3ft.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/zexciv_train_stuff/kustom/3ftstock/3ft_truck.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/zexciv_train_stuff/usa/trucks/archbar_3ft.mdl", 2)
	
	-- 24" ( Joe's 2ft )
	list.Set("Trakpak3_AxleCountOverride", "models/hfb_unterwagen_alte_p2ft.mdl", 2)
	
	-- 32" ( Ron's 2ft / 1 gauge )
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains1ga/coachbogey2.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains1ga/freightbogey2.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains1ga/heavybogey1.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains1ga/locobogey1.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains1ga/locobogey2.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains1ga/locobogey3.mdl", 3)
	
	list.Set("Trakpak3_AxleCountOverride", "models/joe/bogies/2ft_1.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/joe/bogies/2ft_2.mdl", 2)
	
	list.Set("Trakpak3_AxleCountOverride", "models/rod's_stuff/bogie_sliders/2ft/hyperslider_2ft.mdl", 2)
	
	-- PHX
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/trucks/aar_b_westinghouse_phx.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/lazpack/trucks/commonwealth_a1a_long_phx.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/rod's_stuff/bogie_sliders/3axle/hyperslider_phx3axle.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/gsgtrainprops/trains/propper/trucks/dofasco_hi-ad_phxgauge.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/gsgtrainprops/trains/propper/trucks/dofasco_hi-ad_42in_phxgauge.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/rika/truck/broad/alco_freight_a1a_late.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/hanksabutt/trucks/dd_truck/dd_truck_phx.mdl", 4)
	list.Set("Trakpak3_AxleCountOverride", "models/iore/bogie_iore_phx.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/nhff/bogie_gloucester_dca_phx.mdl", 2)
	list.Set("Trakpak3_AxleCountOverride", "models/unionslocos/centipede_bogie_c.mdl", 4)
	list.Set("Trakpak3_AxleCountOverride", "models/unionslocos/centipede_bogie_d.mdl", 4)
	
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains/heavybogey1.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains/locobogey4.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains/locobogey11.mdl", 3)
	list.Set("Trakpak3_AxleCountOverride", "models/magtrains/locobogey13.mdl", 3)
	
	-- Breitspur
	list.Set("Trakpak3_AxleCountOverride", "models/breitspurbahn/henschel_pxi_2-131_3-axle-truck.mdl", 3)
	
	
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
		axlelength = "string",
		
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
	
	local function StringToAxis(axis) --Formatted as X Y Z, X Y Z
		axis = string.Replace(axis, ", ", " ") --Make sure any comma+space combinations are swapped to spaces
		axis = string.Replace(axis, ",", " ") --Replace any commas without spaces, with spaces
		local nums = string.Explode(" ",axis)
		if #nums == 6 then
			local v1 = Vector(tonumber(nums[1]), tonumber(nums[2]), tonumber(nums[3]))
			local v2 = Vector(tonumber(nums[4]), tonumber(nums[5]), tonumber(nums[6]))
			--print("\n",axis, v1, v2, "\n")
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
	
	local V110 = Vector(1,1,0)
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		self.start1, self.end1 = StringToAxis(self.line1)
		self.start2, self.end2 = StringToAxis(self.line2)
		
		self.centerpos = (self.start1 + self.start2 + self.end1 + self.end2)*V110/4
		self.norm_c = ((self.end1 - self.start1)*V110):GetNormalized() --Should be the same as start2/end2
		
		print(self.centerpos, self.norm_c)
		
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
		
		self.axlelength_t = { 100, 200, 240, 300 }
		
		if ( #self.axlelength > 0 ) then
			table.clear( self.axlelength_t )
			for k, v in ipairs( string.Split( self.axlelength, "," ) ) do
				self.axlelength_t[k] = tonumber(v)
			end
		end
		--self.temp = math.random(self.mintemp, self.maxtemp) --For some reason, putting this here always comes up with the maximum number.
		
	end
	
	--Wrapper for transmitting EDD broadcasts. 0: subscribe but no broadcast, 1: subscribe and broadcast, 2: broadcast, 3: broadcast and clear.
	function ENT:Transmit(stage, soundfont, sentence)
	
		if stage<=1 then --Initial broadcast, ping the cabsignal boxes for distance and broadcast as necessary
			self.subscribers = {}
			
			for _, box in pairs(ents.FindByClass("gmod_wire_tp3_cabsignal_box")) do
				local r = box.radius or 2048
				if box:GetPos():DistToSqr(self:GetPos()) <= (r*r) then
					self.subscribers[box] = true --Add to list of subscribers for following transmissions
					if stage==1 then box:DetectorQueue(soundfont, sentence) end
				end
			end
		elseif stage>=2 then --Immediate Alarm
			for box, _ in pairs(self.subscribers) do
				box:DetectorQueue(soundfont, sentence)
			end
			if stage==3 then self.subscribers = {} end
		end
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
		if !self.running or !self.endtime then return end
		
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
					
					--print(self)
					--print(self.line1, self.start1, self.end1)
					--print(self.line2, self.start2, self.end2)
					
					--Spawn marker prop at site of defect
					--[[
					local HP
					if trace1.Hit then
						HP = trace1.HitPos
					elseif trace2.Hit then
						HP = trace2.HitPos
					end
					
					local marker = ents.Create("prop_physics")
					marker:SetModel("models/sprops/cuboids/height12/size_1/cube_12x12x12.mdl")
					marker:SetPos(HP)
					marker:Spawn()
					marker:PhysicsInit(SOLID_VPHYSICS)
					marker:GetPhysicsObject():EnableMotion(false)
					marker:SetCollisionGroup(COLLISION_GROUP_WORLD)
					marker:SetColor(Color(255,0,0,255))
					]]--
					
					--print("DEFECT")
					
					--Broadcast Sentence
					self:Transmit(2, self.soundfont, sentence)
				end
			end
			
			self:NextThink(CurTime() + 0.1)
			return true
		end
		
		--Detector Timed Out: Broadcast Results
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
		self:Transmit(3, self.soundfont, sentence)
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
		
		sentence = string.Replace(sentence, "%mph", DFormatNumber(math.Round(self.trainspeed/17.6))) --Speed (MPH)
		sentence = string.Replace(sentence, "%kph", DFormatNumber(math.Round(self.trainspeed/10.94))) --Speed (KPH)
		
		sentence = string.Replace(sentence, "%temp", DFormatNumber(self.temp)) --Temperature
		
		return sentence
	end
	
	
	
	--Hammer Input Handler
	function ENT:AcceptInput( iname, activator, caller, data )
		if iname == "AddProp" then
		
			--Determine if prop is in the detector's "track line" or not
			local Pos_2d = activator:GetPos()*V110
			local DispToStart = self.centerpos - Pos_2d
			
			
			--print(self.start_c, self.end_c, self.norm_c, Pos_2d)
			
			local DistToLine = DispToStart:Cross(self.norm_c):LengthSqr()
			
			if DistToLine > (64*64) then return end
		
			local phys = activator:GetPhysicsObject()
			if !phys:IsValid() then return end
			
			local velv = phys:GetVelocity()
			local vel2 = velv:LengthSqr()
			if vel2 < (self.minspeed*self.minspeed) then return end --It passes the speed threshold
			
			--Determine direction of motion
			local vx = math.abs(velv:Dot(activator:GetForward()))
			local vy = math.abs(velv:Dot(activator:GetRight()))
			local vz = math.abs(velv:Dot(activator:GetUp()))
			local mins = activator:OBBMins()
			local maxs = activator:OBBMaxs()
			
			local proplength
			local propspeed
			
			if (vy > vx) and (vy > vz) then --Moving in Local Y
				proplength = maxs.y - mins.y
				propspeed = vy
			elseif (vz > vx) and (vz > vy) then --Moving in Local Z
				proplength = maxs.z - mins.z
				propspeed = vz
			else --Moving in Local X
				proplength = maxs.x - mins.x
				propspeed = vx
			end
			
			if proplength > self.axlelength_t[ #self.axlelength_t ] and 
				!list.GetEntry( "Trakpak3_AxleCountOverride", activator:GetModel() ) then return end
			
			--Activate Detector
			if not self.running then
				self.running = true
				self.lastent = nil
				self.trainaxles = 0
				self.ropes = 0
				self.traincars = 0
				self.trainlength = 0
				self.defect_axle = nil
				self.defect_car = nil
				self.dtype = nil
				
				if not self.temp then self.temp = math.random(self.mintemp, self.maxtemp) end --Do this once the first time a train rolls over it
				
				--Broadcast intro when train first drives over
				if self.speakintro then
					self:Transmit(1, self.soundfont, self.s_intro)
				else
					self:Transmit(0)
				end
			end
			
			--Measure speed and count axles
			
			if list.GetEntry( "Trakpak3_AxleCountOverride", activator:GetModel() ) then
				self.trainaxles = self.trainaxles + list.GetEntry( "Trakpak3_AxleCountOverride", activator:GetModel() )
			else
				for k, v in ipairs( string.Split( self.axlelength, "," ) ) do
					if proplength < v then
						self.trainaxles = self.trainaxles + k
						break
					end								
				end
			end
			
			self.trainspeed = propspeed
			
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
					self:Transmit(2, self.soundfont, sentence)
				end
			end
			
			
			self.endtime = CurTime() + 5 --If another prop doesn't enter the trigger by this time, the detector will consider the train finished.
		end
	end
	
end