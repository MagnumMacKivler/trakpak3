Trakpak3.PathConfig = {}
local PathConfig = Trakpak3.PathConfig

PathConfig.Signals = {}

local speednames = {[0] = "STOP/DANGER", [1] = "RESTRICTED", [2] = "SLOW", [3] = "MEDIUM", [4] = "LIMITED", [5] = "FULL"}
local speeds = {["STOP/DANGER"] = 0, ["RESTRICTED"] = 1, ["SLOW"] = 2, ["MEDIUM"] = 3, ["LIMITED"] = 4, ["FULL"] = 5}

--Select/Deselect signals to configure
function PathConfig.SelectSignal(ent)
	if ent and ent:IsValid() and (ent:GetClass()=="tp3_signal_master") then
		local name = ent:GetName()
		if name then
			if PathConfig.selected and PathConfig.selected_path then --Add/Remove as NextSignal
				local signal = PathConfig.selected_ent
				local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path] --signal.pconfigs[PathConfig.selected_path]
				if signal != ent then
					if pc.nextsignal==name then
						pc.nextsignal = nil
						chat.AddText("Cleared NextSignal from path.")
					else
						pc.nextsignal = name
						chat.AddText("Selected NextSignal '"..name.."' for path.")
					end
				else
					chat.AddText("NextSignal cannot be the same as the home Signal.")
				end
			else
				PathConfig.selected = name
				PathConfig.selected_ent = ent
				PathConfig.selected_path = nil
				chat.AddText("Selected signal '"..name.."' to configure.")
				PathConfig.OpenMenu()
			end
		else
			--Print "No Targetname"
			chat.AddText("The signal you are trying to select has no targetname!")
		end
	else
		--Print "Not a signal"
		chat.AddText("The entity you are trying to select is not a tp3_signal_master!")
	end
end

function PathConfig.DeselectSignal()
	PathConfig.selected = nil
	PathConfig.selected_ent = nil
	PathConfig.selected_path = nil
	chat.AddText("Deselected signal.")
end

--Select/Deselect Switches; assumes a signal and path are selected
function PathConfig.CycleSwitch(ent)
	if ent and ent:IsValid() then
		local stand = nil
		if ent:GetClass()=="tp3_switch_lever_anim" then
			stand = ent
		elseif ent:GetClass()=="tp3_switch" then
			stand = ent:GetNWEntity("lever",nil)
		end
		
		if stand then
			local signal = PathConfig.selected_ent
			local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
			local sl = pc.switchlist
			
			local name = stand:GetName()
			
			if sl[name]==nil then --Set to Main
				sl[name] = false
			elseif sl[name]==false then --Set to Div
				sl[name] = true
			elseif sl[name]==true then --Set to Nil
				sl[name] = nil
			end
			
		end
		
	end
end

--Scan for Blocks/Gates
function PathConfig.SelectBlock()
	--if not PathConfig.selected_path then return end
	local mypos = LocalPlayer():GetPos()
	local mins = Vector(-64,-64,-8)
	local maxs = Vector(64,64,128)
	
	local did = false
	
	--Blocks
	for name, block in pairs(Trakpak3.Blocks) do
		
		local bpos = block.pos
		
		if mypos:WithinAABox(bpos+mins, bpos+maxs) then
			did = true
			--print("Ding")
			local signal = PathConfig.selected_ent
			local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
			
			if pc.block==name then
				pc.block = nil
				chat.AddText("Cleared Block from path.")
			else
				pc.block = name
				chat.AddText("Selected Block '"..name.."' for path.")
			end
			
			break
		end
	end
	
	--Logic Gates
	if not did then
		for name, gate in pairs(Trakpak3.LogicGates) do
		
			local bpos = gate.pos
			
			if mypos:WithinAABox(bpos+mins, bpos+maxs) then
				did = true
				--print("Ding")
				local signal = PathConfig.selected_ent
				local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
				
				if pc.block==name then
					pc.block = nil
					chat.AddText("Cleared Logic Gate from path.")
				else
					pc.block = name
					chat.AddText("Selected Logic Gate '"..name.."' for path.")
				end
				
				break
			end
		end
	end
	
	if not did then
		PathConfig.DeselectSignal()
	end
	
end

