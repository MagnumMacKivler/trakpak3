AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_prop" )
ENT.PrintName = "Trakpak3 Switch"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "A Switch"
ENT.Instructions = "Place in Hammer"


if SERVER then

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
	local function btn(boolean)
		if boolean then
			return 1
		else
			return 0
		end
	end

	function ENT:FindAutoPoint()
		if self.autothrow then
			if IsValid(self) then
				local att = self:LookupAttachment("autopoint_1")
				if att>0 then self.point = self:GetAttachment(att)["Pos"] else self.autothrow = false end 
			end
			if not self.point then self.autothrow = false end
		end
	end
	function ENT:Switch(state, force)
		
		if force or (self.switchstate != state) then
			self.switchstate = state
			--Change Track and Fire Hammer/Wire Outputs
			if self.switchstate then
				self:TriggerOutput("OnThrownDiverging",self)
				self:SetModel(self.model_div)
				if WireAddon then
					WireLib.TriggerOutput(self,"Main",0)
					WireLib.TriggerOutput(self,"Diverging",1)
				end
			else
				self:TriggerOutput("OnThrownMain",self)
				self:SetModel(self.model)
				if WireAddon then
					WireLib.TriggerOutput(self,"Main",1)
					WireLib.TriggerOutput(self,"Diverging",0)
				end
			end
			self:FindAutoPoint()
			self:PhysicsInitStatic(SOLID_VPHYSICS)
		
		
			--Broadcast update
			hook.Run("TP3_SwitchUpdate",self:GetName(),self.switchstate)
		end
	end
	
	function ENT:Initialize() --This is called when Source spawns the entity in
	
		--if CLIENT then return end
		
		
		--Initialize Variables
			
		self.switchstate = (self.switchstate=="1") --boolean initial state
		self.autothrow = (self.autothrow=="1")
		
		self:SetModel(self.model)
		self:FindAutoPoint()
		
		--Wire I/O
		if WireAddon then
			local names = {"ThrowMain","ThrowDiverging","ThrowToggle","Throw"}
			local types = {"NORMAL","NORMAL","NORMAL","NORMAL"}
			local descs = {}
			WireLib.CreateSpecialInputs(self, names, types, descs)
			
			local names = {"Main","Diverging"}
			local types = {"NORMAL","NORMAL"}
			WireLib.CreateSpecialOutputs(self, names, types, descs)
			
			WireLib.TriggerOutput(self,"Main",1)
			WireLib.TriggerOutput(self,"Diverging",0)
		end
		
		self:Switch(self.switchstate, true)
		
	end
	
	function ENT:Think()
		if self.autothrow then
			local tr = {start = self.point, endpos = self.point + Vector(0,0,64), ignoreworld = true, filter = player.GetAll()}
			local trace = util.TraceLine(tr)
			if trace.Hit then 
				self:Switch(not self.switchstate)
			end
			self:NextThink(CurTime()+0.25) --Delay for 1/4 second before scanning again
		end
	end
	
	function ENT:AcceptInput( inputname, activator, caller, data )
		if inputname=="ThrowToggle" then
			self:Switch(not self.switchstate)
		elseif inputname=="ThrowMain" then
			if self.switchstate then
				self:Switch(false)
			end
		elseif inputname=="ThrowDiverging" then
			if not self.switchstate then
				self:Switch(true)
			end
		end
	end

	--Wire input handler
	function ENT:TriggerInput(iname, value)
		if iname=="ThrowToggle" and value>0 then
			self:Switch(not self.switchstate)
		elseif iname=="ThrowMain" and value>0 then
			if self.switchstate then
				self:Switch(false)
			end
		elseif iname=="ThrowDiverging" and value>0 then
			if not self.switchstate then
				self:Switch(true)
			end
		elseif iname=="Throw" then
			local new = (value>0)
			if new != self.switchstate then
				self:Switch(new)
			end
		end
	end
	
end




