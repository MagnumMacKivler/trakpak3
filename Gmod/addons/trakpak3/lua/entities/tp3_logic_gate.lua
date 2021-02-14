AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Logic Gate"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Monitors other Signal Blocks"
ENT.Instructions = "Place in Hammer"

if SERVER then

	ENT.KeyValueMap = {
		blockmode = "number",
		operator = "string",
		["block_*"] = "entity",
		OnOccupied = "output",
		OnOccupiedNatural = "output",
		OnClear = "output",
		OnClearNatural = "output",
		OnTestedOccupied = "output",
		OnTestedClear = "output"
	}
	
	function ENT:Initialize()
		
		self:ValidateNumerics()
		
		self.blocks = {}
		self.blockents = {}
		
		--Register initial blocks
		for position, blockname in pairs(self.pkvs) do self:RegisterBlock(position,blockname) end
		
		self.occupied = (self.blockmode==1)
		
	end
	
	--Register a Block
	function ENT:RegisterBlock(position, blockname)
		if not self.blocks then self.blocks = {} end
		if not self.blockents then self.blockents = {} end
		if (not blockname) or (blockname=="") then self.blocks[position] = nil end
		local ent, valid = Trakpak3.FindByTargetname(blockname)
		if valid then
			self.blocks[position] = blockname
			self.blockents[position] = ent
		else
			self.blocks[position] = nil
			self.blockents[position] = nil
		end
	end
	
	--Perform logical calculation for all blocks
	function ENT:EvaluateLogic()
		local states = {}
		for position, blockent in pairs(self.blockents) do
			if blockent then
				states[position] = blockent.occupied or false
			end
		end
		if self.operator=="OR" then
			for k, state in pairs(states) do
				if state then return true end
			end
			return false
		elseif self.operator=="AND" then
			for k, state in pairs(states) do
				if not state then return false end
			end
			return true
		elseif self.operator=="NOR" then
			for k, state in pairs(states) do
				if state then return false end
			end
			return true
		elseif self.operator=="NAND" then
			for k, state in pairs(states) do
				if not state then return true end
			end
			return false
		elseif self.operator=="EQUAL" then
			local _and = true
			local _nor = true
			for k, state in pairs(states) do
				if not state then _and = false end
				if state then _nor = false end
			end
			return (_and or _nor)
		elseif self.operator=="UNEQUAL" then
			local _or = false
			local _nand = false
			for k, state in pairs(states) do
				if state then _or = true end
				if not state then _nand = true end
			end
			return (_or and _nand)
		end
	end
	
	--Update occupancy state of this gate's wireframe
	util.AddNetworkString("tp3_logic_gate_update")
	
	function ENT:UpdateWireframe(occupancy)
		net.Start("tp3_logic_gate_update")
		net.WriteString(self:GetName())
		net.WriteBool(occupancy or false)
		net.Broadcast()
	end
	
	--Handle New State
	function ENT:HandleNewState(state, natural, ent)
		if state and not self.occupied then --Block is now occupied
			self.occupied = true
			--Hammer Outputs
			if natural then self:TriggerOutput("OnOccupiedNatural",self) end
			self:TriggerOutput("OnOccupied",self)
			--Block Update to Signal System
			hook.Run("TP3_BlockUpdate",self:GetName(),true, false, ent)
			Trakpak3.Dispatch.SendInfo(self:GetName(),"occupied",1)
			--Update Wireframe
			self:UpdateWireframe(self.occupied)
			
		elseif not state and self.occupied then --Block is no longer occupied
			self.occupied = false
			--Hammer Outputs
			if natural then self:TriggerOutput("OnClearNatural",self) end
			self:TriggerOutput("OnClear",self)
			--Block Update to Signal System
			hook.Run("TP3_BlockUpdate",self:GetName(),false)
			Trakpak3.Dispatch.SendInfo(self:GetName(),"occupied",0)
			--Update Wireframe
			self:UpdateWireframe(self.occupied)
		end
	end
	
	function ENT:InitialBroadcast() --Fired Externally by startup script (signalsetup)
		hook.Run("TP3_BlockUpdate",self:GetName(),self.occupied,true)
	end
	
	hook.Add("TP3_BlockUpdate","Trakpak3_BlockUpdateLogics",function(blockname, occupied, force)
		for k, gate in pairs(ents.FindByClass("tp3_logic_gate")) do --For all Logic Gates:
			for position, block in pairs(gate.blocks) do 
				if blockname==block then --Check to see if this block is referenced
					gate:HandleNewState(gate:EvaluateLogic(),true,false)
				end
			end
		end
	end)
	
	function ENT:AcceptInput(iname, activator, caller, data)
		if iname=="ForceOccupancy" then
			self.run = false
			if data=="1" then
				self:HandleNewState(true,false)
			elseif data=="0" then
				self:HandleNewState(false,false)
			end
		elseif iname=="UnForceOccupancy" then
			if self.canrun then
				self.run = true
				self.scanid = 1
			end
		elseif iname=="TestOccupancy" then
			if self.occupied then
				self:TriggerOutput("OnTestedOccupied",self)
			else
				self:TriggerOutput("OnTestedClear",self)
			end
		elseif string.Left(iname,8)=="SetBlock" then
			local pos = tonumber(string.Sub(iname,9))
			if pos and pos>0 then self:RegisterBlock(pos,data) end
		end
	end
end