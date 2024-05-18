AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Signal Block Controller"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Monitors Block Occupancy"
ENT.Instructions = "Place in Hammer"
ENT.Type = "anim" --Required for multiconvex triggers to work

--KeyVals: blockmode (0 1 2), scaninterval, hull_lw, hull_h, hull_offset
--Inputs: ForceOccupancy(N), UnForceOccupancy, TestOccupancy
--Outputs: OnOccupied, OnOccupiedNatural, OnClear, OnClearNatural, OnTestedOccupied, OnTestedClear

if SERVER then
	
	local Dispatch = Trakpak3.Dispatch
	
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
	
	function ENT:Initialize()
		
		self:ValidateNumerics()
		
		self.occupied = (self.blockmode==1)
		self.scanid = 1
		self.run = false --will wait until a node chain is provided
		self.softoccupied = false --Controls hull trace detection.
		self.TriggerEnts = {}
		
		self:SetAngles(Angle(0,0,0)) --If somehow hammer places this at an angle, this ensures the trigger hulls will still work.
	end
	
	--Set up node chain, called from nodessetup.lua
	function ENT:SetupNodes(nodechain)
		self.nodes = nodechain.Nodes
		self.skips = nodechain.Skips
		self.chainpos = nodechain.Pos
		
		
		
		--Check for duplicate nodes in sequence which would cause degenerate convexes.
		local lastnode
		local duplicates = {}
		for index, node in ipairs(self.nodes) do
			if node==lastnode then --Duplicate node detected!
				ErrorNoHalt("[Trakpak3] Error! tp3_signal_block '"..self:GetName().."' has the same node ("..node..") twice in the chain! To fix this, clear this block's nodes and re-save the node file.\n")
				table.insert(duplicates,index)
			end
			lastnode = node
		end
		--If any duplicates were found, pop them from the tables so the map will load:
		if next(duplicates) then
			for _, index in ipairs(duplicates) do
				table.remove(self.nodes, index)
				table.remove(self.skips, index)
			end
		end
		
		self.nodecount = #self.nodes --table.Count(self.nodes)
		
		if self.nodecount==1 then
			self.run = false
			ErrorNoHalt("[Trakpak3] Error! Signal Block "..self:GetName().." has only one in the chain! Double check this block's node chain and retry.\n")
		elseif self.nodecount==0 then
			self.run = false
			print("[Trakpak3] Signal Block "..self:GetName().." Has no nodes in the chain.")
		else
			if self.blockmode==0 then self.run = true end
			print("[Trakpak3] Signal Block '"..self:GetName().."' set up successfully with "..self.nodecount.." nodes.")
			self:BecomeTrigger()
		end
	end
	
	--Update occupancy state of all nodes in my block
	
	function ENT:UpdateNodeList(occupancy)
		net.Start("trakpak3")
		net.WriteString("tp3_block_hull_update")
		net.WriteString(self:GetName())
		net.WriteBool(occupancy or false)
		net.Broadcast()
	end
	
	--Handle New State
	function ENT:HandleNewState(state, natural, ent)
		if state and not self.occupied then --Block is now occupied
			self.occupied = true
			
			--Train Tag
			self.traintag, self.trainspeed = self:ReadTrainTag(ent)
			if self.traintag then
				Dispatch.SendInfo(self:GetName(), "traintag", self.traintag, "string")
				Dispatch.SendInfo(self:GetName(), "trainspeed", self.trainspeed)
				self.nextspeedtime = CurTime() + 5
			end
			
			--Hammer Outputs
			if natural then self:TriggerOutput("OnOccupiedNatural",self) end
			self:TriggerOutput("OnOccupied",self)
			--Block Update to Signal System
			hook.Run("TP3_BlockUpdate",self:GetName(),true, false, ent)
			Dispatch.SendInfo(self:GetName(),"occupied",1)
			--Update Wireframe
			self:UpdateNodeList(true)
		elseif not state and self.occupied then --Block is no longer occupied
			self.occupied = false
			--Train Tag
			self.traintag = nil
			self.nextspeedtime = nil
			
			--Hammer Outputs
			if natural then self:TriggerOutput("OnClearNatural",self) end
			self:TriggerOutput("OnClear",self)
			--Block Update to Signal System
			hook.Run("TP3_BlockUpdate",self:GetName(),false)
			Dispatch.SendInfo(self:GetName(),"occupied",0)
			--Update Wireframe
			self:UpdateNodeList(false)
		elseif state then --No state change, but you still hit something
			--Train Tag
			local tag, speed = self:ReadTrainTag(ent)
			
			if tag and tag!=self.traintag then --Different Train Tag
				self.traintag = tag
				Dispatch.SendInfo(self:GetName(), "traintag", self.traintag, "string")
				Dispatch.SendInfo(self:GetName(), "trainspeed", speed)
				self.nextspeedtime = CurTime() + 5
			elseif tag and self.nextspeedtime and (CurTime() > self.nextspeedtime) then --Same train tag, re-measure speed
				Dispatch.SendInfo(self:GetName(), "trainspeed", speed)
				self.nextspeedtime = CurTime() + 5
			elseif not tag and self.traintag then --No train tag!
				self.traintag = nil
				self.nextspeedtime = nil
				Dispatch.SendInfo(self:GetName(), "traintag", nil, "nil")
				Dispatch.SendInfo(self:GetName(), "trainspeed", nil, "nil")
			end
			
		end
		
	end
	
	
	function ENT:ReadTrainTag(ent) --Return Tag and Speed if applicable
		if not Dispatch.RecordTrainTags then return nil, nil end
		if not Dispatch.RecordTrainTags[self:GetName()] then return nil, nil end -- Trakpak3.Dispatch.RecordTrainTags is set in dispatch.lua, for all blocks on the dispatch board.
		local tag
		local speed
		if ent and ent:IsValid() then
			tag = ent.Trakpak3_TrainTag
			if tag then
				local phys = ent:GetPhysicsObject()
				speed = math.floor(phys:GetVelocity():Length())
			end
		end
		--print(tag, speed)
		return tag, speed
	end
	
	function ENT:InitialBroadcast() --Fired Externally by startup script (signalsetup)
		hook.Run("TP3_BlockUpdate",self:GetName(),self.occupied,true)
	end
	
	--Create the convex physics mesh based on node data
	function ENT:BecomeTrigger()
		if Trakpak3.NodeList and self.nodes and self.skips then
			local convexes = {}
		
			local startingpos = self:GetPos() --Position of the entity
			
			for id = 1, #self.nodes - 1 do --For each node except the last:
				if not self.skips[id] then --Node is not marked as a skip
					--Get node IDs
					local node1 = self.nodes[id]
					local node2 = self.nodes[id+1]
					
					--Get node positions
					local pos1 = Trakpak3.NodeList[node1]
					local pos2 = Trakpak3.NodeList[node2]
					
					if pos1 and pos2 then
						--Get the positions local to the signal block ent
						local pos1r = pos1-startingpos
						local pos2r = pos2-startingpos
						
						local disp = pos2r-pos1r --Defined as the Forward Axis, non normalized
						local dispflat = Vector(disp.x, disp.y, 0) --Flattened
						local left = dispflat:GetNormalized()
						left:Rotate(Angle(0,90,0))
						local up = Vector(0,0,1)
						
						--Near Face
						local BL = pos1r + (self.hull_lw/2)*left + (self.hull_offset)*up
						local BR = pos1r + (-self.hull_lw/2)*left + (self.hull_offset)*up
						local TL = pos1r + (self.hull_lw/2)*left + (self.hull_offset + self.hull_h)*up
						local TR = pos1r + (-self.hull_lw/2)*left + (self.hull_offset + self.hull_h)*up
						
						--Far Face
						local FBL = BL + disp
						local FBR = BR + disp
						local FTL = TL + disp
						local FTR = TR + disp
						
						--Add the points that form the convex.
						table.insert(convexes,{BL, BR, TL, TR, FBL, FBR, FTL, FTR})
					end
				end
			end
			
			if next(convexes) then --We have convexes!
				
				local res = self:PhysicsInitMultiConvex(convexes)
				self:SetSolid(SOLID_VPHYSICS)
				self:EnableCustomCollisions(true)
				self:SetNotSolid(true)
				self:SetTrigger(true)
				local mins, maxs = self:WorldSpaceAABB()
				self:SetCollisionBoundsWS(mins, maxs)
			end
			
		end
	end
	
	--Funny debug function haha oh god I'm so glad I figured the trigger thing out
	--[[
	function ENT:Kaboom(pos)
		local barrel = ents.Create("prop_physics")
		barrel:SetModel("models/props_c17/oildrum001_explosive.mdl")
		barrel:SetPos(pos or self:GetPos())
		barrel:Spawn()
		barrel:Fire("break",1,0)
	end
	]]--
	
	--Trigger Functions
	function ENT:StartTouch(ent)
		--print("Start Trigger: ",ent)
		if ent and ent:IsValid() and not Trakpak3.IsBlacklisted(ent) and ent:IsSolid() then
			if table.IsEmpty(self.TriggerEnts) then --Nothing is in there... StartTouchAll!
				self.softoccupied = true
			end
			self.TriggerEnts[ent] = true
		end
	end
	
	function ENT:EndTouch(ent)
		--print("End Trigger: ",ent)
		if ent and ent:IsValid() then
			self.TriggerEnts[ent] = nil
		end
		
		if table.IsEmpty(self.TriggerEnts) then --Nothing is triggering it... EndTouchAll
			self.softoccupied = false
			if self.occupied and self.run then --Clear the state if occupied and not being forced
				self:HandleNewState(false, true)
			end
		end
	end
	
	function ENT:Think()
		
		
		--Hull Trace detection for "Hard" Occupancy. Only runs when the block trigger is active.
		if self.run and self.softoccupied and Trakpak3.NodeList and self.nodes and self.skips and self.scanid then
			--Perform a hull trace between two nodes
			
			if not self.skips[self.scanid] then  --OK to scan
				--Get node IDs
				local node1 = self.nodes[self.scanid]
				local node2 = self.nodes[self.scanid+1]
				
				--Get node positions
				local pos1 = Trakpak3.NodeList[node1]
				local pos2 = Trakpak3.NodeList[node2]
				
				if pos1 and pos2 then
				
					local ht = {
						start = pos1 + Vector(0,0,self.hull_h/2 + self.hull_offset),
						endpos = pos2 + Vector(0,0,self.hull_h/2 + self.hull_offset),
						mins = Vector(-self.hull_lw/2, -self.hull_lw/2, -self.hull_h/2),
						maxs = Vector(self.hull_lw/2, self.hull_lw/2, self.hull_h/2),
						filter = Trakpak3.TraceFilter,
						ignoreworld = true
					}
					local tr = util.TraceHull(ht)
					if tr.Hit then --Trace hit something, block is occupied
						self.scanid = 0 --will be reset to 1 at the end
						self.hitsomething = true
						self:HandleNewState(true, true, Trakpak3.GetRoot(tr.Entity))
						self.HitEntity = tr.Entity
					end
				else
					self.run = false
					print("[Trakpak3] Signal Block "..self:GetName()..", Invalid positions:")
					print("Node 1: ",node1, pos1)
					print("Node 2: ",node2, pos2)
				end
			end
			
			self.scanid = self.scanid + 1
			if self.scanid >= self.nodecount then --End of node list, check and start over
				if not self.hitsomething then self:HandleNewState(false, true) end
				self.scanid = 1
				self.hitsomething = false
				self.HitEntity = nil
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
			self.run = true
			self.scanid = 1
		elseif iname=="TestOccupancy" then
			if self.occupied then
				self:TriggerOutput("OnTestedOccupied",self)
			else
				self:TriggerOutput("OnTestedClear",self)
			end
		end
	end
end