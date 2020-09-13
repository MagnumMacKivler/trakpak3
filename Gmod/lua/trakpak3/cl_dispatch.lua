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

surface.CreateFont("tp3_dispatch",{
	font = "Roboto",
	size = 16,
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
		for _, board in pairs(ents.FindByClass("tp3_dispatch_board")) do board:InitializeBoard() end
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
		Dispatch.Boards[page].x_res = value
		Dispatch.PopulatePage(Dispatch.Panels.canvas)
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
		Dispatch.Boards[page].y_res = value
		Dispatch.PopulatePage(Dispatch.Panels.canvas)
	end
	Dispatch.Panels.ybox = ybox
	
	--Grid Toggle
	local button = vgui.Create("DImageButton",topbar)
	button:SetSize(24,1)
	button:Dock(LEFT)
	--button:SetText("")
	button:SetImage("icon16/collision_on.png")
	button.DoClick = function()
		Dispatch.showgrid = not Dispatch.showgrid
	end
	button:SetTooltip("Toggle Grid Display")
	Dispatch.Panels.gridbutton = button
	
	--Toggle helpers
	local button = vgui.Create("DImageButton",topbar)
	button:SetSize(24,1)
	button:Dock(LEFT)
	button:SetImage("icon16/picture_empty.png")
	button.DoClick = function()
		Dispatch.hidehelpers = not Dispatch.hidehelpers
		Dispatch.PopulatePage(Dispatch.Panels.canvas)
	end
	button:SetTooltip("Toggle Helpers")
	Dispatch.Panels.helperbutton = button
	
	--Toggle Showhulls button
	local button = vgui.Create("DImageButton",topbar)
	button:SetSize(24,1)
	button:Dock(LEFT)
	button:SetImage("icon16/layers.png")
	button:SetTooltip("Toggle Map Block Hulls and Switch/Signal Display")
	function button:DoClick()
		if Trakpak3.ShowHulls != 2 then
			Trakpak3.ShowHulls = 2
		else
			Trakpak3.ShowHulls = false
		end
	end
	
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
	
	
	--The Main Area (Canvas)
	
	local backing = vgui.Create("DImage",lpanel)
	backing:Dock(FILL)
	backing:SetImage("trakpak3_common/icons/backing.png")
	backing:SetKeepAspect(false)
	
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
			elseif (Dispatch.placetype=="signal") or (Dispatch.placetype=="switch") or (Dispatch.placetype=="block") then
				local x, y = self:GetGridCoords(self:LocalCursorPos())
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
				surface.DrawLine(px, py, cx, cy)
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
	epanel:SetSize(1,288)
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
			Dispatch.Deselect()
		end
		Dispatch.page = page
	else
		page = Dispatch.page
	end
	
	local Board = Dispatch.Boards[page]
	if Board then
		local name = Board.name
		Dispatch.Panels.pagelabel:SetText(name.." ("..page.."/"..#Dispatch.Boards..")")
		if editor then
			local xv, yv = Dispatch.Panels.xbox:GetValue(), Dispatch.Panels.ybox:GetValue()
			if xv != Board.x_res then Dispatch.Panels.xbox:SetValue(Board.x_res) end
			if yv != Board.y_res then Dispatch.Panels.ybox:SetValue(Board.y_res) end
			Dispatch.Panels.xbox:SetDisabled(false)
			Dispatch.Panels.ybox:SetDisabled(false)
			Dispatch.Panels.gridbutton:SetDisabled(false)
			Dispatch.Panels.canvas:SetDisabled(false)
		end
	else
		Dispatch.Panels.pagelabel:SetText("No Boards")
		if editor then
			Dispatch.Panels.coord_label:SetText("")
			Dispatch.Panels.xbox:SetDisabled(true)
			Dispatch.Panels.ybox:SetDisabled(true)
			Dispatch.Panels.gridbutton:SetDisabled(true)
			Dispatch.Panels.canvas:SetDisabled(true)
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
			if dt=="integer" then
				row:Setup("Int", {min = element.mins[k], max = element.maxs[k]})
			elseif dt=="float" then
				row:Setup("Float", {min = element.mins[k], max = element.maxs[k]})
			elseif dt=="boolean" then
				row:Setup("Boolean")
			elseif dt=="string" then
				row:Setup("Generic")
			elseif dt=="choices" then
				row:Setup("Combo",{ text = "pootis" })
				for i = 1, #element.choices[k] do
					row:AddChoice(element.choices[k][i],element.values[k][i])
				end
			end
			
			row:SetValue(element[k])
			function row:DataChanged(val)
				element[k] = val
				element:Update(false)
			end
		end
	end)
end

--Select & Deselect
function Dispatch.Select(id, newprop)
	if Dispatch.selected then
		Dispatch.Boards[Dispatch.page].elements[Dispatch.selected]:OnDeselect()
	end
	Dispatch.selected = id
	local element = Dispatch.Boards[Dispatch.page].elements[Dispatch.selected]
	element:OnSelect(Dispatch.Panels.editor)
	if newprop and Dispatch.Panels.editor then Dispatch.DisplayProperties(element) end
end

function Dispatch.Deselect()
	if Dispatch.selected then
		Dispatch.Boards[Dispatch.page].elements[Dispatch.selected]:OnDeselect()
	end
	Dispatch.selected = nil
	Dispatch.editing = nil
	Dispatch.placing = nil
	
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
	function element:OnDeselect() end
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
function Dispatch.AddSignal(ent, x, y, orientation, signal)
	local element = Dispatch.AddElement(ent)
	element.type = "signal"
	element.proporder = { "x", "y", "orientation", "signal" }
	element.properties = {
		x = "integer",
		y = "integer",
		orientation = "choices",
		signal = "string"
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
			button:SetImage("trakpak3_common/icons/signal_grn_"..dir..".png")
			
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
			local cx, cy, sx, sy = button:GetBounds()
			mpanel:SetPos(cx+ sx/2,cy + sy/2)
			self.menu = mpanel
			
			local button = vgui.Create("DButton",mpanel)
			button:SetSize(1,36)
			button:Dock(TOP)
			button:SetText("Hold")
			button:SetImage("trakpak3_common/icons/signal_red_n.png")
			function button:DoClick()
				Dispatch.SendCommand(e.signal, "set_ctc", 0)
				mpanel:Remove()
				self.menu = nil
			end
			
			local button = vgui.Create("DButton",mpanel)
			button:SetSize(1,36)
			button:Dock(TOP)
			button:SetText("Once")
			button:SetImage("trakpak3_common/icons/signal_yel_n.png")
			function button:DoClick()
				Dispatch.SendCommand(e.signal, "set_ctc", 1)
				mpanel:Remove()
				self.menu = nil
			end
			
			local button = vgui.Create("DButton",mpanel)
			button:SetSize(1,36)
			button:Dock(TOP)
			button:SetText("Allow")
			button:SetImage("trakpak3_common/icons/signal_grn_n.png")
			function button:DoClick()
				Dispatch.SendCommand(e.signal, "set_ctc", 2)
				mpanel:Remove()
				self.menu = nil
			end
			
			local button = vgui.Create("DButton",mpanel)
			button:SetSize(1,36)
			button:Dock(TOP)
			button:SetText("Force")
			button:SetImage("trakpak3_common/icons/signal_lun_n.png")
			function button:DoClick()
				Dispatch.SendCommand(e.signal, "set_ctc", 3)
				mpanel:Remove()
				self.menu = nil
			end
		end
	end
	function element:OnDeselect(canvas)
		local button = self.button
		local e = self
		if editor then
			--Update Image
			local dt = {"n", "s", "e", "w"}
			local dir = dt[self.orientation]
			button:SetImage("trakpak3_common/icons/signal_red_"..dir..".png")
			
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
	
	function element:Update(newprop, x, y, orientation, signal) 
		self.x = x or self.x
		self.y = y or self.y
		self.orientation = orientation or self.orientation or 1
		self.signal = signal or self.signal or ""
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
		if editor then
			if selected then 
				button:SetImage("trakpak3_common/icons/signal_grn_"..dir..".png")
			else
				button:SetImage("trakpak3_common/icons/signal_red_"..dir..".png")
			end
		else
			local state = Dispatch.RealData[self.signal].ctc_state
			if state==0 then --Hold
				button:SetImage("trakpak3_common/icons/signal_red_"..dir..".png")
			elseif state==1 then --Once
				button:SetImage("trakpak3_common/icons/signal_yel_"..dir..".png")
			elseif state==2 then --Allow
				button:SetImage("trakpak3_common/icons/signal_grn_"..dir..".png")
			elseif state==3 then --Force
				button:SetImage("trakpak3_common/icons/signal_lun_"..dir..".png")
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
		if self.button and self.button:IsValid() then self.button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2) end
	end
	
	--Receive Info from World (CTC State)
	function element:UpdateValue(name, parm, value)
		if (name==self.signal) and (parm=="ctc_state") then
			local button = self.button
			if button and button:IsValid() then
				local dt = {"n", "s", "e", "w"}
				local dir = dt[self.orientation]
				if value==0 then --Hold
					button:SetImage("trakpak3_common/icons/signal_red_"..dir..".png")
				elseif value==1 then --Once
					button:SetImage("trakpak3_common/icons/signal_yel_"..dir..".png")
				elseif value==2 then --Allow
					button:SetImage("trakpak3_common/icons/signal_grn_"..dir..".png")
				else --Force
					button:SetImage("trakpak3_common/icons/signal_lun_"..dir..".png")
				end
			end
		end
	end
	
	element:Update(true,x,y,orientation,signal)
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
		button:SetImage("trakpak3_common/icons/switch_r_lit.png")
		
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
		button:SetImage("trakpak3_common/icons/switch_n_lit.png")
		
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
			local state = Dispatch.RealData[self.switch]["state"]
			local blocked = Dispatch.RealData[self.switch]["blocked"]
			local broken = Dispatch.RealData[self.switch]["broken"]
			
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
		local e = element
		function button:DoClick()
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
		if self.button and self.button:IsValid() then self.button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2) end
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
		button:SetImage("trakpak3_common/icons/block_occupied.png")
		
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
		button:SetImage("trakpak3_common/icons/block_clear.png")
		
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
			if Dispatch.RealData[self.block].occupied==1 then 
				button:SetImage("trakpak3_common/icons/block_occupied.png")
			else
				button:SetImage("trakpak3_common/icons/block_clear.png")
			end
		end
		
		function button:DoClick() 
			--Dispatchy Stuff
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
		if self.button and self.button:IsValid() then self.button:SetPos(px - Dispatch.elementsize/2, py - Dispatch.elementsize/2) end
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

--Create Line
function Dispatch.AddLine(ent, x1, y1, x2, y2)
	local element = Dispatch.AddElement(ent)
	element.type = "line"
	element.proporder = { "x1", "y1", "x2", "y2" }
	element.properties = {
		x1 = "integer",
		y1 = "integer",
		x2 = "integer",
		y2 = "integer"
	}
	element.mins = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0
	}
	element.maxs = {
		x1 = Dispatch.Boards[Dispatch.page].x_res,
		y1 = Dispatch.Boards[Dispatch.page].y_res,
		x2 = Dispatch.Boards[Dispatch.page].x_res,
		y2 = Dispatch.Boards[Dispatch.page].y_res
	}
	
	function element:Update(newprop, x1, y1, x2, y2)
		self.x1 = x1 or self.x1
		self.y1 = y1 or self.y1
		self.x2 = x2 or self.x2
		self.y2 = y2 or self.y2
		
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
		self.mins = {
			x1 = 0,
			y1 = 0,
			x2 = 0,
			y2 = 0
		}
		self.maxs = {
			x1 = Dispatch.Boards[Dispatch.page].x_res,
			y1 = Dispatch.Boards[Dispatch.page].y_res,
			x2 = Dispatch.Boards[Dispatch.page].x_res,
			y2 = Dispatch.Boards[Dispatch.page].y_res
		}
	end
	
	function element:Render(pnl, nohelpers, selected)
		--print(selected)
		
		--Draw Thicc Line
		local px1, py1 = pnl:GetPanelCoords(self.x1, self.y1)
		local px2, py2 = pnl:GetPanelCoords(self.x2, self.y2)
		
		local verts = Dispatch.GetLineVerts(px1, py1, self.corner1, 2)
		table.Add(verts, Dispatch.GetLineVerts(px2, py2, self.corner2, 2))
		
		if selected then 
			surface.SetDrawColor(color_sel)
		else
			surface.SetDrawColor(black)
		end
		surface.DrawPoly(verts)
		
		--Reposition Buttons
		if nohelpers then return end
		local cx, cy = 0.5*(px1 + px2), 0.5*(py1 + py2)
		if self.handle and self.handle:IsValid() then
			if selected then
				self.handle:SetPos(px1 - 8, py1 - 8)
			else
				self.handle:SetPos(cx - 8, cy - 8)
			end
		end
		if self.eh2 and self.eh2:IsValid() then self.eh2:SetPos(px2 - 8, py2 - 8) end
	end
	
	--print("Created Track Line from point "..x1..", "..y1.." to "..x2..", "..y2)
	element:Update(true, x1,y1,x2,y2)
	
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

