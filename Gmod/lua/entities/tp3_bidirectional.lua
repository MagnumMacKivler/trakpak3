AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Bidirectional Track Handler"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Prevents Cornfield Meets"
ENT.Instructions = "Place in Hammer"

if SERVER then
	
	ENT.KeyValueMap = {
		enabled = "boolean",
		["block_*"] = "entity",
		
		OnBottomOccupied = "output",
		OnTopOccupied = "output",
		OnMiddleOccupied = "output",
		OnChainClear = "output"
	}
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
		self.blockstates = {}
		self.numblocks = 0
		self.blockmap = {} --maps block targetname to number
		self.blocks = {} --maps number to block targetname
		--print("Bidirectional:")
		for n = 1, table.Count(self.pkvs) do
			self.numblocks = n
			local block = self.pkvs["block_"..n]
			self.blockmap[block] = n
			self.blocks[n] = block
			--print(n, block)
		end
	end
	
	--The meat of this entity
	function ENT:HandleNewBlockState(block, state)
		local index = self.blockmap[block]
		
		self.blockstates[block] = state
		--print(block, state)
		if self.enabled then
			if state and not self.triggered then --Something entering track for the first time
				self.triggered = true
				if index==1 then --Bottom
					self:TriggerOutput("OnBottomOccupied",self)
					--print("Bottom Occupied!")
				elseif index==self.numblocks then --Top
					self:TriggerOutput("OnTopOccupied",self)
					--print("Top Occupied!")
				else --Middle
					self:TriggerOutput("OnMiddleOccupied",self)
					--print("Middle Occupied!")
				end
			elseif not state and self.triggered then --Something left the track
				
				--Check if entire track is clear
				local allgood = true
				for _, occ in pairs(self.blockstates) do
					if occ then
						allgood = false
						break
					end
				end
				
				if allgood then
					self.triggered = false
					self:TriggerOutput("OnChainClear",self)
					--print("Clear!")
				end
			end
		end
	end
	
	hook.Add("TP3_BlockUpdate","Trakpak3_UpdateBidirs",function(block, state)
		--print(block, state)
		for _, bidir in pairs(ents.FindByClass("tp3_bidirectional")) do --For every bidir,

			if bidir.blockmap and bidir.blockmap[block] then --If this block belongs to this bidir, update it.
				bidir:HandleNewBlockState(block, state)
				--print("Updated with "..block,state)
			end 
		end
		
	end)
	
	--Input Handler
	function ENT:AcceptInput(iname, activator, caller, data)
		if iname=="Enable" then
			self.enabled = true
		elseif iname=="Disable" then
			self.enabled = false
		end
	end
	
end