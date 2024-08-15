AddCSLuaFile()

DEFINE_BASECLASS("tp3_base_prop")
ENT.PrintName = "Trakpak3 Dispatch Board"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Change Signals and Switches Remotely"
ENT.Instructions = "Place in Hammer"

if SERVER then

	ENT.KeyValueMap = {
		board = "string",
		endpos = "vector"
	}
	
	function ENT:Initialize()
		local pos = self:GetPos()
		local disp = self.endpos - pos
		local norm = disp:Cross(Vector(0,0,1)):GetNormalized()
		
		self:SetNWVector("campos",pos + norm*0.5)
		self:SetNWVector("endpos",self.endpos)
		
		local dx = Vector(disp.x, disp.y, 0)
		local dy = Vector(0, 0, disp.z)
		
		self:SetNWFloat("dx",dx:Length())
		self:SetNWFloat("dy",dy:Length())
		self:SetNWAngle("camang", dx:AngleEx(dx:Cross(-dy)) )
		self:SetNWFloat("camscale", 0.125 ) --Inches per Pixel
		
		self:SetNWString("page",self.board)
		
		--Setpos to midpoint of the rectangle for better rendering due to frustrum culling
		self:SetPos(0.5*pos + 0.5*self.endpos)
	end
end

if CLIENT then
	local Dispatch = Trakpak3.Dispatch
	ENT.Boards = {}
	
	--Draw the Dispatch board (including its creation)
	function ENT:DrawTranslucent()
		if not self.init then return end
		if not self.hasparams then
			self.pos = self:GetNWVector("campos",nil)
			self.endpos = self:GetNWVector("endpos",nil)
			self.ang = self:GetNWAngle("camang",nil)
			self.scale = self:GetNWFloat("camscale",nil)
			self.dx = self:GetNWFloat("dx",nil)
			self.dy = self:GetNWFloat("dy",nil)
			
			if self.pos and self.endpos and self.ang and self.scale and self.dx and self.dy then self.hasparams = true end
		end
		
		if not self.pagenum and (#self.Boards>0) then
			local page = self:GetNWString("page",nil)
			for n, board in pairs(self.Boards) do 
				if page==board.name then
					self.pagenum = n
					break
				end
			end
			if self.pagenum then
				--print("Your page number is "..self.pagenum)
			else
				ErrorNoHalt("[Trakpak3] Could not find a page number for '"..page.."'")
			end
		end
		
		if self.hasparams and self.pagenum and not self.hasframe then
			self.hasframe = true
			local color = self.Boards[self.pagenum].color or "95 95 95"
			
			self:InitializeBoard(color)
		end
		
		if self.frame then
			vgui.Start3D2D(self.pos, self.ang, self.scale)
				vgui.MaxRange3D2D(256)
				self.frame:Paint3D2D()
				
			vgui.End3D2D()
		end
		
	end
	
	function ENT:Draw()	end
	
	function ENT:Think()
		if not self.init and Dispatch.canload then
			Dispatch.LoadBoards(false, self)
			self.init = true
			--print("Initialized entity ",self)
			--PrintTable(self.Boards)
		end
	end
	
	function ENT:InitializeBoard(color)
		local e = self
		--Background Panel
		self.frame = vgui.Create("DPanel")
		self.frame:SetSize(self.dx/self.scale, self.dy/self.scale)
		self.frame:SetPos(0,0)
		
		--The Main Area (Canvas)

		local backing = vgui.Create("DImage",self.frame)
		backing:Dock(FILL)
		backing:SetImage("trakpak3_common/icons/backing.png")
		backing:SetKeepAspect(false)
		backing:SetImageColor(Dispatch.StringToColor(color))

		--Canvas
		local canvas = vgui.Create("DButton",self.frame)
		canvas:Dock(FILL)
		
		canvas:SetText("")
		
		function canvas:DoClick() e:Deselect() end
		
		function canvas:GetPanelCoords(gx, gy) --convert grid coords to panel coords
			local sx, sy = self:GetSize()
			local rx, ry = e.Boards[e.pagenum].x_res, e.Boards[e.pagenum].y_res
			
			return sx*gx/rx, sy*gy/ry
		end
		
		function canvas:GetGridCoords(px, py) --convert panel coords to grid coords
			local sx, sy = self:GetSize()
			local rx, ry = e.Boards[e.pagenum].x_res, e.Boards[e.pagenum].y_res
			
			local gx = math.Round(rx*px/sx)
			local gy = math.Round(ry*py/sy)
			
			return math.Clamp(gx,0,rx), math.Clamp(gy,0,ry)
		end
		
		--Render the Dispatch board
		function canvas:Paint(w, h)
			if e.Boards then
				local board = e.Boards[e.pagenum]
				if e.pagenum > 0 then
					draw.NoTexture()
					
					--Render Elements
					for k, element in pairs(board.elements) do
						element:Render(self)
					end
				end
			end
		end
		
		self:SetRenderBoundsWS(self.pos,self.endpos)
		
		--Populate Page
		timer.Simple(1, function() self:PopulatePage(canvas, self.pagenum) end)
	end
	
	--Create all the elements on the page
	function ENT:PopulatePage(canvas, page)
		--Set Labels and Boxes
		
		local Board = self.Boards[page]
		
		--Fill Canvas
		canvas:Clear()
		if Board then
			for k, element in pairs(Board.elements) do
				element:Generate(canvas)
				--print("Generating element "..element.type)
			end
		end
	end
	
	--Select & Deselect
	function ENT:Select(id)
		if self.selected then
			self.Boards[self.pagenum].elements[self.selected]:OnDeselect()
		end
		self.selected = id
		local element = self.Boards[self.pagenum].elements[self.selected]
		element:OnSelect()
	end
	function ENT:Deselect()
		if self.selected then
			self.Boards[self.pagenum].elements[self.selected]:OnDeselect()
		end
		self.selected = nil
	end
	
	--Set flags required to reinitialize boards following a map cleanup
	local resetboards = function()
		for _, board in pairs(ents.FindByClass("tp3_dispatch_board")) do
			board.hasparams = false
			board.hasframe = false
		end
	end
	
	hook.Add("PostCleanupMap","Trakpak3_ResetWorldDSBoards",function()
		timer.Simple(1,resetboards)
	end)
	
end