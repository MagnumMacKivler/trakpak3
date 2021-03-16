--Code for creating and displaying dispatch boards

Trakpak3.Dispatch = {}
local Dispatch = Trakpak3.Dispatch

Dispatch.Boards = {} --table containing all board scripts for the vgui window
Dispatch.Panels = {} --List of Derma Elements that need to be remembered
Dispatch.showgrid = true
Dispatch.selectnew = true
Dispatch.RealData = {}

local black = Color(0,0,0)
local dark = Color(31,31,31)
local gray = Color(127,127,127)
local color_sel = Color(255,255,191)
local cursor1 = Color(0,255,0)
local cursor2 = Color(255,255,0)
local color_block = Color(127,63,0)
local color_block2 = Color(255,95,0)

Dispatch.elementsize = 20

surface.CreateFont("tp3_dispatch_1",{
	font = "Roboto",
	size = 16,
	weight = 700
})
surface.CreateFont("tp3_dispatch_2",{
	font = "Roboto",
	size = 24,
	weight = 700
})
surface.CreateFont("tp3_dispatch_3",{
	font = "Roboto",
	size = 32,
	weight = 700
})
surface.CreateFont("tp3_dispatch_4",{
	font = "Roboto",
	size = 40,
	weight = 700
})
surface.CreateFont("tp3_dispatch_5",{
	font = "Roboto",
	size = 48,
	weight = 700
})