--Create Block Line
function Dispatch.AddBlockLine(ent, x1, y1, x2, y2, block)
	local element = Dispatch.AddElement(ent)
	element.type = "blockline"
	element.proporder = { "x1", "y1", "x2", "y2", "block" }
	element.properties = {
		x1 = "integer",
		y1 = "integer",
		x2 = "integer",
		y2 = "integer",
		block = "string"
	}
	element.mins = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0
	}
	element.maxs = {
		x1 = Dispatch.Boards[Dispatch.page].x_res,
		y1 = Dispatch.Boards[Dispatch.page].y_res,
		x2 = Dispatch.Boards[Dispatch.page].x_res,
		y2 = Dispatch.Boards[Dispatch.page].y_res
	}
	
	function element:Update(newprop, x1, y1, x2, y2, block)
		self.x1 = x1 or self.x1
		self.y1 = y1 or self.y1
		self.x2 = x2 or self.x2
		self.y2 = y2 or self.y2
		self.block = block or self.block or ""
		
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
		self.mins = {
			x1 = 0,
			y1 = 0,
			x2 = 0,
			y2 = 0
		}
		self.maxs = {
			x1 = Dispatch.Boards[Dispatch.page].x_res,
			y1 = Dispatch.Boards[Dispatch.page].y_res,
			x2 = Dispatch.Boards[Dispatch.page].x_res,
			y2 = Dispatch.Boards[Dispatch.page].y_res
		}
	end
	
	function element:Render(pnl, nohelpers, selected)
		--print(selected)
		
		--Draw Thicc Line
		local px1, py1 = pnl:GetPanelCoords(self.x1, self.y1)
		local px2, py2 = pnl:GetPanelCoords(self.x2, self.y2)
		
		local verts = Dispatch.GetLineVerts(px1, py1, self.corner1, 2)
		table.Add(verts, Dispatch.GetLineVerts(px2, py2, self.corner2, 2))
		
		local occupied = false
		if Dispatch.RealData[self.block] then
			occupied = Dispatch.RealData[self.block].occupied
		end
		
		if selected or occupied then 
			surface.SetDrawColor(color_block2)
		else
			surface.SetDrawColor(color_block)
		end
		surface.DrawPoly(verts)
		
		--Reposition Button
		if nohelpers then return end
		local cx, cy = 0.5*(px1 + px2), 0.5*(py1 + py2)
		if self.handle and self.handle:IsValid() then
			if selected then
				self.handle:SetPos(px1 - 8, py1 - 8)
			else
				self.handle:SetPos(cx - 8, cy - 8)
			end
		end
		if self.eh2 and self.eh2:IsValid() then self.eh2:SetPos(px2 - 8, py2 - 8) end
	end
	
	--print("Created Track Line from point "..x1..", "..y1.." to "..x2..", "..y2)
	element:Update(true, x1,y1,x2,y2,block)
	
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

