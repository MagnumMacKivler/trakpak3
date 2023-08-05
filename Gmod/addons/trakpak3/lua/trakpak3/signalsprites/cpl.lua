
--See lua/trakpak3/cl_signalsprites.lua for formatting help.

local Sprites = Trakpak3.SignalSprites

--The base model for all CPL main heads
local CPL_HIGH_FULL = "models/trakpak3_us/signals/colorpositionlight/rlyg.mdl"

Sprites[CPL_HIGH_FULL] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "red"
		elseif bodygroups[1]==2 then
			return "fl_red"
		elseif bodygroups[1]==3 then
			return "lunar"
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
			pos = Vector(6,13,0),
			color = Sprites.Colors.red,
			size = 9
		},
		sprite2 = {
			pos = Vector(6,-13,0),
			color = Sprites.Colors.red,
			size = 9
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(6,13,0),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 9
			
		},
		sprite2 = {
			pos = Vector(6,-13,0),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 9
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(6,9.25,-9.25),
			color = Sprites.Colors.lunar,
			size = 9
		},
		sprite2 = {
			pos = Vector(6,-9.25,9.25),
			color = Sprites.Colors.lunar,
			size = 9
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(6,9.25,9.25),
			color = Sprites.Colors.yellow,
			size = 9
		},
		sprite2 = {
			pos = Vector(6,-9.25,-9.25),
			color = Sprites.Colors.yellow,
			size = 9
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(6,9.25,9.25),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 9
		},
		sprite2 = {
			pos = Vector(6,-9.25,-9.25),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 9
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(6,0,13),
			color = Sprites.Colors.green,
			size = 9
		},
		sprite2 = {
			pos = Vector(6,0,-13),
			color = Sprites.Colors.green,
			size = 9
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(6,0,13),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green, 
			size = 9
		},
		sprite2 = {
			pos = Vector(6,0,-13),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 9
		}
	}
}

