Trakpak3.SignalSprites = {}
local Sprites = Trakpak3.SignalSprites

--Precache materials
Sprites.Materials = {
	glow = Material("effects/blueflare1"),
	fl_red = Material("models/trakpak3_common/signals/generic/red_fl_b"),
	fl_yellow = Material("models/trakpak3_common/signals/generic/yel_fl_b"),
	fl_green = Material("models/trakpak3_common/signals/generic/grn_fl_b"),
	fl_white = Material("models/trakpak3_common/signals/generic/wht_fl_c"),
	xh_a1 = Material("models/trakpak3_common/signals/crossing/xlight_xh_a1"),
	xh_b1 = Material("models/trakpak3_common/signals/crossing/xlight_xh_b1"),
	fr_a1 = Material("models/trakpak3_common/signals/crossing/xlight_fr_a1"),
	fr_b1 = Material("models/trakpak3_common/signals/crossing/xlight_fr_b1"),
	hc_a1 = Material("models/trakpak3_common/signals/crossing/xlight_hc_a1"),
	hc_b1 = Material("models/trakpak3_common/signals/crossing/xlight_hc_b1"),
}

--Precache colors
Sprites.Colors = {
	red = Color(255,0,0),
	yellow = Color(255,191,0),
	green = Color(0,255,107),
	lunar = Color(223,223,255),
	fog = Color(255,255,0),
	white = Color(255,255,223),
	blue = Color(0,63,255),
	purple = Color(127,95,255)
}

--[[

For making custom signal sprite configurations, follow this general format, and place the file into lua/trakpak3/signalsprites:

local Sprites = Trakpak3.SignalSprites

Sprites[<model>] = {

	GetAspect = function(bodygroups, skin, cycle)
		if(...)
	end,
	
	<aspect1> = {
		
		<sprite1> = {
			pos = Vector(0,0,0),
			color = Sprites.Colors.red,
			size = 8
		}
		
	},
	
	<aspect2> = {
		
		<sprite1> = {
			pos = Vector(0,0,0),
			color = Sprites.Colors.red,
			samplemat = Sprites.Materials.fl_red,
			size = 8
		}
		
	}
	
}

GetAspect is a function that is used to determine what aspect/"color" the signal is showing, based on its bodygroups, skins, and animation cycle.
For most signals, aspects are colors like "red" "lunar" "fl_yellow" etc., as opposed to rules/indications like "Stop" "Restricting" "Advanced Approach" etc.
The function should return an aspect name that is a key in Sprites[<model>] or return nil if the parameters given don't align with a valid aspect.
The function can also return a table of aspects. Make sure to reuse tables in the individual files to avoid increased performance costs!
The bodygroups argument is a numeric table of bodygroups starting with 1 (skipping 0, the reference mesh). An example would be {1, 0, 2}.
The skin argument is an integer from 0 to 31.
The cycle argument is a float from 0.0 to 1.0 representing the percent progress through the model's animation. Only useful for animated signals such as semaphores.

<aspect1>, <aspect2>, etc. should be aspect names that can be returned by GetAspect.
Each aspect table can display multiple sprites. <sprite1>, <sprite2>, etc. can be any string or numeric key.
The "pos" element is the position, LOCAL TO THE SIGNAL MODEL, where the sprite should be placed.
The "color" element should point to an entry in Sprites.Colors.
The "size" element is the diameter of the signal lens. Larger lenses make larger sprites.
The "samplemat" element is for flashing signal aspects only. It should point to an entry in Sprites.Materials for the corresponding flashing light to sync the sprite with. For solid color lights, omit this element.

The "xing_a" element is similar to samplemat but for Crossing Light materials (A).
The "xing_b" element is for (B) Crossing Light materials.
If you set an element "backwards" = true, the sprite will render facing the rear of the model (instead of the front).

]]--

--Load Signal Groups
local sigfiles = file.Find("trakpak3/signalsprites/*.lua","LUA")
for k, file in pairs(sigfiles) do
	include("trakpak3/signalsprites/"..file)
end

