
--See lua/trakpak3/cl_signalsprites.lua for formatting help.

local Sprites = Trakpak3.SignalSprites

local GRS_MODEL5_LH = "models/trakpak3_us/switchstands/grs_model5_lh_left.mdl"
Sprites[GRS_MODEL5_LH] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[3]==2 then
			return "spi_mn"
		elseif bodygroups[3]==3 then
			return "spi_dv"
		end
	end,
	
	spi_mn = {
		sprite1 = {
			pos = Vector(-30,35,6),
			color = Sprites.Colors.green,
			size = 4,
		},
		sprite2 = {
			pos = Vector(-38,35,6),
			color = Sprites.Colors.green,
			size = 4,
			backward = true,
		}
	},
	
	spi_dv = {
		sprite1 = {
			pos = Vector(-30,29,6),
			color = Sprites.Colors.yellow,
			size = 4,
		},
		sprite2 = {
			pos = Vector(-38,29,6),
			color = Sprites.Colors.yellow,
			size = 4,
			backward = true,
		}
	},
}
Sprites["models/trakpak3_us/switchstands/grs_model5_lh_right.mdl"] = Sprites[GRS_MODEL5_LH]

local GRS_MODEL5_RH = "models/trakpak3_us/switchstands/grs_model5_rh_left.mdl"
Sprites[GRS_MODEL5_RH] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[3]==2 then
			return "spi_mn"
		elseif bodygroups[3]==3 then
			return "spi_dv"
		end
	end,
	
	spi_mn = {
		sprite1 = {
			pos = Vector(-30,-29,6),
			color = Sprites.Colors.green,
			size = 4,
		},
		sprite2 = {
			pos = Vector(-38,-29,6),
			color = Sprites.Colors.green,
			size = 4,
			backward = true,
		}
	},
	
	spi_dv = {
		sprite1 = {
			pos = Vector(-30,-35,6),
			color = Sprites.Colors.yellow,
			size = 4,
		},
		sprite2 = {
			pos = Vector(-38,-35,6),
			color = Sprites.Colors.yellow,
			size = 4,
			backward = true,
		}
	},
}
Sprites["models/trakpak3_us/switchstands/grs_model5_rh_right.mdl"] = Sprites[GRS_MODEL5_RH]

local B51A = "models/trakpak3_us/switchstands/bethlehem_51a_left.mdl"
Sprites[B51A] = {
	GetAspect = function(bodygroups, skin, cycle, sequence)
		if bodygroups[1]==5 then
			if skin==0 then --W/R
				if sequence=="idle" or sequence=="idle_close" then
					return "white"
				elseif sequence=="idle_open" then
					return "red"
				end
			elseif skin==1 then --W/Y
				if sequence=="idle" or sequence=="idle_close" then
					return "white"
				elseif sequence=="idle_open" then
					return "yellow"
				end
			elseif skin==2 then --G/R
				if sequence=="idle" or sequence=="idle_close" then
					return "green"
				elseif sequence=="idle_open" then
					return "red"
				end
			elseif skin==3 then --G/Y
				if sequence=="idle" or sequence=="idle_close" then
					return "green"
				elseif sequence=="idle_open" then
					return "yellow"
				end
			end
		end
	end,
	
	white = {
		sprite1 = {
			pos = Vector(6.5,1,15),
			color = Sprites.Colors.white,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6.5,1,15),
			color = Sprites.Colors.white,
			size = 6,
			backward = true,
		},
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(6.5,1,15),
			color = Sprites.Colors.yellow,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6.5,1,15),
			color = Sprites.Colors.yellow,
			size = 6,
			backward = true,
		},
	},
	
	red = {
		sprite1 = {
			pos = Vector(6.5,1,15),
			color = Sprites.Colors.red,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6.5,1,15),
			color = Sprites.Colors.red,
			size = 6,
			backward = true,
		},
	},
	
	green = {
		sprite1 = {
			pos = Vector(6.5,1,15),
			color = Sprites.Colors.green,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6.5,1,15),
			color = Sprites.Colors.green,
			size = 6,
			backward = true,
		},
	},
}
Sprites["models/trakpak3_us/switchstands/bethlehem_51a_right.mdl"] = Sprites[B51A]

