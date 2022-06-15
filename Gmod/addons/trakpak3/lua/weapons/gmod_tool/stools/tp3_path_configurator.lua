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
	
	local SP = game.SinglePlayer()
	
	TOOL.Information0 = {"left"}
	TOOL.Information1 = {"left", "right", "reload"}
	TOOL.Information2 = {"left", "right", "reload"}
	
	language.Add("Tool.tp3_path_configurator.name","Trakpak3 Path Configurator")
	if SP then
		language.Add("Tool.tp3_path_configurator.desc","Configure path info for signals. For use by mappers only!")
	else
		language.Add("Tool.tp3_path_configurator.desc","Configure path info for signals. This tool does not work in multiplayer!")
	end
	
	function TOOL:SetupGui(mode)
		if not SP then
			self.Information = {}
		else
			if mode==0 then --Nothing Selected
				self.Information = self.Information0
				language.Add("Tool.tp3_path_configurator.left","Select a tp3_signal_master and open its Path Configuration Menu.")
			elseif mode==1 then --Signal Selected
				self.Information = self.Information1
				language.Add("Tool.tp3_path_configurator.left","Select a tp3_signal_master and open its Path Configuration Menu.")
				language.Add("Tool.tp3_path_configurator.right","Open the Path Configuration Menu.")
				language.Add("Tool.tp3_path_configurator.reload","Deselect the currently-selected signal.")
			elseif mode==2 then --Signal and Path Selected
				self.Information = self.Information2
				language.Add("Tool.tp3_path_configurator.left","Select a NextSignal, Signal Block, or Logic Gate, or Select/Cycle a Switch.")
				language.Add("Tool.tp3_path_configurator.right","Open the Path Configuration Menu.")
				language.Add("Tool.tp3_path_configurator.reload","Deselect the currently-selected signal.")
			end
		end
	end
	
	TOOL:SetupGui(0)
	
	function TOOL:Think()
		local newmode = 0
		local sel = Trakpak3.PathConfig.selected
		local path = Trakpak3.PathConfig.selected_path
		
		if sel and path then
			newmode = 2
		elseif sel then
			newmode = 1
		end
		
		if not self.mode then self.mode = 0 end
		
		if self.mode != newmode then
			self.mode = newmode
			self:SetupGui(newmode)
		end
	end
	
	function TOOL:Deploy()
		
	end
	
	--local PathConfig = Trakpak3.PathConfig
	
	--Left Click
	--[[
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
		else --Hit World; Search for Blocks in area or Deselect
			--Trakpak3.PathConfig.DeselectSignal()
			if Trakpak3.PathConfig.selected and Trakpak3.PathConfig.selected_path then
				Trakpak3.PathConfig.SelectBlock()
			elseif Trakpak3.PathConfig.selected then
				Trakpak3.PathConfig.DeselectSignal()
			end
		end
	end)
	]]--
	Trakpak3.Net.tp3_pc_leftclick = function(len,ply)
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
		else --Hit World; Search for Blocks in area or Deselect
			--Trakpak3.PathConfig.DeselectSignal()
			if Trakpak3.PathConfig.selected and Trakpak3.PathConfig.selected_path then
				Trakpak3.PathConfig.SelectBlock()
			elseif Trakpak3.PathConfig.selected then
				Trakpak3.PathConfig.DeselectSignal()
			end
		end
	end
	
	--Right Click
	--[[
	net.Receive("tp3_pc_rightclick", function()
		if Trakpak3.PathConfig.selected then Trakpak3.PathConfig.OpenMenu() end 
	end)
	]]--
	Trakpak3.Net.tp3_pc_rightclick = function(len,ply)
		if Trakpak3.PathConfig.selected then Trakpak3.PathConfig.OpenMenu() end 
	end
	
	--Reload
	--[[
	net.Receive("tp3_pc_reload", function()
		if Trakpak3.PathConfig.selected then Trakpak3.PathConfig.DeselectSignal() end
	end)
	]]--
	Trakpak3.Net.tp3_pc_reload = function(len,ply)
		if Trakpak3.PathConfig.selected then Trakpak3.PathConfig.DeselectSignal() end
	end
	
	--Draw HUD Elements
	function TOOL:DrawHUD()
		Trakpak3.PathConfig.Draw()
	end
	
	--Tool Menu
	function TOOL.BuildCPanel(panel)
		
		--Save Button
		local button = vgui.Create("DButton",panel)
		button:SetText("Save Path Configs")
		function button:DoClick()
			LocalPlayer():EmitSound("buttons/button3.wav")
			local AYS = vgui.Create("DFrame")
			AYS:SetPos((ScrW() - 272)/2,(ScrH() - 128)/2)
			AYS:SetSize(272,128)
			AYS:SetTitle("Save Path Config File?")
			AYS:MakePopup()
			AYS:DockPadding(32,32,32,16)
			
			local warning = vgui.Create("DLabel",AYS)
			warning:SetText("This will override the file in\ndata/trakpak3/pathconfig/.")
			warning:SetSize(1,48)
			warning:Dock(TOP)
			
			local yesbutton = vgui.Create("DButton", AYS)
			yesbutton:SetText("Save")
			yesbutton.DoClick = function()
				Trakpak3.PathConfig.Save()
				AYS:Close()
			end
			yesbutton:Dock(LEFT)
			
			local nobutton = vgui.Create("DButton", AYS)
			nobutton:SetText("Cancel")
			nobutton:SetColor(Color(255,0,0))
			nobutton.DoClick = function()
				AYS:Close()
			end
			nobutton:Dock(RIGHT)
		end
		panel:AddPanel(button)
		
		--Load (File) Button
		local button = vgui.Create("DButton",panel)
		button:SetText("Load From File")
		button.DoClick = function()
			
			LocalPlayer():EmitSound("buttons/button3.wav")
			local AYS = vgui.Create("DFrame")
			AYS:SetPos((ScrW() - 272)/2,(ScrH() - 128)/2)
			AYS:SetSize(272,128)
			AYS:SetTitle("Load Path Config File?")
			AYS:MakePopup()
			AYS:DockPadding(32,32,32,16)
			
			local warning = vgui.Create("DLabel",AYS)
			warning:SetText("This will override current path config data.")
			warning:Dock(TOP)
			
			local yesbutton = vgui.Create("DButton", AYS)
			yesbutton:SetText("Load")
			yesbutton.DoClick = function()
				Trakpak3.PathConfig.Load()
				AYS:Close()
			end
			yesbutton:Dock(LEFT)
			
			local nobutton = vgui.Create("DButton", AYS)
			nobutton:SetText("Cancel")
			nobutton:SetColor(Color(255,0,0))
			nobutton.DoClick = function()
				AYS:Close()
			end
			nobutton:Dock(RIGHT)
		end
		panel:AddPanel(button)
		
		--Load (Map) Button
		local button = vgui.Create("DButton",panel)
		button:SetText("Load From Map")
		button.DoClick = function()
			
			LocalPlayer():EmitSound("buttons/button3.wav")
			local AYS = vgui.Create("DFrame")
			AYS:SetPos((ScrW() - 272)/2,(ScrH() - 128)/2)
			AYS:SetSize(272,128)
			AYS:SetTitle("Load Path Config From Map?")
			AYS:MakePopup()
			AYS:DockPadding(32,32,32,16)
			
			local warning = vgui.Create("DLabel",AYS)
			warning:SetText("This will override current path config data.")
			warning:Dock(TOP)
			
			local yesbutton = vgui.Create("DButton", AYS)
			yesbutton:SetText("Load")
			yesbutton.DoClick = function()
				Trakpak3.PathConfig.LoadFromServer(true)
				AYS:Close()
			end
			yesbutton:Dock(LEFT)
			
			local nobutton = vgui.Create("DButton", AYS)
			nobutton:SetText("Cancel")
			nobutton:SetColor(Color(255,0,0))
			nobutton.DoClick = function()
				AYS:Close()
			end
			nobutton:Dock(RIGHT)
		end
		panel:AddPanel(button)
		
		--Clear Button
		local button = vgui.Create("DButton",panel)
		button:SetText("Clear Path Configs")
		button.DoClick = function()
			
			LocalPlayer():EmitSound("buttons/button3.wav")
			local AYS = vgui.Create("DFrame")
			AYS:SetPos((ScrW() - 272)/2,(ScrH() - 128)/2)
			AYS:SetSize(272,128)
			AYS:SetTitle("Clear Path Configs?")
			AYS:MakePopup()
			AYS:DockPadding(32,32,32,16)
			
			local warning = vgui.Create("DLabel",AYS)
			warning:SetText("Anything not saved will be lost.")
			warning:Dock(TOP)
			
			local yesbutton = vgui.Create("DButton", AYS)
			yesbutton:SetText("Clear")
			yesbutton.DoClick = function()
				Trakpak3.PathConfig.Clear()
				AYS:Close()
			end
			yesbutton:Dock(LEFT)
			
			local nobutton = vgui.Create("DButton", AYS)
			nobutton:SetText("Cancel")
			nobutton:SetColor(Color(255,0,0))
			nobutton.DoClick = function()
				AYS:Close()
			end
			nobutton:Dock(RIGHT)

		end
		panel:AddPanel(button)
		
	end
