--Auto Save for the various editors

--Run this function every time something changes. It will prompt the user about autosave the first time, and log that something in the appropriate system has changed.
function Trakpak3.AutosaveLog(key)
	if not Trakpak3.AutosaveInitial then --Prompt the user about auto save the first time they do something
		Trakpak3.AutosaveInitial = true
		LocalPlayer():EmitSound("vo/npc/male01/heydoc01.wav")
		Trakpak3.AutosaveMenu()
	end
	if not Trakpak3.AutosaveDeltas then Trakpak3.AutosaveDeltas = {} end
	Trakpak3.AutosaveDeltas[key] = true
end

--Run this function on manual save to clear the key
function Trakpak3.AutosaveClear(key)
	if not Trakpak3.AutosaveDeltas then Trakpak3.AutosaveDeltas = {} end --Initialize the table
	Trakpak3.AutosaveDeltas[key] = false
end

--The actual Autosave function
hook.Add("Think","Trakpak3_Autosave", function()
	if Trakpak3.Autosave then
		local ct = CurTime()
		if ct > ((Trakpak3.LastAutosave or 0) + 60) then --60 seconds has passed since the last auto save
			
			if not Trakpak3.AutosaveDeltas then Trakpak3.AutosaveDeltas = {} end --Initialize the table
			
			local D = Trakpak3.AutosaveDeltas
			
			local playsound
			
			--Node Edit
			if D["nodetools"] then
				Trakpak3.SaveNodeFile()
				D["nodetools"] = false
				playsound = true
			end
			
			--Path Configurator
			if D["pathconfig"] then
				Trakpak3.PathConfig.Save()
				D["pathconfig"] = false
				playsound = true
			end
			
			if playsound then
				LocalPlayer():EmitSound("garrysmod/save_load"..math.random(1,4)..".wav",75,100,0.5)
				chat.AddText(Color(0,255,0),"Autosaved!")
			end
			
			Trakpak3.LastAutosave = ct
		end
	end
end)

--List of Supported Systems
local supported = {
	"Node Editor/Node Chainer Tools",
	"Path Configurator"
}
local listcolor = Color(255,255,255)

--Open the Auto Save Dialog
function Trakpak3.AutosaveMenu()
	
	local frame = vgui.Create("DFrame")
	
	local w, h = 384, 384
	
	frame:SetPos(ScrW()/2 - w/2, ScrH()/2 - h/2)
	frame:MakePopup()
	
	frame:SetTitle("Enable Autosave?")
	frame:SetSize(w,h)
	
	local label = vgui.Create("DLabel",frame)
	label:SetText("Enable autosave for Trakpak3 Editors?\n\nThis feature will automatically save the config files for Trakpak3's in-game editors every 60 seconds, provided something has actually changed since the last autosave.")
	label:SetSize(1,72)
	label:SetWrap(true)
	label:Dock(TOP)
	
	local label = vgui.Create("DLabel",frame)
	label:SetText("THIS WILL OVERWRITE YOUR LOCAL FILES (IN THE DATA FOLDER) WITHOUT ASKING!")
	label:SetSize(1,48)
	label:SetWrap(true)
	label:Dock(TOP)
	label:SetTextColor(Color(255,63,63))
	
	local label = vgui.Create("DLabel",frame)
	label:SetText("Files included with the map (in the lua folder) are unaffected.\n\nCurrent systems supported:")
	label:SetSize(1,48)
	label:SetWrap(true)
	label:Dock(TOP)
	
	for _, system in ipairs(supported) do
		local label = vgui.Create("DLabel",frame)
		label:SetText("    • "..system)
		label:SetSize(1,16)
		label:SetTextColor(listcolor)
		label:Dock(TOP)
	end
	
	local panel = vgui.Create("DPanel",frame)
	panel:SetSize(1,48)
	panel:Dock(BOTTOM)
	function panel:Paint() end
	
	local enable = vgui.Create("DButton",panel)
	enable:SetText("Enable")
	enable:SetSize(64,1)
	enable:Dock(LEFT)
	enable.DoClick = function()
		Trakpak3.Autosave = true
		Trakpak3.LastAutosave = CurTime()
		frame:Close()
		chat.AddText(Color(0,255,0),"[Trakpak3] Autosave Enabled.")
		LocalPlayer():EmitSound("hl1/fvox/activated.wav")
		LocalPlayer():EmitSound("ambient/machines/thumper_startup1.wav")
	end
	
	local disable = vgui.Create("DButton",panel)
	disable:SetText("Disable/Cancel")
	disable:SetSize(96,1)
	disable:Dock(RIGHT)
	disable.DoClick = function()
		if Trakpak3.Autosave then 
			chat.AddText(Color(255,0,0),"[Trakpak3] Autosave Disabled.")
			LocalPlayer():EmitSound("hl1/fvox/deactivated.wav")
			LocalPlayer():EmitSound("ambient/machines/thumper_shutdown1.wav")
		else
			chat.AddText(Color(255,255,255),"[Trakpak3] Autosave Not Enabled.")
			LocalPlayer():EmitSound("buttons/combine_button3.wav")
		end
		Trakpak3.Autosave = false
		frame:Close()
		
	end
end