function Dispatch.OpenEditor()
	if not game.SinglePlayer() then
		chat.AddText("[Trakpak3] The dispatch board editor is only available in singleplayer.")
		return nil
	end
	--Editor Frame
	local sizex = Dispatch.sizex or (ScrW()*0.75)
	local sizey = Dispatch.sizey or (ScrH()*0.75)
	local posx = Dispatch.posx or (ScrW()/2 - sizex/2)
	local posy = Dispatch.posy or (ScrH()/2 - sizey/2)

	local frame = vgui.Create("DFrame")
	frame:SetSize(sizex, sizey)
	frame:SetPos(posx, posy)
	frame:SetTitle("DispEdit (Trakpak3 Dispatch Board Editor)")
	--frame:SetIcon("icon16/map_edit.png")
	frame:SetIcon("trakpak3_common/icons/switch_n_lit.png")
	frame:SetSizable(true)
	frame:SetScreenLock(true)
	frame:SetMinHeight(64)
	frame:SetMinWidth(128)
	function frame:OnClose()
		
		--Save Position & Scale Data
		Dispatch.sizex, Dispatch.sizey = frame:GetSize()
		Dispatch.posx, Dispatch.posy = frame:GetPos()
		
		--Clear the variables
		Dispatch.Panels.editor = nil
		Dispatch.Deselect()
		
		--Reinitialize all world dispatch boards
		--for _, board in pairs(ents.FindByClass("tp3_dispatch_board")) do board:InitializeBoard() end
	end
	frame:MakePopup()
	Dispatch.Panels.editor = frame
	
	local function RefreshEditor()
		frame:Close()
		Dispatch.OpenEditor()
	end
	
	--Control Bars
	local topbar = vgui.Create("DPanel",frame)
	topbar:SetSize(1,24)
	topbar:Dock(TOP)
	
	local bottombar = vgui.Create("DPanel",frame)
	bottombar:SetSize(1,36)
	bottombar:Dock(BOTTOM)
	
	--Add Board Button
	local button = vgui.Create("DButton",topbar)
	button:SetSize(96,1)
	button:Dock(LEFT)
	button:SetText("Add Board")
	button:SetImage("icon16/add.png")
	button.DoClick = function() --Confirmation window
		local frame2 = vgui.Create("DFrame")
		local x, y = ScrW()/2, ScrH()/2
		local sx, sy = 192, 96
		frame2:SetSize(sx, sy)
		frame2:SetPos(x - sx/2, y - sy/2)
		frame2:SetTitle("New Board Name")
		frame2:MakePopup()
		
		local tbox = vgui.Create("DTextEntry",frame2)
		tbox:SetSize(1,24)
		tbox:Dock(TOP)
		tbox:SetValue("New Dispatch Board")
		tbox:SelectAllOnFocus()
		
		local confirm = vgui.Create("DButton",frame2)
		confirm:SetSize(64,1)
		confirm:Dock(LEFT)
		confirm:SetText("Confirm")
		confirm.DoClick = function()
			local tval = tbox:GetValue()
			if tval and (tval != "") then
				
				table.insert(Dispatch.Boards, {
					name = tval,
					x_res = 64,
					y_res = 48,
					elements = {}
				})
				
				frame2:Close()
				Dispatch.PopulatePage(Dispatch.Panels.canvas,#Dispatch.Boards)
			end
		end
		local cancel = vgui.Create("DButton",frame2)
		cancel:SetSize(64,1)
		cancel:Dock(RIGHT)
		cancel:SetText("Cancel")
		cancel.DoClick = function()
			frame2:Close()
		end
		
		timer.Simple(0.1,function() tbox:RequestFocus() end)
	end
	
	--Rename Board Button
	local button = vgui.Create("DButton",topbar)
	button:SetSize(128,1)
	button:Dock(LEFT)
	button:SetText("Rename Board")
	button:SetImage("icon16/page_edit.png")
	button.DoClick = function() --Confirmation window
		if Dispatch.page > 0 then
			local frame2 = vgui.Create("DFrame")
			local x, y = ScrW()/2, ScrH()/2
			local sx, sy = 192, 96
			frame2:SetSize(sx, sy)
			frame2:SetPos(x - sx/2, y - sy/2)
			frame2:SetTitle("Rename Board")
			frame2:MakePopup()
			
			local tbox = vgui.Create("DTextEntry",frame2)
			tbox:SetSize(1,24)
			tbox:Dock(TOP)
			tbox:SetValue(Dispatch.Boards[Dispatch.page].name)
			
			
			local confirm = vgui.Create("DButton",frame2)
			confirm:SetSize(64,1)
			confirm:Dock(LEFT)
			confirm:SetText("Confirm")
			confirm.DoClick = function()
				local tval = tbox:GetValue()
				if tval and (tval != "") then
					
					Dispatch.Boards[Dispatch.page].name = tval
					
					frame2:Close()
					Dispatch.PopulatePage(Dispatch.Panels.canvas)
				end
			end
			local cancel = vgui.Create("DButton",frame2)
			cancel:SetSize(64,1)
			cancel:Dock(RIGHT)
			cancel:SetText("Cancel")
			cancel.DoClick = function()
				frame2:Close()
			end
			
			timer.Simple(0.1,function() tbox:RequestFocus() end)
		end
	end
	
	--Remove Board Button
	local button = vgui.Create("DButton",topbar)
	button:SetSize(128,1)
	button:Dock(LEFT)
	button:SetText("Delete Board")
	button:SetImage("icon16/bomb.png")
	button.DoClick = function()
		if #Dispatch.Boards > 0 then
			local frame2 = vgui.Create("DFrame")
			local x, y = ScrW()/2, ScrH()/2
			local sx, sy = 256, 64
			frame2:SetSize(sx, sy)
			frame2:SetPos(x - sx/2, y - sy/2)
			frame2:SetTitle("Delete Selected Board?")
			frame2:MakePopup()
			
			local confirm = vgui.Create("DButton",frame2)
			confirm:SetSize(64,1)
			confirm:Dock(LEFT)
			confirm:SetText("Delete")
			confirm.DoClick = function()
				frame2:Close()
				table.remove(Dispatch.Boards,Dispatch.page)
				Dispatch.PopulatePage(Dispatch.Panels.canvas,math.min(#Dispatch.Boards,1))
			end
			
			local cancel = vgui.Create("DButton",frame2)
			cancel:SetSize(64,1)
			cancel:Dock(RIGHT)
			cancel:SetText("Cancel")
			cancel.DoClick = function()
				frame2:Close()
			end
		end
	end
	
	--Clear Board
	local button = vgui.Create("DButton",topbar)
	button:SetSize(96,1)
	button:Dock(LEFT)
	button:SetImage("icon16/cross.png")
	button:SetText("Clear Board")
	function button:DoClick()
		if #Dispatch.Boards > 0 then
			local frame2 = vgui.Create("DFrame")
			local x, y = ScrW()/2, ScrH()/2
			local sx, sy = 256, 64
			frame2:SetSize(sx, sy)
			frame2:SetPos(x - sx/2, y - sy/2)
			frame2:SetTitle("Clear Selected Board?")
			frame2:MakePopup()
			
			local confirm = vgui.Create("DButton",frame2)
			confirm:SetSize(64,1)
			confirm:Dock(LEFT)
			confirm:SetText("Clear")
			confirm.DoClick = function()
				Dispatch.Deselect()
				frame2:Close()
				Dispatch.Boards[Dispatch.page].elements = {}
				Dispatch.PopulatePage(Dispatch.Panels.canvas)
			end
			
			local cancel = vgui.Create("DButton",frame2)
			cancel:SetSize(64,1)
			cancel:Dock(RIGHT)
			cancel:SetText("Cancel")
			cancel.DoClick = function()
				frame2:Close()
			end
		end
	end
	
	--Reset Window Button
	local button = vgui.Create("DButton",topbar)
	button:SetSize(128,1)
	button:Dock(LEFT)
	button:SetText("Reset Window")
	button:SetImage("icon16/layout.png")
	function button:DoClick()
		
		--Reset Main Frame
		local sizex = (ScrW()*0.75)
		local sizey = (ScrH()*0.75)
		local posx = (ScrW()/2 - sizex/2)
		local posy = (ScrH()/2 - sizey/2)
		frame:SetPos(posx, posy)
		frame:SetSize(sizex, sizey)
		
	end
	
	--Edit Grid
	local label = vgui.Create("DLabel",topbar)
	label:SetSize(64,1)
	label:Dock(LEFT)
	label:SetText("Grid Size:")
	label:SetContentAlignment(6)
	label:DockMargin(4,4,4,4)
	label:SetTextColor(dark)
	
	local xbox = vgui.Create("DNumberWang",topbar)
	xbox:SetSize(48,1)
	xbox:Dock(LEFT)
	xbox:SetDecimals(0)
	xbox:SetMinMax(16,96)
	function xbox:OnValueChanged(value)
		local page = Dispatch.page
		if page>0 then
			Dispatch.Boards[page].x_res = value
			Dispatch.PopulatePage(Dispatch.Panels.canvas)
		end
	end
	Dispatch.Panels.xbox = xbox
	
	local label = vgui.Create("DLabel",topbar)
	label:SetSize(12,1)
	label:Dock(LEFT)
	label:SetText("X")
	label:SetContentAlignment(5)
	label:SetTextColor(dark)
	
	local ybox = vgui.Create("DNumberWang",topbar)
	ybox:SetSize(48,1)
	ybox:Dock(LEFT)
	ybox:SetDecimals(0)
	ybox:SetMinMax(16,96)
	function ybox:OnValueChanged(value)
		local page = Dispatch.page
		if page > 0 then
			Dispatch.Boards[page].y_res = value
			Dispatch.PopulatePage(Dispatch.Panels.canvas)
		end
	end
	Dispatch.Panels.ybox = ybox
	
	--Grid Toggle
	local button = vgui.Create("DImageButton",topbar)
	button:SetSize(24,1)
	button:Dock(LEFT)
	--button:SetText("")
	if Dispatch.showgrid then button:SetImage("icon16/collision_on.png") else button:SetImage("icon16/collision_off.png") end
	function button:DoClick()
		Dispatch.showgrid = not Dispatch.showgrid
		if Dispatch.showgrid then self:SetImage("icon16/collision_on.png") else self:SetImage("icon16/collision_off.png") end
	end
	button:SetTooltip("Toggle Grid Display")
	Dispatch.Panels.gridbutton = button
	
	--Toggle helpers
	local button = vgui.Create("DImageButton",topbar)
	button:SetSize(24,1)
	button:Dock(LEFT)
	if not Dispatch.hidehelpers then button:SetImage("icon16/shape_handles.png") else button:SetImage("icon16/shape_square.png") end
	function button:DoClick()
		Dispatch.hidehelpers = not Dispatch.hidehelpers
		if not Dispatch.hidehelpers then self:SetImage("icon16/shape_handles.png") else self:SetImage("icon16/shape_square.png") end
		Dispatch.PopulatePage(Dispatch.Panels.canvas)
	end
	button:SetTooltip("Toggle Helpers")
	Dispatch.Panels.helperbutton = button
	
	--Toggle Showhulls button
	local button = vgui.Create("DImageButton",topbar)
	button:SetSize(24,1)
	button:Dock(LEFT)
	button:SetImage("icon16/layers.png")
	if Trakpak3.ShowHulls then button:SetColor(Color(255,255,255)) else button:SetColor(Color(255,127,127)) end
	button:SetTooltip("Toggle Map Block Hulls and Switch/Signal Display")
	function button:DoClick()
		if Trakpak3.ShowHulls != 2 then
			Trakpak3.ShowHulls = 2
		else
			Trakpak3.ShowHulls = false
		end
		if Trakpak3.ShowHulls then self:SetColor(Color(255,255,255)) else self:SetColor(Color(255,127,127)) end
	end
	
	--Backing Color
	local label = vgui.Create("DLabel",topbar)
	label:SetSize(64,1)
	label:Dock(LEFT)
	label:DockMargin(4,4,4,4)
	label:SetText("BG Color:")
	label:SetTextColor(dark)
	label:SetContentAlignment(6)
	
	local colorbox = vgui.Create("DTextEntry",topbar)
	colorbox:SetSize(72,1)
	colorbox:Dock(LEFT)
	colorbox:SetValue("255 255 255")
	
	function colorbox:OnEnter(value)
		local page = Dispatch.page
		if page > 0 then
			Dispatch.Boards[page].color = value
			Dispatch.PopulatePage(Dispatch.Panels.canvas)
		end
	end
	
	Dispatch.Panels.colorbox = colorbox
	
	--Save Button
	local button = vgui.Create("DButton",topbar)
	button:SetSize(128,1)
	button:Dock(RIGHT)
	button:SetImage("icon16/disk.png")
	button:SetText("Save Boards")
	function button:DoClick() Dispatch.SaveBoards() end
	
	--Load (from save) Button
	local button = vgui.Create("DButton",topbar)
	button:SetSize(128,1)
	button:Dock(RIGHT)
	button:SetImage("icon16/folder_go.png")
	button:SetText("Load From Save")
	function button:DoClick() Dispatch.LoadBoards(true) end
	
	--Load (from map) Button
	local button = vgui.Create("DButton",topbar)
	button:SetSize(128,1)
	button:Dock(RIGHT)
	button:SetImage("icon16/monitor_go.png")
	button:SetText("Load From Map")
	function button:DoClick() Dispatch.LoadBoards(false) end
	
	--Bottom Bar
	
	--Page Controls
	Dispatch.page = Dispatch.page or 0
	
	--Prev Page Button
	local button = vgui.Create("DImageButton",bottombar)
	button:SetSize(36,1)
	button:Dock(LEFT)
	button:SetImage("icon16/resultset_previous.png")
	--button:SetText("Prev")
	button.DoClick = function()
		if Dispatch.page > 1 then
			Dispatch.PopulatePage(Dispatch.Panels.canvas, Dispatch.page - 1)
		else
			Dispatch.PopulatePage(Dispatch.Panels.canvas, #Dispatch.boards)
		end
	end
	
	--Page Label
	local label = vgui.Create("DLabel",bottombar)
	label:SetSize(128,1)
	label:Dock(LEFT)
	label:SetContentAlignment(5)
	label:SetText("No Boards")
	label:SetTextColor(dark)
	Dispatch.Panels.pagelabel = label
	
	--Next Page Button
	local button = vgui.Create("DImageButton",bottombar)
	button:SetSize(36,1)
	button:Dock(LEFT)
	button:SetImage("icon16/resultset_next.png")
	--button:SetText("Next")
	button.DoClick = function()
		if Dispatch.page < #Dispatch.Boards then
			Dispatch.PopulatePage(Dispatch.Panels.canvas, Dispatch.page + 1)
		else
			Dispatch.PopulatePage(Dispatch.Panels.canvas, 1)
		end
	end
	
	--Icon Browser
	local button = vgui.Create("DButton",bottombar)
	button:SetSize(96,1)
	button:Dock(LEFT)
	button:SetText("Icon Browser")
	button.DoClick = function()
		if not Dispatch.iconbrowser then
			Dispatch.iconbrowser = true
			
			local iconframe = vgui.Create("DFrame")
			iconframe:SetSize(256,384)
			iconframe:SetPos(0,0)
			iconframe:SetScreenLock(true)
			iconframe:SetTitle("Icon Browser")
			iconframe:SetIcon("trakpak3_common/icons/generic_star.png")
			function iconframe:OnClose() Dispatch.iconbrowser = false end
			iconframe:MakePopup()
			
			local copy = vgui.Create("DButton",iconframe)
			copy:SetSize(1,36)
			copy:Dock(BOTTOM)
			copy:SetText("Copy To Clipboard")
			
			local tray = vgui.Create("DPanel",iconframe)
			tray:SetSize(1,48)
			tray:Dock(BOTTOM)
			function tray:Paint() end
			
			local icondisplay = vgui.Create("DImage",tray)
			icondisplay:SetSize(48,1)
			icondisplay:Dock(LEFT)
			
			local icontext = vgui.Create("DTextEntry",tray)
			icontext:Dock(FILL)
			icontext:DockMargin(4,12,4,12)
			icontext:SetDisabled(true)
			
			local scrollbase = vgui.Create("DPanel",iconframe)
			scrollbase:Dock(FILL)
			
			local iconscroll = vgui.Create("DScrollPanel",scrollbase)
			iconscroll:Dock(FILL)
			
			local iconselected = ""
			
			local folderpath = "trakpak3_common/icons/"
			
			local iconlist = {
				"toggle_up",
				"toggle_down",
				"toggle_left",
				"toggle_right",
				
				"generic_blank",
				"generic_up",
				"generic_down",
				"generic_left",
				"generic_right",
				"generic_locked",
				"generic_unlocked",
				"generic_star",
				"generic_plus",
				"generic_minus",
				"generic_exclamation",
				"generic_question",
				
				"generic_a",
				"generic_b",
				"generic_c",
				"generic_d",
				"generic_e",
				"generic_f",
				"generic_g",
				"generic_h",
				"generic_i",
				"generic_j",
				"generic_k",
				"generic_l",
				"generic_m",
				"generic_n",
				"generic_o",
				"generic_p",
				"generic_q",
				"generic_r",
				"generic_s",
				"generic_t",
				"generic_u",
				"generic_v",
				"generic_w",
				"generic_x",
				"generic_y",
				"generic_z",
				
				"generic_0",
				"generic_1",
				"generic_2",
				"generic_3",
				"generic_4",
				"generic_5",
				"generic_6",
				"generic_7",
				"generic_8",
				"generic_9",
				
				"signal_red_n",
				"signal_red_s",
				"signal_red_w",
				"signal_red_e",
				
				"signal_yel_n",
				"signal_yel_s",
				"signal_yel_w",
				"signal_yel_e",
				
				"signal_grn_n",
				"signal_grn_s",
				"signal_grn_w",
				"signal_grn_e",
				
				"signal_lun_n",
				"signal_lun_s",
				"signal_lun_w",
				"signal_lun_e",
				
				"signal_red_n_alt",
				"signal_red_s_alt",
				"signal_red_w_alt",
				"signal_red_e_alt",
				
				"signal_yel_n_alt",
				"signal_yel_s_alt",
				"signal_yel_w_alt",
				"signal_yel_e_alt",
				
				"signal_grn_n_alt",
				"signal_grn_s_alt",
				"signal_grn_w_alt",
				"signal_grn_e_alt",
				
				"signal_lun_n_alt",
				"signal_lun_s_alt",
				"signal_lun_w_alt",
				"signal_lun_e_alt",
				
				"block_clear",
				"block_occupied",
				
				"switch_n_unlit",
				"switch_n_lit",
				"switch_r_unlit",
				"switch_r_lit",
				"switch_x_unlit",
				"switch_x_lit",
				"switch_hourglass_lit"
			}
			local index = 1
			local numicons = #iconlist
			local numrows = math.ceil(numicons/6)
			for n = 1, numrows do
				local row = vgui.Create("DPanel",iconscroll)
				row:SetSize(1,36)
				row:Dock(TOP)
				function row:Paint() end
				for m = 1,6 do
					local ibutton = vgui.Create("DImageButton",row)
					ibutton:SetSize(32,32)
					ibutton:Dock(LEFT)
					ibutton:DockMargin(2,2,2,2)
					local img = iconlist[index]..".png"
					local ifull = folderpath..img
					ibutton:SetImage(ifull)
					ibutton.DoClick = function()
						iconselected = img
						icondisplay:SetImage(ifull)
						icontext:SetValue(img)
					end
					index = index + 1
					if index > numicons then break end
				end
				
			end
			
			copy.DoClick = function()
				SetClipboardText(iconselected)
				LocalPlayer():EmitSound("buttons/button9.wav")
			end
			
		end
	end
	
	--Cursor Coords
	local label = vgui.Create("DLabel",bottombar)
	label:SetSize(96,1)
	label:Dock(RIGHT)
	label:DockMargin(4,4,4,4)
	label:SetContentAlignment(6)
	label:SetTextColor(dark)
	label:SetText("")
	Dispatch.Panels.coord_label = label
	
	local rpanel = vgui.Create("DPanel",frame)
	function rpanel:Paint() end
	rpanel:SetSize(256,1)
	rpanel:Dock(RIGHT)
	
	local lpanel = vgui.Create("DPanel",frame)
	function lpanel:Paint() end
	lpanel:Dock(FILL)
	
	--Help Text
	local help = vgui.Create("DLabel",bottombar)
	help:Dock(FILL)
	help:SetText("")
	help:SetContentAlignment(5)
	help:SetTextColor(dark)
	help:SetFont("tp3_dispatch_2")
	Dispatch.Panels.help = help
	
	--The Main Area (Canvas)
	
	local backing = vgui.Create("DImage",lpanel)
	backing:Dock(FILL)
	backing:SetImage("trakpak3_common/icons/backing.png")
	backing:SetKeepAspect(false)
	Dispatch.Panels.backing = backing
	
	--Canvas
	local canvas = vgui.Create("DButton",lpanel)
	Dispatch.Panels.canvas = canvas
	canvas:Dock(FILL)
	
	canvas:SetText("")
	
	function canvas:GetPanelCoords(gx, gy) --convert grid coords to panel coords
		local sx, sy = self:GetSize()
		local rx, ry = Dispatch.Boards[Dispatch.page].x_res, Dispatch.Boards[Dispatch.page].y_res
		
		return sx*gx/rx, sy*gy/ry
	end
	
	function canvas:GetGridCoords(px, py) --convert panel coords to grid coords
		local sx, sy = self:GetSize()
		local rx, ry = Dispatch.Boards[Dispatch.page].x_res, Dispatch.Boards[Dispatch.page].y_res
		
		local gx = math.Round(rx*px/sx)
		local gy = math.Round(ry*py/sy)
		
		return math.Clamp(gx,0,rx), math.Clamp(gy,0,ry)
	end
	
	--Click the background
	function canvas:DoClick()
		if Dispatch.placing==1 then --First click when placing
			if (Dispatch.placetype=="line") or (Dispatch.placetype=="blockline") or (Dispatch.placetype=="box") or (Dispatch.placetype=="text") then
				Dispatch.placex, Dispatch.placey = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.placing = 2
			elseif Dispatch.placetype=="signal" then
				local x, y = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.AddSignal(nil, x, y)
				self:DoRightClick()
			elseif Dispatch.placetype=="switch" then
				local x, y = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.AddSwitch(nil, x, y)
				self:DoRightClick()
			elseif Dispatch.placetype=="block" then
				local x, y = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.AddBlock(nil, x, y)
				self:DoRightClick()
			elseif Dispatch.placetype=="proxy" then
				local x, y = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.AddProxy(nil, x, y)
				self:DoRightClick()
			end
		elseif Dispatch.placing==2 then --Second click when placing
			if Dispatch.placetype=="line" then
				local x2, y2 = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.AddLine(nil, Dispatch.placex, Dispatch.placey, x2, y2)
				self:DoRightClick()
			elseif Dispatch.placetype=="blockline" then
				local x2, y2 = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.AddBlockLine(nil, Dispatch.placex, Dispatch.placey, x2, y2)
				self:DoRightClick()
			elseif Dispatch.placetype=="box" then
				local x2, y2 = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.AddBox(nil, Dispatch.placex, Dispatch.placey, x2, y2)
				self:DoRightClick()
			elseif Dispatch.placetype=="text" then
				local x2, y2 = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.AddText(nil, Dispatch.placex, Dispatch.placey, x2, y2)
				self:DoRightClick()
			end
		elseif Dispatch.editing==1 then --First click when editing
			
		elseif Dispatch.editing==2 then --Second click when editing
			if (Dispatch.placetype=="line") or (Dispatch.placetype=="blockline") or (Dispatch.placetype=="box") or (Dispatch.placetype=="text") then
				local x2, y2 = self:GetGridCoords(self:LocalCursorPos())
				Dispatch.Boards[Dispatch.page].elements[Dispatch.selected]:Update(true, Dispatch.placex, Dispatch.placey, x2, y2)
				self:DoRightClick()
			elseif (Dispatch.placetype=="signal") or (Dispatch.placetype=="switch") or (Dispatch.placetype=="block") or (Dispatch.placetype=="proxy") then
				local x, y = self:GetGridCoords(self:LocalCursorPos())
				--print(Dispatch.page, Dispatch.selected)
				Dispatch.Boards[Dispatch.page].elements[Dispatch.selected]:Update(true, x, y)
				self:DoRightClick()
			end
		else --Deselect
			Dispatch.Deselect()
			--Dispatch.PopulatePage()
		end
	end
	
	function canvas:DoRightClick()
		if Dispatch.editing or Dispatch.placing then
			Dispatch.placex = nil
			Dispatch.placey = nil
			Dispatch.placing = nil
			Dispatch.editing = nil
			Dispatch.PopulatePage(self)
		else
			Dispatch.Deselect()
		end
	end
	
	--Render the Dispatch board
	function canvas:Paint(w, h)
		local page = Dispatch.page
		local board = Dispatch.Boards[page]
		if page > 0 then
			draw.NoTexture()
			--Draw Grid
			if Dispatch.showgrid then
				for gy = 0, board.y_res do
					for gx = 0, board.x_res do
						surface.SetDrawColor(gray)
						local cx, cy = self:GetPanelCoords(gx, gy)
						surface.DrawRect(cx-1, cy-1, 2, 2)
					end
				end
			end
			
			--Update Cursor Coordinates
			local mx, my = self:GetGridCoords(self:LocalCursorPos())
			Dispatch.Panels.coord_label:SetText("( "..mx..", "..my..")")
			
			local cx, cy = self:GetPanelCoords(mx, my)
			
			if (Dispatch.placing==1) or (Dispatch.editing==1) then -- First cursor
				surface.SetDrawColor(cursor1)
				surface.DrawOutlinedRect(cx - 4, cy - 4, 8, 8)
			elseif ((Dispatch.placing==2) or (Dispatch.editing==2)) and Dispatch.placex and Dispatch.placey then -- First cursor and second cursor
				local px, py = self:GetPanelCoords(Dispatch.placex, Dispatch.placey)
				surface.SetDrawColor(cursor2)
				surface.DrawOutlinedRect(px-5, py-5, 10, 10)
				if (Dispatch.placetype=="box") or (Dispatch.placetype=="text") then
				
					local minx = math.min(px, cx)
					local miny = math.min(py, cy)
					
					local sizex = math.abs(cx - px)
					local sizey = math.abs(cy - py)
					
					surface.DrawOutlinedRect(minx, miny, sizex + 1, sizey + 1, 1)
				else
					surface.DrawLine(px, py, cx, cy)
				end
				
				surface.SetDrawColor(cursor1)
				surface.DrawOutlinedRect(cx-4, cy-4, 8, 8)
			end
			
			--Render
			for k, element in pairs(board.elements) do
				element:Render(self, Dispatch.placing or Dispatch.hidehelpers, (Dispatch.selected==k))
			end
		end
	end
	
	
	--Populate Page
	timer.Simple(0.1, function() Dispatch.PopulatePage(canvas) end)
	
	--Add Elements Frame
	local epanel = vgui.Create("DPanel",rpanel)
	epanel:SetSize(1,320)
	epanel:Dock(TOP)
	local label = vgui.Create("DLabel",epanel)
	label:SetSize(1,24)
	label:SetText("Add Elements")
	label:SetContentAlignment(5)
	--label:SetTextColor(dark)
	function epanel:Paint() end
	label:Dock(TOP)
	
	--Element Buttons
	local scroll = vgui.Create("DScrollPanel",epanel)
	scroll:Dock(FILL)
	--Signal
	local button = vgui.Create("DButton",scroll)
	button:SetSize(1,36)
	button:Dock(TOP)
	button:SetText("Signal")
	button:SetIcon("trakpak3_common/icons/signal_red_n.png")
	function button:DoClick()
		Dispatch.Deselect()
		Dispatch.placing = 1
		Dispatch.placetype = "signal"
		Dispatch.PopulatePage(canvas, Dispatch.page, true)
	end
	
	--Switch
	local button = vgui.Create("DButton",scroll)
	button:SetSize(1,36)
	button:Dock(TOP)
	button:SetText("Switch")
	button:SetIcon("trakpak3_common/icons/switch_n_lit.png")
	function button:DoClick()
		Dispatch.Deselect()
		Dispatch.placing = 1
		Dispatch.placetype = "switch"
		Dispatch.PopulatePage(canvas, Dispatch.page, true)
	end
	
	--Block
	local button = vgui.Create("DButton",scroll)
	button:SetSize(1,36)
	button:Dock(TOP)
	button:SetText("Block Detector")
	button:SetIcon("trakpak3_common/icons/block_occupied.png")
	function button:DoClick()
		Dispatch.Deselect()
		Dispatch.placing = 1
		Dispatch.placetype = "block"
		Dispatch.PopulatePage(canvas, Dispatch.page, true)
	end
	
	--Proxy
	local button = vgui.Create("DButton",scroll)
	button:SetSize(1,36)
	button:Dock(TOP)
	button:SetText("Dispatch Proxy")
	button:SetIcon("trakpak3_common/icons/generic_star.png")
	function button:DoClick()
		Dispatch.Deselect()
		Dispatch.placing = 1
		Dispatch.placetype = "proxy"
		Dispatch.PopulatePage(canvas, Dispatch.page, true)
	end
	
	--Line
	local button = vgui.Create("DButton",scroll)
	button:SetSize(1,36)
	button:Dock(TOP)
	button:SetText("Track Line")
	button:SetIcon("trakpak3_common/icons/line.png")
	function button:DoClick()
		Dispatch.Deselect()
		Dispatch.placing = 1
		Dispatch.placetype = "line"
		Dispatch.PopulatePage(canvas, Dispatch.page, true)
	end
	
	--Block Line
	local button = vgui.Create("DButton",scroll)
	button:SetSize(1,36)
	button:Dock(TOP)
	button:SetText("Track Line\n(Block Detector)")
	button:SetIcon("trakpak3_common/icons/block_line.png")
	function button:DoClick()
		Dispatch.Deselect()
		Dispatch.placing = 1
		Dispatch.placetype = "blockline"
		Dispatch.PopulatePage(canvas, Dispatch.page, true)
	end
	
	--Box
	local button = vgui.Create("DButton",scroll)
	button:SetSize(1,36)
	button:Dock(TOP)
	button:SetText("Box")
	button:SetIcon("trakpak3_common/icons/box.png")
	function button:DoClick()
		Dispatch.Deselect()
		Dispatch.placing = 1
		Dispatch.placetype = "box"
		Dispatch.PopulatePage(canvas, Dispatch.page, true)
	end
	
	--Label
	local button = vgui.Create("DButton",scroll)
	button:SetSize(1,36)
	button:Dock(TOP)
	button:SetText("Label")
	button:SetIcon("trakpak3_common/icons/text.png")
	function button:DoClick()
		Dispatch.Deselect()
		Dispatch.placing = 1
		Dispatch.placetype = "text"
		Dispatch.PopulatePage(canvas, Dispatch.page, true)
	end
	
	--Properties Panel
	
	local ppanel = vgui.Create("DPanel", rpanel)
	Dispatch.Panels.ppanel = ppanel
	ppanel:Dock(FILL)
	function ppanel:Paint() end
	
	local label = vgui.Create("DLabel", ppanel)
	label:SetSize(1,24)
	label:Dock(TOP)
	label:SetText("Element Properties")
	label:SetContentAlignment(5)
	--label:SetTextColor(dark)
	
	--Kill Element Button
	local button = vgui.Create("DButton",ppanel)
	button:SetSize(1,36)
	button:Dock(BOTTOM)
	button:SetText("Delete Selected Element")
	button:SetImage("icon16/delete.png")
	function button:DoClick()
		if Dispatch.selected then
			Dispatch.DeleteElement(Dispatch.selected)
		end
	end
	
	--Completely Unnecessary "Ok" Button
	local button = vgui.Create("DButton",ppanel)
	button:SetSize(1,36)
	button:Dock(BOTTOM)
	button:SetText("Confirm & Deselect")
	button:SetImage("icon16/accept.png")
	function button:DoClick()
		if Dispatch.selected then
			Dispatch.Deselect()
		end
	end
	
	--[[
	--Horizontal Divider to group everything together
	local div = vgui.Create("DHorizontalDivider",frame)
	Dispatch.Panels.div = div
	div:Dock(FILL)
	div:SetLeft(lpanel)
	div:SetRight(rpanel)
	local fw = frame:GetSize()
	div:SetLeftWidth(fw-256)
	div:SetLeftMin(ScrW()*0.25)
	div:SetRightMin(192)
	]]--
end



--Create all the elements on the page
function Dispatch.PopulatePage(canvas, page, nohelpers)
	local editor = Dispatch.Panels.editor
	--Set Labels and Boxes
	if page then
		if (page != Dispatch.page) and editor then
			--print("Page Switch, deselecting p"..Dispatch.page.." element #"..(Dispatch.selected or "nil"))
			Dispatch.Deselect()
		end
		Dispatch.page = page
	else
		page = Dispatch.page
	end
	
	local Board = Dispatch.Boards[page]
	if Board then
		local name = Board.name
		local bcolor = Board.color or "95 95 95"
		Dispatch.Panels.pagelabel:SetText(name.." ("..page.."/"..#Dispatch.Boards..")")
		if editor then
			local xv, yv = Dispatch.Panels.xbox:GetValue(), Dispatch.Panels.ybox:GetValue()
			if xv != Board.x_res then Dispatch.Panels.xbox:SetValue(Board.x_res) end
			if yv != Board.y_res then Dispatch.Panels.ybox:SetValue(Board.y_res) end
			Dispatch.Panels.colorbox:SetValue(bcolor)
			Dispatch.Panels.xbox:SetDisabled(false)
			Dispatch.Panels.ybox:SetDisabled(false)
			Dispatch.Panels.gridbutton:SetDisabled(false)
			Dispatch.Panels.helperbutton:SetDisabled(false)
			Dispatch.Panels.canvas:SetDisabled(false)
			Dispatch.Panels.colorbox:SetDisabled(false)
			
			--Help Text
			local help = Dispatch.Panels.help
			if Dispatch.placing then
				help:SetText("Left Click to place item ("..Dispatch.placetype.."), Right Click to Cancel.")
			elseif Dispatch.editing then
				help:SetText("Left Click to move item ("..Dispatch.placetype.."), Right Click to Cancel.")
			elseif Dispatch.selected then
				help:SetText("Left Click on the selected object again to move it.")
			else
				help:SetText("")
			end
		end
		Dispatch.Panels.backing:SetImageColor(Dispatch.StringToColor(bcolor))
	else
		Dispatch.Panels.pagelabel:SetText("No Boards")
		if editor then
			Dispatch.Panels.coord_label:SetText("")
			Dispatch.Panels.xbox:SetDisabled(true)
			Dispatch.Panels.ybox:SetDisabled(true)
			Dispatch.Panels.gridbutton:SetDisabled(true)
			Dispatch.Panels.helperbutton:SetDisabled(true)
			Dispatch.Panels.canvas:SetDisabled(true)
			Dispatch.Panels.colorbox:SetDisabled(true)
			
			Dispatch.Panels.help:SetText("")
		end
	end
		
	
	--Fill Canvas
	nohelpers = nohelpers or Dispatch.hidehelpers
	--local canvas = Dispatch.Panels.canvas
	canvas:Clear()
	if Board then
		for k, element in pairs(Board.elements) do
			local selected = (Dispatch.selected==k)
			element:Generate(canvas,nohelpers,selected,Dispatch.Panels.editor)
			--print("Generating Element, type "..element.type)
			if Dispatch.Panels.editor then element:GenerateEditor(canvas,nohelpers,selected) end
		end
	end
end

--Populate Properties Table
function Dispatch.DisplayProperties(element)
	local ptable = Dispatch.Panels.ptable
	if ptable and ptable:IsValid() then ptable:Remove() end
	
	timer.Simple(0.1, function()
		ptable = vgui.Create("DProperties",Dispatch.Panels.ppanel)
		Dispatch.Panels.ptable = ptable
		ptable:Dock(FILL)
		--PrintTable(element.mins)
		--PrintTable(element.maxs)
		for n = 1, #element.proporder do
			local k = element.proporder[n]
			local dt = element.properties[k]
			local row = ptable:CreateRow("Properties",k)
			
			function row:DataChanged(val)
				element[k] = val
				element:Update(false)
			end
			
			if dt=="integer" then
				row:Setup("Int", {min = element.mins[k], max = element.maxs[k]})
				function row:DataChanged(val)
					val = math.Round(val)
					row:SetValue(val)
					element[k] = val
					element:Update(false)
				end
			elseif dt=="float" then
				row:Setup("Float", {min = element.mins[k], max = element.maxs[k]})
			elseif dt=="boolean" then
				row:Setup("Boolean")
				function row:DataChanged(val)
					val = val==1
					element[k] = val
					element:Update(false)
				end
			elseif dt=="string" then
				row:Setup("Generic")
			elseif dt=="choices" then
				row:Setup("Combo",{ text = "pootis" })
				for i = 1, #element.choices[k] do
					row:AddChoice(element.choices[k][i],element.values[k][i])
				end
			end
			
			row:SetValue(element[k])
			
		end
	end)
end

--Select & Deselect
function Dispatch.Select(id, newprop)
	if Dispatch.selected then
		--print("Currently Selected: "..Dispatch.selected)
		if Dispatch then
			if Dispatch.Boards then
				if Dispatch.Boards[Dispatch.page] then
					if Dispatch.Boards[Dispatch.page].elements then
						if Dispatch.Boards[Dispatch.page].elements[Dispatch.selected] then
							Dispatch.Boards[Dispatch.page].elements[Dispatch.selected]:OnDeselect(Dispatch.Panels.editor)
						else print("Element is Nil.") end
					else print("Element Table is Nil.") end
				else print("Page Table is Nil.") end
			else print("Boards Table is Nil.") end
		else print("Dispatch Table is Nil. You're fucked.") end
				
		
	else
		--print("Nothing is selected.")
	end
	Dispatch.selected = id
	--print("Selected: ",Dispatch.selected)
	
	--Help Text
	if Dispatch.Panels.editor then
		Dispatch.Panels.help:SetText("Left Click on the selected object again to move it.")
		--print("AAA")
	end
	
	local element = Dispatch.Boards[Dispatch.page].elements[Dispatch.selected]
	element:OnSelect(Dispatch.Panels.editor)
	if newprop and Dispatch.Panels.editor then Dispatch.DisplayProperties(element) end
end

function Dispatch.Deselect()
	if Dispatch.selected then
		--print("Currently Selected: "..Dispatch.selected)
		if Dispatch then
			if Dispatch.Boards then
				if Dispatch.Boards[Dispatch.page] then
					if Dispatch.Boards[Dispatch.page].elements then
						if Dispatch.Boards[Dispatch.page].elements[Dispatch.selected] then
							Dispatch.Boards[Dispatch.page].elements[Dispatch.selected]:OnDeselect(Dispatch.Panels.editor)
						else print("Element is Nil.") end
					else print("Element Table is Nil.") end
				else print("Page Table is Nil.") end
			else print("Boards Table is Nil.") end
		else print("Dispatch Table is Nil. You're fucked.") end
		
		
	else
		--print("Nothing is selected.")
	end
	Dispatch.selected = nil
	Dispatch.editing = nil
	Dispatch.placing = nil
	
	--Help Text
	if Dispatch.Panels.editor then
		Dispatch.Panels.help:SetText("")
	end
	
	--Clear properties table
	local ptable = Dispatch.Panels.ptable
	if ptable and ptable:IsValid() then ptable:Remove() end
end

--Element Creation/Destruction
function Dispatch.CreateHandle(gx, gy, pnl)
	local button = vgui.Create("DButton",pnl)
	button:SetSize(16,16)
	local cx, cy = pnl:GetPanelCoords(gx,gy)
	button:SetPos(cx - 8, cy - 8)
	--button:SetBGColor(Color(255,255,255,127))
	button:SetAlpha(95)
	button:SetText("")
	--print(cx, cy)
	return button
end
function Dispatch.AddElement(ent)
	local element = {}
	
	local board
	if ent then
		board = ent.Boards[Dispatch.page]
		element.entity = ent
	else
		board = Dispatch.Boards[Dispatch.page]
	end
	function element:Update() end --Set properties and select
	function element:Render() end --Called every frame
	function element:Generate(canvas, nohelpers, selected, editor) end --Called once for both editor and regular
	function element:GenerateEditor(canvas, nohelpers, selected) end --Called once for editor only
	function element:GetIndex() --Return this element's index in the elements table
		for n = 1, #board.elements do
			if board.elements[n] == self then return n end
		end
	end
	function element:OnSelect(editor) end --Select/Deselect functions
	function element:OnDeselect(editor) end
	function element:OnUse() end --Function to fire when the user clicks this element's button/whatever
	function element:UpdateValue() end --Called when an element in the world changes state
	element.type = "null"
	element.properties = {}
	element.proporder = {}
	element.mins = {}
	element.maxs = {}
	element.choices = {}
	element.values = {}
	local id = #board.elements + 1
	board.elements[id] = element
	return element
end

function Dispatch.DeleteElement(id)
	Dispatch.Deselect()
	table.remove(Dispatch.Boards[Dispatch.page].elements,id)
	Dispatch.PopulatePage(Dispatch.Panels.canvas)
end
--Create Signal
function Dispatch.AddSignal(ent, x, y, orientation, signal, style)
	local element = Dispatch.AddElement(ent)
	element.type = "signal"
	element.proporder = { "x", "y", "orientation", "signal", "style" }
	element.properties = {
		x = "integer",
		y = "integer",
		orientation = "choices",
		signal = "string",
		style = "boolean"
	}
	element.mins = {
		x = 0,
		y = 0
	}
	element.maxs = {
		x = Dispatch.Boards[Dispatch.page].x_res,
		y = Dispatch.Boards[Dispatch.page].y_res
	}
	element.choices = {
		orientation = { "^", "v", ">", "<" } --Lua auto-sorts these into a nice order in the combo box
	}
	element.values = {
		orientation = { 1, 2, 3, 4 }
	}
	function element:OnSelect(editor)
		local button = self.button
		local canvas = button:GetParent()
		local e = self
		
		if editor then
			--Update Image
			local dt = {"n", "s", "e", "w"}
			local dir = dt[self.orientation]
			local alt = ""
			if self.style then alt = "_alt" end
			button:SetImage("trakpak3_common/icons/signal_red_"..dir..alt..".png")
			
			--Set function to set up movement
			function button:DoClick()
				Dispatch.editing = 2
				Dispatch.placex = e.x
				Dispatch.placey = e.y
				Dispatch.placetype = "signal"
				Dispatch.PopulatePage(canvas, Dispatch.page, true)
			end
		else
			local mpanel = vgui.Create("DPanel",canvas)
			mpanel:SetSize(96,144)
			local cx, cy, sx, sy = button:GetBounds() --Button Pos (relative to canvas) and size
			local psx, psy = canvas:GetSize() --Canvas Size
			
			cx = cx + sx/2
			cy = cy + sy/2
			
			--Adjust position of CTC menu to ensure it doesn't go off screen
			if cx > (psx - 96) then cx = psx - 96 end
			if cy > (psy - 144) then cy = psy - 144 end
			
			mpanel:SetPos(cx,cy)
			self.menu = mpanel
			
			local button = vgui.Create("DButton",mpanel)
			button:SetSize(1,36)
			button:Dock(TOP)
			button:SetText("Hold")
			button:SetImage("trakpak3_common/icons/signal_red_n.png")
			function button:DoClick()
				Dispatch.SendCommand(e.signal, "set_ctc", 0)
				--mpanel:Remove()
				--self.menu = nil
				Dispatch.Deselect()
			end
			
			local button = vgui.Create("DButton",mpanel)
			button:SetSize(1,36)
			button:Dock(TOP)
			button:SetText("Once")
			button:SetImage("trakpak3_common/icons/signal_yel_n.png")
			function button:DoClick()
				Dispatch.SendCommand(e.signal, "set_ctc", 1)
				--mpanel:Remove()
				--self.menu = nil
				Dispatch.Deselect()
			end
			
			local button = vgui.Create("DButton",mpanel)
			button:SetSize(1,36)
			button:Dock(TOP)
			button:SetText("Allow")
			button:SetImage("trakpak3_common/icons/signal_grn_n.png")
			function button:DoClick()
				Dispatch.SendCommand(e.signal, "set_ctc", 2)
				--mpanel:Remove()
				--self.menu = nil
				Dispatch.Deselect()
			end
			
			local button = vgui.Create("DButton",mpanel)
			button:SetSize(1,36)
			button:Dock(TOP)
			button:SetText("Force")
			button:SetImage("trakpak3_common/icons/signal_lun_n.png")
			function button:DoClick()
				Dispatch.SendCommand(e.signal, "set_ctc", 3)
				--mpanel:Remove()
				--self.menu = nil
				Dispatch.Deselect()
			end
		end
	end
	function element:OnDeselect(editor)
		local button = self.button
		local e = self
		if editor then
			--Update Image
			local dt = {"n", "s", "e", "w"}
			local dir = dt[self.orientation]
			local alt = ""
			if self.style then alt = "_alt" end
			button:SetImage("trakpak3_common/icons/signal_red_"..dir..alt..".png")
			
			--Setup function to select again
			function button:DoClick()
				if self.entity then self.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
			end
		else
			if self.menu and self.menu:IsValid() then
				self.menu:Remove()
				self.menu = nil
			end
		end
		
	end
	
	function element:Update(newprop, x, y, orientation, signal, style) 
		self.x = x or self.x
		self.y = y or self.y
		self.orientation = orientation or self.orientation or 1
		self.signal = signal or self.signal or ""
		
		if style != nil then self.style = style end
		
		if Dispatch.selectnew then timer.Simple(0.1,function() Dispatch.Select(self:GetIndex(),newprop) end) end
	end
	
	function element:Generate(pnl,nohelpers,selected,editor)
		local button = vgui.Create("DImageButton",pnl)
		self.button = button
		button:SetSize(Dispatch.elementsize,Dispatch.elementsize)
		local px, py = pnl:GetPanelCoords(self.x, self.y)
		button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2)
		local dt = {"n", "s", "e", "w"}
		local dir = dt[self.orientation]
		local alt = ""
		if self.style then alt = "_alt" end
		if editor then
			button:SetImage("trakpak3_common/icons/signal_red_"..dir..alt..".png")
		else
			if self.signal and (self.signal!="") then
				local sig = Dispatch.RealData[self.signal]
				if sig then
					local state = sig.ctc_state
					if state==0 then --Hold
						button:SetImage("trakpak3_common/icons/signal_red_"..dir..alt..".png")
					elseif state==1 then --Once
						button:SetImage("trakpak3_common/icons/signal_yel_"..dir..alt..".png")
					elseif state==2 then --Allow
						button:SetImage("trakpak3_common/icons/signal_grn_"..dir..alt..".png")
					elseif state==3 then --Force
						button:SetImage("trakpak3_common/icons/signal_lun_"..dir..alt..".png")
					end
				else
					ErrorNoHalt("[Trakpak3] Dispatch Board Signal name '"..self.signal.."' does not match an existing entity.")
				end
			else
				ErrorNoHalt("[Trakpak3] Attempted to generate a Dispatch Board Signal with no signal name.")
			end
		end
		
		local e = self
		function button:DoClick() 
			if e.entity then e.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
		end
	end
	
	function element:GenerateEditor(pnl,nohelpers,selected)
		local button = self.button
		if button and button:IsValid() then
			if nohelpers then
				function button.DoClick() pnl:DoClick() end
			else
				local e = self
				function button:DoClick() 
					Dispatch.Select(e:GetIndex(),true)
				end
			end
		end
		element.maxs = {
			x = Dispatch.Boards[Dispatch.page].x_res,
			y = Dispatch.Boards[Dispatch.page].y_res
		}
	end
	
	function element:Render(pnl)
		--Update Pos
		local px, py = pnl:GetPanelCoords(self.x, self.y)
		local size = Dispatch.elementsize
		if self.button and self.button:IsValid() then self.button:SetPos(px - size/2, py - size/2) end
		
		if Dispatch.Panels.editor and (Dispatch.selected == self:GetIndex()) then
			surface.SetDrawColor(color_sel)
			surface.DrawOutlinedRect(px - size/2 - 2, py - size/2 - 2, size + 4, size + 4, 2)
		end
	end
	
	--Receive Info from World (CTC State)
	function element:UpdateValue(name, parm, value)
		if (name==self.signal) and (parm=="ctc_state") then
			local button = self.button
			if button and button:IsValid() then
				local dt = {"n", "s", "e", "w"}
				local dir = dt[self.orientation]
				local alt = ""
				if self.style then alt = "_alt" end
				if value==0 then --Hold
					button:SetImage("trakpak3_common/icons/signal_red_"..dir..alt..".png")
				elseif value==1 then --Once
					button:SetImage("trakpak3_common/icons/signal_yel_"..dir..alt..".png")
				elseif value==2 then --Allow
					button:SetImage("trakpak3_common/icons/signal_grn_"..dir..alt..".png")
				else --Force
					button:SetImage("trakpak3_common/icons/signal_lun_"..dir..alt..".png")
				end
			end
		end
	end
	
	element:Update(true,x,y,orientation,signal,style)
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

--Create Switch
function Dispatch.AddSwitch(ent, x, y, switch)
	local element = Dispatch.AddElement(ent)
	element.type = "switch"
	element.proporder = { "x", "y", "switch" }
	element.properties = {
		x = "integer",
		y = "integer",
		switch = "string"
	}
	element.mins = {
		x = 0,
		y = 0
	}
	element.maxs = {
		x = Dispatch.Boards[Dispatch.page].x_res,
		y = Dispatch.Boards[Dispatch.page].y_res
	}
	function element:OnSelect(editor)
		local button = self.button
		local canvas = button:GetParent()
		
		--Update Image
		--button:SetImage("trakpak3_common/icons/switch_r_lit.png")
		
		--Set function to set up movement
		local e = self
		function button:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x
			Dispatch.placey = e.y
			Dispatch.placetype = "switch"
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
	end
	function element:OnDeselect()
		local button = self.button
		--Update Image
		--button:SetImage("trakpak3_common/icons/switch_n_lit.png")
		
		--Setup function to select again
		local e = self
		function button:DoClick()
			if e.entity then e.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
		end
	end
	
	function element:Update(newprop, x, y, switch) 
		self.x = x or self.x
		self.y = y or self.y
		self.switch = switch or self.switch or ""
		if Dispatch.selectnew then timer.Simple(0.1,function() Dispatch.Select(self:GetIndex(),newprop) end) end
	end
	
	function element:Generate(pnl,nohelpers,selected,editor)
		local button = vgui.Create("DImageButton",pnl)
		self.button = button
		button:SetSize(Dispatch.elementsize,Dispatch.elementsize)
		local px, py = pnl:GetPanelCoords(self.x, self.y)
		button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2)
		if editor then
			if selected then 
				button:SetImage("trakpak3_common/icons/switch_r_lit.png")
			else
				button:SetImage("trakpak3_common/icons/switch_n_lit.png")
			end
		else
			local state = 0
			local blocked = 0
			local broken = 0
			if self.switch and (self.switch!="") then
				local sig = Dispatch.RealData[self.switch]
				if sig then
					state = sig["state"]
					blocked = sig["blocked"]
					broken = sig["broken"]
					
					if (broken==1) and (blocked==1) then --Broken Blocked
						button:SetImage("trakpak3_common/icons/switch_x_unlit.png")
					elseif (broken==1) then --Broken Clear
						button:SetImage("trakpak3_common/icons/switch_x_lit.png")
					elseif (state==0) and (blocked==1) then --MN Blocked
						button:SetImage("trakpak3_common/icons/switch_n_unlit.png")
					elseif (state==0) then --MN Clear
						button:SetImage("trakpak3_common/icons/switch_n_lit.png")
					elseif (state==1) and (blocked==1) then --DV Blocked
						button:SetImage("trakpak3_common/icons/switch_r_unlit.png")
					elseif (state==1) then --DV Clear
						button:SetImage("trakpak3_common/icons/switch_r_lit.png")
					elseif (state==2) then --Moving
						button:SetImage("trakpak3_common/icons/switch_hourglass_lit.png")
					end
				else
					ErrorNoHalt("[Trakpak3] Dispatch Board Switch name '"..self.switch.."' does not match an existing entity.")
				end
			else
				ErrorNoHalt("[Trakpak3] Attempted to generate a Dispatch Board Switch with no switch name.")
			end
			
		end
		local e = element
		function button:DoClick()
			if e.switch and (e.switch!="") then
				local state = Dispatch.RealData[e.switch]["state"]
				local blocked = Dispatch.RealData[e.switch]["blocked"]
				local broken = Dispatch.RealData[e.switch]["broken"]
				
				if (blocked==0) and (broken==0) then
					if state==0 then
						Dispatch.SendCommand(e.switch, "throw", 1)
					elseif state==1 then
						Dispatch.SendCommand(e.switch, "throw", 0)
					end
				end
			end
		end
	end
	
	function element:GenerateEditor(pnl,nohelpers,selected)
		local button = self.button
		if button and button:IsValid() then
			if nohelpers then
				function button.DoClick() pnl:DoClick() end
			else
				local e = self
				function button:DoClick() 
					Dispatch.Select(e:GetIndex(),true)
				end
			end
		end
		element.maxs = {
			x = Dispatch.Boards[Dispatch.page].x_res,
			y = Dispatch.Boards[Dispatch.page].y_res
		}
	end
	
	function element:Render(pnl)
		--Update Pos
		local px, py = pnl:GetPanelCoords(self.x, self.y)
		local size = Dispatch.elementsize
		if self.button and self.button:IsValid() then self.button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2) end
		if Dispatch.Panels.editor and (Dispatch.selected == self:GetIndex()) then
			surface.SetDrawColor(color_sel)
			surface.DrawOutlinedRect(px - size/2 - 2, py - size/2 - 2, size + 4, size + 4, 2)
		end
	end
	
	--Receive Info from World (State and Occupancy)
	function element:UpdateValue(name, parm, value)
		if (name==self.switch) then
			local button = self.button
			if button and button:IsValid() then
				local state
				local blocked
				local broken
				if parm=="state" then
					state = value
					blocked = Dispatch.RealData[name]["blocked"] or 0
					broken = Dispatch.RealData[name]["broken"] or 0
				elseif parm=="blocked" then
					state = Dispatch.RealData[name]["state"] or 0
					blocked = value
					broken = Dispatch.RealData[name]["broken"] or 0
				elseif parm=="broken" then
					state = Dispatch.RealData[name]["state"] or 0
					blocked = Dispatch.RealData[name]["blocked"] or 0
					broken = value
				end
				
				if (broken==1) and (blocked==1) then --Broken Blocked
					button:SetImage("trakpak3_common/icons/switch_x_unlit.png")
				elseif (broken==1) then --Broken Clear
					button:SetImage("trakpak3_common/icons/switch_x_lit.png")
				elseif (state==0) and (blocked==1) then --MN Blocked
					button:SetImage("trakpak3_common/icons/switch_n_unlit.png")
				elseif (state==0) then --MN Clear
					button:SetImage("trakpak3_common/icons/switch_n_lit.png")
				elseif (state==1) and (blocked==1) then --DV Blocked
					button:SetImage("trakpak3_common/icons/switch_r_unlit.png")
				elseif (state==1) then --DV Clear
					button:SetImage("trakpak3_common/icons/switch_r_lit.png")
				elseif (state==2) then --Moving
					button:SetImage("trakpak3_common/icons/switch_hourglass_lit.png")
				end
				
			end
		end
	end
	
	element:Update(true,x,y,switch)
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

--Create Block Detector
function Dispatch.AddBlock(ent, x, y, block)
	local element = Dispatch.AddElement(ent)
	element.type = "block"
	element.proporder = { "x", "y", "block" }
	element.properties = {
		x = "integer",
		y = "integer",
		block = "string"
	}
	element.mins = {
		x = 0,
		y = 0
	}
	element.maxs = {
		x = Dispatch.Boards[Dispatch.page].x_res,
		y = Dispatch.Boards[Dispatch.page].y_res
	}
	function element:OnSelect(editor)
		local button = self.button
		local canvas = button:GetParent()
		
		--Update Image
		--button:SetImage("trakpak3_common/icons/block_occupied.png")
		
		--Set function to set up movement
		local e = self
		function button:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x
			Dispatch.placey = e.y
			Dispatch.placetype = "block"
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
	end
	function element:OnDeselect()
		local button = self.button
		--Update Image
		--button:SetImage("trakpak3_common/icons/block_clear.png")
		
		--Setup function to select again
		local e = self
		function button:DoClick()
			if e.entity then e.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
		end
	end
	
	function element:Update(newprop, x, y, block) 
		self.x = x or self.x
		self.y = y or self.y
		self.block = block or self.block or ""
		if Dispatch.selectnew then timer.Simple(0.1,function() Dispatch.Select(self:GetIndex(),newprop) end) end
	end
	
	function element:Generate(pnl,nohelpers,selected,editor)
		local button = vgui.Create("DImageButton",pnl)
		self.button = button
		button:SetSize(Dispatch.elementsize,Dispatch.elementsize)
		local px, py = pnl:GetPanelCoords(self.x, self.y)
		button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2)
		if editor then
			if selected then 
				button:SetImage("trakpak3_common/icons/block_occupied.png")
			else
				button:SetImage("trakpak3_common/icons/block_clear.png")
			end
		else
			if self.block and (self.block!="") then
				local block = Dispatch.RealData[self.block]
				if block then
					if (block.occupied==1) then 
						button:SetImage("trakpak3_common/icons/block_occupied.png")
					else
						button:SetImage("trakpak3_common/icons/block_clear.png")
					end
				else
					ErrorNoHalt("[Trakpak3] Dispatch Board Block name '"..self.block.."' does not match an existing entity.")
				end
			else
				ErrorNoHalt("[Trakpak3] Attempted to generate a Dispatch Board Block Detector with no block name.")
			end
			
		end
	end
	
	function element:GenerateEditor(pnl,nohelpers,selected)
		local button = self.button
		if button and button:IsValid() then
			if nohelpers then
				function button.DoClick() pnl:DoClick() end
			else
				local e = self
				function button:DoClick() 
					Dispatch.Select(e:GetIndex(),true)
				end
			end
		end
		element.maxs = {
			x = Dispatch.Boards[Dispatch.page].x_res,
			y = Dispatch.Boards[Dispatch.page].y_res
		}
	end
	
	function element:Render(pnl)
		--Update Pos
		local px, py = pnl:GetPanelCoords(self.x, self.y)
		local size = Dispatch.elementsize
		if self.button and self.button:IsValid() then self.button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2) end
		if Dispatch.Panels.editor and (Dispatch.selected == self:GetIndex()) then
			surface.SetDrawColor(color_sel)
			surface.DrawOutlinedRect(px - size/2 - 2, py - size/2 - 2, size + 4, size + 4, 2)
		end
	end
	
	--Receive Info from World (Occupancy)
	function element:UpdateValue(name, parm, value)
		if (name==self.block) and (parm=="occupied") then
			local button = self.button
			if button and button:IsValid() then
				if value==1 then
					button:SetImage("trakpak3_common/icons/block_occupied.png")
				else
					button:SetImage("trakpak3_common/icons/block_clear.png")
				end
			end
		end
	end
	
	element:Update(true,x,y,block)
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