local fadestart = 0
local fadeend = 1024
local minalpha = 0
local maxalpha = 1

local minsize = 2
local maxsize = 6
local mindist = 0
local maxdist = 2048

--Globals to Locals
local isstring = isstring 
local istable = istable
local EyePos = EyePos
local atable = {} --a table we will be reusing to feed into the following function:

--Function to draw a list of aspects
function RenderAspects(ent, sprite_table, aspect_list)
	for _, aspect in ipairs(aspect_list) do
		if aspect and sprite_table[aspect] then --This aspect is registered and therefore has sprites
			render.SetMaterial(Trakpak3.SignalSprites.Materials.glow)
			
			if not ent.forward then ent.forward = ent:GetForward() end
			if not ent.flexcolor then ent.flexcolor = Color(255,255,255) end --This creates a new color, once per entity, on purpose, because it is reused later.
			local disp = EyePos()-ent:GetPos()
			local dist = disp:Length() --Yeah, it's a square root. Fight me
			local fwd
			
			
			--Calculate colors and draw the sprites

			for k, sprite in pairs(sprite_table[aspect]) do
				
				--Calculate alpha based on vision dot product and distance
				
				if sprite.backward then fwd = -ent.forward else fwd = ent.forward end
				local viewdot = (disp/dist):Dot(fwd)
				local dotalpha = math.max(viewdot,0)
				
				local dist2 = math.Clamp(dist, fadestart, fadeend)
				local distalpha = minalpha + (maxalpha-minalpha)*(dist2-fadestart)/(fadeend-fadestart)
				
				local alpha = dotalpha*dotalpha*distalpha
				
				--Increase size with distance
				
				dist2 = math.Clamp(dist, mindist, maxdist)
				local sizefactor = minsize + (maxsize-minsize)*(dist2-mindist)/(maxdist-mindist)
				
				
				local draw = alpha>0
				local framealpha = 1
				
				if sprite.samplemat then
					draw = sprite.samplemat:GetInt("$frame")==1
					--print(draw)
				elseif sprite.xing_a then
					local frame = sprite.xing_a:GetInt("$frame")
					if (frame==7) or (frame==13) then
						framealpha = 0.5
					elseif (frame>=0) and (frame<=6) then
						framealpha = 0
					end
				elseif sprite.xing_b then
					local frame = sprite.xing_b:GetInt("$frame")
					if (frame==0) or (frame==6) then
						framealpha = 0.5
					elseif (frame>=7) and (frame<=13) then
						framealpha = 0
					end
				end
				
				if draw then
					local r, g, b = sprite.color:Unpack()
					ent.flexcolor:SetUnpacked(r*alpha*framealpha, g*alpha*framealpha, b*alpha*framealpha, 255)
					render.DrawSprite(ent:LocalToWorld(sprite.pos), sprite.size*sizefactor, sprite.size*sizefactor, ent.flexcolor)
				end
			end
			
		end
	end
end

--Sprite Render Function
function Sprites.DrawSpriteSignal(ent, flags) --self
	ent:DrawModel(flags)
	local sprite_table = Trakpak3.SignalSprites[ent:GetModel()]
	
	local cvar = GetConVar("tp3_signalsprites")
	
	if cvar and cvar:GetBool() and sprite_table then --Sprites exist for this model!
		
		local aspects_var = sprite_table.GetAspect(Trakpak3.GetBodygroups(ent), ent:GetSkin(), ent:GetCycle(), ent:GetSequenceName(ent:GetSequence())) --Get the aspect or list of aspects the signal model is showing. Aspect here means literally what color/position the signal is showing, not which rule.
		
		--aspects_var is either a single string or a table of strings.
		if isstring(aspects_var) then
			atable[1] = aspects_var
			RenderAspects(ent, sprite_table, atable)
		elseif istable(aspects_var) then --It's a table
			RenderAspects(ent, sprite_table, aspects_var)
		end
		
	end
end

--Convar
CreateClientConVar("tp3_signalsprites","1",true,false,"Enable to make Trakpak3 signals show glow effect sprites for greater visibility at a distance.",0,1)