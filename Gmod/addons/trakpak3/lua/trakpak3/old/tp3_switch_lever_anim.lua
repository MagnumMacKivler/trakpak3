AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_prop" )
ENT.PrintName = "Trakpak3 Switch Lever (Animated)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Control Switches"
ENT.Instructions = "Place in Hammer"
ENT.AutomaticFrameAdvance = true
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

	function ENT:Initialize()
		
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		
		--Initialize Variables
		if self.switch then self.switchent = FindByTargetname(self.switch) end
		if self.switchent and IsValid(self.switchent) then self.valid = true end
		
		self:SetSkin(tonumber(self.skin) or 0)
		self:SetBodygroup(1,tonumber(self.bg_target) or 0)
		self:SetBodygroup(2,tonumber(self.bg_lever) or 0)
		
		self.delay = tonumber(self.delay) or 1
		
		self.seq_idle_close = self:LookupSequence(self.seq_idle_close)
		self.seq_idle_open = self:LookupSequence(self.seq_idle_open)
		self.seq_throw_open, self.dur_throw_open = self:LookupSequence(self.seq_throw_open)
		self.seq_throw_close, self.dur_throw_close = self:LookupSequence(self.seq_throw_close)
		
		if self.seq_idle_close == -1 then print("Switch Lever "..self:EntIndex().." ("..self.model..") Invalid Sequence (Idle Closed)") end
		if self.seq_idle_open == -1 then print("Switch Lever "..self:EntIndex().." ("..self.model..") Invalid Sequence (Idle Open)") end
		if self.seq_throw_open == -1 then print("Switch Lever "..self:EntIndex().." ("..self.model..") Invalid Sequence (Throw Open)") end
		if self.seq_throw_close == -1 then print("Switch Lever "..self:EntIndex().." ("..self.model..") Invalid Sequence (Throw Closed)") end
		
		print(self.seq_idle_close, self.seq_idle_open, self.seq_throw_open, self.seq_throw_close)
		print(self.dur_throw_open, self.dur_throw_close)
		
		self:SetUseType(SIMPLE_USE) --Set use type to ping once when the player presses E on it
		
		self.leverstate = false
		self.canchange = true
		
		if self.seq_idle_close then timer.Simple(1,function() self:ResetSequence(self.seq_idle_close) end) end
	end

	function ENT:Actuate(state)
		if self.leverstate != state then
			self.leverstate = state
			self.canchange = false
			if state then
				self:ResetSequence(self.seq_throw_open)
				timer.Simple(self.dur_throw_open,function()
					self:ResetSequence(self.seq_idle_open)
					self.canchange = true
				end)
			else
				self:ResetSequence(self.seq_throw_close)
				timer.Simple(self.dur_throw_close,function()
					self:ResetSequence(self.seq_idle_close)
					self.canchange = true
				end)
			end
		end
	end

	function ENT:Use()

		if self.valid and self.canchange then --Force the switch to toggle
			local newstate = not self.switchent.switchstate
			self:Actuate(newstate)
			timer.Simple(self.delay, function() self.switchent:Switch(newstate) end)
		end
	end
	
	function ENT:Think() --Necessary to get animations to play smoothly?
		self:NextThink(CurTime())
		return true
	end
	
	--Store all switch levers for future use
	hook.Add("InitPostEntity","tp3_switch_lever_getall", function()
		if TP3_ALL_LEVERS then return end
		local levers = ents.FindByClass("tp3_switch_lever_*")
		if not table.IsEmpty(levers) then
			TP3_ALL_LEVERS = levers
			--Set up hook for activating on switch updates
			hook.Add("TP3_SwitchUpdate","tp3_switch_lever",function(switchname, state)
				if TP3_ALL_LEVERS and switchname and switchname != "" then
					for _, lever in pairs(TP3_ALL_LEVERS) do
						local myswitch = lever.switch
						if myswitch and myswitch==switchname then
							lever:Actuate(state)
						end
					end
				end
			end)
		end
	end)
	
end

