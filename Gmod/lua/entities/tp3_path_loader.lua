AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Path Loader"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Modifies Signals"
ENT.Instructions = "Place in Hammer"

--Remember, this monitors switch STANDS, not switches themselves! Any in-code reference to switches actually refers to stands!

if SERVER then
	ENT.KeyValueMap = {
		target = "entity",
		block = "entity",
		nextsignal = "entity",
		
		target2 = "entity",
		block2 = "entity",
		nextsignal2 = "entity",
		
		diverging = "boolean",
		speed = "number",
		
		OnPathTrue = "output",
		OnPathFalse = "output",
		
		["stand_*"] = "entity",
		["state_*"] = "boolean"
	}
	
	
	
	function ENT:Initialize()
		--Keyvalue Validation
		self:RegisterEntity("target",self.target)
		self:RegisterEntity("target2",self.target2)
		self:ValidateNumerics()
		
		self:ProcessLogic()
		local condition = self:EvaluateLogic()
		if condition and not self.currentstate then
			self.currentstate = true
			self:TriggerOutput("OnPathTrue",self)
		elseif not condition and self.currentstate then
			self.currentstate = false
			self:TriggerOutput("OnPathFalse",self)
		end
		
		if self.target_valid then
			self.pathname = self:EntIndex()
			self.target_ent:AddPath(self.pathname,self.diverging,self.speed,self.block,self.nextsignal,condition)
		end
		if self.target2_valid then
			self.pathname = self:EntIndex()
			self.target2_ent:AddPath(self.pathname,self.diverging,self.speed,self.block2,self.nextsignal2,condition)
		end
	end
	
	--Update on switch change
	hook.Add("TP3_SwitchUpdate","Trakpak3_UpdatePaths",function(switchname, switchstate, broken)
		--print(switchname, switchstate)
		for _, loader in pairs(ents.FindByClass("tp3_path_loader")) do --For every path loader,
			if loader.target_valid then --If this loader has a target,
				for k, swname in pairs(loader.switches) do --Check if this switch is referenced anywhere in this path
					if switchname==swname then
						local condition = loader:EvaluateLogic() and not broken
						if condition and not loader.currentstate then
							loader.currentstate = true
							loader:TriggerOutput("OnPathTrue",loader)
						elseif not condition and loader.currentstate then
							loader.currentstate = false
							loader:TriggerOutput("OnPathFalse",loader)
						end
						--Update
						if loader.target_valid then loader.target_ent:SetPathState(loader.pathname,condition) end
						if loader.target2_valid then loader.target2_ent:SetPathState(loader.pathname,condition) end
						break
					end
				end
			end
		end
		
	end)
	
	--Figure out switch logic stuff
	function ENT:ProcessLogic()
		self.switches = {}
		self.states = {}

		for key, value in pairs(self.pkvs) do
			if string.Left(key,5)=="stand" then
				local k = string.Right(key,1)
				self.switches[k] = self.pkvs["stand_"..k]
				self.states[k] = self.pkvs["state_"..k]
				if (self.states[k]!=true) and (self.states[k]!=false) then
					print("Switch Path "..self:GetName().." Switch without matching condition: "..key.."!")
					self.switches[k] = nil
				end
			end
		end
	end
	
	--Check whether the conditions are correct
	function ENT:EvaluateLogic()
		if table.Count(self.switches)==0 then return false end
		for k, switchname in pairs(self.switches) do
			local stand = Trakpak3.FindByTargetname(switchname)
			if stand.state != self.states[k] then
				return false
			end
		end
		
		return true
	end
	
	--Tell all the signals to update to the default path after initialization
	hook.Add("InitPostEntity","Trakpak3_Init_Paths", function()
		for _, loader in pairs(ents.FindByClass("tp3_path_loader")) do --for each loader,
			if loader.target_valid then
				local condition = loader:EvaluateLogic()
				if condition and not loader.currentstate then
					loader.currentstate = true
					loader:TriggerOutput("OnPathTrue",loader)
				elseif not condition and loader.currentstate then
					loader.currentstate = false
					loader:TriggerOutput("OnPathFalse",loader)
				end
				--Update
				if loader.target_valid then loader.target_ent:SetPathState(loader.pathname,condition) end
				if loader.target2_valid then loader.target2_ent:SetPathState(loader.pathname,condition) end
			end
		end
	end)
	
	--Hammer Input Handler
	function ENT:AcceptInput(iname, activator, caller, data)
		if iname=="SetSpeed" then
			self.speed = tonumber(data) or Trakpak3.FULL
			self.target_ent:AddPath(self.pathname,self.script,self.diverging,self.speed,self.block,self.nextsignal,self:ProcessLogic())
		end
	end
end