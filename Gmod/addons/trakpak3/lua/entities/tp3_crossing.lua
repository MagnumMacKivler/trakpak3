AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Crossing Controller"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Monitors Blocks and controls gates"
ENT.Instructions = "Place in Hammer"


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
							--subtract_a = 0,
							--subtract_b = 0
						}
					end
				end
			end
		end
	end
	
	--Give a semi-random delay to each crossing gate that asks for it.
	function ENT:RequestDelay()
		if not self.totaldelay then self.totaldelay = -0.5 end
		
		self.totaldelay = self.totaldelay + 0.5 + math.Rand(0,0.5)
		return self.totaldelay
	end
	
	function ENT:HandleNewState(trigger, skiphysteresis)
		if trigger and not self.triggered then
			self.triggered = true
			self.block_island_ent.run = true
			
			--Stop hysteresis timer
			timer.Remove("tp3_xing_"..self:EntIndex().."_hysteresis")
			
			--Broadcast to gates
			--hook.Run("TP3_CrossingUpdate",self:GetName(),true)
			self.TriggerGates = true
			
			--Hammer Output
			self:TriggerOutput("OnTrigger",self)
		elseif not trigger and self.triggered then
			self.triggered = false
			self.block_island_ent.run = false
			
			local hdelay = 5
			if skiphysteresis then hdelay = 0 end
			
			--Setup hysteresis timer; all this does is keep the gates down for a bit after the train passes over.
			timer.Create("tp3_xing_"..self:EntIndex().."_hysteresis",hdelay,1, function()
				--Broadcast to gates
				--hook.Run("TP3_CrossingUpdate",self:GetName(),false)
				self.TriggerGates = false
				
				--Hammer Output
				self:TriggerOutput("OnClear",self)
			end)
			
		end
	end
	
	function ENT:GetBlockDistance(block_ent, targetpos)
		return Trakpak3.BlockDistance(block_ent, targetpos)
	end
	
	--local SysTime = SysTime
	local max = math.max
	local min = math.min
	
	function ENT:Think()
		if self.tracks then
			local should_trigger = false
			local ETA
			
			--Island Block
			local onisland = self.block_island_valid and self.block_island_ent.occupied
			
			--A/B Blocks
			for tracknum, trackdata in pairs(self.tracks) do
				
				local occ_a = trackdata.ent_a.occupied
				local occ_b = trackdata.ent_b.occupied
				
				if self.predicting then --use predictor circuit
					--Block A
					
					local culprit = trackdata.ent_a.HitEntity
					
					if occ_a and culprit and culprit:IsValid() then
						
						if culprit != trackdata.culprit_a then --Reset data for a new entity
							trackdata.culprit_a = culprit
							trackdata.olddist_a = nil
							trackdata.ETA_a = nil
						end
						
						local boxsize = culprit:OBBMaxs()
						local subtract = max(boxsize.x, boxsize.y, boxsize.z)
						if trackdata.olddist_a then --prior distance data exists
							local newpos = culprit:GetPos()
							local dist_new = max(self:GetBlockDistance(trackdata.ent_a, newpos) - subtract, 0)
							local dvel = (trackdata.olddist_a - dist_new)*10 --positive = closer
							trackdata.olddist_a = dist_new
							if dvel>1 then --Train is moving closer
								trackdata.ETA_a = dist_new/dvel
								
								if ((dist_new<1024) or (trackdata.ETA_a < (self.arrivaltarget + self.TargetOffset))) and not trackdata.triggered_a then
									trackdata.triggered_a = true
								end
							elseif (dist_new > 1024) and not onisland then --Train out of range, not moving closer, and not blocking the island
								trackdata.triggered_a = false
								trackdata.ETA_a = nil
							end
						else --prior distance data does not exist
							trackdata.olddist_a = max(self:GetBlockDistance(trackdata.ent_a, culprit:GetPos()) - subtract, 0)
						end
					elseif not onisland and trackdata.triggered_a then --block not occupied, or there's no culprit; nothing on the island; clear trigger
						trackdata.triggered_a = false
						trackdata.olddist_a = nil
						trackdata.ETA_a = nil
						trackdata.culprit_a = nil
					end
					if trackdata.culprit_a and not occ_a then
						trackdata.culprit_a = nil
						trackdata.olddist_a = nil
					end
					
					
					--Block B
					local culprit = trackdata.ent_b.HitEntity
					
					if occ_b and culprit and culprit:IsValid() then
						
						if culprit != trackdata.culprit_b then --Reset data for a new entity
							trackdata.culprit_b = culprit
							trackdata.olddist_b = nil
							trackdata.ETA_b = nil
						end
						
						local boxsize = culprit:OBBMaxs()
						local subtract = max(boxsize.x, boxsize.y, boxsize.z)
						if trackdata.olddist_b then --prior distance data exists
							local newpos = culprit:GetPos()
							local dist_new = max(self:GetBlockDistance(trackdata.ent_b, newpos) - subtract,0)
							local dvel = (trackdata.olddist_b - dist_new)*10 --positive = closer
							trackdata.olddist_b = dist_new
							if dvel>1 then --Train is moving closer
								trackdata.ETA_b = dist_new/dvel
								
								if ((dist_new<1024) or (trackdata.ETA_b < (self.arrivaltarget + self.TargetOffset))) and not trackdata.triggered_b then
									trackdata.triggered_b = true
								end
							elseif (dist_new > 1024) and not onisland then --Train out of range, not moving closer, and not blocking the island
								trackdata.triggered_b = false
								trackdata.ETA_b = nil
							end
						else --prior distance data does not exist
							trackdata.olddist_b = max(self:GetBlockDistance(trackdata.ent_b, culprit:GetPos()) - subtract, 0)
						end
					elseif not onisland and trackdata.triggered_b then --block not occupied, or there's no culprit; nothing on the island; clear trigger
						trackdata.triggered_b = false
						trackdata.olddist_b = nil
						trackdata.ETA_b = nil
						trackdata.culprit_b = nil
					end
					if trackdata.culprit_b and not occ_b then
						trackdata.culprit_b = nil
						trackdata.olddist_b = nil
					end
					
				else --use block occupancy instead of predictor
					trackdata.triggered_a = occ_a
					trackdata.triggered_b = occ_b
				end
				
				--If either condition is met, overall trigger should be true
				if trackdata.triggered_a or trackdata.triggered_b then should_trigger = true end
				
				--ETA

				local myeta
				
				if trackdata.ETA_a and trackdata.ETA_b then
					myeta = min(trackdata.ETA_a, trackdata.ETA_b)
				elseif trackdata.ETA_a then
					myeta = trackdata.ETA_a
				elseif trackdata.ETA_b then
					myeta = trackdata.ETA_b
				end
				if (not ETA) or (ETA and myeta and myeta<ETA) then
					ETA = myeta
				end
			end
			self.ETA = min(ETA or 60,60) --grabbed by the gates for ETA wire outputs
			self:HandleNewState(should_trigger or self.force)
			
		end
		
		self:NextThink(CurTime()+0.1) --Execute 10Hz
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
	--[[
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
			
			if false and self.tracks then --Execute only if the crossing has tracks to speak of
				for tracknum, trackdata in pairs(self.tracks) do
					--if this is one of my blocks, assign/clear entities
					if blockname==trackdata.block_a then
						if occupied and ent then
							trackdata.culprit_a = ent
							local maxs = ent:OBBMaxs()
							trackdata.subtract_a = math.max(maxs.x, maxs.y, maxs.z)/2
						else trackdata.culprit_a = nil end
					elseif blockname==trackdata.block_b then
						if occupied and ent then
							trackdata.culprit_b = ent
							local maxs = ent:OBBMaxs()
							trackdata.subtract_b = math.max(maxs.x, maxs.y, maxs.z)/2
						else trackdata.culprit_b = nil end
					end
				end
			end
		end
		
	end)
	]]--
end