Sprites["models/trakpak3_us/signals/colorpositionlight/ryg.mdl"] = {
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
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_HIGH_FULL].red,
	fl_red = Sprites[CPL_HIGH_FULL].fl_red,
	--lunar = Sprites[CPL_HIGH_FULL].lunar,
	yellow = Sprites[CPL_HIGH_FULL].yellow,
	fl_yellow = Sprites[CPL_HIGH_FULL].fl_yellow,
	green = Sprites[CPL_HIGH_FULL].green,
	fl_green = Sprites[CPL_HIGH_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositionlight/rlg.mdl"] = {
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
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_HIGH_FULL].red,
	fl_red = Sprites[CPL_HIGH_FULL].fl_red,
	lunar = Sprites[CPL_HIGH_FULL].lunar,
	--yellow = Sprites[CPL_HIGH_FULL].yellow,
	--fl_yellow = Sprites[CPL_HIGH_FULL].fl_yellow,
	green = Sprites[CPL_HIGH_FULL].green,
	fl_green = Sprites[CPL_HIGH_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositionlight/rly.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "red"
		elseif bodygroups[1]==2 then
			return "fl_red"
		elseif bodygroups[1]==3 then
			return "lunar"
		elseif bodygroups[1]==4 then
			return "yellow"
		elseif bodygroups[1]==5 then
			return "fl_yellow"
		--elseif bodygroups[1]==6 then
			--return "green"
		--elseif bodygroups[1]==7 then
			--return "fl_green"
		else
			return nil
		end
	end,
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_HIGH_FULL].red,
	fl_red = Sprites[CPL_HIGH_FULL].fl_red,
	lunar = Sprites[CPL_HIGH_FULL].lunar,
	yellow = Sprites[CPL_HIGH_FULL].yellow,
	fl_yellow = Sprites[CPL_HIGH_FULL].fl_yellow,
	--green = Sprites[CPL_HIGH_FULL].green,
	--fl_green = Sprites[CPL_HIGH_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositionlight/rg.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "red"
		elseif bodygroups[1]==2 then
			return "fl_red"
		--elseif bodygroups[1]==3 then
			--return "lunar"
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
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_HIGH_FULL].red,
	fl_red = Sprites[CPL_HIGH_FULL].fl_red,
	--lunar = Sprites[CPL_HIGH_FULL].lunar,
	--yellow = Sprites[CPL_HIGH_FULL].yellow,
	--fl_yellow = Sprites[CPL_HIGH_FULL].fl_yellow,
	green = Sprites[CPL_HIGH_FULL].green,
	fl_green = Sprites[CPL_HIGH_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositionlight/rl.mdl"] = {
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
		--elseif bodygroups[1]==6 then
			--return "green"
		--elseif bodygroups[1]==7 then
			--return "fl_green"
		else
			return nil
		end
	end,
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_HIGH_FULL].red,
	fl_red = Sprites[CPL_HIGH_FULL].fl_red,
	lunar = Sprites[CPL_HIGH_FULL].lunar,
	--yellow = Sprites[CPL_HIGH_FULL].yellow,
	--fl_yellow = Sprites[CPL_HIGH_FULL].fl_yellow,
	--green = Sprites[CPL_HIGH_FULL].green,
	--fl_green = Sprites[CPL_HIGH_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositionlight/ry.mdl"] = {
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
		--elseif bodygroups[1]==6 then
			--return "green"
		--elseif bodygroups[1]==7 then
			--return "fl_green"
		else
			return nil
		end
	end,
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_HIGH_FULL].red,
	fl_red = Sprites[CPL_HIGH_FULL].fl_red,
	--lunar = Sprites[CPL_HIGH_FULL].lunar,
	yellow = Sprites[CPL_HIGH_FULL].yellow,
	fl_yellow = Sprites[CPL_HIGH_FULL].fl_yellow,
	--green = Sprites[CPL_HIGH_FULL].green,
	--fl_green = Sprites[CPL_HIGH_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositionlight/x.mdl"] = Sprites[CPL_HIGH_FULL]

--Base Model for all CPL Dwarf Main Heads
local CPL_DWARF_FULL = "models/trakpak3_us/signals/colorpositiondwarf/rlyg.mdl"

Sprites[CPL_DWARF_FULL] = {
	GetAspect = Sprites[CPL_HIGH_FULL].GetAspect,
	
	red = {
		sprite1 = {
			pos = Vector(6,5.75,0),
			color = Sprites.Colors.red,
			size = 4
		},
		sprite2 = {
			pos = Vector(6,-5.75,0),
			color = Sprites.Colors.red,
			size = 4
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(6,5.75,0),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 4
			
		},
		sprite2 = {
			pos = Vector(6,-5.75,0),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 4
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(6,4.125,-4.125),
			color = Sprites.Colors.lunar,
			size = 4
		},
		sprite2 = {
			pos = Vector(6,-4.125,4.125),
			color = Sprites.Colors.lunar,
			size = 4
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(6,4.125,4.125),
			color = Sprites.Colors.yellow,
			size = 4
		},
		sprite2 = {
			pos = Vector(6,-4.125,-4.125),
			color = Sprites.Colors.yellow,
			size = 4
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(6,4.125,4.125),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 4
		},
		sprite2 = {
			pos = Vector(6,-4.125,-4.125),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 4
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(6,0,5.75),
			color = Sprites.Colors.green,
			size = 4
		},
		sprite2 = {
			pos = Vector(6,0,-5.75),
			color = Sprites.Colors.green,
			size = 4
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(6,0,5.75),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green, 
			size = 4
		},
		sprite2 = {
			pos = Vector(6,0,-5.75),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 4
		}
	}
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/ryg.mdl"] = {
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
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_DWARF_FULL].red,
	fl_red = Sprites[CPL_DWARF_FULL].fl_red,
	--lunar = Sprites[CPL_DWARF_FULL].lunar,
	yellow = Sprites[CPL_DWARF_FULL].yellow,
	fl_yellow = Sprites[CPL_DWARF_FULL].fl_yellow,
	green = Sprites[CPL_DWARF_FULL].green,
	fl_green = Sprites[CPL_DWARF_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/rlg.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "red"
		elseif bodygroups[1]==2 then
			return "fl_red"
		elseif bodygroups[1]==3 then
			--return "lunar"
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
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_DWARF_FULL].red,
	fl_red = Sprites[CPL_DWARF_FULL].fl_red,
	lunar = Sprites[CPL_DWARF_FULL].lunar,
	--yellow = Sprites[CPL_DWARF_FULL].yellow,
	--fl_yellow = Sprites[CPL_DWARF_FULL].fl_yellow,
	green = Sprites[CPL_DWARF_FULL].green,
	fl_green = Sprites[CPL_DWARF_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/rly.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "red"
		elseif bodygroups[1]==2 then
			return "fl_red"
		elseif bodygroups[1]==3 then
			return "lunar"
		elseif bodygroups[1]==4 then
			return "yellow"
		elseif bodygroups[1]==5 then
			return "fl_yellow"
		--elseif bodygroups[1]==6 then
			--return "green"
		--elseif bodygroups[1]==7 then
			--return "fl_green"
		else
			return nil
		end
	end,
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_DWARF_FULL].red,
	fl_red = Sprites[CPL_DWARF_FULL].fl_red,
	lunar = Sprites[CPL_DWARF_FULL].lunar,
	yellow = Sprites[CPL_DWARF_FULL].yellow,
	fl_yellow = Sprites[CPL_DWARF_FULL].fl_yellow,
	--green = Sprites[CPL_DWARF_FULL].green,
	--fl_green = Sprites[CPL_DWARF_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/rg.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "red"
		elseif bodygroups[1]==2 then
			return "fl_red"
		--elseif bodygroups[1]==3 then
			--return "lunar"
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
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_DWARF_FULL].red,
	fl_red = Sprites[CPL_DWARF_FULL].fl_red,
	--lunar = Sprites[CPL_DWARF_FULL].lunar,
	--yellow = Sprites[CPL_DWARF_FULL].yellow,
	--fl_yellow = Sprites[CPL_DWARF_FULL].fl_yellow,
	green = Sprites[CPL_DWARF_FULL].green,
	fl_green = Sprites[CPL_DWARF_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/ry.mdl"] = {
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
		--elseif bodygroups[1]==6 then
			--return "green"
		--elseif bodygroups[1]==7 then
			--return "fl_green"
		else
			return nil
		end
	end,
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_DWARF_FULL].red,
	fl_red = Sprites[CPL_DWARF_FULL].fl_red,
	--lunar = Sprites[CPL_DWARF_FULL].lunar,
	yellow = Sprites[CPL_DWARF_FULL].yellow,
	fl_yellow = Sprites[CPL_DWARF_FULL].fl_yellow,
	--green = Sprites[CPL_DWARF_FULL].green,
	--fl_green = Sprites[CPL_DWARF_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/rl.mdl"] = {
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
		--elseif bodygroups[1]==6 then
			--return "green"
		--elseif bodygroups[1]==7 then
			--return "fl_green"
		else
			return nil
		end
	end,
	
	--Steal the aspects from the full signal, unused ones commented out
	red = Sprites[CPL_DWARF_FULL].red,
	fl_red = Sprites[CPL_DWARF_FULL].fl_red,
	lunar = Sprites[CPL_DWARF_FULL].lunar,
	--yellow = Sprites[CPL_DWARF_FULL].yellow,
	--fl_yellow = Sprites[CPL_DWARF_FULL].fl_yellow,
	--green = Sprites[CPL_DWARF_FULL].green,
	--fl_green = Sprites[CPL_DWARF_FULL].fl_green,
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/x.mdl"] = Sprites[CPL_DWARF_FULL]

--Base model for CPL Dwarf Upper Orbitals
local CPL_DWARF_ORBITALS_U = "models/trakpak3_us/signals/colorpositiondwarf/upper_orbital_ooo.mdl"

Sprites[CPL_DWARF_ORBITALS_U] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "xxo"
		elseif bodygroups[1]==2 then
			return "xxf"
		elseif bodygroups[1]==3 then
			return "oxx"
		elseif bodygroups[1]==4 then
			return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	xxo = { sprite1 = {
		pos = Vector(6,11.5,14.125),
		color = Sprites.Colors.yellow,
		size = 4
	}},
	
	xxf = { sprite1 = {
		pos = Vector(6,11.5,14.125),
		color = Sprites.Colors.yellow,
		samplemat = Sprites.Materials.fl_yellow,
		size = 4
	}},
	
	oxx = { sprite1 = {
		pos = Vector(6,-11.5,14.125),
		color = Sprites.Colors.white,
		size = 4
	}},
	
	fxx = { sprite1 = {
		pos = Vector(6,-11.5,14.125),
		color = Sprites.Colors.white,
		samplemat = Sprites.Materials.fl_white,
		size = 4
	}},
	
	xox = { sprite1 = {
		pos = Vector(6,0,14.125),
		color = Sprites.Colors.white,
		size = 4
	}},
	
	xfx = { sprite1 = {
		pos = Vector(6,0,14.125),
		color = Sprites.Colors.white,
		samplemat = Sprites.Materials.fl_white,
		size = 4
	}}
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/upper_orbital_oox.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		--if bodygroups[1]==1 then
			--return "xxo"
		--elseif bodygroups[1]==2 then
			--return "xxf"
		if bodygroups[1]==3 then
			return "oxx"
		elseif bodygroups[1]==4 then
			return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	--xxo = Sprites[CPL_DWARF_ORBITALS_U].xxo,
	--xxf = Sprites[CPL_DWARF_ORBITALS_U].xxf,
	oxx = Sprites[CPL_DWARF_ORBITALS_U].oxx,
	fxx = Sprites[CPL_DWARF_ORBITALS_U].fxx,
	xox = Sprites[CPL_DWARF_ORBITALS_U].xox,
	xfx = Sprites[CPL_DWARF_ORBITALS_U].xfx
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/upper_orbital_xoo.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "xxo"
		elseif bodygroups[1]==2 then
			return "xxf"
		--elseif bodygroups[1]==3 then
			--return "oxx"
		--elseif bodygroups[1]==4 then
			--return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	xxo = Sprites[CPL_DWARF_ORBITALS_U].xxo,
	xxf = Sprites[CPL_DWARF_ORBITALS_U].xxf,
	--oxx = Sprites[CPL_DWARF_ORBITALS_U].oxx,
	--fxx = Sprites[CPL_DWARF_ORBITALS_U].fxx,
	xox = Sprites[CPL_DWARF_ORBITALS_U].xox,
	xfx = Sprites[CPL_DWARF_ORBITALS_U].xfx
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/upper_orbital_xox.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		--if bodygroups[1]==1 then
			--return "xxo"
		--elseif bodygroups[1]==2 then
			--return "xxf"
		--elseif bodygroups[1]==3 then
			--return "oxx"
		--elseif bodygroups[1]==4 then
			--return "fxx"
		if bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	--xxo = Sprites[CPL_DWARF_ORBITALS_U].xxo,
	--xxf = Sprites[CPL_DWARF_ORBITALS_U].xxf,
	--oxx = Sprites[CPL_DWARF_ORBITALS_U].oxx,
	--fxx = Sprites[CPL_DWARF_ORBITALS_U].fxx,
	xox = Sprites[CPL_DWARF_ORBITALS_U].xox,
	xfx = Sprites[CPL_DWARF_ORBITALS_U].xfx
}

--Base model for CPL Dwarf Lower Orbitals
local CPL_DWARF_ORBITALS_L = "models/trakpak3_us/signals/colorpositiondwarf/lower_orbital_ooo.mdl"

Sprites[CPL_DWARF_ORBITALS_L] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "xxo"
		elseif bodygroups[1]==2 then
			return "xxf"
		elseif bodygroups[1]==3 then
			return "oxx"
		elseif bodygroups[1]==4 then
			return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	xxo = { sprite1 = {
		pos = Vector(6,11.5,-14.125),
		color = Sprites.Colors.yellow,
		size = 4
	}},
	
	xxf = { sprite1 = {
		pos = Vector(6,11.5,-14.125),
		color = Sprites.Colors.yellow,
		samplemat = Sprites.Materials.fl_yellow,
		size = 4
	}},
	
	oxx = { sprite1 = {
		pos = Vector(6,-11.5,-14.125),
		color = Sprites.Colors.white,
		size = 4
	}},
	
	fxx = { sprite1 = {
		pos = Vector(6,-11.5,-14.125),
		color = Sprites.Colors.white,
		samplemat = Sprites.Materials.fl_white,
		size = 4
	}},
	
	xox = { sprite1 = {
		pos = Vector(6,0,-14.125),
		color = Sprites.Colors.white,
		size = 4
	}},
	
	xfx = { sprite1 = {
		pos = Vector(6,0,-14.125),
		color = Sprites.Colors.white,
		samplemat = Sprites.Materials.fl_white,
		size = 4
	}}
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/lower_orbital_oox.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		--if bodygroups[1]==1 then
			--return "xxo"
		--elseif bodygroups[1]==2 then
			--return "xxf"
		if bodygroups[1]==3 then
			return "oxx"
		elseif bodygroups[1]==4 then
			return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	--xxo = Sprites[CPL_DWARF_ORBITALS_L].xxo,
	--xxf = Sprites[CPL_DWARF_ORBITALS_L].xxf,
	oxx = Sprites[CPL_DWARF_ORBITALS_L].oxx,
	fxx = Sprites[CPL_DWARF_ORBITALS_L].fxx,
	xox = Sprites[CPL_DWARF_ORBITALS_L].xox,
	xfx = Sprites[CPL_DWARF_ORBITALS_L].xfx
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/lower_orbital_xoo.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "xxo"
		elseif bodygroups[1]==2 then
			return "xxf"
		--elseif bodygroups[1]==3 then
			--return "oxx"
		--elseif bodygroups[1]==4 then
			--return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	xxo = Sprites[CPL_DWARF_ORBITALS_L].xxo,
	xxf = Sprites[CPL_DWARF_ORBITALS_L].xxf,
	--oxx = Sprites[CPL_DWARF_ORBITALS_L].oxx,
	--fxx = Sprites[CPL_DWARF_ORBITALS_L].fxx,
	xox = Sprites[CPL_DWARF_ORBITALS_L].xox,
	xfx = Sprites[CPL_DWARF_ORBITALS_L].xfx
}

