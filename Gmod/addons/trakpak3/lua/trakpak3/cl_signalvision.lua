--Signal Vision: Everything you need to know about a signal at the touch of a button.
Trakpak3.SignalVision = {}
local SignalVision = Trakpak3.SignalVision
SignalVision.speeds = {
	[0] = "STOP/DANGER",
	[1] = "RESTRICTED",
	[2] = "SLOW",
	[3] = "MEDIUM",
	[4] = "LIMITED",
	[5] = "FULL"
}
SignalVision.colortable = {
	["Red"] = Color(255,0,0),
	["Amber"] = Color(255,191,0),
	["Lemon Yellow"] = Color(255,255,0),
	["Yellow-Green"] = Color(203,255,0),
	["Green"] = Color(0,255,63),
	["Derail Blue"] = Color(0,63,255),
	["Lunar White"] = Color(223,235,255),
	["Purple"] = Color(127,63,191),
	["White"] = Color(255,255,255),
	["Black"] = Color(0,0,0)
}
--Console Commands
concommand.Add("+tp3_signal_vision",function()
	SignalVision.active = true
	SignalVision.selected = nil
	SignalVision.flashtime = nil
	SignalVision.signals = ents.FindByClass("tp3_signal_master")
end)

concommand.Add("-tp3_signal_vision",function()
	SignalVision.active = false
	SignalVision.Readout()
end)

concommand.Add("tp3_signal_vision",function()
	if SignalVision.active then
		SignalVision.active = false
		SignalVision.Readout()
	else
		SignalVision.active = true
		SignalVision.selected = nil
		SignalVision.flashtime = nil
		SignalVision.signals = ents.FindByClass("tp3_signal_master")
	end
end)

--The Heavy Lifting

--Draw a box around this signal and add text labels
function SignalVision.drawSignalBox(ent, distance, color, addtext)
	local data = ent:GetPos():ToScreen()
	local centerx = data.x
	local centery = data.y
	
	local size = math.Clamp(math.Remap(distance,256,4096,ScrW()/16,ScrW()/128), ScrW()/128, ScrW()/16)
	
	--Set Color
	if addtext then
		draw.SimpleTextOutlined(ent:GetNWString("Nickname","Signal"), "DermaDefault", centerx, centery - size/2 - 32, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,color.a))
		draw.SimpleTextOutlined("("..ent:GetNWString("Aspect","Error")..")", "DermaDefault", centerx, centery - size/2 - 16, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,color.a))
	end
	surface.SetDrawColor(color)
	
	--Draw Rectangle
	surface.DrawOutlinedRect(centerx - size/2, centery - size/2, size, size)
end

hook.Add("DrawOverlay","Trakpak3_SignalVision",function()
	
	
	
	if SignalVision.active and SignalVision.signals and not table.IsEmpty(SignalVision.signals) then --show all signals you're looking at
		SignalVision.selected = nil
		local others = {} --actually used for all signals
		local distances = {}
		local maxdot = 0
		local ep = EyePos()
		local ev = EyeVector()
		--find which signal you're looking at
		for k, signal in pairs(SignalVision.signals) do
			local disp = (signal:GetPos() - ep)
			local dist = math.max(disp:Length(),1)
			local lvec = disp:GetNormalized()
			local viewdot = ev:Dot(lvec)
			if viewdot>0.95 then
				
				if (viewdot > maxdot) then
					maxdot = viewdot
					SignalVision.selected = signal
				end
				
				table.insert(others,signal)
				table.insert(distances,math.Clamp(dist,0,16384))
			end
		end
		
		
		
		if not table.IsEmpty(others) then
			for k, v in pairs(others) do
				local color = Color(127,127,127)
				local examine = false
				if v==SignalVision.selected then
					local cname = v:GetNWString("Color","White")
					color = table.Copy(SignalVision.colortable[cname])
					examine = true
				end
				SignalVision.drawSignalBox(v, distances[k],color,examine)
			end
		end
		
	elseif SignalVision.flashtime and SignalVision.selected then --flash the selected signal
		local timeleft = SignalVision.flashtime - CurTime()
		local flash = ((math.floor(timeleft*2)%2)==0)
		local alpha = math.Remap(timeleft,0,5,0,255)
		local color = Color(255, 255, 255,alpha)
		
		if flash then
			local cname = SignalVision.selected:GetNWString("Color","White")
			color = table.Copy(SignalVision.colortable[cname])
			color.a = alpha
			
		end
		SignalVision.drawSignalBox(SignalVision.selected, SignalVision.selected:GetPos():Distance(EyePos()), color, true)
		
		if CurTime() > SignalVision.flashtime then SignalVision.flashtime = nil end
	end
end)

