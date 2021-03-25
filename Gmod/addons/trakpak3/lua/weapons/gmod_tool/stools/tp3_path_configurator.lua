TOOL.Category = "Trakpak3 Dev Tools"
TOOL.Name = "Path Configurator"
TOOL.Command = nil
TOOL.Configname = ""

if CLIENT then
	--[[
	List of Operations
	
	Mode 0 - Nothing is selected
	Select a Signal to Configure (Left)
	
	Mode 1 - You have selected a signal
	Select another Signal to Configure (Left)
	Add/Cycle/Remove a switch/stand to selected path (Left)
	Add/Remove a Block/NextSignal (E+Left)
	Open Signal Config Menu (Right)
	Deselect Signal (Reload)
	
	
	]]--
	TOOL.Information0 = {"left"}
	
	TOOL.Information1 = {"left", "right", "reload"}
	
	language.Add("Tool.tp3_path_configurator.name","Trakpak3 Path Configurator")
	language.Add("Tool.tp3_path_configurator.desc","Configure path info for signals. For use by mappers only!")
	
	function TOOL:SetupGui0()
		self.Information = self.Information0
		language.Add("Tool.tp3_path_configurator.left","Select a signal (master) and open the Path Configuration Menu.")
	end
	
	function TOOL:SetupGui1()
		self.Information = self.Information1
		language.Add("Tool.tp3_path_configurator.left","Select a different signal, or toggle switch state for the selected path.")
		language.Add("Tool.tp3_path_configurator.right","Open the Path Configuration Menu.")
		language.Add("Tool.tp3_path_configurator.reload","Deselect the currently-selected signal.")
	end
	
	TOOL:SetupGui0()
	
	
	function TOOL:Deploy()
		
	end
	
	--local PathConfig = Trakpak3.PathConfig
	
	--Left Click
	net.Receive("tp3_pc_leftclick", function()
		local id = net.ReadUInt(32)
		local use = net.ReadBool()
		--print(id)
		if id!=0 then
			local ent = Entity(id)

			if ent and ent:IsValid() then
				if Trakpak3.PathConfig.selected then
					if use and Trakpak3.PathConfig.selected_path then --Scan for a Block/Gate
						Trakpak3.PathConfig.SelectBlock()
					else --Click a physical object
						if ent:GetClass()=="tp3_signal_master" then --A signal, may or may not be editing a path
							Trakpak3.PathConfig.SelectSignal(ent)
							--print(Trakpak3.PathConfig.selected)
						elseif Trakpak3.PathConfig.selected_path then --Not a signal, but you are editing a path
							Trakpak3.PathConfig.CycleSwitch(ent)
						end
					end
					
				else --Nothing is selected, attempt to select a signal
					Trakpak3.PathConfig.SelectSignal(ent)
				end
			end
		else --Hit World; Search for Blocks in area
			--Trakpak3.PathConfig.DeselectSignal()
			if use and Trakpak3.PathConfig.selected and Trakpak3.PathConfig.selected_path then
				Trakpak3.PathConfig.SelectBlock()
			end
		end
	end)
	
	--Right Click
	net.Receive("tp3_pc_rightclick", function()
		if Trakpak3.PathConfig.selected then Trakpak3.PathConfig.OpenMenu() end 
	end)
	
	--Reload
	net.Receive("tp3_pc_reload", function()
		if Trakpak3.PathConfig.selected then Trakpak3.PathConfig.DeselectSignal() end
	end)
	
	function TOOL:DrawHUD()
		Trakpak3.PathConfig.Draw()
	end
end

--Fake hook calling on client since these hooks are predicted
if SERVER then
	util.AddNetworkString("tp3_pc_leftclick")
	util.AddNetworkString("tp3_pc_rightclick")
	util.AddNetworkString("tp3_pc_reload")
	
	function TOOL:LeftClick(tr)
		local ply = self:GetOwner()
		--local json = util.TableToJSON(tr)
		local id = 0
		if not tr.HitWorld then id = tr.Entity:EntIndex() end
		
		local k_use = self:GetOwner():KeyDown(IN_USE)
		
		net.Start("tp3_pc_leftclick")
		--net.WriteString(json)
			net.WriteUInt(id,32)
			net.WriteBool(k_use)
		net.Send(ply)
		return true
	end
	function TOOL:RightClick(tr)
		local ply = self:GetOwner()
		--local json = util.TableToJSON(tr)
		net.Start("tp3_pc_rightclick")
		--net.WriteString(json)
		net.Send(ply)
		return true
	end
	function TOOL:Reload(tr)
		local ply = self:GetOwner()
		local json = util.TableToJSON(tr)
		net.Start("tp3_pc_reload")
		net.WriteString(json)
		net.Send(ply)
		return true
	end
end