function Dispatch.StringToColor(cstring)
	local carray = string.Explode(" ",cstring)
	for n = 1,3 do
		carray[n] = tonumber(carray[n])
	end
	
	if carray[1] and carray[2] and carray[3] then --RGB Color
		return Color(carray[1], carray[2], carray[3])
	elseif carray[1] then --Single number to Grayscale
		return Color(carray[1], carray[1], carray[1])
	else
		return Color(255,255,255)
	end
end

--Dispatch Proxy
function Dispatch.AddProxy(ent, x, y, proxy, icon0, icon1, icon2, icon3, icon4, icon5, icon6, icon7, icon8, icon9, color0, color1, color2, color3, color4, color5, color6, color7, color8, color9)
	local element = Dispatch.AddElement(ent)
	element.type = "proxy"
	element.proporder = { "x", "y", "proxy", "icon0", "color0", "icon1", "color1", "icon2", "color2", "icon3", "color3", "icon4", "color4", "icon5", "color5", "icon6", "color6", "icon7", "color7",
	"icon8", "color8", "icon9", "color9"}
	element.properties = {
		x = "integer",
		y = "integer",
		proxy = "string",
		icon0 = "string",
		icon1 = "string",
		icon2 = "string",
		icon3 = "string",
		icon4 = "string",
		icon5 = "string",
		icon6 = "string",
		icon7 = "string",
		icon8 = "string",
		icon9 = "string",
		color0 = "string",
		color1 = "string",
		color2 = "string",
		color3 = "string",
		color4 = "string",
		color5 = "string",
		color6 = "string",
		color7 = "string",
		color8 = "string",
		color9 = "string"
	}
	element.mins = {
		x = 0,
		y = 0
	}
	element.maxs = {
		x = Dispatch.Boards[Dispatch.page].x_res,
		y = Dispatch.Boards[Dispatch.page].y_res
	}
	element.header = "trakpak3_common/icons/"
	
	function element:OnSelect(editor)
		local button = self.button
		local canvas = button:GetParent()
		
		--Update Image
		button:SetImage(self.header..self.icon0)
		button:SetColor(Dispatch.StringToColor(self.color0))
		
		--Set function to set up movement
		local e = self
		function button:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x
			Dispatch.placey = e.y
			Dispatch.placetype = "proxy"
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
	end
	function element:OnDeselect()
		local button = self.button
		--Update Image
		button:SetImage(self.header..self.icon0)
		button:SetColor(Dispatch.StringToColor(self.color0))
		
		--Setup function to select again
		local e = self
		function button:DoClick()
			if e.entity then e.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
		end
	end
	
	function element:Update(newprop, x, y, proxy, icon0, icon1, icon2, icon3, icon4, icon5, icon6, icon7, icon8, icon9, color0, color1, color2, color3, color4, color5, color6, color7, color8, color9) 
		self.x = x or self.x
		self.y = y or self.y
		
		self.proxy = proxy or self.proxy or ""
		
		self.icon0 = icon0 or self.icon0 or "generic_0.png"
		self.icon1 = icon1 or self.icon1 or "generic_1.png"
		self.icon2 = icon2 or self.icon2 or "generic_2.png"
		self.icon3 = icon3 or self.icon3 or "generic_3.png"
		self.icon4 = icon4 or self.icon4 or "generic_4.png"
		self.icon5 = icon5 or self.icon5 or "generic_5.png"
		self.icon6 = icon6 or self.icon6 or "generic_6.png"
		self.icon7 = icon7 or self.icon7 or "generic_7.png"
		self.icon8 = icon8 or self.icon8 or "generic_8.png"
		self.icon9 = icon9 or self.icon9 or "generic_9.png"
		
		self.color0 = color0 or self.color0 or "255 255 255"
		self.color1 = color1 or self.color1 or "255 255 255"
		self.color2 = color2 or self.color2 or "255 255 255"
		self.color3 = color3 or self.color3 or "255 255 255"
		self.color4 = color4 or self.color4 or "255 255 255"
		self.color5 = color5 or self.color5 or "255 255 255"
		self.color6 = color6 or self.color6 or "255 255 255"
		self.color7 = color7 or self.color7 or "255 255 255"
		self.color8 = color8 or self.color8 or "255 255 255"
		self.color9 = color9 or self.color9 or "255 255 255"
		
		if Dispatch.selectnew then timer.Simple(0.1,function() Dispatch.Select(self:GetIndex(),newprop) end) end
	end
	
	function element:Generate(pnl,nohelpers,selected,editor)
		local button = vgui.Create("DImageButton",pnl)
		self.button = button
		button:SetSize(Dispatch.elementsize,Dispatch.elementsize)
		local px, py = pnl:GetPanelCoords(self.x, self.y)
		button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2)
		if editor then
			if true then 
				button:SetImage(self.header..self.icon0)
				button:SetColor(Dispatch.StringToColor(self.color0))
			else
				--button:SetImage(self.header..self.icon1)
				--button:SetColor(Dispatch.StringToColor(self.color1))
			end
		else
			if self.proxy and (self.proxy!="") then
				local proxy = Dispatch.RealData[self.proxy]
				if proxy then
					local state = proxy.setstate
					self.state = state
					button:SetImage(self.header..self["icon"..state])
					button:SetColor(Dispatch.StringToColor(self["color"..state]))
					
					local e = self
					function button:DoClick()
						Dispatch.SendCommand(e.proxy, "fire", e.state)
					end
					
				else
					ErrorNoHalt("[Trakpak3] Dispatch Board Proxy name '"..self.proxy.."' does not match an existing entity.")
				end
			else
				ErrorNoHalt("[Trakpak3] Attempted to generate a Dispatch Board Proxy with no proxy name.")
			end
			
		end
	end
	
	function element:GenerateEditor(pnl,nohelpers,selected)
		local button = self.button
		if button and button:IsValid() then
			if nohelpers then
				function button.DoClick() pnl:DoClick() end
			else
				local e = self
				function button:DoClick() 
					Dispatch.Select(e:GetIndex(),true)
				end
			end
		end
		element.maxs = {
			x = Dispatch.Boards[Dispatch.page].x_res,
			y = Dispatch.Boards[Dispatch.page].y_res
		}
	end
	
	function element:Render(pnl)
		--Update Pos
		local px, py = pnl:GetPanelCoords(self.x, self.y)
		local size = Dispatch.elementsize
		if self.button and self.button:IsValid() then self.button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2) end
		if Dispatch.Panels.editor and (Dispatch.selected == self:GetIndex()) then
			surface.SetDrawColor(color_sel)
			surface.DrawOutlinedRect(px - size/2 - 2, py - size/2 - 2, size + 4, size + 4, 2)
		end
	end
	
	--Receive Info from World (Occupancy)
	function element:UpdateValue(name, parm, value)
		--print(e.proxy, name, parm, value)
		if (name==self.proxy) and (parm=="setstate") then
			local button = self.button
			if button and button:IsValid() then
				button:SetImage(self.header..self["icon"..value])
				button:SetColor(Dispatch.StringToColor(self["color"..value]))
				self.state = value
			end
		end
	end
	
	element:Update(true,x,y,proxy, icon0, icon1, icon2, icon3, icon4, icon5, icon6, icon7, icon8, icon9, color0, color1, color2, color3, color4, color5, color6, color7, color8, color9)
	