--Create Box
function Dispatch.AddBox(ent, x1, y1, x2, y2)
	local element = Dispatch.AddElement(ent)
	element.type = "box"
	element.proporder = { "x1", "y1", "x2", "y2" }
	element.properties = {
		x1 = "integer",
		y1 = "integer",
		x2 = "integer",
		y2 = "integer"
	}
	element.mins = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0
	}
	element.maxs = {
		x1 = Dispatch.Boards[Dispatch.page].x_res,
		y1 = Dispatch.Boards[Dispatch.page].y_res,
		x2 = Dispatch.Boards[Dispatch.page].x_res,
		y2 = Dispatch.Boards[Dispatch.page].y_res
	}
	
	function element:Update(newprop, x1, y1, x2, y2)
		self.x1 = x1 or self.x1
		self.y1 = y1 or self.y1
		self.x2 = x2 or self.x2
		self.y2 = y2 or self.y2
		
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
		self.mins = {
			x1 = 0,
			y1 = 0,
			x2 = 0,
			y2 = 0
		}
		self.maxs = {
			x1 = Dispatch.Boards[Dispatch.page].x_res,
			y1 = Dispatch.Boards[Dispatch.page].y_res,
			x2 = Dispatch.Boards[Dispatch.page].x_res,
			y2 = Dispatch.Boards[Dispatch.page].y_res
		}
	end
	
	function element:Render(pnl, nohelpers, selected)
		--print(selected)
		
		--Draw bax
		local px1, py1 = pnl:GetPanelCoords(self.x1, self.y1)
		local px2, py2 = pnl:GetPanelCoords(self.x2, self.y2)
		
		if selected then 
			surface.SetDrawColor(color_sel)
		else
			surface.SetDrawColor(black)
		end
		
		for n=1,2 do
			local inset = (n-1)
			local sx = px2 - px1 - 2*inset
			local sy = py2 - py1 - 2*inset
			surface.DrawOutlinedRect(px1 + inset, py1 + inset, sx, sy)
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
	element:Update(true, x1,y1,x2,y2)
	
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end

