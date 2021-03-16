AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Dispatch Proxy"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Dispatch-Hammer Interface"
ENT.Instructions = "Place in Hammer"

if SERVER then
	
	ENT.KeyValueMap = {
		state = "number",
		maxstate = "number",
		OnFireAny = "output",
		OnFire0 = "output",
		OnFire1 = "output",
		OnFire2 = "output",
		OnFire3 = "output",
		OnFire4 = "output",
		OnFire5 = "output",
		OnFire6 = "output",
		OnFire7 = "output",
		OnFire8 = "output",
		OnFire9 = "output"
	}
	
	function ENT:Initialize()
		self:ValidateNumerics()
		
	end
	
	--Receive DS commands
	hook.Add("TP3_Dispatch_Command", "Trakpak3_DS_Proxies", function(name, cmd, val)
		for _, proxy in pairs(ents.FindByClass("tp3_dispatch_proxy")) do --For Each Proxy,
			--print(stand:GetName(), cmd, val)
			if (name==proxy:GetName()) and (cmd=="fire") then
				if val==proxy.state then
					local st = tostring(proxy.state)
					proxy:TriggerOutput("OnFireAny",proxy,st)
					proxy:TriggerOutput("OnFire"..st,proxy)
					--print(self, "Firing: "..st)
				end
			end
		end
	end)
	
	--Input Handler
	function ENT:AcceptInput(iname, activator, caller, data)
		if iname=="SetState" then
			if data then
				local n = tonumber(data) or 0
				self.state = math.Clamp(math.floor(n),0,self.maxstate)
			end
			Trakpak3.Dispatch.SendInfo(self:GetName(),"setstate",self.state)
			--print("Set State: "..self.state)
		elseif iname=="AddState" then
			local increment = 1
			if data then increment = tonumber(data) or 0 end
			local newstate = (self.state + increment) % (self.maxstate+1)
			Trakpak3.Dispatch.SendInfo(self:GetName(),"setstate",self.state)
		elseif iname=="SubtractState" then
			local increment = 1
			if data then increment = tonumber(data) or 0 end
			local newstate = (self.state - increment) % (self.maxstate+1)
			Trakpak3.Dispatch.SendInfo(self:GetName(),"setstate",self.state)
		end
	end
	
end