--Open the menu for the selected signal
function PathConfig.OpenMenu()
	
	local signal = PathConfig.selected_ent
	
	local frame = vgui.Create("DFrame")
	frame:SetSize(512,512)
	frame:SetPos(ScrW()/2 - 192, ScrH()/2 - 256)
	frame:SetTitle("Signal Paths: "..PathConfig.selected)
	frame:MakePopup()
	
	--Path List
	local pathlist = vgui.Create("DListView",frame)
	pathlist:SetSize(1,256+64)
	pathlist:Dock(TOP)
	pathlist:SetMultiSelect(false)
	
	local c1 = pathlist:AddColumn("Index",1)
	pathlist:AddColumn("Speed",2)
	pathlist:AddColumn("Divergence",3)
	pathlist:AddColumn("Switches",4)
	pathlist:AddColumn("Signal Block",5)
	pathlist:AddColumn("Next Signal",6)
	
	c1:SetFixedWidth(48)
	
	local speedbox
	local divbox
	local sbutton
	
	function pathlist:OnRowSelected(_, row)
		local index = tonumber(row:GetColumnText(1))
		local speedname = speednames[tonumber(row:GetColumnText(2))]
		
		PathConfig.selected_path = index
		local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
		
		--Set Speed and Divergence boxes
		speedbox:SetEnabled(true)
		speedbox:SetValue(speednames[pc.speed])
		
		divbox:SetEnabled(true)
		local div = pc.divergence
		divbox:SetChecked(div)
		if div then divbox:SetText("Path is Diverging") else divbox:SetText("Path is Main") end
		
		sbutton:SetEnabled(true)
	end
	
	function pathlist:Repopulate()
		self:Clear()
		
		--Add List Items
		local pcs = PathConfig.Signals[PathConfig.selected]
		if pcs then
			for n=1, #pcs do
				local pc = pcs[n]
				self:AddLine(n, speednames[pc.speed], pc.divergence and "Diverging" or "Main", table.Count(pc.switchlist), pc.block, pc.nextsignal)
			end
		end
		
		if pcs and PathConfig.selected_path then
			
			local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
			
			--Select the Row
			for k, v in pairs(self:GetLines()) do
				local index = tonumber(v:GetColumnText(1))
				if index==PathConfig.selected_path then
					v:SetSelected(true)
					break
				end
			end
			
			--Set Speed Box Value
			speedbox:SetEnabled(true)
			speedbox:SetValue(speednames[pc.speed])
			
			--Set Divergence Checkbox
			divbox:SetEnabled(true)
			local div = pc.divergence
			divbox:SetChecked(div)
			if div then divbox:SetText("Path is Diverging") else divbox:SetText("Path is Main") end
			
			sbutton:SetEnabled(true)
		else
			--print("This should be disabling stuff")
			speedbox:SetValue("")
			speedbox:SetEnabled(false)
			divbox:SetText("No Path Selected")
			divbox:SetEnabled(false)
			sbutton:SetEnabled(false)
		end
	end
	
	--Add/Remove/Clear Buttons
	local panel = vgui.Create("DPanel",frame)
	panel:SetSize(128,1)
	panel:Dock(LEFT)
	--Add
	local button = vgui.Create("DButton",panel)
	button:SetSize(1,48)
	button:Dock(TOP)
	button:SetText("Add Path")
	button:SetImage("icon16/add.png")
	function button:DoClick()
		
		if not PathConfig.Signals[PathConfig.selected] then PathConfig.Signals[PathConfig.selected] = {} end
		
		local count = #PathConfig.Signals[PathConfig.selected]
		
		table.insert(PathConfig.Signals[PathConfig.selected],{speed = 5, divergence = (count > 0), switchlist = {}, block = nil, nextsignal = nil})
		pathlist:Repopulate()
	end
	--Remove
	local button = vgui.Create("DButton",panel)
	button:SetSize(1,24)
	button:Dock(TOP)
	button:SetText("Remove Path")
	button:SetTextColor(Color(191,0,0))
	button:SetImage("icon16/delete.png")
	function button:DoClick()
		local _, line = pathlist:GetSelectedLine()
		if not line then return end
		
		local index = tonumber(line:GetColumnText(1))
		table.remove(PathConfig.Signals[PathConfig.selected],index)
		PathConfig.selected_path = nil
		pathlist:Repopulate()
	end
	--Clear
	local button = vgui.Create("DButton",panel)
	button:SetSize(1,24)
	button:Dock(TOP)
	button:SetText("Clear Paths")
	button:SetTextColor(Color(191,0,0))
	button:SetImage("icon16/bomb.png")
	function button:DoClick()
		PathConfig.Signals[PathConfig.selected] = nil
		PathConfig.selected_path = nil
		pathlist:Repopulate()
	end
	
	--Speed, Divergence, Switchlist Controls
	local panel = vgui.Create("DPanel",frame)
	panel:Dock(FILL)
	
	local color_dark = Color(0,0,0)
	
	--Speed
	
	local label = vgui.Create("DLabel",panel)
	label:SetSize(1,24)
	label:Dock(TOP)
	label:SetContentAlignment(5)
	label:SetTextColor(color_dark)
	label:SetText("Path Speed")
	
	speedbox = vgui.Create("DComboBox",panel)
	speedbox:SetSize(1,24)
	speedbox:Dock(TOP)
	speedbox:DockMargin(16,0,16,0)
	
	speedbox:AddChoice("FULL",5)
	speedbox:AddChoice("LIMITED",4)
	speedbox:AddChoice("MEDIUM",3)
	speedbox:AddChoice("SLOW",2)
	speedbox:AddChoice("RESTRICTED",1)
	speedbox:AddChoice("STOP/DANGER",0)
	
	speedbox:SetSortItems(false)
	
	function speedbox:OnSelect(_, value, data)
		if PathConfig.selected_path and PathConfig.Signals[PathConfig.selected] then
			PathConfig.Signals[PathConfig.selected][PathConfig.selected_path].speed = data
			pathlist:Repopulate()
		end
	end
	
	--Divergence
	
	divbox = vgui.Create("DCheckBoxLabel",panel)
	divbox:SetSize(1,36)
	divbox:Dock(TOP)
	divbox:DockMargin(16,16,16,16)
	divbox:SetTextColor(color_dark)
	--divbox:SetText("Path is Main")
	
	function divbox:OnChange(val)
		if PathConfig.selected_path and PathConfig.Signals[PathConfig.selected] then
			PathConfig.Signals[PathConfig.selected][PathConfig.selected_path].divergence = val
			pathlist:Repopulate()
		end
	end
	
	--Clear Switch List
	sbutton = vgui.Create("DButton",panel)
	sbutton:Dock(FILL)
	sbutton:DockMargin(16,16,16,16)
	sbutton:SetText("Clear Switches")
	sbutton:SetTextColor(Color(191,0,0))
	function sbutton:DoClick()
		if PathConfig.selected_path and PathConfig.Signals[PathConfig.selected] then
			PathConfig.Signals[PathConfig.selected][PathConfig.selected_path].switchlist = {}
			pathlist:Repopulate()
		end
	end
	
	--Populate the list
	pathlist:Repopulate()