Sprites["models/trakpak3_us/signals/colorpositiondwarf/lower_orbital_xox.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		--if bodygroups[1]==1 then
			--return "xxo"
		--elseif bodygroups[1]==2 then
			--return "xxf"
		--elseif bodygroups[1]==3 then
			--return "oxx"
		--elseif bodygroups[1]==4 then
			--return "fxx"
		if bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	--xxo = Sprites[CPL_DWARF_ORBITALS_L].xxo,
	--xxf = Sprites[CPL_DWARF_ORBITALS_L].xxf,
	--oxx = Sprites[CPL_DWARF_ORBITALS_L].oxx,
	--fxx = Sprites[CPL_DWARF_ORBITALS_L].fxx,
	xox = Sprites[CPL_DWARF_ORBITALS_L].xox,
	xfx = Sprites[CPL_DWARF_ORBITALS_L].xfx
}


--Base model for all CPL High Orbitals
local CPL_HIGH_ORBITALS = "models/trakpak3_us/signals/colorpositionlight/orbital_ooo.mdl"

Sprites[CPL_HIGH_ORBITALS] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "xxo"
		elseif bodygroups[1]==2 then
			return "xxf"
		elseif bodygroups[1]==3 then
			return "oxx"
		elseif bodygroups[1]==4 then
			return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	xxo = { sprite1 = {
		pos = Vector(6,40,0),
		color = Sprites.Colors.yellow,
		size = 9
	}},
	
	xxf = { sprite1 = {
		pos = Vector(6,40,0),
		color = Sprites.Colors.yellow,
		samplemat = Sprites.Materials.fl_yellow,
		size = 9
	}},
	
	oxx = { sprite1 = {
		pos = Vector(6,-40,0),
		color = Sprites.Colors.white,
		size = 9
	}},
	
	fxx = { sprite1 = {
		pos = Vector(6,-40,0),
		color = Sprites.Colors.white,
		samplemat = Sprites.Materials.fl_white,
		size = 9
	}},
	
	xox = { sprite1 = {
		pos = Vector(6,0,0),
		color = Sprites.Colors.white,
		size = 9
	}},
	
	xfx = { sprite1 = {
		pos = Vector(6,0,0),
		color = Sprites.Colors.white,
		samplemat = Sprites.Materials.fl_white,
		size = 9
	}}
}

