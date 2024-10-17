TOOL.Category = "Constraints"
TOOL.Name = "AutoCoupler"

if CLIENT then
	
	language.Add("Tool.tp3_autocoupler.name","Trakpak3 AutoCoupler")
	language.Add("Tool.tp3_autocoupler.desc","Adds automatic couplers to rolling stock. Duplicator-Compatible!")
	
	language.Add("Tool.tp3_autocoupler.left_1","Add AutoCouplers automatically. Works best for 'regular' locomotives/railcars. Displays existing AutoCouplers on cars that have them already.")
	language.Add("Tool.tp3_autocoupler.left_2","Select the prop that will be roped when coupling (the truck/bogie/axle).")
	language.Add("Tool.tp3_autocoupler.right_1","View/Edit a prop's AutoCouplers manually.")
	language.Add("Tool.tp3_autocoupler.reload_1","Remove Autocouplers from a car and/or deselect.")
	language.Add("Tool.tp3_autocoupler.reload_2","Cancel prop selection.")
	
	TOOL.Information = {
		{ name = "left_1", stage = 0 }, --Auto Solve
		{ name = "left_2", stage = 1 }, --Pick Truck
		{ name = "right_1", stage = 0 }, --Open Editor
		{ name = "reload_1", stage = 0 }, --Clear
		{ name = "reload_2", stage = 1 }, --Cancel
	}
	
	TOOL.ClientConVar["slack"] = 6
	TOOL.ClientConVar["tolerance"] = 48
	TOOL.ClientConVar["ropewidth"] = 2
	TOOL.ClientConVar["decoupletime"] = 1
	
	TOOL.BuildCPanel = function(pnl) Trakpak3.AutoCoupler.ToolPanel(pnl) end
	--function TOOL:DrawHud() Trakpak3.AutoCoupler.DrawHUD() end
	
	--Forward to sh_autocoupler.lua
	function TOOL:LeftClick(tr) return true end
	function TOOL:RightClick(tr) return true end
	function TOOL:Reload(tr) return true end
end

if SERVER then
	
	--Forward to sh_autocoupler.lua
	function TOOL:LeftClick(tr) return Trakpak3.AutoCoupler.LeftClick(self, tr) end
	function TOOL:RightClick(tr) return Trakpak3.AutoCoupler.RightClick(self, tr) end
	function TOOL:Reload(tr) return Trakpak3.AutoCoupler.Reload(self, tr) end
	
end