end

--Create Line
function Dispatch.AddLine(ent, x1, y1, x2, y2, color, weight)
	local element = Dispatch.AddElement(ent)
	element.type = "line"
	element.proporder = { "x1", "y1", "x2", "y2", "color", "weight" }
	element.properties = {
		x1 = "integer",
		y1 = "integer",
		x2 = "integer",
		y2 = "integer",
		color = "string",
		weight = "integer"
	}
	element.mins = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0,
		weight = 1
	}
	element.maxs = {
		x1 = Dispatch.Boards[Dispatch.page].x_res,
		y1 = Dispatch.Boards[Dispatch.page].y_res,
		x2 = Dispatch.Boards[Dispatch.page].x_res,
		y2 = Dispatch.Boards[Dispatch.page].y_res,
		weight = 5
	}
	
	function element:Update(newprop, x1, y1, x2, y2, color, weight)
		self.x1 = x1 or self.x1
		self.y1 = y1 or self.y1
		self.x2 = x2 or self.x2
		self.y2 = y2 or self.y2
		self.color = color or self.color or "0 0 0"
		self.weight = weight or self.weight or 3
		
		if self.x1==self.x2 then --line is vertical
			if self.y1 > self.y2 then --line goes up
				self.corner1 = 2
				self.corner2 = 8
			else
				self.corner1 = 8
				self.corner2 = 2
			end
		elseif self.y1==self.y2 then --horizontal
			if self.x2 > self.x1 then --line goes right
				self.corner1 = 4
				self.corner2 = 6
			else
				self.corner1 = 6
				self.corner2 = 4
			end
		elseif (self.y1 > self.y2) and (self.x2 > self.x1) then --up and right
			self.corner1 = 1
			self.corner2 = 9
		elseif (self.y1 < self.y2) and (self.x2 > self.x1) then --down and right
			self.corner1 = 7
			self.corner2 = 3
		elseif (self.y1 > self.y2) and (self.x2 < self.x1) then --up and left
			self.corner1 = 3
			self.corner2 = 7
		else --down and left
			self.corner1 = 9
			self.corner2 = 1
		end
		if Dispatch.selectnew then timer.Simple(0.1,function() Dispatch.Select(self:GetIndex(),newprop) end) end
	end
	
	function element:OnSelect(editor)
		--self.eh1 = Dispatch.CreateHandle(self.x1, self.y1,canvas)
		local canvas = self.handle:GetParent()
		self.eh2 = Dispatch.CreateHandle(self.x2, self.y2, canvas)
		local e = self
		function self.handle:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x2
			Dispatch.placey = e.y2
			Dispatch.placetype = "line"
			self:Remove()
			e.eh2:Remove()
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
		function e.eh2:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x1
			Dispatch.placey = e.y1
			Dispatch.placetype = "line"
			e.handle:Remove()
			self:Remove()
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
	end
	
	function element:OnDeselect()
		local e = self
		if self.handle and self.handle:IsValid() then
			function self.handle:DoClick()
				if e.entity then e.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
			end
		end
		--if self.eh1 and self.eh1:IsValid() then self.eh1:Remove() end
		if self.eh2 and self.eh2:IsValid() then self.eh2:Remove() end
	end
	
	function element:GenerateEditor(pnl,nohelpers,selected)
		if nohelpers then
			self.handle = nil
			return nil
		end
		if selected then
			self.eh2 = Dispatch.CreateHandle(0,0,pnl)
		end
		self.handle = Dispatch.CreateHandle(0,0,pnl)
		local e = self
		function self.handle:DoClick()
			Dispatch.Select(e:GetIndex(),true)
		end
		
		--Set these here because they all have to do with grid dims and this func is called when the grid changes
		self.mins.x1 = 0
		self.mins.y1 = 0
		self.mins.x2 = 0
		self.mins.y2 = 0
		
		self.maxs.x1 = Dispatch.Boards[Dispatch.page].x_res
		self.maxs.y1 = Dispatch.Boards[Dispatch.page].y_res
		self.maxs.x2 = Dispatch.Boards[Dispatch.page].x_res
		self.maxs.y2 = Dispatch.Boards[Dispatch.page].y_res
	end
	
	function element:Render(pnl, nohelpers, selected)
		--print(selected)
		
		--Draw Thicc Line
		local px1, py1 = pnl:GetPanelCoords(self.x1, self.y1)
		local px2, py2 = pnl:GetPanelCoords(self.x2, self.y2)
		
		local verts = Dispatch.GetLineVerts(px1, py1, self.corner1, self.weight)
		table.Add(verts, Dispatch.GetLineVerts(px2, py2, self.corner2, self.weight))
		
		
		--if selected then 
			--surface.SetDrawColor(color_sel)
		--else
		surface.SetDrawColor(Dispatch.StringToColor(self.color))
		--end
		surface.DrawPoly(verts)
		
		--Reposition Buttons
		if nohelpers then return end
		local cx, cy = 0.5*(px1 + px2), 0.5*(py1 + py2)
		if self.handle and self.handle:IsValid() then
			if selected then
				self.handle:SetPos(px1 - 8, py1 - 8)
				
				local size = Dispatch.elementsize
				surface.SetDrawColor(color_sel)
				surface.DrawOutlinedRect(px1 - size/2 - 2, py1 - size/2 - 2, size + 4, size + 4, 2)
				surface.DrawOutlinedRect(px2 - size/2 - 2, py2 - size/2 - 2, size + 4, size + 4, 2)
				
			else
				self.handle:SetPos(cx - 8, cy - 8)
			end
		end
		if self.eh2 and self.eh2:IsValid() then self.eh2:SetPos(px2 - 8, py2 - 8) end
	end
	
	--print("Created Track Line from point "..x1..", "..y1.." to "..x2..", "..y2)
	element:Update(true, x1,y1,x2,y2,color,weight)
	
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