--Create Text
function Dispatch.AddText(ent, x1, y1, x2, y2, text)
	local element = Dispatch.AddElement(ent)
	element.type = "text"
	element.proporder = { "x1", "y1", "x2", "y2", "text" }
	element.properties = {
		x1 = "integer",
		y1 = "integer",
		x2 = "integer",
		y2 = "integer",
		text = "string"
	}
	element.mins = {
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0
	}
	element.maxs = {
		x1 = Dispatch.Boards[Dispatch.page].x_res,
		y1 = Dispatch.Boards[Dispatch.page].y_res,
		x2 = Dispatch.Boards[Dispatch.page].x_res,
		y2 = Dispatch.Boards[Dispatch.page].y_res
	}
	
	function element:Update(newprop, x1, y1, x2, y2, text)
		self.x1 = x1 or self.x1
		self.y1 = y1 or self.y1
		self.x2 = x2 or self.x2
		self.y2 = y2 or self.y2
		self.text = text or self.text or ""
		self.rendertext = string.Replace(self.text,"[n]","\n")
		
		
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
		local label = vgui.Create("DLabel",pnl)
		label:SetFont("tp3_dispatch")
		label:SetTextColor(black)
		label:SetContentAlignment(5)
		self.label = label
		
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
		self.mins = {
			x1 = 0,
			y1 = 0,
			x2 = 0,
			y2 = 0
		}
		self.maxs = {
			x1 = Dispatch.Boards[Dispatch.page].x_res,
			y1 = Dispatch.Boards[Dispatch.page].y_res,
			x2 = Dispatch.Boards[Dispatch.page].x_res,
			y2 = Dispatch.Boards[Dispatch.page].y_res
		}
	end
	
	function element:Render(pnl, nohelpers, selected)
		--print(selected)
		
		--Draw bax
		local px1, py1 = pnl:GetPanelCoords(self.x1, self.y1)
		local px2, py2 = pnl:GetPanelCoords(self.x2, self.y2)
		
		local sx = px2 - px1
		local sy = py2 - py1
		
		if selected then 
			surface.SetDrawColor(color_sel)
		else
			surface.SetDrawColor(black)
		end
		
		surface.DrawOutlinedRect(px1, py1, sx, sy)
		
		--Reposition Label
		if self.label and self.label:IsValid() then
			self.label:SetPos(px1,py1)
			self.label:SetSize(sx,sy)
			self.label:SetText(self.rendertext)
		end
		
		--Reposition Button
		if nohelpers then return end
		if self.handle and self.handle:IsValid() then
			self.handle:SetPos(px1 - 8, py1 - 8)
		end
		if self.eh2 and self.eh2:IsValid() then self.eh2:SetPos(px2 - 8, py2 - 8) end
		
		
	end
	
	--print("Created Track Line from point "..x1..", "..y1.." to "..x2..", "..y2)
	element:Update(true, x1,y1,x2,y2,text or "Sample Text")
	
	--if Dispatch.selectnew then Dispatch.PopulatePage(Dispatch.page) end