function SignalVision.Readout()
	local ent = SignalVision.selected
	if ent then
		LocalPlayer():EmitSound("buttons/button24.wav")
		--local nickname = ent:GetNWString("Nickname",nil)
		local aspect = ent:GetNWString("Aspect","Error")
		local speed = ent:GetNWInt("Speed",0)
		local desc = ent:GetNWString("Description","No Description")
		local c1 = Color(255,255,255)
		
		local cname = ent:GetNWString("Color","White")
		local c2 = table.Copy(SignalVision.colortable[cname])
		
		chat.AddText(c1,"\n[Trakpak3 SignalVision] Aspect: ",c2,aspect,c1,"; Speed: ",c2,SignalVision.speeds[speed])
		chat.AddText(c1,"Description: ",c2,desc)
		
		SignalVision.flashtime = CurTime()+5
	end
end

--Signal System Printout

--Request signal systems from server
hook.Add("InitPostEntity","Trakpak3_GetSignalSystems",function()
	net.Start("Trakpak3_GetSignalSystems") --Received in signalsetup.lua
	net.SendToServer()
end)

net.Receive("Trakpak3_GetSignalSystems",function(length, ply)
	--print("[Trakpak3] Signal Systems Received.")
	local data = net.ReadData(length)
	local json = util.Decompress(data)
	if json then
		Trakpak3.UsedSignalSystems = util.JSONToTable(json)
		--print(table.Count(Trakpak3.UsedSignalSystems))
	end
end)

local colortable = { --Shamelessly copy-pasted from cl_sigedit.lua
	["Red"] = Color(255,0,0),
	["Amber"] = Color(255,191,0),
	["Lemon Yellow"] = Color(255,255,0),
	["Yellow-Green"] = Color(203,255,0),
	["Green"] = Color(0,255,63),
	["Derail Blue"] = Color(0,63,255),
	["Lunar White"] = Color(223,235,255),
	["Purple"] = Color(127,63,191),
	["White"] = Color(255,255,255),
	["Black"] = Color(0,0,0)
}
local dictionary = {
	[0] = "STOP/DANGER",
	[1] = "RESTRICTED",
	[2] = "SLOW",
	[3] = "MEDIUM",
	[4] = "LIMITED",
	[5] = "FULL"
}

--Add autocompletes for all the signal systems in the map
local function AutoComplete(cmd, arg)
	if Trakpak3.UsedSignalSystems then
		local tbl = {}
		for sysname, system in pairs(Trakpak3.UsedSignalSystems) do
			table.insert(tbl, "tp3_rulebook "..sysname)
		end
		return tbl
	end
end

concommand.Add("tp3_rulebook", function(ply, cmd, args)
	if Trakpak3.UsedSignalSystems then
		local sysname = args[1]
		local system = Trakpak3.UsedSignalSystems[sysname]
		if (sysname!="") and system then
			local rules = system.rules
			local order = system.order
			
			MsgC(Color(255,255,255), "Trakpak3 Signal System '"..sysname.."':\n-------------------\n")
			for n = 1, #order do
				local name = order[n]
				local rule = rules[name]
				local clr = colortable[rule.color] or Color(255,255,255)
				MsgC(clr, "\n"..name.." ["..dictionary[rule.speed].."] : "..(rule.desc or "No Description").."\n")
				--PrintTable(rule)
			end
			
		else
			MsgC(Color(255,255,255),"List of loaded signal systems:\n")
			for sysname, _ in pairs(Trakpak3.UsedSignalSystems) do MsgC(Color(0,255,255),sysname.."\n") end
		end
	else
		MsgC(Color(255,255,255),"This map has no signal systems loaded.")
	end
end, AutoComplete, "Prints out a list of rules for the given signal system name.")