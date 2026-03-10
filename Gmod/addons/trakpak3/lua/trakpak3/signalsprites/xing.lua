
--See lua/trakpak3/cl_signalsprites.lua for formatting help.

local Sprites = Trakpak3.SignalSprites

--US Gates

local XING_POST_LIGHTS_US = "models/trakpak3_us/signals/xing/post_lights.mdl"
--Functions to retrieve the correct material based on model skin. These are necessary because source actually doesn't run material proxies on materials that aren't being rendered.
local get_a = function(ent)
	if not (ent and ent:IsValid()) then return end
	
	local skin = ent:GetSkin()
	if skin==3 then
		return Sprites.Materials.xh_a1 
	elseif skin==4 then
		return Sprites.Materials.fr_a1
	elseif skin==5 then
		return Sprites.Materials.hc_a1
	else
		return
	end
end

local get_b = function(ent)
	if not (ent and ent:IsValid()) then return end
	
	local skin = ent:GetSkin()
	if skin==3 then
		return Sprites.Materials.xh_b1 
	elseif skin==4 then
		return Sprites.Materials.fr_b1
	elseif skin==5 then
		return Sprites.Materials.hc_b1
	else
		return
	end
end

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
			xing_a = get_a,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,96),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,96),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,96),
			color = Sprites.Colors.red,
			xing_b = get_b,
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
			xing_a = get_a,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,96),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,96),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,96),
			color = Sprites.Colors.red,
			xing_b = get_b,
			backward = true,
			size = 8
		},
		
		sprite1h = {
			pos = Vector(18,-271,177),
			color = Sprites.Colors.red,
			xing_a = get_a,
			size = 8
		},
		sprite2h = {
			pos = Vector(18,-241,177),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3h = {
			pos = Vector(-18,-241,177),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4h = {
			pos = Vector(-18,-271,177),
			color = Sprites.Colors.red,
			xing_b = get_b,
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
			xing_a = get_a,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,96),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,96),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,96),
			color = Sprites.Colors.red,
			xing_b = get_b,
			backward = true,
			size = 8
		},
		
		sprite1h = {
			pos = Vector(18,271,177),
			color = Sprites.Colors.red,
			xing_a = get_a,
			size = 8
		},
		sprite2h = {
			pos = Vector(18,241,177),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3h = {
			pos = Vector(-18,241,177),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4h = {
			pos = Vector(-18,271,177),
			color = Sprites.Colors.red,
			xing_b = get_b,
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
			xing_a = get_a,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,108),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,108),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,108),
			color = Sprites.Colors.red,
			xing_b = get_b,
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
			xing_a = get_a,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,108),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,108),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,108),
			color = Sprites.Colors.red,
			xing_b = get_b,
			backward = true,
			size = 8
		},
		
		sprite1h = {
			pos = Vector(18,-271,177),
			color = Sprites.Colors.red,
			xing_a = get_a,
			size = 8
		},
		sprite2h = {
			pos = Vector(18,-241,177),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3h = {
			pos = Vector(-18,-241,177),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4h = {
			pos = Vector(-18,-271,177),
			color = Sprites.Colors.red,
			xing_b = get_b,
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
			xing_a = get_a,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,108),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,108),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,108),
			color = Sprites.Colors.red,
			xing_b = get_b,
			backward = true,
			size = 8
		},
		
		sprite1h = {
			pos = Vector(18,271,177),
			color = Sprites.Colors.red,
			xing_a = get_a,
			size = 8
		},
		sprite2h = {
			pos = Vector(18,241,177),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3h = {
			pos = Vector(-18,241,177),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4h = {
			pos = Vector(-18,271,177),
			color = Sprites.Colors.red,
			xing_b = get_b,
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
			xing_a = get_a,
			size = 8
		},
		sprite2 = {
			pos = Vector(12,15,72),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3 = {
			pos = Vector(-12,15,72),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-12,-15,72),
			color = Sprites.Colors.red,
			xing_b = get_b,
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
			xing_a = get_a,
			size = 8
		},
		sprite2 = {
			pos = Vector(18,15,8),
			color = Sprites.Colors.red,
			xing_b = get_b,
			size = 8
		},
		sprite3 = {
			pos = Vector(-18,15,8),
			color = Sprites.Colors.red,
			xing_a = get_a,
			backward = true,
			size = 8
		},
		sprite4 = {
			pos = Vector(-18,-15,8),
			color = Sprites.Colors.red,
			xing_b = get_b,
			backward = true,
			size = 8
		}
	},
}