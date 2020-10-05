AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Crossing Controller"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Monitors Blocks and controls gates"
ENT.Instructions = "Place in Hammer"

--[[

TO DO

Integrate with node systems to get better measurements
Get Distance based on node array
Add timeouts
]]--
if SERVER then
	ENT.KeyValueMap = {
		predicting = "boolean",
		arrivaltarget = "number",
		["block_a_*"] = "entity",
		["block_b_*"] = "entity",
		block_island = "entity",
		OnTrigger = "output",
		OnClear = "output"
	}
	
	--Fired by the gates to add more margin
	function ENT:InputDelay(delay)
		if delay > self.TargetOffset then
			self.TargetOffset = delay
		end
	end
	
	ENT.TargetOffset = 0
	
	function ENT:Initialize()
		--Entity validation
		self:RegisterEntity("block_island",self.block_island)
		self:ValidateNumerics()
		
		if self.pkvs then
			self.tracks = {}
			for key, targetname in pairs(self.pkvs) do
				if string.Left(key,7)=="block_a" then
					local tracknum = string.sub(key,9)
					local bkey = "block_b_"..tracknum
					--self:RegisterEntity(key,targetname)
					--self:RegisterEntity(bkey,self.pkvs[bkey])
					
					local a_ent, a_valid = Trakpak3.FindByTargetname(targetname)
					local b_ent, b_valid = Trakpak3.FindByTargetname(self.pkvs[bkey])
					
					if a_valid and b_valid then
						self.tracks[tracknum] = {
							block_a = targetname,
							block_b = self.pkvs[bkey],
							ent_a = a_ent,
							ent_b = b_ent,
							culprit_a = nil,
							culprit_b = nil,
							olddist_a = nil,
							olddist_b = nil,
							triggered_a = false,
							triggered_b = false,
							ETA_a = nil,
							ETA_b = nil,
							subtract_a = 0,
							subtract_b = 0
						}
					end
				end
			end
		end
	end
	
	function ENT:HandleNewState(trigger, skiphysteresis)
		if trigger and not self.triggered then
			self.triggered = true
			self.block_island_ent.run = true
			
			--Stop hysteresis timer
			timer.Remove("tp3_xing_"..self:EntIndex().."_hysteresis")
			
			--Broadcast to gates
			hook.Run("TP3_CrossingUpdate",self:GetName(),true)
			
			--Hammer Output
			self:TriggerOutput("OnTrigger",self)
		elseif not trigger and self.triggered then
			self.triggered = false
			self.block_island_ent.run = false
			
			local hdelay = 5
			if skiphysteresis then hdelay = 0 end
			
			--Setup hysteresis timer
			timer.Create("tp3_xing_"..self:EntIndex().."_hysteresis",hdelay,1, function()
				--Broadcast to gates
				hook.Run("TP3_CrossingUpdate",self:GetName(),false)
				
				--Hammer Output
				self:TriggerOutput("OnClear",self)
			end)
			
			--Stop timeout timer
			timer.Remove("tp3_xing_"..self:EntIndex().."_timeout")
			
		end
	end
	
	function ENT:GetBlockDistance(block_ent, targetpos)
		local nodepositions = {}
		for seq, node in pairs(block_ent.nodes) do
			nodepositions[seq] = Trakpak3.NodeList[node]
		end

		return Trakpak3.ZZDistance(nodepositions, targetpos, 96)
	end
	
	function ENT:Think()
		if self.tracks then
			local should_trigger = false
			local ETA
			for tracknum, trackdata in pairs(self.tracks) do
				if self.predicting then --use predictor circuit
					--Block A
					if trackdata.culprit_a and trackdata.culprit_a:IsValid() then
						if trackdata.olddist_a then --prior data exists
							local newpos = trackdata.culprit_a:GetPos()
							local dist_new = self:GetBlockDistance(trackdata.ent_a, newpos) - trackdata.subtract_a
							local dvel = (trackdata.olddist_a - dist_new)*10 --positive = closer
							--print("A", math.Round(dvel))
							trackdata.olddist_a = dist_new
							if dvel>1 then --Only bother calculating arrival time if it's moving towards you at a speed greater than 1 inch per second
								trackdata.ETA_a = dist_new/dvel
								
								--print(trackdata.ETA_a)
								if ((dist_new<1024) or (trackdata.ETA_a < (self.arrivaltarget + self.TargetOffset))) and not trackdata.triggered_a then
									trackdata.triggered_a = true
									--print("A true")
								end
							elseif (dist_new > 1024) and not self.onisland then
								trackdata.triggered_a = false
								trackdata.olddist_a = nil
								trackdata.ETA_a = nil
							end
						else --prior data does not exist
							trackdata.olddist_a = self:GetBlockDistance(trackdata.ent_a, trackdata.culprit_a:GetPos()) - trackdata.subtract_a
						end
					elseif not self.onisland and trackdata.triggered_a then --block not occupied, nothing on the island; clear trigger
						trackdata.triggered_a = false
						trackdata.olddist_a = nil
						trackdata.ETA_a = nil
						--print("A false")
					end
					--Block B
					if trackdata.culprit_b and trackdata.culprit_b:IsValid() then
						if trackdata.olddist_b then --prior data exists
							local newpos = trackdata.culprit_b:GetPos()
							local dist_new = self:GetBlockDistance(trackdata.ent_b, newpos) - trackdata.subtract_b
							local dvel = (trackdata.olddist_b - dist_new)*10 --positive = closer
							--print("B", math.Round(dvel))
							trackdata.olddist_b = dist_new
							if dvel>1 then --Only bother calculating arrival time if it's moving towards you at a speed greater than 1 inch per second
								trackdata.ETA_b = dist_new/dvel
								--print(trackdata.ETA_b)
								if ((dist_new<1024) or (trackdata.ETA_b < (self.arrivaltarget + self.TargetOffset))) and not trackdata.triggered_b then
									trackdata.triggered_b = true
									--print("B true")
								end
							elseif (dist_new > 1024) and not self.onisland then
								trackdata.triggered_b = false
								trackdata.olddist_b = nil
							trackdata.ETA_b = nil
							end
						else --prior data does not exist
							trackdata.olddist_b = self:GetBlockDistance(trackdata.ent_b, trackdata.culprit_b:GetPos()) - trackdata.subtract_b
						end
					elseif not self.onisland and trackdata.triggered_b then --block not occupied, nothing on the island; clear trigger
						trackdata.triggered_b = false
						trackdata.olddist_b = nil
						trackdata.ETA_b = nil
						--print("B false")
					end
					
					
				else --use block occupancy instead of predictor
					if trackdata.culprit_a then trackdata.triggered_a = true else trackdata.triggered_a = false end
					if trackdata.culprit_b then trackdata.triggered_b = true else trackdata.triggered_b = false end
				end
				
				--If either condition is met, overall trigger should be true
				if trackdata.triggered_a or trackdata.triggered_b then should_trigger = true end
				
				--ETA

				local myeta
				
				if trackdata.ETA_a and trackdata.ETA_b then
					myeta = math.min(trackdata.ETA_a, trackdata.ETA_b)
				elseif trackdata.ETA_a then
					myeta = trackdata.ETA_a
				elseif trackdata.ETA_b then
					myeta = trackdata.ETA_b
				end
				if (not ETA) or (ETA and myeta and myeta<ETA) then
					ETA = myeta
				end
			end
			self.ETA = math.max(ETA or -1,-1)
			self:HandleNewState(should_trigger or self.force)
			
		end
		
		self:NextThink(CurTime()+0.1)
		return true
	end
	
	function ENT:AcceptInput(iname, activator, caller, data)
		if iname=="ForceTrigger" then
			self.force = true
			self:HandleNewState(true)
		elseif iname=="ForceClear" then
			self.force = false
			self:HandleNewState(false, true)
			if self.tracks then
				for tracknum, trackdata in pairs(self.tracks) do
					trackdata.triggered_a = false
					trackdata.triggered_b = false
				end
			end
		elseif iname=="RemoveForce" then
			self.force = nil
		end
	end
	
	--Receive Block Updates
	hook.Add("TP3_BlockUpdate","Trakpak3_BlockUpdateCrossings",function(blockname, occupied, force, ent)
		
		for k, self in pairs(ents.FindByClass("tp3_crossing")) do
			
			if blockname==self.block_island then
				self.onisland = occupied
				--stop the timeout timer if something is on the island
				if occupied then
					--print("Cancel Timeout!")
					--timer.Remove("tp3_xing_"..self:EntIndex().."_timeout")
				end
				--print("Island ",occupied)
			end
			
			if self.tracks then --Execute only if the crossing has tracks to speak of
				for tracknum, trackdata in pairs(self.tracks) do
					--if this is one of my blocks, assign/clear entities
					if blockname==trackdata.block_a then
						if occupied then
							trackdata.culprit_a = ent
							local maxs = ent:OBBMaxs()
							trackdata.subtract_a = math.max(maxs.x, maxs.y, maxs.z)/2
						else trackdata.culprit_a = nil end
					elseif blockname==trackdata.block_b then
						if occupied then
							trackdata.culprit_b = ent
							local maxs = ent:OBBMaxs()
							trackdata.subtract_b = math.max(maxs.x, maxs.y, maxs.z)/2
						else trackdata.culprit_b = nil end
					end
				end
			end
		end
		
	end)
end