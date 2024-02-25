--Remote Switcher
Trakpak3.RemoteSwitcher = {}
local RemoteSwitcher = Trakpak3.RemoteSwitcher

--UI Colors
RemoteSwitcher.Colors = {
	n = Color(0,255,0),
	r = Color(255,191,0),
	n_blocked = Color(0,95,0),
	r_blocked = Color(127,95,0),
	n_locked = Color(127,191,127),
	r_locked = Color(159,143,63),
	derail_on = Color(0,127,255),
	derail_off = Color(127,255,255),
	broken = Color(255,0,0),
	moving = Color(255,255,255),
	deselected = Color(127,127,127)
}

--Throw it
function RemoteSwitcher.Switch(stand)
	if stand and stand:IsValid() and stand:GetClass()=="tp3_switch_lever_anim" then
		if stand:GetNWInt("state")==2 or stand:GetNWBool("blocked") or stand:GetNWBool("locked") or stand:GetNWBool("interlocked") then
			LocalPlayer():EmitSound("buttons/button11.wav",nil,nil,0.25)
			chat.AddText(Color(255,95,63),"[Trakpak3 Remote Switcher] Could not throw switch because it is moving, locked, interlocked, or blocked.")
		else
			if stand:GetNWInt("broken") then
				LocalPlayer():EmitSound("weapons/crowbar/crowbar_impact2.wav",nil,nil,0.25)
			else
				LocalPlayer():EmitSound("buttons/button17.wav",nil,nil,0.5)
			end
			--net.Start("tp3_remoteswitcher")
			net.Start("trakpak3")
				net.WriteString("tp3_remoteswitcher")
				net.WriteEntity(stand)
			net.SendToServer()
			
		end
	end
end

