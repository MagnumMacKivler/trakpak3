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
		
		if self.nodecount==1 then
			self.run = false
			ErrorNoHalt("[Trakpak3] Error! Signal Block "..self:GetName().." has only one in the chain! Double check this block's node chain and retry.\n")
		elseif self.nodecount==0 then
			self.run = false
			print("[Trakpak3] Signal Block "..self:GetName().." Has no nodes in the chain.")
		else
			if self.blockmode==0 then self.run = true end
			print("[Trakpak3] Signal Block '"..self:GetName().."' set up successfully with "..self.nodecount.." nodes.")
		end
	end
	
	--Update occupancy state of all nodes in my block
	--util.AddNetworkString("tp3_block_hull_update")
	
	function ENT:UpdateNodeList(occupancy)
		--net.Start("tp3_block_hull_update")
		net.Start("trakpak3")
		net.WriteString("tp3_block_hull_update")
		net.WriteString(self:GetName())
		net.WriteBool(occupancy or false)
		net.Broadcast()
	end
	
	--[[
	Trakpak3.TrainTagList = {} --List of blocks and speeds associated with each train tag
	Trakpak3.NextTrainTagBroadcastTime = 0
	util.AddNetworkString("Trakpak3_UpdateTrainTags")
	--Broadcast all Tag Data
	function Trakpak3.BroadcastTrainTagData()
		Trakpak3.NextTrainTagBroadcastTime = CurTime() + 5
		net.Start("Trakpak3_UpdateTrainTags")
		net.WriteTable(Trakpak3.TrainTagList)
		net.Broadcast()
	end
	--Every 5 seconds
	hook.Add("Think","Trakpak3_TrainTagBroadcastTimer",function()
		if CurTime() > Trakpak3.NextTrainTagBroadcastTime then
			Trakpak3.BroadcastTrainTagData()
		end
	end)
	]]--
	--Handle New State
	function ENT:HandleNewState(state, natural, ent)
		if state and not self.occupied then --Block is now occupied
			self.occupied = true
			
			--Train Tag
			self.traintag, self.trainspeed = self:ReadTrainTag(ent)
			if self.traintag then
				Trakpak3.Dispatch.SendInfo(self:GetName(), "traintag", self.traintag, "string")
				Trakpak3.Dispatch.SendInfo(self:GetName(), "trainspeed", self.trainspeed)
				self.nextspeedtime = CurTime() + 5
			end
			
			--Hammer Outputs
			if natural then self:TriggerOutput("OnOccupiedNatural",self) end
			self:TriggerOutput("OnOccupied",self)
			--Block Update to Signal System
			hook.Run("TP3_BlockUpdate",self:GetName(),true, false, ent)
			Trakpak3.Dispatch.SendInfo(self:GetName(),"occupied",1)
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
			Trakpak3.Dispatch.SendInfo(self:GetName(),"occupied",0)
			--Update Wireframe
			self:UpdateNodeList(false)
		elseif state then --No state change, but you still hit something
			--Train Tag
			local tag, speed = self:ReadTrainTag(ent)
			
			if tag and tag!=self.traintag then --Different Train Tag
				self.traintag = tag
				Trakpak3.Dispatch.SendInfo(self:GetName(), "traintag", self.traintag, "string")
				Trakpak3.Dispatch.SendInfo(self:GetName(), "trainspeed", speed)
				self.nextspeedtime = CurTime() + 5
			elseif tag and self.nextspeedtime and (CurTime() > self.nextspeedtime) then --Same train tag, re-measure speed
				Trakpak3.Dispatch.SendInfo(self:GetName(), "trainspeed", speed)
				self.nextspeedtime = CurTime() + 5
			elseif not tag and self.traintag then --No train tag!
				self.traintag = nil
				self.nextspeedtime = nil
				Trakpak3.Dispatch.SendInfo(self:GetName(), "traintag", nil, "nil")
				Trakpak3.Dispatch.SendInfo(self:GetName(), "trainspeed", nil, "nil")
			end
			
		end
		
	end
	
	function ENT:ReadTrainTag(ent) --Return Tag and Speed if applicable
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
	
	--[[
	function ENT:CheckAndUpdateTag(ent)
		local newtag
		if ent and ent:IsValid() then
			newtag = ent.Trakpak3_TrainTag
		elseif not ent then --Block is empty, delete all tags that say they are in here (edge case to protect against multi-train cleanups)
			for tag, data in pairs(Trakpak3.TrainTagList) do
				if data.block==self:GetName() then
					Trakpak3.TrainTagList[tag] = nil
				end
			end
		end
		if newtag then --The hit entity is valid and has a train tag
			local phys = ent:GetPhysicsObject()
			local speed = math.floor(phys:GetVelocity():Length())
			if newtag != self.traintag then --New or Changed Tag
				
				
				if self.traintag and Trakpak3.TrainTagList[self.traintag] and (Trakpak3.TrainTagList[self.traintag].block==self:GetName()) then --The stored tag is associated with this block, so clear it
					Trakpak3.TrainTagList[self.traintag] = nil
				end
				
				
				self.traintag = newtag
				Trakpak3.TrainTagList[newtag] = {block = self:GetName(), speed = speed} --Create/Overwrite this tag, associate with this block
			elseif Trakpak3.TrainTagList[newtag] and (Trakpak3.TrainTagList[newtag].block==self:GetName()) then --Still the same tag, you are the "master" block
				Trakpak3.TrainTagList[newtag].speed = speed --Update speed only
			end
		elseif self.traintag then --The hit entity has no train tag, but you had one stored
			if Trakpak3.TrainTagList[self.traintag] and (Trakpak3.TrainTagList[self.traintag].block==self:GetName()) then --The stored tag is associated with this block, so clear it
				Trakpak3.TrainTagList[self.traintag] = nil
			end
			self.traintag = nil
		end
		
	end
	]]--
	
	function ENT:InitialBroadcast() --Fired Externally by startup script (signalsetup)
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
				
				if pos1 and pos2 then
				
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
						self.scanid = 0 --will be reset to 1 at the end
						self.hitsomething = true
						self:HandleNewState(true, true, Trakpak3.GetRoot(tr.Entity))
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