--Create Block Line
function Dispatch.AddBlockLine(ent, x1, y1, x2, y2, block, color0, color1, weight)
	local element = Dispatch.AddElement(ent)
	element.type = "blockline"
	element.proporder = { "x1", "y1", "x2", "y2", "block", "color0", "color1", "weight" }
	element.properties = {
		x1 = "integer",
		y1 = "integer",
		x2 = "integer",
		y2 = "integer",
		block = "string",
		color0 = "string",
		color1 = "string",
		weight = "integer"
	}
	element.mins = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0,
		weight = 1
	}
	element.maxs = {
		x1 = Dispatch.Boards[Dispatch.page].x_res,
		y1 = Dispatch.Boards[Dispatch.page].y_res,
		x2 = Dispatch.Boards[Dispatch.page].x_res,
		y2 = Dispatch.Boards[Dispatch.page].y_res,
		weight = 5
	}
	
	function element:Update(newprop, x1, y1, x2, y2, block, color0, color1, weight)
		self.x1 = x1 or self.x1
		self.y1 = y1 or self.y1
		self.x2 = x2 or self.x2
		self.y2 = y2 or self.y2
		self.block = block or self.block or ""
		self.color0 = color0 or self.color0 or "127 63 0"--color_block
		self.color1 = color1 or self.color1 or "255 95 0" --color_block2
		self.weight = weight or self.weight or 3
		
		if self.x1==self.x2 then --line is vertical
			if self.y1 > self.y2 then --line goes up
				self.corner1 = 2
				self.corner2 = 8
			else
				self.corner1 = 8
				self.corner2 = 2
			end
		elseif self.y1==self.y2 then --horizontal
			if self.x2 > self.x1 then --line goes right
				self.corner1 = 4
				self.corner2 = 6
			else
				self.corner1 = 6
				self.corner2 = 4
			end
		elseif (self.y1 > self.y2) and (self.x2 > self.x1) then --up and right
			self.corner1 = 1
			self.corner2 = 9
		elseif (self.y1 < self.y2) and (self.x2 > self.x1) then --down and right
			self.corner1 = 7
			self.corner2 = 3
		elseif (self.y1 > self.y2) and (self.x2 < self.x1) then --up and left
			self.corner1 = 3
			self.corner2 = 7
		else --down and left
			self.corner1 = 9
			self.corner2 = 1
		end
		if Dispatch.selectnew then timer.Simple(0.1,function() Dispatch.Select(self:GetIndex(),newprop) end) end
	end
	
	function element:OnSelect(editor)
		--self.eh1 = Dispatch.CreateHandle(self.x1, self.y1,canvas)
		local canvas = self.handle:GetParent()
		self.eh2 = Dispatch.CreateHandle(self.x2, self.y2,canvas)
		local e = self
		function self.handle:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x2
			Dispatch.placey = e.y2
			Dispatch.placetype = "blockline"
			self:Remove()
			e.eh2:Remove()
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
		function e.eh2:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x1
			Dispatch.placey = e.y1
			Dispatch.placetype = "blockline"
			e.handle:Remove()
			self:Remove()
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
	end
	
	function element:OnDeselect()
		local e = self
		function self.handle:DoClick()
			if e.entity then e.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
		end
		--if self.eh1 and self.eh1:IsValid() then self.eh1:Remove() end
		if self.eh2 and self.eh2:IsValid() then self.eh2:Remove() end
	end
	
	function element:Generate(pnl,nohelpers,selected,editor)
		if not editor then
			if self.block and (self.block!="") then
				local block = Dispatch.RealData[self.block]
				if not block then
					ErrorNoHalt("[Trakpak3] Dispatch Board BlockLine name '"..self.block.."' does not match an existing entity.")
				end
			else
				ErrorNoHalt("[Trakpak3] Attempted to generate a Dispatch Board Block Line with no block name.")
			end
		end
	end
	
	function element:GenerateEditor(pnl,nohelpers,selected)
		if nohelpers then
			self.handle = nil
			return nil
		end
		if selected then
			self.eh2 = Dispatch.CreateHandle(0,0,pnl)
		end
		self.handle = Dispatch.CreateHandle(0,0,pnl)
		local e = self
		function self.handle:DoClick()
			Dispatch.Select(e:GetIndex(),true)
		end
		
		--Set these here because they all have to do with grid dims and this func is called when the grid changes
		self.mins.x1 = 0
		self.mins.y1 = 0
		self.mins.x2 = 0
		self.mins.y2 = 0
		
		self.maxs.x1 = Dispatch.Boards[Dispatch.page].x_res
		self.maxs.y1 = Dispatch.Boards[Dispatch.page].y_res
		self.maxs.x2 = Dispatch.Boards[Dispatch.page].x_res
		self.maxs.y2 = Dispatch.Boards[Dispatch.page].y_res
	end
	
	function element:Render(pnl, nohelpers, selected)
		--print(selected)
		
		--Draw Thicc Line
		local px1, py1 = pnl:GetPanelCoords(self.x1, self.y1)
		local px2, py2 = pnl:GetPanelCoords(self.x2, self.y2)
		
		local verts = Dispatch.GetLineVerts(px1, py1, self.corner1, self.weight)
		table.Add(verts, Dispatch.GetLineVerts(px2, py2, self.corner2, self.weight))
		
		local occupied = false
		if Dispatch.RealData[self.block] then
			occupied = Dispatch.RealData[self.block].occupied
		end
		
		if occupied then --if selected or occupied then 
			surface.SetDrawColor(Dispatch.StringToColor(self.color1))
		else
			surface.SetDrawColor(Dispatch.StringToColor(self.color0))
		end
		surface.DrawPoly(verts)
		
		--Reposition Button
		if nohelpers then return end
		local cx, cy = 0.5*(px1 + px2), 0.5*(py1 + py2)
		if self.handle and self.handle:IsValid() then
			if selected then
				self.handle:SetPos(px1 - 8, py1 - 8)
				
				local size = Dispatch.elementsize
				surface.SetDrawColor(color_sel)
				surface.DrawOutlinedRect(px1 - size/2 - 2, py1 - size/2 - 2, size + 4, size + 4, 2)
				surface.DrawOutlinedRect(px2 - size/2 - 2, py2 - size/2 - 2, size + 4, size + 4, 2)
			else
				self.handle:SetPos(cx - 8, cy - 8)
			end
		end
		if self.eh2 and self.eh2:IsValid() then self.eh2:SetPos(px2 - 8, py2 - 8) end
	end
	
	--print("Created Track Line from point "..x1..", "..y1.." to "..x2..", "..y2)
	element:Update(true, x1,y1,x2,y2,block,color0,color1,weight)
	
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