--Enable/Disable Functions
function RemoteSwitcher.Enable(forcenumber)
	--print("Remote Switcher Enable")
	RemoteSwitcher.Active = true
	RemoteSwitcher.fadetime = nil
	--Get Convar values
	local cvar = GetConVar("tp3_remote_switcher_angle")
	RemoteSwitcher.FOV = cvar:GetInt()
	cvar = GetConVar("tp3_remote_switcher_distance")
	RemoteSwitcher.Distance = cvar:GetInt()
	
	if LocalPlayer():KeyDown(IN_SPEED) or forcenumber then --Setup numbers mode if player is holding shift, or if they do a "1" in the console command
		RemoteSwitcher.NumberMode = true
		RemoteSwitcher.Stands = {}
		local origin = LocalPlayer():EyePos()
		
		--local cvar = GetConVar("tp3_remote_switcher_angle")
		--local cangle = cvar:GetFloat()
		--print("Cone Angle: "..cangle)
		--if cangle==0 then cangle = 5 end
		
		local allents = ents.FindInCone(origin,LocalPlayer():GetAimVector(),RemoteSwitcher.Distance,math.cos(math.rad(RemoteSwitcher.FOV)))
		local allstands = {}
		for k, ent in pairs(allents) do --Filter out stands and find distances
			if ent:GetClass()=="tp3_switch_lever_anim" then
				local stand = ent
				local dist2 = origin:DistToSqr(stand:GetPos())
				table.insert(allstands,{stand = stand, dist2 = dist2})
			end
		end 
		
		--Sort by distance
		table.sort(allstands,function(a,b) return a.dist2 < b.dist2 end)
		
		--Copy to main table
		for n=1,10 do
			if allstands[n] then
				table.insert(RemoteSwitcher.Stands,allstands[n].stand)
			end
		end
		
		--PrintTable(RemoteSwitcher.Stands)
		
	else
		RemoteSwitcher.Stands = ents.FindByClass("tp3_switch_lever_anim")
		RemoteSwitcher.NumberMode = false
		--print("Switches: "..#RemoteSwitcher.Stands)
	end
	
	
end

function RemoteSwitcher.Disable()
	if RemoteSwitcher.Active then
		RemoteSwitcher.Stands = {}
		if not RemoteSwitcher.NumberMode and not LocalPlayer():KeyDown(IN_SPEED) and RemoteSwitcher.selected then --If not in numbers mode (and not holding shift), throw the switch you're looking at
			RemoteSwitcher.Switch(RemoteSwitcher.selected)
			RemoteSwitcher.fadetime = CurTime()+5
		end
	end
	RemoteSwitcher.Active = false
	RemoteSwitcher.NumberMode = false
end

--Console Commands
concommand.Add("tp3_remote_switcher", function(ply, cmd, args)
	if RemoteSwitcher.Active then
		RemoteSwitcher.Disable()
	else
		RemoteSwitcher.Enable()
	end
end)

concommand.Add("+tp3_remote_switcher", function(ply, cmd, args)
	if RemoteSwitcher.Active and RemoteSwitcher.NumberMode then
		RemoteSwitcher.Disable()
	else
		RemoteSwitcher.Enable(args[1]=="1")
	end
end)

concommand.Add("-tp3_remote_switcher", function()
	if not RemoteSwitcher.NumberMode then RemoteSwitcher.Disable() end
end)

CreateClientConVar("tp3_remote_switcher_distance", "8192", true, false, "The maximum distance for Remote Switcher, in Source Units. Default is 8192.", 0, 32768) --20 degrees corresponds to about 0.95 dot

CreateClientConVar("tp3_remote_switcher_angle", "20", true, false, "The search cone angle for Remote Switcher, in degrees. Default is 20.", 5, 90)

--Draw a box around this stand and add text labels
function RemoteSwitcher.drawStandBox(ent, distance, addtext, alpha)
	local data = ent:GetPos():ToScreen()
	local centerx = data.x
	local centery = data.y
	
	local size = math.Clamp(math.Remap(distance,256,4096,ScrW()/16,ScrW()/128), ScrW()/128, ScrW()/16)
	
	--Get Info
	local state = ent:GetNWInt("state",2)
	local broken = ent:GetNWBool("broken")
	local blocked = ent:GetNWBool("blocked")
	local locked = ent:GetNWBool("locked")
	local interlocked = ent:GetNWBool("interlocked")
	
	local levertype = ent:GetNWInt("levertype",0)
	local isderail = (levertype==1) or (levertype==2)
	
	local toptext = "Switch Stand"
	local bottomtext = "Unknown"
	local color = RemoteSwitcher.Colors.deselected
	
	if addtext then
		
		if levertype==0 then
			toptext = "Switch Stand"
		elseif (levertype==1) or (levertype==2) then
			toptext = "Derail"
		else
			toptext = "Lever"
		end
		
		if broken then --Broken 
			color = RemoteSwitcher.Colors.broken
			bottomtext = "Broken"
		elseif isderail then --Derail (All 3 States)
			if state==2 then
				color = RemoteSwitcher.Colors.moving
				bottomtext = "Moving"
			elseif state==1 then
				color = RemoteSwitcher.Colors.derail_off
				bottomtext = "Derail Off"
			else
				color = RemoteSwitcher.Colors.derail_on
				bottomtext = "Derail On"
			end			
		elseif state==2 then --Moving
			color = RemoteSwitcher.Colors.moving
			bottomtext = "Moving"
		
		elseif state==1 then --Diverging
			if interlocked then
				color = RemoteSwitcher.Colors.r_locked
				bottomtext = "Interlocked Reverse"
			elseif locked then
				color = RemoteSwitcher.Colors.r_locked
				bottomtext = "Locked Reverse"
			elseif blocked then
				color = RemoteSwitcher.Colors.r_blocked
				bottomtext = "Blocked Reverse"
			else
				color = RemoteSwitcher.Colors.r
				bottomtext = "Reverse"
			end
		elseif state==0 then --Main
			if interlocked then
				color = RemoteSwitcher.Colors.n_locked
				bottomtext = "Interlocked Normal"
			elseif locked then
				color = RemoteSwitcher.Colors.n_locked
				bottomtext = "Locked Normal"
			elseif blocked then
				color = RemoteSwitcher.Colors.n_blocked
				bottomtext = "Blocked Normal"
			else
				color = RemoteSwitcher.Colors.n
				bottomtext = "Normal"
			end
		end
		
		if alpha then color = Color(color.r, color.g, color.b, alpha) end
		
		--Set Top Text if addtext is a string
		if addtext!=true then toptext = addtext end
	end
	
	--Set Color
	if addtext then
		draw.SimpleTextOutlined(toptext, "DermaDefault", centerx, centery - size/2 - 16, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,color.a))
		draw.SimpleTextOutlined(bottomtext, "DermaDefault", centerx, centery + size/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,color.a))
	end
	surface.SetDrawColor(color)
	
	--Draw Rectangle
	surface.DrawOutlinedRect(centerx - size/2, centery - size/2, size, size)
