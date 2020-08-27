AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Signal Controller (Multi)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Signal Controller for double-headed (mostly) signals"
ENT.Instructions = "Place in Hammer"

local function FindByTargetname(name)
	if name and name!="" then
		local result = ents.FindByName(name)[1]
		if IsValid(result) then
			return result, true
		else
			return nil, false
		end
	else
		return nil, false
	end
end
local function fif(condition, result_true, result_false)
	if condition then
		return result_true
	else
		return result_false
	end
end

--Add class as a valid signal
if tp3_allowedsignalclasses then
	tp3_allowedsignalclasses.tp3_signal_basic = true
else
	tp3_allowedsignalclasses = { tp3_signal_basic = true }
end

--Keyvalues: prop1, prop2, automatic (0 1 2) actuationmode (0-6) upper_mode0-2 lower_mode0-2 switch_N block_X nextsignal_X equation_X
--Inputs: SetManualMode SetAutoMode SetSignalState(integer) SetMain SetDiverging
--Outputs: OnDark OnStop OnRestricting OnApproach OnAdvanceApproach OnClear OnMain OnDiverging

function ENT:KeyValue(key, value) --Assign KeyValues (all string) to entity for later processing
	if CLIENT then return end
	if string.Left(key, 2)=="On" then --Keyvalue is an output
		self:StoreOutput(key, value)
	elseif string.Left(key,9)=="equation_" then --Keyvalue is an equation - just store it
		if self.equations then
			self.equations[key] = value
		else
			self.equations = {[key] = value}
		end
	elseif string.Left(key,6)=="block_" then --Keyvalue is a block
		if self.blocks then
			self.blocks[key] = value
		else
			self.blocks = {[key] = value}
		end
	elseif string.Left(key,11)=="nextsignal_" then --Keyvalue is a next signal
		if self.nexts then
			self.nexts[key] = value
		else
			self.nexts = {[key] = value}
		end
	elseif string.Left(key,7)=="switch_" then --Keyvalue is a switch
		if self.switches then
			self.switches[key] = value
		else
			self.switches = {[key] = value}
		end
	elseif string.Left(key,6)=="mode0_" then --Keyvalue is a mode 0 modifier
		if self.mode0mod then
			self.mode0mod[key] = value
		else
			self.mode0mod = {[key] = value}
		end
	elseif string.Left(key,6)=="mode1_" then --Keyvalue is a mode 1 modifier
		if self.mode1mod then
			self.mode1mod[key] = value
		else
			self.mode1mod = {[key] = value}
		end
	elseif string.Left(key,6)=="mode2_" then --Keyvalue is a mode 2 modifier
		if self.mode2mod then
			self.mode2mod[key] = value
		else
			self.mode2mod = {[key] = value}
		end
	else --Keyvalue is a regular keyvalue
		self[key] = value 
	end
end

