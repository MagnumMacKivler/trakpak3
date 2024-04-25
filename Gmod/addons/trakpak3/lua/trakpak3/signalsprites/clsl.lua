
--See lua/trakpak3/cl_signalsprites.lua for formatting help.

local Sprites = Trakpak3.SignalSprites
local rtable = {} --Return Table, we'll be using this in the dwarf signals to return multiple aspects at once without creating a new table every frame.

local function Clear() table.Empty(rtable) end

--Color Light High Signals

Sprites["models/trakpak3_us/signals/colorlight/rygl.mdl"] = {
	
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
			pos = Vector(6,0,-15),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(6,0,-15),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(6,0,-5),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(6,0,5),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(6,0,5),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(6,0,15),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(6,0,15),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/colorlight/ryg.mdl"] = {
	
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
			pos = Vector(6,0,-10),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(6,0,-10),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	--[[
	lunar = {
		sprite1 = {
			pos = Vector(6,0,-5),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	]]--
	yellow = {
		sprite1 = {
			pos = Vector(6,0,0),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(6,0,0),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(6,0,10),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(6,0,10),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/colorlight/rx.mdl"] = {
	
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
			pos = Vector(6,0,-5),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(6,0,-5),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(6,0,5),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(6,0,5),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(6,0,5),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(6,0,5),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(6,0,5),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/colorlight/x.mdl"] = {
	
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
			pos = Vector(6,0,0),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(6,0,0),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(6,0,0),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(6,0,0),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(6,0,0),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(6,0,0),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(6,0,0),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

--Color Light Dwarf Signals

Sprites["models/trakpak3_us/signals/colorlight/dwarf_rygl.mdl"] = {
	
	GetAspect = function(bodygroups, skin, cycle)
		Clear()
		
		local lens_red = bodygroups[1]
		local lens_lun = bodygroups[2]
		local lens_yel = bodygroups[3]
		local lens_grn = bodygroups[4]
		
		if lens_red==1 then
			table.insert(rtable,"red")
		elseif lens_red==2 then
			table.insert(rtable,"fl_red")
		end
		
		if lens_lun==3 then table.insert(rtable, "lunar") end
		
		if lens_yel==4 then
			table.insert(rtable,"yellow")
		elseif lens_yel==5 then
			table.insert(rtable,"fl_yellow")
		end
		
		if lens_grn==6 then
			table.insert(rtable,"green")
		elseif lens_grn==7 then
			table.insert(rtable,"fl_green")
		end
		
		return rtable
	end,
	
	red = {
		sprite1 = {
			pos = Vector(8,0,-10),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(8,0,-10),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(8,0,0),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	
	yellow = {
		sprite1 = {
			pos = Vector(8,0,10),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(8,0,10),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	
	green = {
		sprite1 = {
			pos = Vector(8,0,20),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(8,0,20),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	},
}

Sprites["models/trakpak3_us/signals/colorlight/dwarf_ryg.mdl"] = {
	
	GetAspect = function(bodygroups, skin, cycle)
		Clear()
		
		local lens_red = bodygroups[1]
		local lens_yel = bodygroups[2]
		local lens_grn = bodygroups[3]
		
		if lens_red==1 then
			table.insert(rtable,"red")
		elseif lens_red==2 then
			table.insert(rtable,"fl_red")
		end
		
		if lens_yel==4 then
			table.insert(rtable,"yellow")
		elseif lens_yel==5 then
			table.insert(rtable,"fl_yellow")
		end
		
		if lens_grn==6 then
			table.insert(rtable,"green")
		elseif lens_grn==7 then
			table.insert(rtable,"fl_green")
		end
		
		return rtable
	end,
	
	red = {
		sprite1 = {
			pos = Vector(8,0,-10),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(8,0,-10),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	
	yellow = {
		sprite1 = {
			pos = Vector(8,0,0),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(8,0,0),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	
	green = {
		sprite1 = {
			pos = Vector(8,0,10),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(8,0,10),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	},
}

Sprites["models/trakpak3_us/signals/colorlight/dwarf_rx.mdl"] = {
	
	GetAspect = function(bodygroups, skin, cycle)
		Clear()
		
		local lens_red = bodygroups[1]
		local lens_other = bodygroups[2]
		
		if lens_red==1 then
			table.insert(rtable,"red")
		elseif lens_red==2 then
			table.insert(rtable,"fl_red")
		end
		
		if lens_other==3 then
			table.insert(rtable,"lunar")		
		elseif lens_other==4 then
			table.insert(rtable,"yellow")
		elseif lens_other==5 then
			table.insert(rtable,"fl_yellow")
		elseif lens_other==6 then
			table.insert(rtable,"green")
		elseif lens_other==7 then
			table.insert(rtable,"fl_green")
		end
		
		return rtable
	end,
	
	red = {
		sprite1 = {
			pos = Vector(8,0,-10),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(8,0,-10),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(8,0,0),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(8,0,0),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(8,0,0),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	
	green = {
		sprite1 = {
			pos = Vector(8,0,0),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(8,0,0),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	},
}

--Type G 'Tri-Light'
Sprites["models/trakpak3_us/signals/tri-light/rlyg.mdl"] = {
	
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
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	lunar = {
		sprite1 = {
			pos = Vector(2,-5.25,-7.5),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(2,5.25,-7.5),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(2,5.25,-7.5),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/tri-light/ryg.mdl"] = {
	
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
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	--[[
	lunar = {
		sprite1 = {
			pos = Vector(2,-5.25,-7.5),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	]]--
	
	yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/tri-light/rlg.mdl"] = {
	
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
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	
	lunar = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	--[[
	yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	]]--
	green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/tri-light/ryl.mdl"] = {
	
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
	
	red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	
	lunar = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	--[[
	green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	]]--
	
}

Sprites["models/trakpak3_us/signals/tri-light/rg.mdl"] = {
	
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
	
	red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	--[[
	lunar = {
		sprite1 = {
			pos = Vector(2,-5.25,-7.5),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	
	yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	]]--
	
	green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/tri-light/ry.mdl"] = {
	
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
	
	red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	--[[
	lunar = {
		sprite1 = {
			pos = Vector(2,-5.25,-7.5),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	]]--
	
	yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	--[[
	green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	]]--
	
}

Sprites["models/trakpak3_us/signals/tri-light/yg.mdl"] = {
	
	GetAspect = function(bodygroups, skin, cycle)
		--if bodygroups[1]==1 then
			--return "red"
		--elseif bodygroups[1]==2 then
			--return "fl_red"
		--elseif bodygroups[1]==3 then
			--return "lunar"
		if bodygroups[1]==4 then
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
	
	--[[
	red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	]]--
	
	--[[
	lunar = {
		sprite1 = {
			pos = Vector(2,-5.25,-7.5),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	]]--
	
	yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(2,-5.25,3),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	
	green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(2,5.25,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/tri-light/x.mdl"] = {
	
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
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	
	lunar = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	
	yellow = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(2,0,-6.25),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

--Searchlights!

Sprites["models/trakpak3_us/signals/searchlight/searchlight.mdl"] = {
	
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
			pos = Vector(10,0,0),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(10,0,0),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	
	lunar = {
		sprite1 = {
			pos = Vector(10,0,0),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	
	yellow = {
		sprite1 = {
			pos = Vector(10,0,0),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(10,0,0),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(10,0,0),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(10,0,0),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/searchlight/dwarf_searchlight_1x.mdl"] = {
	
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
			pos = Vector(8,0,3),
			color = Sprites.Colors.red,
			size = 8
		}
	},
	
	fl_red = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
	},
	
	
	lunar = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.lunar,
			size = 8
		}
	},
	
	
	yellow = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.yellow,
			size = 8
		}
	},
	
	fl_yellow = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}
	},
	
	green = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.green,
			size = 8
		}
	},
	
	fl_green = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}
	}
	
}

Sprites["models/trakpak3_us/signals/searchlight/dwarf_searchlight_2x.mdl"] = {

	GetAspect = function(bodygroups, skin, cycle)
		Clear()
		if bodygroups[1]==1 then
			table.insert(rtable,"1_red")
		elseif bodygroups[1]==2 then
			table.insert(rtable,"1_fl_red")
		elseif bodygroups[1]==3 then
			table.insert(rtable,"1_lunar")
		elseif bodygroups[1]==4 then
			table.insert(rtable,"1_yellow")
		elseif bodygroups[1]==5 then
			table.insert(rtable,"1_fl_yellow")
		elseif bodygroups[1]==6 then
			table.insert(rtable,"1_green")
		elseif bodygroups[1]==7 then
			table.insert(rtable,"1_fl_green")
		end
		
		if bodygroups[2]==1 then
			table.insert(rtable,"2_red")
		elseif bodygroups[2]==2 then
			table.insert(rtable,"2_fl_red")
		elseif bodygroups[2]==3 then
			table.insert(rtable,"2_lunar")
		elseif bodygroups[2]==4 then
			table.insert(rtable,"2_yellow")
		elseif bodygroups[2]==5 then
			table.insert(rtable,"2_fl_yellow")
		elseif bodygroups[2]==6 then
			table.insert(rtable,"2_green")
		elseif bodygroups[2]==7 then
			table.insert(rtable,"2_fl_green")
		end
		
		return rtable
	end,
	
	--Bottom Lamp
	["1_red"] = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.red,
			size = 8
		}	
	},
	
	["1_fl_red"] = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}	
	},
	
	["1_lunar"] = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.lunar,
			size = 8
		}	
	},
	
	["1_yellow"] = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.yellow,
			size = 8
		}	
	},
	
	["1_fl_yellow"] = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}	
	},
	
	["1_green"] = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.green,
			size = 8
		}	
	},
	
	["1_fl_green"] = {
		sprite1 = {
			pos = Vector(8,0,3),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}	
	},
	
	--Top Lamp
	["2_red"] = {
		sprite1 = {
			pos = Vector(8,0,16.25),
			color = Sprites.Colors.red,
			size = 8
		}	
	},
	
	["2_fl_red"] = {
		sprite1 = {
			pos = Vector(8,0,16.25),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}	
	},
	
	["2_lunar"] = {
		sprite1 = {
			pos = Vector(8,0,16.25),
			color = Sprites.Colors.lunar,
			size = 8
		}	
	},
	
	["2_yellow"] = {
		sprite1 = {
			pos = Vector(8,0,16.25),
			color = Sprites.Colors.yellow,
			size = 8
		}	
	},
	
	["2_fl_yellow"] = {
		sprite1 = {
			pos = Vector(8,0,16.25),
			color = Sprites.Colors.yellow,
			samplemat = Sprites.Materials.fl_yellow,
			size = 8
		}	
	},
	
	["2_green"] = {
		sprite1 = {
			pos = Vector(8,0,16.25),
			color = Sprites.Colors.green,
			size = 8
		}	
	},
	
	["2_fl_green"] = {
		sprite1 = {
			pos = Vector(8,0,16.25),
			color = Sprites.Colors.green,
			samplemat = Sprites.Materials.fl_green,
			size = 8
		}	
	},
}