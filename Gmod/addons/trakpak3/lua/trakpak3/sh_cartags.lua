local black = Vector(0,0,0)
local white = Vector(1,1,1)
local class_whitelist = {
	["prop_physics"] = true
}

local mmax = math.max
local mmin = math.min

if SERVER then
	
	Trakpak3.CarTags = {}
	
	function Trakpak3.CarTags.Set(ent, tag, color1, color2, heightoverride) --Set Car Tag on an entity. color1 and color2 are normalized vectors!
		if ent and ent:IsValid() and class_whitelist[ent:GetClass()] then
			if tag and isstring(tag) and tag != "" then
				color1 = color1 or white --Text color
				color2 = color2 or black --Outline color
				ent:SetNWString("tp3_cartag_text", string.Left(tag,199))
				ent:SetNWVector("tp3_cartag_color1", color1)
				ent:SetNWVector("tp3_cartag_color2", color2)
				ent:SetNWFloat("tp3_cartag_heightoverride",heightoverride or 0)
				
			else
				ent:SetNWString("tp3_cartag_text", "") --This will be the 'cleared' value
			end
		end
	end
	
	function Trakpak3.CarTags.Get(ent) --Retrieve car tag info
		if ent and ent:IsValid() then
			local tag = ent:GetNWString("tp3_cartag_text", "")
			local color1
			local color2
			if tag != "" then --A tag is actually set
				color1 = ent:GetNWVector("tp3_cartag_color1", white)
				color2 = ent:GetNWVector("tp3_cartag_color2", black)
				heightoverride = ent:GetNWFloat("tp3_cartag_heightoverride",0)
				return tag, color1, color2, heightoverride
			else --No tag is set
				return
			end
		end
	end
	
	
end

if CLIENT then
	--Local versions of functions
	local ents_iterator = ents.Iterator
	local eyepos = EyePos
	local eyevec = EyeVector
	local eyeang = EyeAngles
	local cam_start3d2d = cam.Start3D2D
	local cam_end3d2d = cam.End3D2D
	local draw_roundedboxex = draw.RoundedBoxEx
	local draw_simpletext = draw.SimpleText
	local vector = Vector
	local matrix = Matrix
	local cam_pushmodelmatrix = cam.PushModelMatrix
	local cam_popmodelmatrix = cam.PopModelMatrix
	local render_pushfiltermag = render.PushFilterMag
	local render_popfiltermag = render.PopFilterMag
	local render_pushfiltermin = render.PushFilterMin
	local render_popfiltermin = render.PopFilterMin
	
	--Set Up Convars
	local tags_enabled_cvar = CreateClientConVar("tp3_car_tags", "1", true, false, "Set 1 to enable viewing Trakpak3 Car Tags, set 0 to disable.", 0, 1)
	local tags_scale_cvar = CreateClientConVar("tp3_car_tags_scale", "1", true, false, "Car tag scale factor.", 0.5, 2)
	local tags_maxdist_cvar = CreateClientConVar("tp3_car_tags_maxdist", "8192", true, false, "Maximum draw distance for car tags. They will start to fade at half this distance. Set to 0 to draw disable distance culling/fading.", 0, 32768)
	
	--Get the max rectangle size for a block of text which may contain newlines, using the Trakpak3 Dispatch fonts.
	local function processtext(text)
		local fontsize = 5
		local fontname = "tp3_dispatch_5"
		
		local linespace = (fontsize+1)
		
		local textlines = string.Explode("\n",text)
		local textheights = {}
		local maxwidth = 0
		local maxheight = 0
		
		surface.SetFont(fontname)
		
		for n=1, #textlines do
			local lw, lh = surface.GetTextSize(textlines[n])
			if lw > maxwidth then maxwidth = lw end
			
			maxheight = maxheight + lh
			if n>1 then maxheight = maxheight + linespace end
			
			textheights[n] = maxheight - lh/2
		end
		
		return textlines, textheights, fontname, fontsize, maxwidth, maxheight
	end
	
	--Draw the Tags
	hook.Add("PreDrawEffects","Trakpak3_CarTags",function() --PreDrawEffects is chosen because it is the last 3D rendering hook. This does not work if a 2D rendering hook is used.
		if Trakpak3.InitPostEntity then
			
			if tags_enabled_cvar:GetBool() then --Enabled
				
				--Calculate view angle so they always face the player
				local rang = eyeang()
				rang.r = 0
				rang:RotateAroundAxis(rang:Up(),-90)
				rang:RotateAroundAxis(rang:Forward(),90)
				
				for _, ent in ents_iterator() do --For all entities:
					if ent:IsValid() and class_whitelist[ent:GetClass()] and not ent:IsDormant() then --It matches the applicable filters
						local tag = ent:GetNWString("tp3_cartag_text", "")
						if tag != "" then --Tag is valid string
							local EP = eyepos()
							local EV = eyevec()
							local dist = ent:GetPos():Distance(EP) --Fuck it we ball
							local maxdist = tags_maxdist_cvar:GetFloat()
							if maxdist==0 or dist<maxdist then --Distance filters passed
								local disp = ent:GetPos() - EP
								if EV:Dot(disp) > 0 then --Car is in front of you, draw the tag
									local color1 = ent:GetNWVector("tp3_cartag_color1", white):ToColor()
									local color2 = ent:GetNWVector("tp3_cartag_color2", black):ToColor()
									heightoverride = ent:GetNWFloat("tp3_cartag_heightoverride",0)
									
									--Transparency Fade
									if maxdist==0 then
										color2.a = 191 --Transparency!
									else
										local dfactor = 1
										if dist > maxdist/2 then dfactor = 2*(maxdist - dist)/maxdist end
										color1.a = 255*dfactor
										color2.a = 191*dfactor
									end
									
									--Calculate offset position above car
									local carheight = ent:OBBMaxs().z - ent:OBBMins().z
									local adjustment
									if heightoverride != 0 then adjustment = heightoverride else adjustment = mmax(carheight + 16, 192) end
									local rpos = ent:LocalToWorld(vector(0,0,ent:OBBMins().z + adjustment))
									
									local textlines, textheights, fontname, fontsize, maxwidth, maxheight = processtext(tag) --Figure out text heights and such
									
									--Draw the box and text
									local scl = tags_scale_cvar:GetFloat()
									if scl > 0 then
										cam_start3d2d(rpos, rang, scl/2)
											local m = matrix()
											cam_pushmodelmatrix(m,true)
											render_pushfiltermag(TEXFILTER.ANISOTROPIC)
											render_pushfiltermin(TEXFILTER.ANISOTROPIC)
											local r = fontsize*8
											draw_roundedboxex(r, -maxwidth/2 - r/2, -maxheight - r/2, maxwidth + r, maxheight + r, color2, true, true, false, true)
											for n = 1, #textlines do
												draw_simpletext(textlines[n], fontname, 0, -maxheight + textheights[n], color1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2)
											end
											render_popfiltermag()
											render_popfiltermin()
											cam_popmodelmatrix()
										cam_end3d2d()
									end
								end
							end
						end
					end
				end
			end
			
		end
	end)
	
end