end

local color_black = Color(0,0,0,191)
local color_signal = Color(255,255,255)
local color_n = Color(0,255,0)
local color_r = Color(255,223,0)
local color_nextsignal = Color(255,191,127)
local color_block0 = Color(0,63,255)
local color_block1 = Color(0,255,255)
local color_gate0 = Color(127,0,127)
local color_gate1 = Color(255,0,255)

--Draw Stuff
function PathConfig.Draw()
	if not PathConfig.selected then return end
	local signal = PathConfig.selected_ent
	local elementsize = 64
	
	local homesigpos
	
	--Draw Signal
	if PathConfig.selected_ent:IsValid() then
		local data = signal:GetPos():ToScreen()
		
		homesigpos = data
		
		local cx = data.x
		local cy = data.y
		
		surface.SetDrawColor(color_black)
		surface.DrawRect(cx - elementsize/2, cy - elementsize/2, elementsize, elementsize)
		
		surface.SetDrawColor(color_signal)
		surface.DrawOutlinedRect(cx - elementsize/2 + 2, cy - elementsize/2 + 2, elementsize-4, elementsize-4, 2)
		
		draw.SimpleText("SIGNAL","tp3_dispatch_1",cx,cy,color_signal, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		if PathConfig.selected_path then
			surface.SetDrawColor(color_black)
			surface.DrawRect(cx - elementsize, cy - elementsize, elementsize*2, elementsize*0.5)
			surface.DrawRect(cx - elementsize, cy + elementsize/2, elementsize*2, elementsize*0.5)
			
			surface.SetDrawColor(color_signal)
			surface.DrawOutlinedRect(cx - elementsize + 2, cy - elementsize + 2, elementsize*2 - 4, elementsize*0.5 - 4, 1)
			surface.DrawOutlinedRect(cx - elementsize + 2, cy + elementsize/2 + 2, elementsize*2 - 4, elementsize*0.5 - 4, 1)
			
			local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
			
			draw.SimpleText(speednames[pc.speed], "tp3_dispatch_1", cx, cy - elementsize*0.75, color_signal, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(pc.divergence and "Diverging" or "Main", "tp3_dispatch_1", cx, cy + elementsize*0.75, color_signal, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	end
	
	--Draw Switches, Nextsignal, Block
	if PathConfig.selected and PathConfig.selected_path then
		
		local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
		
		--Switches
		
		local sl = pc.switchlist
		for name, pos in pairs(Trakpak3.Switches) do 
			--local name = stand:GetName()
			if sl[name]==false then --Main
				--local pos = stand:GetPos()
				local data = pos:ToScreen()
				local cx = data.x
				local cy = data.y
				
				surface.SetDrawColor(color_black)
				surface.DrawRect(cx - elementsize/2, cy - elementsize/2, elementsize, elementsize)
				
				surface.SetDrawColor(color_n)
				surface.DrawOutlinedRect(cx - elementsize/2 + 2, cy - elementsize/2 + 2, elementsize-4, elementsize-4, 2)
				
				draw.SimpleText("SWITCH","tp3_dispatch_1",cx,cy-12,color_n, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("N","tp3_dispatch_3",cx,cy+12,color_n, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif sl[name] then --Diverging
				--local pos = stand:GetPos()
				local data = pos:ToScreen()
				local cx = data.x
				local cy = data.y
				
				surface.SetDrawColor(color_black)
				surface.DrawRect(cx - elementsize/2, cy - elementsize/2, elementsize, elementsize)
				
				surface.SetDrawColor(color_r)
				surface.DrawOutlinedRect(cx - elementsize/2 + 2, cy - elementsize/2 + 2, elementsize-4, elementsize-4, 2)
				
				draw.SimpleText("SWITCH","tp3_dispatch_1",cx,cy-12,color_r, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("R","tp3_dispatch_3",cx,cy+12,color_r, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		
		--Nextsignal
		
		local ns = pc.nextsignal
		if ns then
			for name, pos in pairs(Trakpak3.Signals) do
				--local name = signal:GetName()
				if ns==name then
					--local pos = signal:GetPos()
					local data = pos:ToScreen()
					local cx = data.x
					local cy = data.y
					
					surface.SetDrawColor(color_black)
					surface.DrawRect(cx - elementsize/2, cy - elementsize/2, elementsize, elementsize)
					
					surface.SetDrawColor(color_nextsignal)
					surface.DrawOutlinedRect(cx - elementsize/2 + 2, cy - elementsize/2 + 2, elementsize-4, elementsize-4, 2)
					
					draw.SimpleText("NEXT","tp3_dispatch_1",cx,cy-6,color_nextsignal, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("SIGNAL","tp3_dispatch_1",cx,cy+6,color_nextsignal, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					--Arrow from one to the other; cool concept, not really useful
					--[[
					if homesigpos and homesigpos.visible and data.visible then
						local sx = homesigpos.x
						local sy = homesigpos.y
						
						local dx = cx-sx
						local dy = cy-sy
						
						local length = math.sqrt(dx*dx + dy*dy)
						if length > (elementsize*1.5) then
							local nx = dx/length
							local ny = dy/length
							
							surface.SetDrawColor(color_signal)
							
							surface.DrawLine(sx + nx*elementsize*0.75, sy + ny*elementsize*0.75, cx - nx*elementsize*0.75, cy - ny*elementsize*0.75)
							
						end
						
					end
					]]--
					
					break
				end
			end
		end
		
		--Non-Tangibles
		--local rdist = (GetConVar("tp3_node_editor_drawdistance"):GetFloat() or 1024)^2
		local mypos = LocalPlayer():GetPos()
		
		local incopyzone = false
		
		--Blocks
		
		if Trakpak3.Blocks then
			
			--Draw Hit Hulls
			cam.Start3D()
				for name, block in pairs(Trakpak3.Blocks) do
					local bpos = block.pos
					
					local mins = Vector(-64,-64,-8)
					local maxs = Vector(64,64,128)
					
					local bcolor = color_block0
					
					if mypos:WithinAABox(bpos+mins, bpos+maxs) then
					
						bcolor = color_block1
						
					end
					
					render.DrawWireframeBox(bpos,Angle(),mins,maxs,bcolor)
				end
			cam.End3D()
			
			--Draw Selection
			if PathConfig.selected and PathConfig.selected_path then
				local signal = PathConfig.selected_ent
				local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
				
				local block = Trakpak3.Blocks[pc.block]
				
				if block then
					local data = block.pos:ToScreen()
					
					local cx = data.x
					local cy = data.y
					
					surface.SetDrawColor(color_black)
					surface.DrawRect(cx - elementsize/2, cy - elementsize/2, elementsize, elementsize)
					
					surface.SetDrawColor(color_block1)
					surface.DrawOutlinedRect(cx - elementsize/2 + 2, cy - elementsize/2 + 2, elementsize-4, elementsize-4, 2)
					
					draw.SimpleText("SIGNAL","tp3_dispatch_1",cx,cy-6,color_block1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("BLOCK","tp3_dispatch_1",cx,cy+6,color_block1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
		
		--Logic Gates
		
		if Trakpak3.LogicGates then
			
			--Draw Hit Hulls
			cam.Start3D()
				for name, gate in pairs(Trakpak3.LogicGates) do
					local bpos = gate.pos
					
					local mins = Vector(-64,-64,-8)
					local maxs = Vector(64,64,128)
					
					local bcolor = color_gate0
					
					if mypos:WithinAABox(bpos+mins, bpos+maxs) then
					
						bcolor = color_gate1
						
					end
					
					render.DrawWireframeBox(bpos,Angle(),mins,maxs,bcolor)
				end
			cam.End3D()
			
			--Draw Selection
			if PathConfig.selected and PathConfig.selected_path then
				local signal = PathConfig.selected_ent
				local pc = PathConfig.Signals[PathConfig.selected][PathConfig.selected_path]
				
				local gate = Trakpak3.LogicGates[pc.block]
				
				if gate then
					local data = gate.pos:ToScreen()
					
					local cx = data.x
					local cy = data.y
					
					surface.SetDrawColor(color_black)
					surface.DrawRect(cx - elementsize/2, cy - elementsize/2, elementsize, elementsize)
					
					surface.SetDrawColor(color_gate1)
					surface.DrawOutlinedRect(cx - elementsize/2 + 2, cy - elementsize/2 + 2, elementsize-4, elementsize-4, 2)
					
					draw.SimpleText("LOGIC","tp3_dispatch_1",cx,cy-6,color_gate1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText("GATE","tp3_dispatch_1",cx,cy+6,color_gate1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
		
		
	end
	
end

--Save PathConfig File
function PathConfig.Save()
	
	local PCT = PathConfig.Signals
	
	local json = util.TableToJSON(PCT, true)
	
	file.CreateDir("trakpak3/pathconfig")
	file.Write("trakpak3/pathconfig/"..game.GetMap()..".txt", json)
	local gray = Color(127,255,255)
	chat.AddText(gray, "File saved as ",Color(255,127,127),"data",gray,"/trakpak3/pathconfig/"..game.GetMap()..".txt! To include it with your map, change its extension to .lua and place it in ",Color(0,127,255),"lua",gray,"/trakpak3/pathconfig/!")
	
end

--Load PathConfig File
function PathConfig.Load()
	local json = file.Read("trakpak3/pathconfig/"..game.GetMap()..".txt", "DATA")
	if json then
		local PCT = util.JSONToTable(json)
		PathConfig.Signals = PCT
		chat.AddText(Color(127,255,255), "Loaded pathconfig file data/trakpak3/pathconfig/"..game.GetMap()..".txt successfully.")
		
		PathConfig.selected = nil
		PathConfig.selected_ent = nil
		PathConfig.selected_path = nil
		
	else
		chat.AddText(Color(127,255,255),"Could not find pathconfig file data/trakpak3/pathconfig/"..game.GetMap()..".txt!")
	end
end

--Load From Map
function PathConfig.LoadFromServer(message)
	
	if PathConfig.MapSignals then
		
		PathConfig.Signals = PathConfig.MapSignals
		
		PathConfig.selected = nil
		PathConfig.selected_ent = nil
		PathConfig.selected_path = nil
		
		if message then chat.AddText(Color(127,255,255), "Loaded path config from map successfully.") end
	else
		if message then chat.AddText(Color(127,255,255), "Could not load path config from map (lua/trakpak3/pathconfig/"..game.GetMap()..".lua does not exist?)!") end
	end
end

--Clear
function PathConfig.Clear()
	PathConfig.Signals = {}
	PathConfig.selected = nil
	PathConfig.selected_ent = nil
	PathConfig.selected_path = nil
end
--Receive From Server
net.Receive("tp3_pathpack", function(mlen)
	print("[Trakpak3] Path Pack Received.")
	local JSON = net.ReadData(mlen)
	JSON = util.Decompress(JSON)
	PathConfig.MapSignals = util.JSONToTable(JSON)
	
	PathConfig.LoadFromServer(false)
end)