local R112E = "models/trakpak3_us/switchstands/racor_112e_left.mdl"
Sprites[R112E] = {
	GetAspect = function(bodygroups, skin, cycle, sequence)
		if bodygroups[1]==5 then
			if skin==0 then --W/R
				if sequence=="idle" or sequence=="idle_close" then
					return "white"
				elseif sequence=="idle_open" then
					return "red"
				end
			elseif skin==1 then --W/Y
				if sequence=="idle" or sequence=="idle_close" then
					return "white"
				elseif sequence=="idle_open" then
					return "yellow"
				end
			elseif skin==2 then --G/R
				if sequence=="idle" or sequence=="idle_close" then
					return "green"
				elseif sequence=="idle_open" then
					return "red"
				end
			elseif skin==3 then --G/Y
				if sequence=="idle" or sequence=="idle_close" then
					return "green"
				elseif sequence=="idle_open" then
					return "yellow"
				end
			end
		end
	end,
	
	white = {
		sprite1 = {
			pos = Vector(6.5,1,62),
			color = Sprites.Colors.white,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6.5,1,62),
			color = Sprites.Colors.white,
			size = 6,
			backward = true,
		},
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(6.5,1,62),
			color = Sprites.Colors.yellow,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6.5,1,62),
			color = Sprites.Colors.yellow,
			size = 6,
			backward = true,
		},
	},
	
	red = {
		sprite1 = {
			pos = Vector(6.5,1,62),
			color = Sprites.Colors.red,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6.5,1,62),
			color = Sprites.Colors.red,
			size = 6,
			backward = true,
		},
	},
	
	green = {
		sprite1 = {
			pos = Vector(6.5,1,62),
			color = Sprites.Colors.green,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6.5,1,62),
			color = Sprites.Colors.green,
			size = 6,
			backward = true,
		},
	},
}
Sprites["models/trakpak3_us/switchstands/racor_112e_right.mdl"] = Sprites[R112E]

local R22 = "models/trakpak3_us/switchstands/racor_22_left.mdl"
Sprites[R22] = {
	GetAspect = function(bodygroups, skin, cycle, sequence)
		if bodygroups[1]==5 then
			if skin==0 then --W/R
				if sequence=="idle" or sequence=="idle_close" then
					return "white"
				elseif sequence=="idle_open" then
					return "red"
				end
			elseif skin==1 then --W/Y
				if sequence=="idle" or sequence=="idle_close" then
					return "white"
				elseif sequence=="idle_open" then
					return "yellow"
				end
			elseif skin==2 then --G/R
				if sequence=="idle" or sequence=="idle_close" then
					return "green"
				elseif sequence=="idle_open" then
					return "red"
				end
			elseif skin==3 then --G/Y
				if sequence=="idle" or sequence=="idle_close" then
					return "green"
				elseif sequence=="idle_open" then
					return "yellow"
				end
			end
		end
	end,
	
	white = {
		sprite1 = {
			pos = Vector(6,0,18),
			color = Sprites.Colors.white,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6,0,18),
			color = Sprites.Colors.white,
			size = 6,
			backward = true,
		},
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(6,0,18),
			color = Sprites.Colors.yellow,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6,0,18),
			color = Sprites.Colors.yellow,
			size = 6,
			backward = true,
		},
	},
	
	red = {
		sprite1 = {
			pos = Vector(6,0,18),
			color = Sprites.Colors.red,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6,0,18),
			color = Sprites.Colors.red,
			size = 6,
			backward = true,
		},
	},
	
	green = {
		sprite1 = {
			pos = Vector(6,0,18),
			color = Sprites.Colors.green,
			size = 6,
		},
		sprite2 = {
			pos = Vector(-6,0,18),
			color = Sprites.Colors.green,
			size = 6,
			backward = true,
		},
	},
}
Sprites["models/trakpak3_us/switchstands/racor_22_right.mdl"] = Sprites[R22]
Sprites["models/trakpak3_us/switchstands/racor_22e_left.mdl"] = Sprites[R22]
Sprites["models/trakpak3_us/switchstands/racor_22e_right.mdl"] = Sprites[R22]