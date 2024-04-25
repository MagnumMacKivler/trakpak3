

--See lua/trakpak3/cl_signalsprites.lua for formatting help.

local Sprites = Trakpak3.SignalSprites

Sprites["models/trakpak3_us/signals/semaphore_uq/ryg.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "red"
		elseif bodygroups[1]==2 then
			return "fl_red"
		--elseif bodygroups[1]==3 then
			--return "lunar"
		elseif bodygroups[1]==4 then
			return "yellow"
		elseif bodygroups[1]==5 then
			return "fl_yellow"
		elseif bodygroups[1]==6 then
			return "green"
		elseif bodygroups[1]==7 then
			return "fl_green"
		else
			return nil
		end
	end,
	
	red = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.red,
			size = 8,
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8,
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.yellow,
			size = 8,
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8,
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.green,
			size = 8,
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8,
		}
	},
	
}

Sprites["models/trakpak3_us/signals/semaphore_uq/rlg.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "red"
		elseif bodygroups[1]==2 then
			return "fl_red"
		elseif bodygroups[1]==3 then
			return "lunar"
		--elseif bodygroups[1]==4 then
			--return "yellow"
		--elseif bodygroups[1]==5 then
			--return "fl_yellow"
		elseif bodygroups[1]==6 then
			return "green"
		elseif bodygroups[1]==7 then
			return "fl_green"
		else
			return nil
		end
	end,
	
	red = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.red,
			size = 8,
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8,
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.lunar,
			size = 8,
		}
	},

	
	green = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.green,
			size = 8,
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(8,15,-11),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8,
		}
	},
	
}