end

--Rendering Code

hook.Add("DrawOverlay","Trakpak3_RemoteSwitcher",function()
	if RemoteSwitcher.Active and RemoteSwitcher.Stands and RemoteSwitcher.FOV and RemoteSwitcher.Distance and not table.IsEmpty(RemoteSwitcher.Stands) then
		RemoteSwitcher.selected = nil
		local others = {} --actually used for all stands
		local distances = {}
		local indices = {}
		local maxdot = 0
		local ep = EyePos()
		local ev = EyeVector()
		local fovdot = math.cos(math.rad(RemoteSwitcher.FOV))
		--find which switch you're looking at
		for k, stand in pairs(RemoteSwitcher.Stands) do
			if stand and stand:IsValid() then
				local disp = (stand:GetPos() - ep)
				local dist = math.max(disp:Length(),1)
				local lvec = disp:GetNormalized()
				local viewdot = ev:Dot(lvec)
				if not stand:IsDormant() and (viewdot>fovdot) and (dist<RemoteSwitcher.Distance) then --Only mark stands that you're looking at, and are actually being rendered.
					
					if (viewdot > maxdot) then
						maxdot = viewdot
						RemoteSwitcher.selected = stand
					end
					
					table.insert(others,stand)
					table.insert(distances,math.Clamp(dist,0,16384))
					table.insert(indices,k)
				end
			end
		end
		--print(RemoteSwitcher.selected)
		
		if not RemoteSwitcher.NumberMode then --"SIGNALVISION" MODE
			--Draw all the stands
			if not table.IsEmpty(others) then
				for k, v in pairs(others) do
					local examine = v==RemoteSwitcher.selected
					RemoteSwitcher.drawStandBox(v, distances[k], examine)
				end
			end
		else --"NUMBERS" MODE
			--Draw all the stands
			if not table.IsEmpty(others) then
				for k, v in pairs(others) do
					RemoteSwitcher.drawStandBox(v, distances[k], tostring(indices[k]))
				end
			end
			
			--Button Processing
			local keys = {
				input.IsKeyDown(KEY_1),
				input.IsKeyDown(KEY_2),
				input.IsKeyDown(KEY_3),
				input.IsKeyDown(KEY_4),
				input.IsKeyDown(KEY_5),
				input.IsKeyDown(KEY_6),
				input.IsKeyDown(KEY_7),
				input.IsKeyDown(KEY_8),
				input.IsKeyDown(KEY_9),
				input.IsKeyDown(KEY_0)
			}
			--OR
			local any = false
			for k, v in pairs(keys) do
				if v then
					any = true
					if not RemoteSwitcher.keyq then --Fire switch!
						RemoteSwitcher.keyq = true
						RemoteSwitcher.Switch(RemoteSwitcher.Stands[k])
					end
					
				end
			end
			if RemoteSwitcher.keyq and not any then RemoteSwitcher.keyq = false end
			
			
		end
		
		
	elseif RemoteSwitcher.fadetime and RemoteSwitcher.selected then --flash the selected stand
		local timeleft = RemoteSwitcher.fadetime - CurTime()
		local alpha = math.Remap(timeleft,0,5,0,255)
		RemoteSwitcher.drawStandBox(RemoteSwitcher.selected, RemoteSwitcher.selected:GetPos():Distance(EyePos()), true, alpha)
		
		if CurTime() > RemoteSwitcher.fadetime then RemoteSwitcher.fadetime = nil end
	end
	
end)

--[[
--Freezebug's Hook Blocking Checker - Checks to see if any hooks on HUDPaint are returning something.

local dHooks = hook.GetTable()["HUDPaint"]

for name,func in pairs(dHooks) do 
    local res
    pcall(function()
        res = func() --Provide hook arguments here
    end) 
    if (res~=nil) then 
        print("!!!!!!!!!" .. tostring(name) .. " !!!!!!! BLOCKING!") 
        PrintTable(debug.getinfo(func,"flS"))
    else 
        print(tostring(name) .. " OK")
    end     
end
]]--