Sprites["models/trakpak3_us/signals/colorpositionlight/orbital_oox.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		--if bodygroups[1]==1 then
			--return "xxo"
		--elseif bodygroups[1]==2 then
			--return "xxf"
		if bodygroups[1]==3 then
			return "oxx"
		elseif bodygroups[1]==4 then
			return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	--xxo = Sprites[CPL_HIGH_ORBITALS].xxo,
	--xxf = Sprites[CPL_HIGH_ORBITALS].xxf,
	oxx = Sprites[CPL_HIGH_ORBITALS].oxx,
	fxx = Sprites[CPL_HIGH_ORBITALS].fxx,
	xox = Sprites[CPL_HIGH_ORBITALS].xox,
	xfx = Sprites[CPL_HIGH_ORBITALS].xfx
}

Sprites["models/trakpak3_us/signals/colorpositionlight/orbital_xoo.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if bodygroups[1]==1 then
			return "xxo"
		elseif bodygroups[1]==2 then
			return "xxf"
		--elseif bodygroups[1]==3 then
			--return "oxx"
		--elseif bodygroups[1]==4 then
			--return "fxx"
		elseif bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	xxo = Sprites[CPL_HIGH_ORBITALS].xxo,
	xxf = Sprites[CPL_HIGH_ORBITALS].xxf,
	--oxx = Sprites[CPL_HIGH_ORBITALS].oxx,
	--fxx = Sprites[CPL_HIGH_ORBITALS].fxx,
	xox = Sprites[CPL_HIGH_ORBITALS].xox,
	xfx = Sprites[CPL_HIGH_ORBITALS].xfx
}

Sprites["models/trakpak3_us/signals/colorpositionlight/orbital_xox.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		--if bodygroups[1]==1 then
			--return "xxo"
		--elseif bodygroups[1]==2 then
			--return "xxf"
		--elseif bodygroups[1]==3 then
			--return "oxx"
		--elseif bodygroups[1]==4 then
			--return "fxx"
		if bodygroups[1]==5 then
			return "xox"
		elseif bodygroups[1]==6 then
			return "xfx"
		else
			return nil
		end
	end,
	
	--xxo = Sprites[CPL_HIGH_ORBITALS].xxo,
	--xxf = Sprites[CPL_HIGH_ORBITALS].xxf,
	--oxx = Sprites[CPL_HIGH_ORBITALS].oxx,
	--fxx = Sprites[CPL_HIGH_ORBITALS].fxx,
	xox = Sprites[CPL_HIGH_ORBITALS].xox,
	xfx = Sprites[CPL_HIGH_ORBITALS].xfx
}