end

--Fake hook calling on client since these hooks are predicted
if SERVER then
	--util.AddNetworkString("tp3_pc_leftclick")
	--util.AddNetworkString("tp3_pc_rightclick")
	--util.AddNetworkString("tp3_pc_reload")
	
	local SP = game.SinglePlayer()
	
	function TOOL:LeftClick(tr)
		if SP then
			local ply = self:GetOwner()
			--local json = util.TableToJSON(tr)
			local id = 0
			if not tr.HitWorld then id = tr.Entity:EntIndex() end
			
			local k_use = self:GetOwner():KeyDown(IN_USE)
			
			--net.Start("tp3_pc_leftclick")
			net.Start("trakpak3")
			net.WriteString("tp3_pc_leftclick")
			--net.WriteString(json)
				net.WriteUInt(id,32)
				net.WriteBool(k_use)
			net.Send(ply)
			return true
		else
			return false
		end
	end
	function TOOL:RightClick(tr)
		if SP then
			local ply = self:GetOwner()
			--local json = util.TableToJSON(tr)
			--net.Start("tp3_pc_rightclick")
			net.Start("trakpak3")
			net.WriteString("tp3_pc_rightclick")
			--net.WriteString(json)
			net.Send(ply)
			return true
		else
			return false
		end
	end
	function TOOL:Reload(tr)
		if SP then
			local ply = self:GetOwner()
			--local json = util.TableToJSON(tr)
			--net.Start("tp3_pc_reload")
			--net.WriteString(json)
			net.Start("trakpak3")
			net.WriteString("tp3_pc_reload")
			net.Send(ply)
			return true
		else
			return false
		end
	end
end