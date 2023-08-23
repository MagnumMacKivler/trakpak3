
--See lua/trakpak3/cl_signalsprites.lua for formatting help.

local Sprites = Trakpak3.SignalSprites

--US Gates

local XING_POST_LIGHTS_US = "models/trakpak3_us/signals/xing/post_lights.mdl"

Sprites[XING_POST_LIGHTS_US] = {
	GetAspect = function(bodygroups, skin, cycle)
		if (skin==3) or (skin==4) or (skin==5) then
			return "on"
		else
			return nil
		end
	end,
	
	on = {
		sprite1 = {
			pos = Vector(18,-15,96),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,96),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,96),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,96),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		}
	},
}

Sprites["models/trakpak3_us/signals/xing/post_gated_rh.mdl"] = Sprites[XING_POST_LIGHTS_US]
Sprites["models/trakpak3_us/signals/xing/post_gated_lh.mdl"] = Sprites[XING_POST_LIGHTS_US]

Sprites["models/trakpak3_us/signals/xing/cantilever_rh.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if (skin==3) or (skin==4) or (skin==5) then
			return "on"
		else
			return nil
		end
	end,
	
	on = {
		sprite1 = {
			pos = Vector(18,-15,96),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,96),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,96),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,96),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		},
		
		sprite1h = {
			pos = Vector(18,-271,177),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2h = {
			pos = Vector(18,-241,177),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3h = {
			pos = Vector(-18,-241,177),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4h = {
			pos = Vector(-18,-271,177),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		}
	},
}
Sprites["models/trakpak3_us/signals/xing/cantilever_lh.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if (skin==3) or (skin==4) or (skin==5) then
			return "on"
		else
			return nil
		end
	end,
	
	on = {
		sprite1 = {
			pos = Vector(18,-15,96),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,96),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,96),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,96),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		},
		
		sprite1h = {
			pos = Vector(18,271,177),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2h = {
			pos = Vector(18,241,177),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3h = {
			pos = Vector(-18,241,177),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4h = {
			pos = Vector(-18,271,177),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		}
	},
}

--Canadian Gates

local XING_POST_LIGHTS_CA = "models/trakpak3_ca/signals/xing/post_lights.mdl"

Sprites[XING_POST_LIGHTS_CA] = {
	GetAspect = function(bodygroups, skin, cycle)
		if (skin==3) or (skin==4) or (skin==5) then
			return "on"
		else
			return nil
		end
	end,
	
	on = {
		sprite1 = {
			pos = Vector(18,-15,108),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,108),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,108),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,108),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		}
	},
}

Sprites["models/trakpak3_ca/signals/xing/post_gated_rh.mdl"] = Sprites[XING_POST_LIGHTS_CA]
Sprites["models/trakpak3_ca/signals/xing/post_gated_lh.mdl"] = Sprites[XING_POST_LIGHTS_CA]

Sprites["models/trakpak3_ca/signals/xing/cantilever_rh.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if (skin==3) or (skin==4) or (skin==5) then
			return "on"
		else
			return nil
		end
	end,
	
	on = {
		sprite1 = {
			pos = Vector(18,-15,108),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,108),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,108),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,108),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		},
		
		sprite1h = {
			pos = Vector(18,-271,177),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2h = {
			pos = Vector(18,-241,177),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3h = {
			pos = Vector(-18,-241,177),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4h = {
			pos = Vector(-18,-271,177),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		}
	},
}

Sprites["models/trakpak3_ca/signals/xing/cantilever_lh.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if (skin==3) or (skin==4) or (skin==5) then
			return "on"
		else
			return nil
		end
	end,
	
	on = {
		sprite1 = {
			pos = Vector(18,-15,108),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,108),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,108),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,108),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		},
		
		sprite1h = {
			pos = Vector(18,271,177),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2h = {
			pos = Vector(18,241,177),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3h = {
			pos = Vector(-18,241,177),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4h = {
			pos = Vector(-18,271,177),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		}
	},
}

--Griswold Signals
Sprites["models/trakpak3_us/signals/xing/griswold.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if (skin==3) or (skin==4) or (skin==5) then
			return "on"
		else
			return nil
		end
	end,
	
	on = {
		sprite1 = {
			pos = Vector(12,-15,72),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2 = {
			pos = Vector(12,15,72),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3 = {
			pos = Vector(-12,15,72),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-12,-15,72),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		}
	},
}

Sprites["models/trakpak3_ca/signals/xing/griswold.mdl"] = Sprites["models/trakpak3_us/signals/xing/griswold.mdl"]

--And last but not least, the single light cluster.
Sprites["models/trakpak3_us/signals/xing/lights.mdl"] = {
	GetAspect = function(bodygroups, skin, cycle)
		if (skin==3) or (skin==4) or (skin==5) then
			return "on"
		else
			return nil
		end
	end,
	
	on = {
		sprite1 = {
			pos = Vector(18,-15,8),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,8),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,8),
			color = Sprites.Colors.red,
			xing_a = Sprites.Materials.xh_a1,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,8),
			color = Sprites.Colors.red,
			xing_b = Sprites.Materials.xh_b1,
			backward = true,
			size = 8
		}
	},
}