AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Signal Controller (Basic)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Signal Controller for single-headed signals"
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

--KVs: block, prop, automatic (1 0), actuationmode (0 - 6), mode0-mode2 (0 - 6), nextsignal
--Inputs: SetManualMode, SetAutoMode, SetSignalState(integer)
--Outputs: OnDark OnStop OnRestricting OnApproach OnAdvanceApproach OnClear

function ENT:Initialize()
	if CLIENT then return end
	--Narrow down to one entity
	self.propent = FindByTargetname(self.prop)
	self.blockent = FindByTargetname(self.block)
	self.nextsignalent = FindByTargetname(self.nextsignal)
	
	if self.automatic=="1" then self.automatic = true else self.automatic = false end --Initial State
	
	--Set flags
	self.hasprops = (self.prop) and (self.propent) and (IsValid(self.propent))
	self.hasblock = (self.block) and (self.blockent) and (IsValid(self.blockent)) and (self.blockent.ClassName=="tp3_signal_block")
	self.hasnext = (self.nextsignal) and (self.nextsignalent) and (IsValid(self.nextsignalent)) and (tp3_allowedsignalclasses[self.nextsignalent.ClassName])
	
	if self.hasblock then self.mem_occ = false end
	if self.hasnext then self.mem_nss = 5 end
	
	self.mode0 = tonumber(self.mode0) or 0
	self.mode1 = tonumber(self.mode1) or 0
	self.mode2 = tonumber(self.mode2) or 0
	--"mode3" = clear = 5
	local am = self.actuationmode
	self.doskins = (am=="0") or (am=="3") or (am=="4") or (am=="6")
	self.dobodygroups = (am=="1") or (am=="3") or (am=="5") or (am=="6")
	self.doanims = (am=="2") or (am=="4") or (am=="5") or (am=="6")
	--print(self.actuationmode, type(self.actuationmode), self.doskins, self.dobodygroups, self.doanims)
	
	--Output Lookup Table
	self.outputbystate = {
		[0] = "OnDark",
		[1] = "OnStop",
		[2] = "OnRestricting",
		[3] = "OnApproach",
		[4] = "OnAdvanceApproach",
		[5] = "OnClear"
	}
	
	if self.hasblock then --set up event hook for when the block changes
		hook.Add("TP3_BlockUpdate","tp3_blockupdate_"..self:EntIndex(),function(target, data)
			self:UpdateSignalState(target, data)
		end)
	end
	
	--Update any signals that may be monitoring this one
	function self.Broadcast()
		hook.Run("TP3_BlockUpdate",self:GetName(),self.signalstate)
	end
	
	self.signalstate = 0 --Majority of blocks are going to be unoccupied initially
	self:HandleStateChange(5)
end

function ENT:UpdateSignalState(target_ent, target_data, forceupdate) --Figure out which aspect to show if in automatic mode
	if CLIENT then return end
	local oneofmine = false
	if forceupdate then
		oneofmine = true
	elseif target_ent then
		oneofmine = (target_ent==self.block) or (target_ent==self.nextsignal)
	end
	if (!self.hasprops) or (not oneofmine) then return end --Bail out if the signal has no props, or if the update just doens't pertain to this signal.

	
	--Update Memory
	if (target_data==true) or (target_data==false) then --Update Block Occupancy Mem
		self.mem_occ = target_data
	elseif target_data then --Update Next Signal State Mem
		self.mem_nss = target_data
	end --if nil, update nothing
	
	if self.automatic then --Signal memory is still updated while in manual mode, it just doesn't change unless told to
	
		if self.mem_occ then --Block is Occupied
			self:HandleStateChange(self.mode0)
		elseif (self.mem_nss==1) or (self.mem_nss==2) then --Block is Clear, Next Signal is Red or Restricting
			self:HandleStateChange(self.mode1)
		elseif (self.mem_nss==3) then --Block is Clear, Next Signal is Yellow
			self:HandleStateChange(self.mode2)
		else --Block is Clear, Next Signal is Off, Advance Approach, or Green
			self:HandleStateChange(5)
		end
	end
	 
end
--Outputs: OnDark OnStop OnRestricting OnApproach OnAdvanceApproach OnClear
function ENT:HandleStateChange(state) --Change the State and broadcast updates if applicable
	if CLIENT then return end
	if self.signalstate != state then
		--print(self,self.signalstate,state)
		self.signalstate = state
		self.Broadcast()
		if self.doskins then self.propent:SetSkin(self.signalstate) end --Skin Change
		if self.dobodygroups then self.propent:SetBodygroup(1,self.signalstate) end --Bodygroup Change
		if self.doanims then end --Animation Change (TO DO)
		
		self:TriggerOutput(self.outputbystate[self.signalstate],self) --Fire appropriate output from lookup table
	end
end

--Inputs: SetManualMode, SetAutoMode, SetSignalState(integer)
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
	end
end