--Create Box
function Dispatch.AddBox(ent, x1, y1, x2, y2, color, weight, solid)
	local element = Dispatch.AddElement(ent)
	element.type = "box"
	element.proporder = { "x1", "y1", "x2", "y2", "color", "weight", "solid" }
	element.properties = {
		x1 = "integer",
		y1 = "integer",
		x2 = "integer",
		y2 = "integer",
		color = "string",
		weight = "integer",
		solid = "boolean"
	}
	element.mins = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0,
		weight = 1
	}
	element.maxs = {
		x1 = Dispatch.Boards[Dispatch.page].x_res,
		y1 = Dispatch.Boards[Dispatch.page].y_res,
		x2 = Dispatch.Boards[Dispatch.page].x_res,
		y2 = Dispatch.Boards[Dispatch.page].y_res,
		weight = 5
	}
	
	function element:Update(newprop, x1, y1, x2, y2, color, weight, solid)
		self.x1 = x1 or self.x1
		self.y1 = y1 or self.y1
		self.x2 = x2 or self.x2
		self.y2 = y2 or self.y2
		self.color = color or self.color or "0 0 0"
		self.weight = weight or self.weight or 2
		if solid != nil then self.solid = solid end
		
		--Make sure all the points are nicely ordered
		local minx = math.min(self.x1, self.x2)
		local miny = math.min(self.y1, self.y2)
		local maxx = math.max(self.x1, self.x2)
		local maxy = math.max(self.y1, self.y2)
		self.x1 = minx
		self.y1 = miny
		self.x2 = maxx
		self.y2 = maxy
		
		if Dispatch.selectnew then timer.Simple(0.1,function() Dispatch.Select(self:GetIndex(),newprop) end) end
	end
	
	function element:OnSelect(editor)
		--self.eh1 = Dispatch.CreateHandle(self.x1, self.y1,canvas)
		local canvas = self.handle:GetParent()
		self.eh2 = Dispatch.CreateHandle(self.x2, self.y2,canvas)
		local e = self
		function self.handle:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x2
			Dispatch.placey = e.y2
			Dispatch.placetype = "box"
			self:Remove()
			e.eh2:Remove()
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
		function e.eh2:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x1
			Dispatch.placey = e.y1
			Dispatch.placetype = "box"
			e.handle:Remove()
			self:Remove()
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
	end
	
	function element:OnDeselect()
		local e = self
		function self.handle:DoClick()
			if e.entity then e.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
		end
		--if self.eh1 and self.eh1:IsValid() then self.eh1:Remove() end
		if self.eh2 and self.eh2:IsValid() then self.eh2:Remove() end
	end
	
	function element:GenerateEditor(pnl,nohelpers,selected)
		if nohelpers then
			self.handle = nil
			return nil
		end
		if selected then
			self.eh2 = Dispatch.CreateHandle(0,0,pnl)
		end
		self.handle = Dispatch.CreateHandle(0,0,pnl)
		local e = self
		function self.handle:DoClick()
			Dispatch.Select(e:GetIndex(),true)
		end
		
		--Set these here because they all have to do with grid dims and this func is called when the grid changes
		self.mins.x1 = 0
		self.mins.y1 = 0
		self.mins.x2 = 0
		self.mins.y2 = 0
		
		self.maxs.x1 = Dispatch.Boards[Dispatch.page].x_res
		self.maxs.y1 = Dispatch.Boards[Dispatch.page].y_res
		self.maxs.x2 = Dispatch.Boards[Dispatch.page].x_res
		self.maxs.y2 = Dispatch.Boards[Dispatch.page].y_res
	end
	
	function element:Render(pnl, nohelpers, selected)
		--print(selected)
		
		--Draw bax
		local px1, py1 = pnl:GetPanelCoords(self.x1, self.y1)
		local px2, py2 = pnl:GetPanelCoords(self.x2, self.y2)
		
		if self.solid or self.weight>0 then
			if selected then 
				surface.SetDrawColor(color_sel)
				surface.DrawOutlinedRect(px1-2, py1-2, px2 - px1 + 5, py2 - py1 + 5, 2)
			end
			
			surface.SetDrawColor(Dispatch.StringToColor(self.color))
			
			if self.solid then
				surface.DrawRect(px1, py1, px2 - px1 + 1, py2 - py1 + 1)
			else
				surface.DrawOutlinedRect(px1, py1, px2 - px1 + 1, py2 - py1 + 1, self.weight)
			end
			
		end
		
		--Reposition Button
		if nohelpers then return end
		local cx, cy = 0.5*(px1 + px2), 0.5*(py1 + py2)
		if self.handle and self.handle:IsValid() then
			self.handle:SetPos(px1 - 8, py1 - 8)
		end
		if self.eh2 and self.eh2:IsValid() then self.eh2:SetPos(px2 - 8, py2 - 8) end
	end
	
	--print("Created Track Line from point "..x1..", "..y1.." to "..x2..", "..y2)
	element:Update(true, x1,y1,x2,y2, color, weight, solid)
	
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