--Keyvalues: prop1, prop2, automatic (0 1 2) actuationmode (0-6) mode0-2 switch_N block_X nextsignal_X equation_X
function ENT:Initialize()
	if CLIENT then return end
	
	self.prop1ent = FindByTargetname(self.prop1)
	self.prop2ent = FindByTargetname(self.prop2)
	
	self.pathexists = {} --logs the available paths, keys are string names
	self.blockents = {}
	self.nextents = {}
	
	self.switchids = {} --logs the available switches, keys are targetnames, vals are single-character IDs
	self.switchents = {}
	
	function ProcessPath(name) --Register that there is actually a valid path here
		if self.blocks and self.blocks["block_"..name] then
			local ent = FindByTargetname(self.blocks["block_"..name])
			if IsValid(ent) then self.blockents[name] = ent; self.pathexists[name] = true end
		end
		if self.nexts and self.nexts["nextsignal_"..name] then
			local ent = FindByTargetname(self.nexts["nextsignal_"..name])
			if IsValid(ent) then self.nextents[name] = ent; self.pathexists[name] = true end
		end
	end
	
	--Process paths by equation
	for k, v in pairs(self.equations) do
		local name = string.Right(k, #k - 9)
		ProcessPath(name)
	end
	
	--Process Switches
	for k, v in pairs(self.switches) do
		local ent = FindByTargetname(v)
		local id = string.Right(k, 1)
		if IsValid(ent) then self.switchents[id] = ent; self.switchids[v] = id end
	end
	--[[
	print("Switch IDs")
	PrintTable(self.switchids)
	print("Switch Ents")
	PrintTable(self.switchents)
	print("Path Exists")
	PrintTable(self.pathexists)
	print("Equations")
	PrintTable(self.equations)
	]]--
	
	if self.automatic=="1" then self.automatic = true else self.automatic = false end --Initial State
	
	--Set flags
	self.hasprop1 = (self.prop1) and (self.prop1ent) and (IsValid(self.prop1ent))
	self.hasprop2 = (self.prop2) and (self.prop2ent) and (IsValid(self.prop2ent))
	
	self.valid = ( (not table.IsEmpty(self.blockents)) or (not table.IsEmpty(self.nextents)) ) and (not table.IsEmpty(self.switchents)) --There must be at least one path and one switch for this to be valid
	
	--Configurable Aspect Modes
	self.mode0 = tonumber(self.mode0) or 0
	self.mode1 = tonumber(self.mode1) or 0
	self.mode2 = tonumber(self.mode2) or 0
	
	if self.mode0mod then
		for k, v in pairs(self.mode0mod) do
			self.mode0mod[k] = tonumber(v) or 0
		end
	end
	if self.mode1mod then
		for k, v in pairs(self.mode1mod) do
			self.mode1mod[k] = tonumber(v) or 0
		end
	end
	if self.mode2mod then
		for k, v in pairs(self.mode2mod) do
			self.mode2mod[k] = tonumber(v) or 0
		end
	end
	
	--Actuation Mode
	local am = self.actuationmode
	self.doskins = (am=="0") or (am=="3") or (am=="4") or (am=="6")
	self.dobodygroups = (am=="1") or (am=="3") or (am=="5") or (am=="6")
	self.doanims = (am=="2") or (am=="4") or (am=="5") or (am=="6")
	
	--Output Lookup Table
	self.outputbystate = {
		[0] = "OnDark",
		[1] = "OnStop",
		[2] = "OnRestricting",
		[3] = "OnApproach",
		[4] = "OnAdvanceApproach",
		[5] = "OnClear"
	}
	
	if self.valid then
		self.mem_occ = false
		self.mem_nss = 5
		self.mem_sws = {}
		self.mem_div = false
		--Set up hooks for receiving signal and switch updates
		hook.Add("TP3_BlockUpdate","tp3_blockupdate_"..self:EntIndex(),function(target, data)
			self:UpdateSignalState(target, data)
			--print("JCT Block Update!",target,data)
		end)
		
		hook.Add("TP3_SwitchUpdate","tp3_switchupdate_"..self:EntIndex(),function(target, data)
			self:UpdateLogicState(target, data)
			--print("JCT Switch Update!",target,data)
		end)
		
		function self.Broadcast()
			hook.Run("TP3_BlockUpdate",self:GetName(),self.signalstate)
		end
		
		for k, v in pairs(self.switchents) do
			v:EnableBroadcast()
		end
		
		self.signalstate = 0 --Majority of blocks are going to be unoccupied initially
		self:HandleStateChange(5)
	end
end

function ENT:UpdateSignalState(target_ent, target_data, forceupdate) --Figure out which aspect to show if in automatic mode
	if CLIENT then return end
	--print(self.block, self.nextsignal)
	local oneofmine = false
	if forceupdate then
		oneofmine = true
	elseif target_ent and (self.block or self.nextsignal) then
		oneofmine = (target_ent==self.block) or (target_ent==self.nextsignal)
	end
	if (!self.hasprop1 and !self.hasprop2) or (not oneofmine) then return end --Bail out if the signal has no props, or if the update just doens't pertain to this signal.

	
	--Update Memory
	if (target_data==true) or (target_data==false) then --Update Block Occupancy Mem
		self.mem_occ = target_data
	elseif target_data then --Update Next Signal State Mem
		self.mem_nss = target_data
	end --if nil, update nothing
	
	
	if self.automatic then --Signal memory is still updated while in manual mode, it just doesn't change unless told to
		
		--Resolve modes
		local mode0 = self.mode0
		local mode1 = self.mode1
		local mode2 = self.mode2
		if self.currentpath then
			if self.mode0mod and self.mode0mod[self.currentpath] then mode0 = self.mode0mod[self.currentpath] end
			if self.mode1mod and self.mode1mod[self.currentpath] then mode1 = self.mode1mod[self.currentpath] end
			if self.mode2mod and self.mode2mod[self.currentpath] then mode2 = self.mode2mod[self.currentpath] end
		end
		
		if self.mem_occ then --Block is Occupied
			self:HandleStateChange(mode0)
		elseif (self.mem_nss==1) or (self.mem_nss==2) then --Block is Clear, Next Signal is Red or Restricting
			self:HandleStateChange(mode1)
		elseif (self.mem_nss==3) then --Block is Clear, Next Signal is Yellow
			self:HandleStateChange(mode2)
		else --Block is Clear, Next Signal is Off, Advance Approach, or Green
			self:HandleStateChange(5)
		end
	end
	 
end

function ENT:UpdateLogicState(target_ent, target_data) --Analyze the switch positions and figure out which path you're taking
	if CLIENT then return end
	local id = self.switchids[target_ent]
	--print("ID: "..id)
	if id then --If the update is for one of this signal's switches:
		--Update the data
		self.mem_sws[id] = target_data
		
		--Run the logic
		if self.automatic then
			local safepath = false
			for pathname,v in pairs(self.pathexists) do --check the conditions for each path until you find one that works
				local equation = self.equations["equation_"..pathname]
				local terms = string.Explode(" ",equation)
				local truepath = true
				for n, term in pairs(terms) do
					local switch_id = term[1]
					local switch_requiredcondition = (term[2]=="d") or (term[2]=="D")
					local switch_condition = self.mem_sws[switch_id] or false --assume main if no data received
					--print(self.mem_sws[switch_id], switch_requiredcondition)
					if switch_condition!=switch_requiredcondition then
						truepath = false
						break
					end
				end
				if truepath then --This path is valid, do this'n
					safepath = true
					--print("Aligned to path: "..pathname)
					if self.blockents[pathname] then
						self.block = self.blocks["block_"..pathname]
						self.mem_occ = self.blockents[pathname].occupied
					end
					if self.nextents[pathname] then
						self.nextsignal = self.nexts["nextsignal_"..pathname]
						self.mem_nss = self.nextents[pathname].signalstate
					end
					self.div = pathname!="main"
					self.currentpath = pathname
					self:UpdateSignalState(nil,nil,true)
					break
				end
			end
			
			if not safepath then --Force Red over Red
				self.block = nil
				self.nextsignal = nil
				self:HandleStateChange(1)
			end
		end
	end
end

function ENT:HandleStateChange(state) --Change the State and broadcast updates if applicable
	if CLIENT then return end
	print("State change:",self,self.signalstate,state)
	local statechange = (self.signalstate!=state)
	local divchange = (self.div!=self.mem_div)
	if statechange or divchange then
		
		self.mem_div = self.div
		self.signalstate = state
		self.Broadcast()
		
		local state1 = nil
		local state2 = nil
		if self.hasprop1 and self.hasprop2 then
			state1 = fif(self.div, 1, state)
			state2 = fif(self.div, state, 1)
		elseif self.hasprop1 then
			state1 = state
		elseif self.hasprop2 then
			state2 = state
		end
		if self.doskins then --Skin Change
			if state1 then self.prop1ent:SetSkin(state1) end
			if state2 then self.prop2ent:SetSkin(state2) end
		end 
		if self.dobodygroups then --Bodygroup Change
			if state1 then self.prop1ent:SetBodygroup(1,state1) end
			if state2 then self.prop2ent:SetBodygroup(1,state2) end
		end 
		if self.doanims then end --Animation Change (TO DO)
		
		if statechange then self:TriggerOutput(self.outputbystate[self.signalstate],self) end --Fire appropriate output from lookup table
		if divchange then self:TriggerOutput(fif(self.div, "OnDiverging", "OnMain"),self) end
	end
end

--SetManualMode SetAutoMode SetSignalState(integer) SetMain SetDiverging
function ENT:AcceptInput(inputname, activator, caller, data)
	if inputname=="SetManualMode" then
		self.automatic = false
	elseif inputname=="SetAutoMode" then
		self.automatic = true
		self:UpdateSignalState(nil, nil, true)
	elseif inputname=="SetSignalState" then
		local data = math.floor(tonumber(data))
		if (data >= 0) and (data <= 6) then
			self.automatic = false
			self:HandleStateChange(data)
		end
	elseif inputname=="SetMain" then
		self.automatic = false
		self.div = false
	elseif inputname=="SetDiverging" then
		self.automatic = false
		self.div = true
	end
end