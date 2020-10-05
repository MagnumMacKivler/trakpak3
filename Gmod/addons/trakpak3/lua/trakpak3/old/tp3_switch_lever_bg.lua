AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_prop" )
ENT.PrintName = "Trakpak3 Switch Lever (Bodygroup)"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Control Switches"
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

	function ENT:Initialize()
		
		self:SetModel(self.model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		
		--Initialize Variables
		if self.switch then self.switchent = FindByTargetname(self.switch) end
		if self.switchent and IsValid(self.switchent) then self.valid = true end
		
		self.bg_target_close = tonumber(self.bg_target_close) or 0
		self.bg_target_open = tonumber(self.bg_target_open) or self.bg_target_close
		
		self.bg_lever_close = tonumber(self.bg_lever_close) or 0
		self.bg_lever_open = tonumber(self.bg_lever_open) or self.bg_lever_close
		
		self.skin_close = tonumber(self.skin) or 0
		self.skin_open = tonumber(self.skin_open) or self.skin_close
		
		self:SetUseType(SIMPLE_USE) --Set use type to ping once when the player presses E on it
		
		self.leverstate = false
	end

	function ENT:Actuate(state)
		if self.leverstate != state then
			self.leverstate = state
			if state then
				self:SetSkin(self.skin_open)
				self:SetBodygroup(1, self.bg_target_open)
				self:SetBodygroup(2, self.bg_lever_open)
			else
				self:SetSkin(self.skin_close)
				self:SetBodygroup(1, self.bg_target_close)
				self:SetBodygroup(2, self.bg_lever_close)
			end
		end
	end

	function ENT:Use()

		if self.valid then --Force the switch to toggle
			self.switchent:Switch(not self.switchent.switchstate)
		end
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

