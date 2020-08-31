AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Signal Block Controller"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Monitors Block Occupancy"
ENT.Instructions = "Place in Hammer"

--KeyVals: blockmode (0 1 2), scaninterval, hull_lw, hull_h, hull_offset
--Inputs: ForceOccupancy(N), UnForceOccupancy, TestOccupancy
--Outputs: OnOccupied, OnOccupiedNatural, OnClear, OnClearNatural, OnTestedOccupied, OnTestedClear

if SERVER then

	ENT.KeyValueMap = {
		blockmode = "number",
		scaninterval = "number",
		hull_lw = "number",
		hull_h = "number",
		hull_offset = "number",
		OnOccupied = "output",
		OnOccupiedNatural = "output",
		OnClear = "output",
		OnClearNatural = "output",
		OnTestedOccupied = "output",
		OnTestedClear = "output"
	}

	util.AddNetworkString("tp3_showhulls")
	
	function ENT:Initialize()
		
		self:ValidateNumerics()
		
		self.occupied = (self.blockmode==1)
		self.scanid = 1
		self.run = false --will wait until a node chain is provided
		
	end
	--[[
	hook.Add("InitPostEntity",function()
		local blocks = ents.FindByClass("tp3_signal_block")
		for k, v in pairs(blocks) do
			v:Initialize2()
		end
	end)
	]]--
	
	--Set up node chain using the new system
	function ENT:SetupNodes(nodechain)
		self.nodes = nodechain.Nodes
		self.skips = nodechain.Skips
		self.chainpos = nodechain.Pos
		
		self.nodecount = table.Count(self.nodes)
		
		if self.blockmode==0 then self.run = true end
		print("Block '"..self:GetName().."' set up successfully.")
	end
	
	--Update occupancy state of all nodes in my block
	util.AddNetworkString("tp3_block_hull_update")
	
	function ENT:UpdateNodeList(occupancy)
		net.Start("tp3_block_hull_update")
		net.WriteString(self:GetName())
		net.WriteBool(occupancy or false)
		net.Send(player.GetAll())
	end
	
	function ENT:HandleNewState(state, natural, ent)
		if state and not self.occupied then --Block is now occupied
			self.occupied = true
			--Hammer Outputs
			if natural then self:TriggerOutput("OnOccupiedNatural",self) end
			self:TriggerOutput("OnOccupied",self)
			--Block Update to Signal System
			hook.Run("TP3_BlockUpdate",self:GetName(),true, false, ent)
			--Update Wireframe
			self:UpdateNodeList(true)
		elseif not state and self.occupied then --Block is no longer occupied
			self.occupied = false
			--Hammer Outputs
			if natural then self:TriggerOutput("OnClearNatural",self) end
			self:TriggerOutput("OnClear",self)
			--Block Update to Signal System
			hook.Run("TP3_BlockUpdate",self:GetName(),false)
			--Update Wireframe
			self:UpdateNodeList(false)
		end
	end
	
	function ENT:InitialBroadcast() --Fired Externally by startup script
		hook.Run("TP3_BlockUpdate",self:GetName(),self.occupied,true)
	end
	
	function ENT:Think()
		--print("AAA")
		if self.run and Trakpak3.NodeList and self.nodes and self.skips and self.scanid then
			--print(Entity(35).run)
			--Perform a hull trace between two nodes
			if not self.skips[self.scanid] then  --OK to scan
				--Get node IDs
				local node1 = self.nodes[self.scanid]
				local node2 = self.nodes[self.scanid+1]
				
				--Get node positions
				local pos1 = Trakpak3.NodeList[node1]
				local pos2 = Trakpak3.NodeList[node2]
				
				local ht = {
					start = pos1 + Vector(0,0,self.hull_h/2 + self.hull_offset),
					endpos = pos2 + Vector(0,0,self.hull_h/2 + self.hull_offset),
					mins = Vector(-self.hull_lw/2, -self.hull_lw/2, -self.hull_h/2),
					maxs = Vector(self.hull_lw/2, self.hull_lw/2, self.hull_h/2),
					filter = Trakpak3.GetBlacklist(),
					ignoreworld = true
				}
				local tr = util.TraceHull(ht)
				if tr.Hit then --Trace hit something, block is occupied
					self.scanid = 1
					self.hitsomething = true
					self:HandleNewState(true, true, Trakpak3.GetRoot(tr.Entity))
				end
			end
			
			self.scanid = self.scanid + 1
			if self.scanid >= self.nodecount then --End of node list, check and start over
				if not self.hitsomething then self:HandleNewState(false, true) end
				self.scanid = 1
				self.hitsomething = false
			end
		end
		--Set up next think
		self:NextThink(CurTime() + self.scaninterval/1000)
		return true

	end
	
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
		end
	end
end