end


--Helper Functions for Elements

--Line Rendering
function Dispatch.GetLineVerts(px, py, corner, w)
	local verts = {}
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
			elements = {}
		}
		
		for id, element in pairs(board.elements) do
			local new = {}
			new.type = element.type
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
			else --text
				new.x1 = element.x1
				new.y1 = element.y1
				new.x2 = element.x2
				new.y2 = element.y2
				new.text = element.text
			end
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
		
		if ent then --Load to a world board
			print("Loading ",ent)
			ent:Deselect()
			ent.Boards = {}
			
			for page = 1, #mapboards do
				--Create Board page
				local mb = mapboards[page]
				ent.Boards[page] = {
					name = mb.name,
					x_res = mb.x_res,
					y_res = mb.y_res,
					elements = {}
				}
				Dispatch.page = page
				--Fill it with stuff
				for id, element in pairs(mb.elements) do
					if element.type=="signal" then
						Dispatch.AddSignal(ent, element.x, element.y, element.orientation, element.signal)
					elseif element.type=="switch" then
						Dispatch.AddSwitch(ent, element.x, element.y, element.switch)
					elseif element.type=="block" then
						Dispatch.AddBlock(ent, element.x, element.y, element.block)
					elseif element.type=="line" then
						Dispatch.AddLine(ent, element.x1, element.y1, element.x2, element.y2)
					elseif element.type=="blockline" then
						Dispatch.AddBlockLine(ent, element.x1, element.y1, element.x2, element.y2, element.block)
					elseif element.type=="box" then
						Dispatch.AddBox(ent, element.x1, element.y1, element.x2, element.y2)
					elseif element.type=="text" then
						Dispatch.AddText(ent, element.x1, element.y1, element.x2, element.y2, element.text)
					end
				end
				
			end
			print("Loaded ",ent)
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
					elements = {}
				}
				Dispatch.page = page
				--Fill it with stuff
				for id, element in pairs(mb.elements) do
					if element.type=="signal" then
						Dispatch.AddSignal(nil, element.x, element.y, element.orientation, element.signal)
					elseif element.type=="switch" then
						Dispatch.AddSwitch(nil, element.x, element.y, element.switch)
					elseif element.type=="block" then
						Dispatch.AddBlock(nil, element.x, element.y, element.block)
					elseif element.type=="line" then
						Dispatch.AddLine(nil, element.x1, element.y1, element.x2, element.y2)
					elseif element.type=="blockline" then
						Dispatch.AddBlockLine(nil, element.x1, element.y1, element.x2, element.y2, element.block)
					elseif element.type=="box" then
						Dispatch.AddBox(nil, element.x1, element.y1, element.x2, element.y2)
					elseif element.type=="text" then
						Dispatch.AddText(nil, element.x1, element.y1, element.x2, element.y2, element.text)
					end
				end
				
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
		net.WriteUInt(arg,2)
	net.SendToServer()
	LocalPlayer():EmitSound("buttons/lightswitch2.wav")
end

--Receive Status from Entity
net.Receive("tp3_dispatch_comm", function(mlen, ply)
	local entname = net.ReadString()
	local parm = net.ReadString()
	local value = net.ReadUInt(2)
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
		end
	end
	
	
	local lpanel = vgui.Create("DPanel",frame)
	function lpanel:Paint() end
	lpanel:Dock(FILL)
	
	--The Main Area (Canvas)
	
	local backing = vgui.Create("DImage",lpanel)
	backing:Dock(FILL)
	backing:SetImage("trakpak3_common/icons/backing.png")
	backing:SetKeepAspect(false)
	
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