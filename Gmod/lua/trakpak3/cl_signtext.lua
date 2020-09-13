--Used for displaying 3D2D text in the world due to tp3_sign_prop and tp3_sign_world.

Trakpak3.SignText = {}
local SignText = Trakpak3.SignText

SignText.Signs = {}
SignText.Fonts = {}

--Checks to see if a given font already exists (each parameter combo has exactly one font) and if not, creates it.
function SignText.GetFont(fontname, size, weight, italic, underline, strike, shadow)
	fontname = fontname or "Arial"
	size = size or 128
	weight = weight or 500
	
	local it = "0"
	if italic then it = "1" end
	local un = "0"
	if underline then un = "1" end
	local st = "0"
	if strike then st = "1" end
	local sh = "0"
	if shadow then sh = "1" end
	
	--Example: tp3_Arial_128_500_0_1_0_1
	local fname = "tp3_"..fontname.."_"..size.."_"..weight.."_"..it.."_"..un.."_"..st.."_"..sh
	
	if not SignText.Fonts[fname] then
		SignText.Fonts[fname] = true
		local ftable = {
			font = fontname,
			size = size,
			weight = weight,
			italic = italic,
			underline = underline,
			strikeout = strike,
			shadow = shadow
		}
		surface.CreateFont(fname, ftable)
		--print("Creating font "..fname)
		--PrintTable(ftable)
	end
	
	return fname
end

--Request sign data from server
hook.Add("InitPostEntity","Trakpak3_RequestSignData",function()
	net.Start("tp3_register_sign")
	net.SendToServer()
	--print("[Trakpak3] Requesting Sign Data...")
end)

--Net message triggered by each sign entity to register their info on client.
net.Receive("tp3_register_sign",function(mlen, ply)
	local JSON = net.ReadData(mlen)
	JSON = util.Decompress(JSON)
	local data = util.JSONToTable(JSON)
	
	--On-Delivery Processing
	
	--Font
	local font = SignText.GetFont(data.text_font, data.text_res, data.text_weight, data.text_it, data.text_un, data.text_st, data.text_sh)
	
	--Map Lighting
	
	if not data.glow then
		local textcolor = data.color
		local textcolor2 = data.color2
		
		local snorm = data.angle:Up()
		local lightvec = render.ComputeLighting(data.pos, snorm) + render.GetAmbientLightColor()
		local r1 = math.Clamp(textcolor.r * lightvec.x,0,255)
		local g1 = math.Clamp(textcolor.g * lightvec.y,0,255)
		local b1 = math.Clamp(textcolor.b * lightvec.z,0,255)
		
		data.color = Color(r1,g1,b1,textcolor.a)
		
		r1 = math.Clamp(textcolor2.r * lightvec.x,0,255)
		g1 = math.Clamp(textcolor2.g * lightvec.y,0,255)
		b1 = math.Clamp(textcolor2.b * lightvec.z,0,255)
		
		data.color2 = Color(r1,g1,b1,textcolor2.a)
	end
	
	--Multi-Line Text
	local textlines = string.Explode("[n]",data.text)
	local textpositions = {}
	local numlines = #textlines
	local unit = data.text_res*1.25
	
	if numlines == 0 then
		textpositions[1] = 0
	elseif data.v_align==TEXT_ALIGN_TOP then
		for n = 1, numlines do
			textpositions[n] = (n-1)*unit
		end
	elseif data.v_align==TEXT_ALIGN_BOTTOM then
		for n = 1, numlines do
			textpositions[n] = -(numlines-n)*unit
		end
	else
		local startheight = -(numlines-1)*unit/2
		for n = 1, numlines do
			textpositions[n] = startheight + (n-1)*unit
		end
	end
	
	SignText.Signs[data.id] = {
		pos = data.pos,
		angle = data.angle, --angle should be pre-rotated
		scale = data.scale,
		textlines = textlines,
		textpositions = textpositions,
		font = font, --font calculated above
		h_align = data.h_align,
		v_align = data.v_align,
		color = data.color,
		outline = data.outline,
		color2 = data.color2,
		outw = data.outw,
		--glow = data.glow,
		nocull = data.nocull
	}
	
	--print("[Trakpak3] Received Sign:")
	--PrintTable(data)
	
end)

hook.Add("PostDrawTranslucentRenderables","Trakpak3_RenderSigns",function()
	
	if true then
		for id, data in pairs(SignText.Signs) do
			local drawthis = false
			
			if data.nocull then --Ignore render distance
				drawthis = true
			else
				local dist2 = LocalPlayer():GetPos():DistToSqr(data.pos)
				if dist2<(4096*4096) then drawthis = true end --Only render if within draw distance
			end
			
			if drawthis then
				
				cam.Start3D2D(data.pos, data.angle, data.scale)
					for n = 1, #data.textlines do
						
						local text = data.textlines[n]
						local height = data.textpositions[n]
						if data.outline then --text should have an outline
							draw.SimpleTextOutlined(text, data.font, 0, height, data.color, data.h_align, data.v_align, data.outw, data.color2)
						else --text does not have an outline
							draw.SimpleText(text, data.font, 0, height, data.color, data.h_align, data.v_align)
						end
					end
				cam.End3D2D()
			end
		end
	end
end)