--Create Text
function Dispatch.AddText(ent, x1, y1, x2, y2, text, textcolor, textsize, textalign_h, textalign_v, boxcolor, boxweight, boxsolid)
	local element = Dispatch.AddElement(ent)
	element.type = "text"
	element.proporder = { "x1", "y1", "x2", "y2", "text", "textcolor", "textsize", "textalign_h", "textalign_v", "boxcolor", "boxweight", "boxsolid" }
	element.properties = {
		x1 = "integer",
		y1 = "integer",
		x2 = "integer",
		y2 = "integer",
		text = "string",
		textcolor = "string",
		textsize = "integer",
		textalign_h = "integer",
		textalign_v = "integer",
		boxcolor = "string",
		boxweight = "integer",
		boxsolid = "boolean"
	}
	element.mins = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0,
		textsize = 1,
		textalign_h = -1,
		textalign_v = -1,
		boxweight = 0
	}
	element.maxs = {
		x1 = Dispatch.Boards[Dispatch.page].x_res,
		y1 = Dispatch.Boards[Dispatch.page].y_res,
		x2 = Dispatch.Boards[Dispatch.page].x_res,
		y2 = Dispatch.Boards[Dispatch.page].y_res,
		textsize = 5,
		textalign_h = 1,
		textalign_v = 1,
		boxweight = 5
	}
	
	function element:Update(newprop, x1, y1, x2, y2, text, textcolor, textsize, textalign_h, textalign_v, boxcolor, boxweight, boxsolid)
		self.x1 = x1 or self.x1
		self.y1 = y1 or self.y1
		self.x2 = x2 or self.x2
		self.y2 = y2 or self.y2
		
		self.text = text or self.text or ""
		self.textcolor = textcolor or self.textcolor or "0 0 0"
		self.textsize = textsize or self.textsize or 1
		self.textalign_h = textalign_h or self.textalign_h or 0
		self.textalign_v = textalign_v or self.textalign_v or 0
		
		self.boxcolor = boxcolor or self.boxcolor or "0 0 0"
		self.boxweight = boxweight or self.boxweight or 2
		if boxsolid != nil then self.boxsolid = boxsolid end
		
		--print(self.boxcolor)
		
		self.rendertext = string.Explode("[n]",self.text)
		
		--Make sure all the points are nicely ordered
		local minx = math.min(self.x1, self.x2)
		local miny = math.min(self.y1, self.y2)
		local maxx = math.max(self.x1, self.x2)
		local maxy = math.max(self.y1, self.y2)
		self.x1 = minx
		self.y1 = miny
		self.x2 = maxx
		self.y2 = maxy
		
		if Dispatch.selectnew then timer.Simple(0.1,function() Dispatch.Select(self:GetIndex(),newprop) end) end
	end
	
	function element:OnSelect(editor)
		--self.eh1 = Dispatch.CreateHandle(self.x1, self.y1,canvas)
		local canvas = self.handle:GetParent()
		self.eh2 = Dispatch.CreateHandle(self.x2, self.y2,canvas)
		local e = self
		function self.handle:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x2
			Dispatch.placey = e.y2
			Dispatch.placetype = "text"
			self:Remove()
			e.eh2:Remove()
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
		function e.eh2:DoClick()
			Dispatch.editing = 2
			Dispatch.placex = e.x1
			Dispatch.placey = e.y1
			Dispatch.placetype = "text"
			e.handle:Remove()
			self:Remove()
			Dispatch.PopulatePage(canvas, Dispatch.page, true)
		end
	end
	
	function element:OnDeselect()
		--if self.eh1 and self.eh1:IsValid() then self.eh1:Remove() end
		local e = self
		function self.handle:DoClick()
			if e.entity then e.entity:Select(e:GetIndex()) else Dispatch.Select(e:GetIndex(),true) end
		end
		if self.eh2 and self.eh2:IsValid() then self.eh2:Remove() end
	end
	
	function element:Generate(pnl, nohelpers, selected)
		--[[
		local label = vgui.Create("DLabel",pnl)
		label:SetFont("tp3_dispatch")
		label:SetTextColor(black)
		label:SetContentAlignment(5)
		self.label = label
		]]--
		
	end
	
	function element:GenerateEditor(pnl,nohelpers,selected)
		if nohelpers then
			self.handle = nil
			return nil
		end
		self.handle = Dispatch.CreateHandle(0,0,pnl)
		local e = self
		function self.handle:DoClick()
			Dispatch.Select(e:GetIndex(),true)
		end
		--Set these here because they all have to do with grid dims and this func is called when the grid changes
		self.mins.x1 = 0
		self.mins.y1 = 0
		self.mins.x2 = 0
		self.mins.y2 = 0
		
		self.maxs.x1 = Dispatch.Boards[Dispatch.page].x_res
		self.maxs.y1 = Dispatch.Boards[Dispatch.page].y_res
		self.maxs.x2 = Dispatch.Boards[Dispatch.page].x_res
		self.maxs.y2 = Dispatch.Boards[Dispatch.page].y_res
	end
	
	function element:Render(pnl, nohelpers, selected)
		--print(selected)
		
		--Draw bax
		local px1, py1 = pnl:GetPanelCoords(self.x1, self.y1)
		local px2, py2 = pnl:GetPanelCoords(self.x2, self.y2)
		
		local sx = px2 - px1 + 1
		local sy = py2 - py1 + 1
		
		if selected then 
			surface.SetDrawColor(color_sel)
			surface.DrawOutlinedRect(px1-2, py1-2, px2 - px1 + 5, py2 - py1 + 5, 2)
		end
		
		surface.SetDrawColor(Dispatch.StringToColor(self.boxcolor))
		
		if self.boxsolid then
			surface.DrawRect(px1, py1, sx, sy)
		elseif self.boxweight > 0 then
			surface.DrawOutlinedRect(px1, py1, sx, sy, self.boxweight)
		end
		
		--Reposition Label
		--[[
		if self.label and self.label:IsValid() then
			self.label:SetPos(px1,py1)
			self.label:SetSize(sx,sy)
			self.label:SetText(self.rendertext)
		end
		]]--
		
		--Draw Text
		local numlines = #self.rendertext
		local unit = (self.textsize*4 + 8)*1.25
		local offset = 0
		
		local xalign
		if self.textalign_h==1 then --Right
			xalign = TEXT_ALIGN_RIGHT
			cx = px2 - self.boxweight
		elseif self.textalign_h == -1 then --Left
			xalign = TEXT_ALIGN_LEFT
			cx = px1 + self.boxweight
		else --Center
			xalign = TEXT_ALIGN_CENTER
			cx = (px1 + px2)/2
		end
		
		local cy
		
		if numlines > 0 then
			
			if self.textalign_v==1 then --Top
				for n = 1, numlines do
					cy = py1 + (n-1)*unit + self.boxweight
					draw.DrawText(self.rendertext[n],"tp3_dispatch_"..self.textsize, cx, cy, Dispatch.StringToColor(self.textcolor),xalign)
				end
			elseif self.textalign_v==-1 then --Bottom
				for n = 1, numlines do
					cy = py2 - (numlines - n + 1)*unit - self.boxweight
					draw.DrawText(self.rendertext[n],"tp3_dispatch_"..self.textsize, cx, cy, Dispatch.StringToColor(self.textcolor),xalign)
				end
			else --Center
				for n = 1, numlines do
					cy = (py1 + py2)/2 + unit*(-numlines/2 + (n-1))
					draw.DrawText(self.rendertext[n],"tp3_dispatch_"..self.textsize, cx, cy, Dispatch.StringToColor(self.textcolor),xalign)
				end
			end
		end
		
		
		--Reposition Button
		if nohelpers then return end
		if self.handle and self.handle:IsValid() then
			self.handle:SetPos(px1 - 8, py1 - 8)
		end
		if self.eh2 and self.eh2:IsValid() then self.eh2:SetPos(px2 - 8, py2 - 8) end
		
		
	end
	
	--print("Created Track Line from point "..x1..", "..y1.." to "..x2..", "..y2)
	element:Update(true, x1,y1,x2,y2,text or "Sample Text",textcolor, textsize, textalign_h, textalign_v, boxcolor, boxweight, boxsolid)
	
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end


--Helper Functions for Elements

--Line Rendering
function Dispatch.GetLineVerts(px, py, corner, weight)
	local verts = {}
	
	local w = (weight - 0.5)
	
	if corner==1 then
		verts[1] = { x = px + w, y = py + w }
		verts[2] = { x = px - w, y = py + w }
		verts[3] = { x = px - w, y = py - w }
	elseif corner==2 then
		verts[1] = { x = px + w, y = py + w }
		verts[2] = { x = px - w, y = py + w }
	elseif corner==3 then
		verts[1] = { x = px + w, y = py - w }
		verts[2] = { x = px + w, y = py + w }
		verts[3] = { x = px - w, y = py + w }
	elseif corner==6 then
		verts[1] = { x = px + w, y = py - w }
		verts[2] = { x = px + w, y = py + w }
	elseif corner==9 then
		verts[1] = { x = px - w, y = py - w }
		verts[2] = { x = px + w, y = py - w }
		verts[3] = { x = px + w, y = py + w }
	elseif corner==8 then
		verts[1] = { x = px - w, y = py - w }
		verts[2] = { x = px + w, y = py - w }
	elseif corner==7 then
		verts[1] = { x = px - w, y = py + w }
		verts[2] = { x = px - w, y = py - w }
		verts[3] = { x = px + w, y = py - w }
	elseif corner==4 then
		verts[1] = { x = px - w, y = py + w }
		verts[2] = { x = px - w, y = py - w }
	end
	return verts
end

--Save/Load
function Dispatch.SaveBoards()
	local ftable = {}
	
	for page = 1, #Dispatch.Boards do
		local board = Dispatch.Boards[page]
		ftable[page] = {
			name = board.name,
			x_res = board.x_res,
			y_res = board.y_res,
			color = board.color,
			elements = {}
		}
		
		for id, element in pairs(board.elements) do
			local new = {}
			new.type = element.type
			
			for pname, _ in pairs(element.properties) do
				new[pname] = element[pname]
			end
			
			--if element.type=="line" then
				--print(element.color)
			--end
			
			--[[
			if new.type=="signal" then
				new.x = element.x
				new.y = element.y
				new.signal = element.signal
				new.orientation = element.orientation
			elseif new.type=="switch" then
				new.x = element.x
				new.y = element.y
				new.switch = element.switch
			elseif new.type=="block" then
				new.x = element.x
				new.y = element.y
				new.block = element.block
			elseif new.type=="line" then
				new.x1 = element.x1
				new.y1 = element.y1
				new.x2 = element.x2
				new.y2 = element.y2
				new.color = element.color
			elseif new.type=="blockline" then
				new.x1 = element.x1
				new.y1 = element.y1
				new.x2 = element.x2
				new.y2 = element.y2
				new.block = element.block
			elseif new.type=="box" then
				new.x1 = element.x1
				new.y1 = element.y1
				new.x2 = element.x2
				new.y2 = element.y2
			elseif new.type=="proxy" then
				new.x = element.x
				new.y = element.y
				new.proxy = element.proxy
				for n = 0,7 do
					new["icon"..n] = element["icon"..n]
					new["color"..n] = element["color"..n]
				end
			else --text
				new.x1 = element.x1
				new.y1 = element.y1
				new.x2 = element.x2
				new.y2 = element.y2
				new.text = element.text
			end
			]]--
			ftable[page].elements[id] = new
		end
	end
	
	local json = util.TableToJSON(ftable, true)
	file.CreateDir("trakpak3/dispatch")
	file.Write("trakpak3/dispatch/"..game.GetMap()..".txt", json)
	local gray = Color(127,255,255)
	chat.AddText(gray, "File saved as ",Color(255,127,127),"data",gray,"/trakpak3/dispatch/"..game.GetMap()..".txt! To include it with your map, change its extension to .lua and place it in ",Color(0,127,255),"lua",gray,"/trakpak3/dispatch/!")
end

--Load from map-provided or save file
function Dispatch.LoadBoards(fromdata, ent)
	local mapboards
	
	if fromdata then
		local json = file.Read("trakpak3/dispatch/"..game.GetMap()..".txt", "DATA")
		if json then
			local ftable = util.JSONToTable(json)
			mapboards = ftable
		else
			chat.AddText(Color(127,255,255),"Could not find dispatch save file data/trakpak3/dispatch/"..game.GetMap()..".txt!")
		end
	else
		mapboards = Dispatch.MapBoards
	end
	
	if mapboards then
		if fromdata then
			chat.AddText(Color(127,255,255), "Loaded dispatch save file data/trakpak3/dispatch/"..game.GetMap()..".txt successfully.")
		end
		
		Dispatch.selectnew = false
		
		local function loadboard(mb)
			for id, element in pairs(mb.elements) do
				if element.type=="signal" then
					Dispatch.AddSignal(ent, element.x, element.y, element.orientation, element.signal, element.style)
				elseif element.type=="switch" then
					Dispatch.AddSwitch(ent, element.x, element.y, element.switch)
				elseif element.type=="block" then
					Dispatch.AddBlock(ent, element.x, element.y, element.block)
				elseif element.type=="line" then
					Dispatch.AddLine(ent, element.x1, element.y1, element.x2, element.y2, element.color, element.weight)
				elseif element.type=="blockline" then
					Dispatch.AddBlockLine(ent, element.x1, element.y1, element.x2, element.y2, element.block, element.color0, element.color1, element.weight)
				elseif element.type=="box" then
					Dispatch.AddBox(ent, element.x1, element.y1, element.x2, element.y2, element.color, element.weight, element.solid)
				elseif element.type=="text" then
					--PrintTable(element)
					Dispatch.AddText(ent, element.x1, element.y1, element.x2, element.y2, element.text, element.textcolor, element.textsize, element.textalign_h, element.textalign_v, element.boxcolor, element.boxweight, element.boxsolid)
				elseif element.type=="proxy" then
					Dispatch.AddProxy(ent, element.x, element.y, element.proxy,
						element.icon0, element.icon1, element.icon2, element.icon3, element.icon4, element.icon5, element.icon6, element.icon7, element.icon8, element.icon9,
						element.color0, element.color1, element.color2, element.color3, element.color4, element.color5, element.color6, element.color7, element.color8, element.color9
					)
				end
			end
		end
		
		if ent then --Load to a world board
			--print("Loading ",ent)
			ent:Deselect()
			ent.Boards = {}
			
			for page = 1, #mapboards do
				--Create Board page
				local mb = mapboards[page]
				ent.Boards[page] = {
					name = mb.name,
					x_res = mb.x_res,
					y_res = mb.y_res,
					color = mb.color,
					elements = {}
				}
				Dispatch.page = page
				--Fill it with stuff
				loadboard(mb)
				
			end
			--print("Loaded ",ent)
		else --Client
			Dispatch.Deselect()
			Dispatch.Boards = {}
			
			for page = 1, #mapboards do
				--Create Board page
				local mb = mapboards[page]
				Dispatch.Boards[page] = {
					name = mb.name,
					x_res = mb.x_res,
					y_res = mb.y_res,
					color = mb.color,
					elements = {}
				}
				Dispatch.page = page
				--Fill it with stuff
				loadboard(mb)
				
			end
		end
		Dispatch.selectnew = true
		if Dispatch.Panels.dispatcher or Dispatch.Panels.editor then Dispatch.PopulatePage(Dispatch.Panels.canvas,1) end
		
	else
		print("[Trakpak3] Something went wrong loading this Dispatch Board.")
	end
end

--Request DS board from server
hook.Add("InitPostEntity", "Trakpak3_Request_Dispatch", function()
	net.Start("tp3_transmit_ds")
	net.SendToServer()
end)

--Receive DS data from server
net.Receive("tp3_transmit_dsdata",function(mlen, ply)
	local JSON = net.ReadData(mlen)
	JSON = util.Decompress(JSON)
	Dispatch.RealData = util.JSONToTable(JSON)
	--PrintTable(Dispatch.RealData)
end)
--Receive DS board from server
net.Receive("tp3_transmit_ds",function(mlen, ply)
	print("[Trakpak3] Dispatch Board Received.")
	local JSON = net.ReadData(mlen)
	JSON = util.Decompress(JSON)
	Dispatch.MapBoards = util.JSONToTable(JSON)
	Dispatch.LoadBoards(false)
	Dispatch.canload = true
	--PrintTable(Dispatch.MapBoards)
end)

--Send Command to Entity
function Dispatch.SendCommand(target, cmd, arg)
	net.Start("tp3_dispatch_comm")
		net.WriteString(target)
		net.WriteString(cmd)
		net.WriteUInt(arg,3)
	net.SendToServer()
	LocalPlayer():EmitSound("buttons/lightswitch2.wav")
end

--Receive Status from Entity
net.Receive("tp3_dispatch_comm", function(mlen, ply)
	local entname = net.ReadString()
	local parm = net.ReadString()
	local value = net.ReadUInt(3)
	--print("Dispatch Update: ", entname, parm, value)
	if not Dispatch.RealData[entname] then Dispatch.RealData[entname] = {} end
	Dispatch.RealData[entname][parm] = value
	for page, board in pairs(Dispatch.Boards) do
		for index, element in pairs(board.elements) do element:UpdateValue(entname, parm, value) end
	end
	for _, ent in pairs(ents.FindByClass("tp3_dispatch_board")) do
		for page, board in pairs(ent.Boards) do
			for index, element in pairs(board.elements) do element:UpdateValue(entname, parm, value) end
		end
	end
end)

--Create Dispatch Board VGUI (not editor)
function Dispatch.OpenDispatcher()
	--Dispatcher Frame
	local sizex = Dispatch.sizex or (ScrW()*0.75)
	local sizey = Dispatch.sizey or (ScrH()*0.75)
	local posx = Dispatch.posx or (ScrW()/2 - sizex/2)
	local posy = Dispatch.posy or (ScrH()/2 - sizey/2)

	local frame = vgui.Create("DFrame")
	frame:SetSize(sizex, sizey)
	frame:SetPos(posx, posy)
	frame:SetTitle("Dispatch Board: "..game.GetMap())
	--frame:SetIcon("icon16/map_edit.png")
	frame:SetIcon("trakpak3_common/icons/switch_n_lit.png")
	frame:SetSizable(true)
	frame:SetScreenLock(true)
	frame:SetMinHeight(64)
	frame:SetMinWidth(128)
	function frame:OnClose()
		
		--Save Position & Scale Data
		Dispatch.sizex, Dispatch.sizey = frame:GetSize()
		Dispatch.posx, Dispatch.posy = frame:GetPos()
		
		--Clear the variables
		Dispatch.Panels.dispatcher = nil
		
		--Reinitialize all world dispatch boards
		--for _, board in pairs(ents.FindByClass("tp3_dispatch_board")) do board:InitializeBoard() end
	end
	frame:MakePopup()
	Dispatch.Panels.dispatcher = frame
	
	--Control Bar
	local bottombar = vgui.Create("DPanel",frame)
	bottombar:SetSize(1,36)
	bottombar:Dock(BOTTOM)
	
	--Page Controls
	Dispatch.page = Dispatch.page or 0
	
	--Prev Page Button
	local button = vgui.Create("DImageButton",bottombar)
	button:SetSize(36,1)
	button:Dock(LEFT)
	button:SetImage("icon16/resultset_previous.png")
	--button:SetText("Prev")
	button.DoClick = function()
		if Dispatch.page > 1 then
			Dispatch.PopulatePage(Dispatch.Panels.canvas, Dispatch.page - 1)
		else
			Dispatch.PopulatePage(Dispatch.Panels.canvas, #Dispatch.Boards)
		end
	end
	
	--Page Label
	local label = vgui.Create("DLabel",bottombar)
	label:SetSize(128,1)
	label:Dock(LEFT)
	label:SetContentAlignment(5)
	label:SetText("No Boards")
	label:SetTextColor(dark)
	Dispatch.Panels.pagelabel = label
	
	--Next Page Button
	local button = vgui.Create("DImageButton",bottombar)
	button:SetSize(36,1)
	button:Dock(LEFT)
	button:SetImage("icon16/resultset_next.png")
	--button:SetText("Next")
	button.DoClick = function()
		if Dispatch.page < #Dispatch.Boards then
			Dispatch.PopulatePage(Dispatch.Panels.canvas, Dispatch.page + 1)
		else
			Dispatch.PopulatePage(Dispatch.Panels.canvas, 1)
		end
	end
	
	local label = vgui.Create("DLabel",bottombar)
	label:Dock(FILL)
	label:SetContentAlignment(5)
	label:SetText("Unless you're the designated dispatcher, always make sure to ask before changing signals and switches!")
	label:SetTextColor(dark)
	surface.CreateFont("TP3_DispatchWarning",{
		font = "Roboto",
		size = 24,
		weight = 600
	})
	label:SetFont("TP3_DispatchWarning")
	
	local lpanel = vgui.Create("DPanel",frame)
	function lpanel:Paint() end
	lpanel:Dock(FILL)
	
	--The Main Area (Canvas)
	
	local backing = vgui.Create("DImage",lpanel)
	backing:Dock(FILL)
	backing:SetImage("trakpak3_common/icons/backing.png")
	backing:SetKeepAspect(false)
	Dispatch.Panels.backing = backing
	
	--Canvas
	local canvas = vgui.Create("DButton",lpanel)
	Dispatch.Panels.canvas = canvas
	canvas:Dock(FILL)
	
	canvas:SetText("")
	
	function canvas:DoClick() Dispatch.Deselect() end
	
	function canvas:GetPanelCoords(gx, gy) --convert grid coords to panel coords
		local sx, sy = self:GetSize()
		local rx, ry = Dispatch.Boards[Dispatch.page].x_res, Dispatch.Boards[Dispatch.page].y_res
		
		return sx*gx/rx, sy*gy/ry
	end
	
	function canvas:GetGridCoords(px, py) --convert panel coords to grid coords
		local sx, sy = self:GetSize()
		local rx, ry = Dispatch.Boards[Dispatch.page].x_res, Dispatch.Boards[Dispatch.page].y_res
		
		local gx = math.Round(rx*px/sx)
		local gy = math.Round(ry*py/sy)
		
		return math.Clamp(gx,0,rx), math.Clamp(gy,0,ry)
	end
	
	--Render the Dispatch board
	function canvas:Paint(w, h)
		local page = Dispatch.page
		local board = Dispatch.Boards[page]
		if page > 0 then
			draw.NoTexture()
			
			--Render Elements
			for k, element in pairs(board.elements) do
				element:Render(self, Dispatch.placing or Dispatch.hidehelpers, (Dispatch.selected==k))
			end
		end
	end
	
	--Populate Page
	timer.Simple(0.1, function()
		if #Dispatch.Boards > 0 then --Normal Load
			Dispatch.PopulatePage(canvas)
		else --File was reloaded, repopulate
			net.Start("tp3_transmit_ds")
			net.SendToServer()
		end
	end)
end

--Console Commands
concommand.Add("tp3_dispatch_editor",Dispatch.OpenEditor)
concommand.Add("tp3_dispatch",Dispatch.OpenDispatcher)

--hook.Add("KeyPress", "Trakpak3_Test_Shit", function(ply, key) if key==IN_USE then print("E") end end)