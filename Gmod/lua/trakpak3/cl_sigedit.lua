--SigEdit: Trakpak3's Signal System Editor

--Signal Editor variables
function Trakpak3.ResetSigEdit()
	Trakpak3.SigEdit = {
		rules = {},
		tags = {},
		sigtypes = {},
		panels = {rules = {}, tags = {}, types = {}, cfg = {}, nodes = {}},
	}
end
Trakpak3.ResetSigEdit()

--Signal Editor Concommand
concommand.Add("tp3_signal_editor", function()
	Trakpak3.OpenSigEdit()
end)

--[[
concommand.Add("tp3_sigedit_reset", function()
	Trakpak3.ResetSigEdit()
	print("Reset SigEdit.")
end)
]]--

local function SSC(panel, w, h)
	panel:SetPos(ScrW()/2 - w/2, ScrH()/2 - h/2)
	panel:SetSize(w,h)
end


function Trakpak3.OpenSigEdit(page)
	--local SigEdit = Trakpak3.SigEdit
	--Open new frame and then populate
	local frame = vgui.Create("DFrame")
	frame:MakePopup()

	--Populate with chosen page
	Trakpak3.SigEdit.page = page or Trakpak3.SigEdit.page or 0
	if Trakpak3.SigEdit.page==0 then --New/Load menu
		SSC(frame, 384,192)
		frame:SetTitle("Trakpak3 Signal System Editor: New/Load System")
		
		local epanel = vgui.Create("DPanel",frame)
		epanel:Dock(FILL)
		
		local left = vgui.Create("DPanel",epanel)
		left:SetSize(256,1)
		left:Dock(LEFT)
		function left:Paint() end
		
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("Create a new Trakpak3 signaling system,\nor load one with the following name:")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local newtext = vgui.Create("DTextEntry", left)
		newtext:SetSize(192,32)
		newtext:Dock(TOP)
		
		local right = vgui.Create("DPanel",epanel)
		right:Dock(FILL)
		function right:Paint() end
		
		--Create new signal system button
		local newbutton = vgui.Create("DButton",right)
		newbutton:SetSize(128,32)
		newbutton:Dock(TOP)
		newbutton:SetText("Create New")
		newbutton.DoClick = function()
			local name = newtext:GetValue()
			if true then
				--Trakpak3.SigEdit.sysname = name
				
				Trakpak3.OpenSigEdit(1)
				frame:Close()
			end
		end
		
		local loadbutton = vgui.Create("DButton",right)
		loadbutton:SetSize(128,32)
		loadbutton:Dock(TOP)
		loadbutton:SetText("Load Existing")
		loadbutton.DoClick = function()
			local name = newtext:GetValue()
			if name and name != "" then
				local loaded = Trakpak3.SigEdit.LoadSigEdit(name)
				if loaded then
					Trakpak3.OpenSigEdit(1)
					frame:Close()
				else
					local badlabel = vgui.Create("DLabel",left)
					badlabel:Dock(FILL)
					badlabel:SetText("Could not load the specified signal system.\nDouble check the filename and try again.")
					badlabel:SetColor(Color(255,0,0))
					badlabel:SetContentAlignment(5)
					LocalPlayer():EmitSound("buttons/button5.wav")
				end
			end
		end
		
	elseif Trakpak3.SigEdit.page==1 then --Everything Else
		SSC(frame, 1280,640)
		frame:SetTitle("Trakpak3 Signal System Editor: Configure")
		
		local sheet = vgui.Create("DPropertySheet",frame)
		sheet:Dock(FILL)
		
		--Rule Definition Sheet Page 1
		
		local page1 = vgui.Create("DPanel",sheet)
		page1:SetBackgroundColor(Color(63,63,63))
		sheet:AddSheet("Define Aspects",page1,"icon16/book_edit.png",false,false,"Edit the list of aspects (rules) your signaling system uses.")
		
		local rules_list = vgui.Create("DListView",page1)
		rules_list:SetSize(1024,336)
		rules_list:Dock(TOP)
		rules_list:SetMultiSelect(false)
		rules_list:SetSortable(false)
		
		Trakpak3.SigEdit.panels.rules[1] = rules_list
		
		local c1 = rules_list:AddColumn("Aspect Name")
		local c2 = rules_list:AddColumn("Speed")
		rules_list:AddColumn("Description")
		local c4 = rules_list:AddColumn("Color")
		
		--c1:SetFixedWidth(128)
		c2:SetFixedWidth(96)
		c4:SetFixedWidth(96)
		
		--Rule Entry Options
		local rpanel = vgui.Create("DPanel",page1)
		rpanel:SetSize(512,1)
		rpanel:Dock(LEFT)
		function rpanel:Paint() end
		
		local panel = vgui.Create("DPanel",rpanel)
		panel:SetSize(1,24)
		panel:Dock(TOP)
		function panel:Paint() end
		
		
		--rule name label
		local label = vgui.Create("DLabel",panel)
		label:SetSize(256,24)
		label:Dock(LEFT)
		label:SetText("Aspect Name")
		label:SetContentAlignment(5)
		
		--rule speed label
		local label = vgui.Create("DLabel",panel)
		label:SetSize(128,24)
		label:Dock(LEFT)
		label:SetText("Signal Speed")
		label:SetContentAlignment(5)
		
		--color label
		local label = vgui.Create("DLabel",panel)
		label:Dock(FILL)
		label:SetText("Rule Color")
		label:SetContentAlignment(5)
		
		--name, speed, color boxes
		
		local panel = vgui.Create("DPanel",rpanel)
		panel:SetSize(1,24)
		panel:Dock(TOP)
		function panel:Paint() end
		
		local rulenamebox = vgui.Create("DTextEntry",panel)
		rulenamebox:SetSize(256,24)
		rulenamebox:Dock(LEFT)
		
		local speedbox = vgui.Create("DComboBox",panel)
		speedbox:SetSize(128,24)
		speedbox:Dock(LEFT)
		speedbox:AddChoice("FULL")
		speedbox:AddChoice("LIMITED")
		speedbox:AddChoice("MEDIUM")
		speedbox:AddChoice("SLOW")
		speedbox:AddChoice("RESTRICTED")
		speedbox:AddChoice("STOP/DANGER")
		speedbox:SetValue("FULL")
		
		local colortable = {
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
		
		local colorbox = vgui.Create("DComboBox",panel)
		colorbox:Dock(FILL)
		colorbox:SetSortItems(false)
		colorbox:SetValue("White")
		colorbox:AddChoice("Red")
		colorbox:AddChoice("Amber")
		colorbox:AddChoice("Lemon Yellow")
		colorbox:AddChoice("Yellow-Green")
		colorbox:AddChoice("Green")
		colorbox:AddChoice("Derail Blue")
		colorbox:AddChoice("Lunar White")
		colorbox:AddChoice("Purple")
		colorbox:AddChoice("White")
		colorbox:AddChoice("Black")
		function colorbox:OnSelect(index, value)
			Trakpak3.SigEdit.panels.color_indicator:SetBackgroundColor(colortable[value])
		end
		
		--rule description & color indicator
		
		local panel = vgui.Create("DPanel",rpanel)
		panel:SetSize(1,64)
		panel:Dock(TOP)
		function panel:Paint() end
		
		local descbox = vgui.Create("DTextEntry",panel)
		descbox:SetSize(384,64)
		descbox:Dock(LEFT)
		descbox:SetContentAlignment(7)
		descbox:SetMultiline(true)
		
		local color_indicator = vgui.Create("DPanel",panel)
		color_indicator:Dock(FILL)
		color_indicator:SetBackgroundColor(Color(255,255,255))
		color_indicator:DockMargin(8,8,8,8)
		Trakpak3.SigEdit.panels.color_indicator = color_indicator
		
		local label = vgui.Create("DLabel",rpanel)
		label:SetSize(384,24)
		label:Dock(TOP)
		label:SetText("Signal Description")
		label:SetContentAlignment(5)
		
		
		--Set the Entry stuff when you click something
		function rules_list:OnRowSelected(index, row)
			rulenamebox:SetValue(row:GetColumnText(1))
			speedbox:SetValue(row:GetColumnText(2))
			descbox:SetValue(row:GetColumnText(3))
			local clr = row:GetColumnText(4) or "White"
			colorbox:SetValue(clr)
			Trakpak3.SigEdit.panels.color_indicator:SetBackgroundColor(colortable[clr])
			
		end
		
		local bpanel = vgui.Create("DPanel",rpanel)
		bpanel:SetSize(1,72)
		bpanel:Dock(TOP)
		function bpanel:Paint() end
		
		--Add Rule Button
		local button = vgui.Create("DButton",bpanel)
		button:SetSize(96,88)
		button:Dock(LEFT)
		button:SetText("Add New Rule")
		button.DoClick = function()
			local name = rulenamebox:GetValue()
			local speed = speedbox:GetValue()
			local desc = descbox:GetValue()
			local color = colorbox:GetValue()
			if name and (name!="") then
				Trakpak3.SigEdit.AddRule(name, speed, desc, color)
				Trakpak3.SigEdit.PopulateRules()
			end
		end
		
		local panel = vgui.Create("DPanel",bpanel)
		panel:SetSize(96,1)
		panel:Dock(LEFT)
		function panel:Paint() end
		
		--Update Rule Button
		local button = vgui.Create("DButton",panel)
		button:SetSize(96,36)
		button:Dock(TOP)
		button:SetText("Update Selected")
		button.DoClick = function()
			local name = rulenamebox:GetValue()
			local speed = speedbox:GetValue()
			local desc = descbox:GetValue()
			local color = colorbox:GetValue()
			local index = rules_list:GetSelectedLine()
			if name and (name!="") and index then
				Trakpak3.SigEdit.AddRule(name, speed, desc, color, index)
				Trakpak3.SigEdit.PopulateRules()
			end
		end
		
		--Delet Rule Button
		local button = vgui.Create("DButton",panel)
		button:SetSize(96,36)
		button:Dock(FILL)
		button:SetText("DELETE Selected")
		button:SetTextColor(Color(255,0,0))
		button.DoClick = function()
			local index = rules_list:GetSelectedLine()
			if index then
				Trakpak3.SigEdit.PopRule(index)
				Trakpak3.SigEdit.PopulateRules()
			end
		end
		
		--Reset Text Entry Button
		local button = vgui.Create("DButton",bpanel)
		button:SetSize(96,72)
		button:Dock(LEFT)
		button:SetText("Clear Data Entry")
		button.DoClick = function()
			rulenamebox:SetValue("")
			speedbox:SetValue("FULL")
			descbox:SetValue("")
		end
		
		local panel = vgui.Create("DPanel",bpanel)
		panel:SetSize(96,1)
		panel:Dock(LEFT)
		function panel:Paint() end
		
		--Move Up/Down buttons
		local up_button = vgui.Create("DButton",panel)
		up_button:SetSize(96,36)
		up_button:SetText("Move Up")
		up_button:Dock(TOP)
		up_button.DoClick = function()
			local newid = Trakpak3.SigEdit.NudgeRule(rules_list,1)
			if newid then
				Trakpak3.SigEdit.PopulateRules()
				rules_list:SelectItem(rules_list:GetLine(newid))
			end
		end
		
		local dn_button = vgui.Create("DButton",panel)
		dn_button:SetSize(96,36)
		dn_button:SetText("Move Down")
		dn_button:Dock(FILL)
		dn_button.DoClick = function()
			local newid = Trakpak3.SigEdit.NudgeRule(rules_list,-1)
			if newid then
				Trakpak3.SigEdit.PopulateRules()
				rules_list:SelectItem(rules_list:GetLine(newid))
			end
		end
		
		local label = vgui.Create("DLabel",page1)
		label:SetText("This is where you define the list of signal aspects that the system is capable of showing. Each aspect has a name, a maximum speed at which a train is allowed to pass it, and a description.\n\nThe name can be one or more words but CANNOT contain underscores.\n\nThe description is optional, but it's a good idea to add one in order to give explicit instructions. The description is shown in Signal Vision.\n\nColor doesn't affect what the signal actually shows, but is used to quickly organize aspects in Signal Vision.")
		label:SetSize(192,4)
		label:SetWrap(true)
		label:Dock(FILL)
		label:DockMargin(8,8,8,8)
		
		--Tag/SigType Editor Page 2
		
		local page2 = vgui.Create("DPanel",sheet)
		page2:SetBackgroundColor(Color(63,63,63))
		sheet:AddSheet("Define Signal Types & Tags",page2,"icon16/tag_blue.png",false,false,"Edit the list of valid signal types and tags.")
		
		--SIGNAL TYPES
		
		local typelist = vgui.Create("DListView", page2)
		typelist:SetSize(192,128)
		typelist:Dock(LEFT)
		typelist:SetMultiSelect(false)
		typelist:AddColumn("Signal Types")
		
		Trakpak3.SigEdit.panels.types[1] = typelist
		
		local panel = vgui.Create("DPanel",page2)
		panel:SetSize(192,1)
		panel:Dock(LEFT)
		function panel:Paint() end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Signal Type Name")
		label:SetContentAlignment(5)
		
		--Type Text Box
		local typebox = vgui.Create("DTextEntry",panel)
		typebox:SetSize(192,24)
		typebox:Dock(TOP)
		function typebox:OnEnter(typename)
			if typename and (typename!="") then Trakpak3.SigEdit.AddSigType(typename) end
			timer.Simple(0,function() self:SetValue("") end)
			Trakpak3.SigEdit.PopulateTypes()
		end
		
		--Add Type Button
		local button = vgui.Create("DButton",panel)
		button:SetSize(96,32)
		button:Dock(TOP)
		button:SetText("Add Signal Type")
		button.DoClick = function()
			local typename = typebox:GetValue()
			if typename and (typename!="") then Trakpak3.SigEdit.AddSigType(typename) end
			typebox:SetValue("")
			Trakpak3.SigEdit.PopulateTypes()
		end
		
		--Remove Type Button
		local button = vgui.Create("DButton",panel)
		button:SetSize(96,32)
		button:Dock(TOP)
		button:SetText("DELETE Selected")
		button:SetTextColor(Color(255,0,0))
		button.DoClick = function()
			local _, typename = typelist:GetSelectedLine()
			if typename then typename = typename:GetColumnText(1) end
			if typename then Trakpak3.SigEdit.DeleteSigType(typename) end
			Trakpak3.SigEdit.PopulateTypes()
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("This is where you list the available signal types your system can support. Signal types must be one word (no spaces, but underscores are okay).\n\nThe signal type determines how to set bodygroups, skins, etc. for a given aspect.")
		label:SetWrap(true)
		label:SetSize(192,256)
		label:Dock(TOP)
		label:SetContentAlignment(8)
		label:DockMargin(8,8,8,8)
		
		--TAGS
		
		local taglist = vgui.Create("DListView", page2)
		taglist:SetSize(192,128)
		taglist:Dock(RIGHT)
		taglist:SetMultiSelect(false)
		taglist:AddColumn("Available Tags")
		
		Trakpak3.SigEdit.panels.tags[1] = taglist
		
		local panel = vgui.Create("DPanel",page2)
		panel:SetSize(192,1)
		panel:Dock(RIGHT)
		function panel:Paint() end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Tag Name")
		label:SetContentAlignment(5)
		
		--Tag Text Box
		local tagbox = vgui.Create("DTextEntry",panel)
		tagbox:SetSize(192,24)
		tagbox:Dock(TOP)
		function tagbox:OnEnter(tagname)
			if tagname and (tagname!="") then Trakpak3.SigEdit.AddTag(tagname) end
			timer.Simple(0,function() self:SetValue("") end)
			Trakpak3.SigEdit.PopulateTags(taglist)
		end
		
		--Add Tag Button
		local button = vgui.Create("DButton",panel)
		button:SetSize(96,32)
		button:Dock(TOP)
		button:SetText("Add Tag")
		button.DoClick = function()
			local tagname = tagbox:GetValue()
			if tagname and (tagname!="") then Trakpak3.SigEdit.AddTag(tagname) end
			tagbox:SetValue("")
			Trakpak3.SigEdit.PopulateTags(taglist)
		end
		
		--Remove Tag Button
		local button = vgui.Create("DButton",panel)
		button:SetSize(96,32)
		button:Dock(TOP)
		button:SetText("DELETE Selected")
		button:SetTextColor(Color(255,0,0))
		button.DoClick = function()
			local _, tagname = taglist:GetSelectedLine()
			if tagname then tagname = tagname:GetColumnText(1) end
			if tagname then Trakpak3.SigEdit.DeleteTag(tagname) end
			Trakpak3.SigEdit.PopulateTags(taglist)
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetText("This is where you list the available signal tags your system can understand. Tags must be one word (no spaces, but underscores are okay).\n\nTags are set by the mapper in Hammer to provide extra directions when choosing an aspect to display. Tags can be used in the Logic Function.")
		label:SetWrap(true)
		label:SetSize(192,256)
		label:Dock(TOP)
		label:SetContentAlignment(8)
		label:DockMargin(8,8,8,8)
		
		--Signal Interpretations Page 3
		
		local page3 = vgui.Create("DPanel",sheet) 
		page3:SetBackgroundColor(Color(63,63,63))
		sheet:AddSheet("Signal Interpretations",page3,"icon16/chart_organisation.png",false,false,"Configure how the signals models represent each aspect.")
		
		--Model Display Panel
		
		local mpanel = vgui.Create("DPanel",page3)
		mpanel:SetSize(256,1)
		mpanel:Dock(RIGHT)
		
		--1
		local panel = vgui.Create("DPanel",mpanel)
		function panel:Paint() end
		panel:SetSize(1,128+48)
		panel:Dock(TOP)
		
		local mv1 = vgui.Create("DModelPanel",panel)
		mv1:SetSize(1,128)
		mv1:Dock(TOP)
		mv1:SetModel(Trakpak3.SigEdit.intmodels[2])
		Trakpak3.SigEdit.AdjustCamera(mv1,192)
		mv1:SetFOV(30)
		
		Trakpak3.SigEdit.init_anim = {true, true, true, true, true, true}
		
		function mv1:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,1) end
		
		local ds1 = vgui.Create("DNumSlider",panel)
		ds1:SetSize(1,24)
		ds1:Dock(TOP)
		ds1:SetText(" Draw Distance")
		ds1:SetMinMax(0,384)
		ds1:SetDefaultValue(192)
		ds1:SetValue(192)
		ds1:SetDecimals(0)
		ds1:SetDark(true)
		function ds1:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(mv1,value) end
		
		local mb1 = vgui.Create("DTextEntry",panel)
		mb1:SetSize(1,24)
		mb1:Dock(TOP)
		mb1:SetValue(Trakpak3.SigEdit.intmodels[1])
		function mb1:OnEnter(text)
			Trakpak3.SigEdit.intmodels[1] = text
			mv1:SetModel(text)
			Trakpak3.SigEdit.init_anim[1] = true
		end
		
		--2
		local panel = vgui.Create("DPanel",mpanel)
		function panel:Paint() end
		panel:SetSize(1,128+48)
		panel:Dock(TOP)
		
		local mv2 = vgui.Create("DModelPanel",panel)
		mv2:SetSize(1,128)
		mv2:Dock(TOP)
		mv2:SetModel(Trakpak3.SigEdit.intmodels[2])
		Trakpak3.SigEdit.AdjustCamera(mv2,192)
		mv2:SetFOV(30)
		function mv2:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,2) end
		
		local ds2 = vgui.Create("DNumSlider",panel)
		ds2:SetSize(1,24)
		ds2:Dock(TOP)
		ds2:SetText(" Draw Distance")
		ds2:SetMinMax(0,384)
		ds2:SetDefaultValue(192)
		ds2:SetValue(192)
		ds2:SetDecimals(0)
		ds2:SetDark(true)
		function ds2:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(mv2,value) end
		
		local mb2 = vgui.Create("DTextEntry",panel)
		mb2:SetSize(1,24)
		mb2:Dock(TOP)
		mb2:SetValue(Trakpak3.SigEdit.intmodels[2])
		function mb2:OnEnter(text)
			Trakpak3.SigEdit.intmodels[2] = text
			mv2:SetModel(text)
			Trakpak3.SigEdit.init_anim[2] = true
		end
		
		--3
		local panel = vgui.Create("DPanel",mpanel)
		function panel:Paint() end
		panel:SetSize(1,128+48)
		panel:Dock(TOP)
		
		local mv3 = vgui.Create("DModelPanel",panel)
		mv3:SetSize(1,128)
		mv3:Dock(TOP)
		mv3:SetModel(Trakpak3.SigEdit.intmodels[3])
		Trakpak3.SigEdit.AdjustCamera(mv3,192)
		mv3:SetFOV(30)
		function mv3:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,3) end
		
		local ds3 = vgui.Create("DNumSlider",panel)
		ds3:SetSize(1,24)
		ds3:Dock(TOP)
		ds3:SetText(" Draw Distance")
		ds3:SetMinMax(0,384)
		ds3:SetDefaultValue(192)
		ds3:SetValue(192)
		ds3:SetDecimals(0)
		ds3:SetDark(true)
		function ds3:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(mv3,value) end
		
		local mb3 = vgui.Create("DTextEntry",panel)
		mb3:SetSize(1,24)
		mb3:Dock(TOP)
		mb3:SetValue(Trakpak3.SigEdit.intmodels[3])
		function mb2:OnEnter(text)
			Trakpak3.SigEdit.intmodels[2] = text
			mv2:SetModel(text)
			Trakpak3.SigEdit.init_anim[2] = true
		end
		
		--Aspect Sheet
		
		local int_aspectsheet = vgui.Create("DListView",page3)
		int_aspectsheet:SetSize(192,1)
		int_aspectsheet:Dock(LEFT)
		int_aspectsheet:SetMultiSelect(false)
		int_aspectsheet:AddColumn("Aspect Name")
		Trakpak3.SigEdit.panels.rules[2] = int_aspectsheet
		function int_aspectsheet:OnRowSelected(index, row)
			--print("Selected Aspect:",row:GetColumnText(1))
			Trakpak3.SigEdit.int_aspect = row:GetColumnText(1)
			Trakpak3.SigEdit.IntFillBoxes()
		end
		
		local panel = vgui.Create("DPanel",page3)
		panel:SetSize(256,1)
		panel:Dock(LEFT)
		function panel:Paint() end
		
		--Signal Types Sheet
		local int_typelist = vgui.Create("DListView",panel)
		int_typelist:SetSize(1,128)
		int_typelist:Dock(TOP)
		int_typelist:AddColumn("Signal Types")
		Trakpak3.SigEdit.panels.types[2] = int_typelist
		function int_typelist:OnRowSelected(index, row)
			--print("Selected SigType:",row:GetColumnText(1))
			Trakpak3.SigEdit.int_sigtype = row:GetColumnText(1)
			Trakpak3.SigEdit.IntFillBoxes()
		end
		
		--Head 1
		local panel1 = vgui.Create("DPanel",panel)
		panel1:SetSize(1,128)
		panel1:Dock(TOP)
		function panel1:Paint() end
		local label = vgui.Create("DLabel",panel1)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Head 1")
		label:SetContentAlignment(5)
		
		local left = vgui.Create("DPanel",panel1)
		left:SetSize(96,1)
		left:Dock(LEFT)
		function left:Paint() end
		local right = vgui.Create("DPanel",panel1)
		right:Dock(FILL)
		function right:Paint() end
		
		--Skin 1
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Skin")
		label:SetContentAlignment(5)
		local skinbox1 = vgui.Create("DTextEntry",right)
		skinbox1:SetSize(1,24)
		skinbox1:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.skinbox1 = skinbox1
		
		
		--BG 1
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Bodygroups")
		label:SetContentAlignment(5)
		local bgbox1 = vgui.Create("DTextEntry",right)
		bgbox1:SetSize(1,24)
		bgbox1:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.bgbox1 = bgbox1
		
		--Cycle 1
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Anim Cycle")
		label:SetContentAlignment(5)
		local cyclebox1 = vgui.Create("DTextEntry",right)
		cyclebox1:SetSize(1,24)
		cyclebox1:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.cyclebox1 = cyclebox1
		
		--Head 2
		local panel2 = vgui.Create("DPanel",panel)
		panel2:SetSize(1,128)
		panel2:Dock(TOP)
		function panel2:Paint() end
		local label = vgui.Create("DLabel",panel2)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Head 2")
		label:SetContentAlignment(5)
		
		local left = vgui.Create("DPanel",panel2)
		left:SetSize(96,1)
		left:Dock(LEFT)
		function left:Paint() end
		local right = vgui.Create("DPanel",panel2)
		right:Dock(FILL)
		function right:Paint() end
		
		--Skin 2
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Skin")
		label:SetContentAlignment(5)
		local skinbox2 = vgui.Create("DTextEntry",right)
		skinbox2:SetSize(1,24)
		skinbox2:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.skinbox2 = skinbox2
		
		
		--BG 2
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Bodygroups")
		label:SetContentAlignment(5)
		local bgbox2 = vgui.Create("DTextEntry",right)
		bgbox2:SetSize(1,24)
		bgbox2:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.bgbox2 = bgbox2
		
		--Cycle 2
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Anim Cycle")
		label:SetContentAlignment(5)
		local cyclebox2 = vgui.Create("DTextEntry",right)
		cyclebox2:SetSize(1,24)
		cyclebox2:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.cyclebox2 = cyclebox2
		
		--Head 3
		local panel3 = vgui.Create("DPanel",panel)
		panel3:SetSize(1,128)
		panel3:Dock(TOP)
		function panel3:Paint() end
		local label = vgui.Create("DLabel",panel3)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Head 3")
		label:SetContentAlignment(5)
		
		local left = vgui.Create("DPanel",panel3)
		left:SetSize(96,1)
		left:Dock(LEFT)
		function left:Paint() end
		local right = vgui.Create("DPanel",panel3)
		right:Dock(FILL)
		function right:Paint() end
		
		--Skin 3
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Skin")
		label:SetContentAlignment(5)
		local skinbox3 = vgui.Create("DTextEntry",right)
		skinbox3:SetSize(1,24)
		skinbox3:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.skinbox3 = skinbox3
		
		
		--BG 3
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Bodygroups")
		label:SetContentAlignment(5)
		local bgbox3 = vgui.Create("DTextEntry",right)
		bgbox3:SetSize(1,24)
		bgbox3:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.bgbox3 = bgbox3
		
		--Cycle 1
		local label = vgui.Create("DLabel",left)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("Anim Cycle")
		label:SetContentAlignment(5)
		local cyclebox3 = vgui.Create("DTextEntry",right)
		cyclebox3:SetSize(1,24)
		cyclebox3:Dock(TOP)
		Trakpak3.SigEdit.panels.cfg.cyclebox3 = cyclebox3
		
		--Operation Buttons
		local bpanel = vgui.Create("DPanel",page3)
		bpanel:SetSize(192,1)
		bpanel:Dock(LEFT)
		
		--Assign
		local button = vgui.Create("DButton",bpanel)
		button:SetSize(1,32)
		button:Dock(TOP)
		button:SetText("Apply To Selected")
		button.DoClick = function()
			Trakpak3.SigEdit.IntAssignData()
		end
		
		--Copy Data
		local button = vgui.Create("DButton",bpanel)
		button:SetSize(1,32)
		button:Dock(TOP)
		button:SetText("Copy Data")
		button.DoClick = function()
			Trakpak3.SigEdit.IntCopyData()
		end
		
		--Paste Data
		local button = vgui.Create("DButton",bpanel)
		button:SetSize(1,32)
		button:Dock(TOP)
		button:SetText("Paste Into Selected")
		button.DoClick = function()
			Trakpak3.SigEdit.IntPasteData()
		end
		
		local label = vgui.Create("DLabel",page3)
		label:SetText("This is where you configure how each Signal Type adjusts its skins, bodygroups, or animation cycle for each Aspect. Not every Signal Type needs to be able to display every Aspect; you can use the Logic Function, Tags, and decisions from the mapper to make sure signals only show what they can.\n\nMultiple Signal Types can be selected at once.\n\nSkin is an integer starting from 0 (max of 31).\n\nBodygroups is a list of integers starting from 0. A single number affects only the first bodygroup. Mutiple numbers affect multiple bodygroups in order; for example, '0 2 1' will set the first bodygroup to 0, the second bodygroup to 2, and the third bodygroup to 1.\n\nAnimation Cycle is the normalized fraction (decimal from 0 to 1) along the model's animation. For example, '0' is at the start, '0.5' is halfway through, and '1' is at the end. The animation sequence used must be named 'range'.\n\nLeaving any parameter box blank will tell the signal system not to change the associated skin/bodygroups/cycle.")
		label:SetWrap(true)
		label:SetSize(192,256)
		label:Dock(FILL)
		label:SetContentAlignment(8)
		label:DockMargin(8,8,8,8)
		
		--Logic Editor Page 4
		
		local page4 = vgui.Create("DPanel",sheet)
		page4:SetBackgroundColor(Color(63,63,63))
		sheet:AddSheet("Logic Editor",page4,"icon16/monitor_lightning.png",false,false,"Configure the Logic Function.")
		
		--Aspect Return Sheet
		
		local panel = vgui.Create("DPanel",page4)
		panel:SetSize(128,1)
		panel:Dock(RIGHT)
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(1,48)
		button:Dock(BOTTOM)
		button:SetText("Add Aspect Return")
		button.DoClick = function()
			local id = Trakpak3.SigEdit.selectednode
			if id and (id>1) then
				local ntable = Trakpak3.SigEdit.panels.nodes[id]
				if ntable and ntable.canattach and not ntable.nextnode then
					local _, row = Trakpak3.SigEdit.panels.rules[3]:GetSelectedLine()
					if row then
						local aspect = row:GetColumnText(1)
						Trakpak3.SigEdit.AddReturn(ntable.node,aspect)
					end
				end
			end
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_att[1] = button
		
		local aspect_returns = vgui.Create("DListView",panel)
		aspect_returns:Dock(FILL)
		aspect_returns:AddColumn("Aspect Name")
		aspect_returns:SetMultiSelect(false)
		Trakpak3.SigEdit.panels.rules[3] = aspect_returns
		function aspect_returns:DoDoubleClick()
			local id = Trakpak3.SigEdit.selectednode
			if id and (id>1) then
				local ntable = Trakpak3.SigEdit.panels.nodes[id]
				if ntable and ntable.canattach and not ntable.nextnode then
					local _, row = Trakpak3.SigEdit.panels.rules[3]:GetSelectedLine()
					if row then
						local aspect = row:GetColumnText(1)
						Trakpak3.SigEdit.AddReturn(ntable.node,aspect)
					end
				end
			end
		end
		
		--Conditional Megapanel
		local conpanel = vgui.Create("DPanel",page4)
		conpanel:SetSize(256,1)
		conpanel:Dock(RIGHT)
		function conpanel:Paint() end
		
		--General Add/Delete panel
		
		local button = vgui.Create("DButton",conpanel)
		button:SetSize(1,48)
		button:Dock(BOTTOM)
		button:SetText("Clear Logic Editor")
		button.DoClick = function()
			local ays = vgui.Create("DFrame")
			ays:SetSize(256,128)
			ays:SetPos(ScrW()/2 - 128, ScrH()/2 - 64)
			ays:MakePopup()
			
			local label = vgui.Create("DLabel",ays)
			label:SetSize(1,32)
			label:Dock(TOP)
			label:SetContentAlignment(5)
			label:SetText("Are you sure you want to clear the logic editor?")
			
			local button = vgui.Create("DButton",ays)
			button:SetSize(96,1)
			button:Dock(LEFT)
			button:SetText("Yes, clear it!")
			button.DoClick = function()
				Trakpak3.SigEdit.panels.nodes = {}
				Trakpak3.SigEdit.node_id = 1
				
				local logicview = Trakpak3.SigEdit.panels.logicview
				Trakpak3.SigEdit.node_id = 1
				function Trakpak3.SigEdit.LogicFunction() return false end
				if logicview then
					logicview:Clear()
					Trakpak3.SigEdit.CreateStartNode(logicview)
				end
				
				--frame:Close()
				ays:Close()
			end
			
			local button = vgui.Create("DButton",ays)
			button:SetSize(96,1)
			button:Dock(RIGHT)
			button:SetText("No, cancel!")
			button.DoClick = function() ays:Close() end
			
		end
		
		local button = vgui.Create("DButton",conpanel)
		button:SetSize(1,48)
		button:Dock(BOTTOM)
		button:SetText("Write Logic Function")
		button.DoClick = function()
			Trakpak3.SigEdit.WriteLogicFunction()
		end
		
		local panel = vgui.Create("DPanel",conpanel)
		panel:SetSize(1,48)
		panel:Dock(BOTTOM)
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(128,1)
		button:Dock(LEFT)
		button:SetText("Add Conditional\n(IF-THEN-ELSE)")
		button.DoClick = function()
			local index = Trakpak3.SigEdit.selectednode
			if index and (index > 0) then
				local insert_table = Trakpak3.SigEdit.panels.nodes[index]
				if insert_table.canattach and not insert_table.nextnode then Trakpak3.SigEdit.AddConditional(insert_table.node) end
			end
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_att[2] = button
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(128,1)
		button:Dock(FILL)
		button:SetText("DELETE Selected Item")
		button:SetTextColor(Color(255,0,0))
		button.DoClick = function()
			local index = Trakpak3.SigEdit.selectednode
			if index and (index>2) then
				local delete_table = Trakpak3.SigEdit.panels.nodes[index]
				if not delete_table.canattach then
					local ptable = Trakpak3.SigEdit.GetNodeTable(delete_table.node:GetParentNode())
					ptable.nextnode = nil
					
					delete_table.node:Remove()
					Trakpak3.SigEdit.panels.nodes[index] = nil
					Trakpak3.SigEdit.selectednode = 0
				end
			end
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_noatt[1] = button
		
		--Spacer
		local panel = vgui.Create("DPanel",conpanel)
		panel:SetSize(1,128)
		panel:Dock(BOTTOM)
		function panel:Paint() end
		
		local label = vgui.Create("DLabel",panel)
		label:Dock(FILL)
		label:SetWrap(true)
		label:SetContentAlignment(5)
		label:SetText("This is where you set the Logic Function. The Logic Function takes signal parameters (such as track occupancy, route speed, next signal states, CTC states, etc.) and tags, and outputs the aspect the signal should show.")
		label:DockMargin(8,8,8,8)
		
		--Condition Edit Panel
		
		local panel = vgui.Create("DPanel",conpanel)
		panel:SetSize(1,64)
		panel:Dock(BOTTOM)
		
		local condition_box = vgui.Create("DTextEntry",panel)
		condition_box:SetSize(1,24)
		condition_box:Dock(BOTTOM)
		--condition_box:SetEditable(false)
		condition_box:SetEnabled(false)
		
		Trakpak3.SigEdit.panels.condition_box = condition_box
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(64,1)
		button:Dock(LEFT)
		button:SetText("Add\nAND")
		--button:SetContentAlignment(5)
		button.DoClick = function()
			Trakpak3.SigEdit.AddCText("and")
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_noatt[2] = button
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(64,1)
		button:Dock(LEFT)
		button:SetText("Add\nOR")
		--button:SetContentAlignment(5)
		button.DoClick = function()
			Trakpak3.SigEdit.AddCText("or")
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_noatt[3] = button
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(64,1)
		button:Dock(LEFT)
		button:SetText("Apply\nCondition")
		--button:SetContentAlignment(5)
		button.DoClick = function()
			Trakpak3.SigEdit.ApplyCondition()
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_noatt[4] = button
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(64,1)
		button:Dock(FILL)
		button:SetText("Clear\nCondition")
		--button:SetContentAlignment(5)
		button.DoClick = function()
			local index = Trakpak3.SigEdit.selectednode
			if index and (index>1) then
				local ntable = Trakpak3.SigEdit.panels.nodes[index]
				if ntable and ntable.isconditional then
					ntable.condition = {}
					Trakpak3.SigEdit.panels.condition_box:SetValue("")
					ntable.node:SetText("IF")
				end
			end
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_noatt[5] = button
		
		--Tag Sheet
		
		local panel = vgui.Create("DPanel",conpanel)
		panel:SetSize(128,1)
		panel:Dock(RIGHT)
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(1,32)
		button:Dock(BOTTOM)
		button:SetText("Add Tag\nFalse")
		--button:SetContentAlignment(5)
		button.DoClick = function()
			local _, row = Trakpak3.SigEdit.panels.tags[2]:GetSelectedLine()
			if row then
				local tagname = row:GetColumnText(1)
				if tagname!="" then Trakpak3.SigEdit.AddCText("( not TAGS."..tagname.." )") end
			end
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_noatt[6] = button
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(1,32)
		button:Dock(BOTTOM)
		button:SetText("Add Tag\nTrue")
		--button:SetContentAlignment(5)
		button.DoClick = function()
			local _, row = Trakpak3.SigEdit.panels.tags[2]:GetSelectedLine()
			if row then
				local tagname = row:GetColumnText(1)
				if tagname!="" then Trakpak3.SigEdit.AddCText("( TAGS."..tagname.." )") end
			end
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_noatt[7] = button
		
		local tag_conditions = vgui.Create("DListView",panel)
		tag_conditions:Dock(FILL)
		tag_conditions:AddColumn("Signal Tags")
		tag_conditions:SetMultiSelect(false)
		Trakpak3.SigEdit.panels.tags[2] = tag_conditions
		
		--Signal Parameter Sheet
		
		local panel = vgui.Create("DPanel",conpanel)
		panel:SetSize(128,1)
		panel:Dock(RIGHT)
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(1,32)
		button:Dock(BOTTOM)
		button:SetText("Add Parameter")
		button.DoClick = function()
			local _, row = Trakpak3.SigEdit.panels.parmlist:GetSelectedLine()
			if row then
				local parm_name = row:GetColumnText(1)
				local op_name = Trakpak3.SigEdit.panels.opbox:GetValue()
				local comp_name = Trakpak3.SigEdit.panels.compbox:GetValue()
				if comp_name=="" then return end
				
				parm_name = Trakpak3.SigEdit.dictionary[parm_name]
				op_name = Trakpak3.SigEdit.dictionary[op_name]
				
				if parm_name=="NEXTASPECT" then
					comp_name = "\""..comp_name.."\""
					--print("Aspect : "..comp_name.."\n")
					Trakpak3.SigEdit.AddCText("( "..parm_name.." "..op_name.." "..comp_name.." )")
				elseif (parm_name=="OCCUPIED") or (parm_name=="DIVERGING") then
					if (comp_name=="Clear") or (comp_name=="Main") then
						op_name = "not "
					else
						op_name = ""
					end
					Trakpak3.SigEdit.AddCText("( "..op_name..parm_name.." )")
				else
					comp_name = Trakpak3.SigEdit.dictionary[comp_name] or comp_name
					Trakpak3.SigEdit.AddCText("( "..parm_name.." "..op_name.." "..comp_name.." )")
				end
				
				
			end
		end
		button:SetEnabled(false)
		Trakpak3.SigEdit.panels.logic_buttons_noatt[8] = button
		
		local compbox = vgui.Create("DComboBox",panel)
		compbox:SetSize(1,24)
		compbox:Dock(BOTTOM)
		compbox:SetValue("")
		compbox:SetSortItems(false)
		
		Trakpak3.SigEdit.panels.compbox = compbox
		
		local opbox = vgui.Create("DComboBox",panel)
		opbox:SetSize(1,24)
		opbox:Dock(BOTTOM)
		opbox:SetValue("")
		opbox:SetSortItems(false)
		
		Trakpak3.SigEdit.panels.opbox = opbox
		
		local parm_conditions = vgui.Create("DListView",panel)
		parm_conditions:Dock(FILL)
		parm_conditions:AddColumn("Signal Parameters")
		parm_conditions:SetMultiSelect(false)
		parm_conditions:AddLine("Track Occupancy")
		parm_conditions:AddLine("Route Diverging")
		parm_conditions:AddLine("Route Speed")
		parm_conditions:AddLine("Next Signal Aspect")
		parm_conditions:AddLine("Next Signal Speed")
		parm_conditions:AddLine("CTC State")
		
		Trakpak3.SigEdit.panels.parmlist = parm_conditions
		
		function parm_conditions:OnRowSelected(idx, row)
			compbox:Clear()
			opbox:Clear()
			local text = row:GetColumnText(1)
			if text=="Track Occupancy" then
				opbox:AddChoice("Is")
				opbox:SetValue("Is")
				
				compbox:AddChoice("Occupied")
				compbox:AddChoice("Clear")
				compbox:SetValue("Occupied")
			elseif text=="Route Diverging" then
				opbox:AddChoice("Is")
				opbox:SetValue("Is")
				
				compbox:AddChoice("Diverging")
				compbox:AddChoice("Main")
				compbox:SetValue("Diverging")
			elseif text=="Route Speed" or text=="Next Signal Speed" then
				opbox:AddChoice("Equals")
				opbox:AddChoice("Does Not Equal")
				opbox:AddChoice("Is Less Than")
				opbox:AddChoice("Is Greater Than")
				opbox:AddChoice("Is Less Or Equal To")
				opbox:AddChoice("Is Greater Or Equal To")
				opbox:SetValue("Equals")
				
				compbox:AddChoice("FULL")
				compbox:AddChoice("LIMITED")
				compbox:AddChoice("MEDIUM")
				compbox:AddChoice("SLOW")
				compbox:AddChoice("RESTRICTED")
				compbox:AddChoice("STOP/DANGER")
				compbox:SetValue("FULL")
			elseif text=="Next Signal Aspect" then
				opbox:AddChoice("Is")
				opbox:AddChoice("Is Not")
				opbox:SetValue("Is")
				
				for n = 1, #Trakpak3.SigEdit.rules do
					compbox:AddChoice(Trakpak3.SigEdit.rules[n].name)
				end
				
				compbox:SetValue("")
			elseif text=="CTC State" then
				opbox:AddChoice("Is")
				opbox:SetValue("Is")
				
				compbox:AddChoice("HOLD")
				compbox:AddChoice("ALLOW")
				compbox:AddChoice("FORCE")
				compbox:SetValue("HOLD")
			end
		end
		
		--Logic Viewer
		
		local logicview = vgui.Create("DTree",page4)
		--logicview:SetSize(384,1)
		logicview:Dock(FILL)
		Trakpak3.SigEdit.node_id = 1
		Trakpak3.SigEdit.CreateStartNode(logicview)
		Trakpak3.SigEdit.panels.logicview = logicview
		
		--Signal Simulator Page 5
		
		local page5 = vgui.Create("DPanel",sheet)
		page5:SetBackgroundColor(Color(63,63,63))
		sheet:AddSheet("Signal Simulator",page5,"icon16/chart_curve.png",false,false,"Test your signal system.")
		
		--Next Signal Megapanel
		local npanel = vgui.Create("DPanel",page5)
		npanel:SetSize(256,1)
		npanel:Dock(RIGHT)
		
		local label = vgui.Create("DLabel",npanel)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("NEXT Signal")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		--1
		local nmodel1 = vgui.Create("DModelPanel",npanel)
		nmodel1:SetSize(128,128)
		nmodel1:Dock(TOP)
		nmodel1:SetModel(Trakpak3.SigEdit.intmodels[1])
		nmodel1:SetFOV(30)
		Trakpak3.SigEdit.AdjustCamera(nmodel1,192)
		function nmodel1:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,1) end
		
		local ds = vgui.Create("DNumSlider",npanel)
		ds:SetSize(1,24)
		ds:Dock(TOP)
		ds:SetText(" Draw Distance")
		ds:SetMinMax(0,384)
		ds:SetDefaultValue(192)
		ds:SetValue(192)
		ds:SetDecimals(0)
		ds:SetDark(true)
		function ds:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(nmodel1,value) end
		
		local mb = vgui.Create("DTextEntry",npanel)
		mb:SetSize(1,24)
		mb:Dock(TOP)
		mb:SetValue(Trakpak3.SigEdit.intmodels[1])
		function mb:OnEnter(text)
			Trakpak3.SigEdit.intmodels[1] = text
			nmodel1:SetModel(text)
			Trakpak3.SigEdit.init_anim[1] = true
		end
		
		--2
		local nmodel2 = vgui.Create("DModelPanel",npanel)
		nmodel2:SetSize(128,128)
		nmodel2:Dock(TOP)
		nmodel2:SetModel(Trakpak3.SigEdit.intmodels[2])
		nmodel2:SetFOV(30)
		Trakpak3.SigEdit.AdjustCamera(nmodel2,192)
		function nmodel2:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,2) end
		
		local ds = vgui.Create("DNumSlider",npanel)
		ds:SetSize(1,24)
		ds:Dock(TOP)
		ds:SetText(" Draw Distance")
		ds:SetMinMax(0,384)
		ds:SetDefaultValue(192)
		ds:SetValue(192)
		ds:SetDecimals(0)
		ds:SetDark(true)
		function ds:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(nmodel2,value) end
		
		local mb = vgui.Create("DTextEntry",npanel)
		mb:SetSize(1,24)
		mb:Dock(TOP)
		mb:SetValue(Trakpak3.SigEdit.intmodels[2])
		function mb:OnEnter(text)
			Trakpak3.SigEdit.intmodels[2] = text
			nmodel2:SetModel(text)
			Trakpak3.SigEdit.init_anim[2] = true
		end
		
		--3
		local nmodel3 = vgui.Create("DModelPanel",npanel)
		nmodel3:SetSize(128,128)
		nmodel3:Dock(TOP)
		nmodel3:SetModel(Trakpak3.SigEdit.intmodels[3])
		nmodel3:SetFOV(30)
		Trakpak3.SigEdit.AdjustCamera(nmodel3,192)
		function nmodel3:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,3) end
		
		local ds = vgui.Create("DNumSlider",npanel)
		ds:SetSize(1,24)
		ds:Dock(TOP)
		ds:SetText(" Draw Distance")
		ds:SetMinMax(0,384)
		ds:SetDefaultValue(192)
		ds:SetValue(192)
		ds:SetDecimals(0)
		ds:SetDark(true)
		function ds:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(nmodel3,value) end
		
		local mb = vgui.Create("DTextEntry",npanel)
		mb:SetSize(1,24)
		mb:Dock(TOP)
		mb:SetValue(Trakpak3.SigEdit.intmodels[3])
		function mb:OnEnter(text)
			Trakpak3.SigEdit.intmodels[3] = text
			nmodel3:SetModel(text)
			Trakpak3.SigEdit.init_anim[3] = true
		end
		
		--Next Signal Options
		local panel = vgui.Create("DPanel",page5)
		panel:SetSize(192,1)
		panel:Dock(RIGHT)
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("NEXT Signal Type")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local list = vgui.Create("DListView",panel)
		list:SetSize(1,128)
		list:Dock(TOP)
		list:AddColumn("Signal Type")
		list:SetMultiSelect(false)
		list:SetSortable(false)
		Trakpak3.SigEdit.panels.types[3] = list
		function list:OnRowSelected(index, row)
			Trakpak3.SigEdit.sim_next_sigtype = row:GetColumnText(1)
			Trakpak3.SigEdit.SimNextSignal()
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("NEXT Signal Aspect")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local list = vgui.Create("DListView",panel)
		list:SetSize(1,128)
		list:Dock(FILL)
		list:AddColumn("Aspect Name")
		list:SetMultiSelect(false)
		list:SetSortable(false)
		Trakpak3.SigEdit.panels.rules[4] = list
		function list:OnRowSelected(index, row)
			Trakpak3.SigEdit.sim_next_rule = Trakpak3.SigEdit.rules[index]
			Trakpak3.SigEdit.SimNextSignal()
		end
		
		--Local Signal Megapanel
		local lpanel = vgui.Create("DPanel",page5)
		lpanel:SetSize(256,1)
		lpanel:Dock(LEFT)
		
		local label = vgui.Create("DLabel",lpanel)
		label:SetSize(1,24)
		label:Dock(TOP)
		label:SetText("LOCAL Signal")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		--1
		local lmodel1 = vgui.Create("DModelPanel",lpanel)
		lmodel1:SetSize(128,128)
		lmodel1:Dock(TOP)
		lmodel1:SetModel(Trakpak3.SigEdit.intmodels[4])
		lmodel1:SetFOV(30)
		Trakpak3.SigEdit.AdjustCamera(lmodel1,192)
		function lmodel1:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,4) end
		
		local ds = vgui.Create("DNumSlider",lpanel)
		ds:SetSize(1,24)
		ds:Dock(TOP)
		ds:SetText(" Draw Distance")
		ds:SetMinMax(0,384)
		ds:SetDefaultValue(192)
		ds:SetValue(192)
		ds:SetDecimals(0)
		ds:SetDark(true)
		function ds:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(lmodel1,value) end
		
		local mb = vgui.Create("DTextEntry",lpanel)
		mb:SetSize(1,24)
		mb:Dock(TOP)
		mb:SetValue(Trakpak3.SigEdit.intmodels[4])
		function mb:OnEnter(text)
			Trakpak3.SigEdit.intmodels[4] = text
			lmodel1:SetModel(text)
			Trakpak3.SigEdit.init_anim[4] = true
		end
		
		--2
		local lmodel2 = vgui.Create("DModelPanel",lpanel)
		lmodel2:SetSize(128,128)
		lmodel2:Dock(TOP)
		lmodel2:SetModel(Trakpak3.SigEdit.intmodels[5])
		lmodel2:SetFOV(30)
		Trakpak3.SigEdit.AdjustCamera(lmodel2,192)
		function lmodel2:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,5) end
		
		local ds = vgui.Create("DNumSlider",lpanel)
		ds:SetSize(1,24)
		ds:Dock(TOP)
		ds:SetText(" Draw Distance")
		ds:SetMinMax(0,384)
		ds:SetDefaultValue(192)
		ds:SetValue(192)
		ds:SetDecimals(0)
		ds:SetDark(true)
		function ds:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(lmodel2,value) end
		
		local mb = vgui.Create("DTextEntry",lpanel)
		mb:SetSize(1,24)
		mb:Dock(TOP)
		mb:SetValue(Trakpak3.SigEdit.intmodels[5])
		function mb:OnEnter(text)
			Trakpak3.SigEdit.intmodels[5] = text
			lmodel2:SetModel(text)
			Trakpak3.SigEdit.init_anim[5] = true
		end
		
		--3
		local lmodel3 = vgui.Create("DModelPanel",lpanel)
		lmodel3:SetSize(128,128)
		lmodel3:Dock(TOP)
		lmodel3:SetModel(Trakpak3.SigEdit.intmodels[6])
		lmodel3:SetFOV(30)
		Trakpak3.SigEdit.AdjustCamera(lmodel3,192)
		function lmodel3:LayoutEntity(ent) Trakpak3.SigEdit.UpdateModel(ent,6) end
		
		local ds = vgui.Create("DNumSlider",lpanel)
		ds:SetSize(1,24)
		ds:Dock(TOP)
		ds:SetText(" Draw Distance")
		ds:SetMinMax(0,384)
		ds:SetDefaultValue(192)
		ds:SetValue(192)
		ds:SetDecimals(0)
		ds:SetDark(true)
		function ds:OnValueChanged(value) Trakpak3.SigEdit.AdjustCamera(lmodel3,value) end
		
		local mb = vgui.Create("DTextEntry",lpanel)
		mb:SetSize(1,24)
		mb:Dock(TOP)
		mb:SetValue(Trakpak3.SigEdit.intmodels[6])
		function mb:OnEnter(text)
			Trakpak3.SigEdit.intmodels[6] = text
			lmodel3:SetModel(text)
			Trakpak3.SigEdit.init_anim[6] = true
		end
		
		--Local Signal Options
		local panel = vgui.Create("DPanel",page5)
		panel:SetSize(192,1)
		panel:Dock(LEFT)
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("LOCAL Signal Type")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local list = vgui.Create("DListView",panel)
		list:SetSize(1,128)
		list:Dock(TOP)
		list:AddColumn("Signal Type")
		list:SetMultiSelect(false)
		list:SetSortable(false)
		Trakpak3.SigEdit.panels.types[4] = list
		function list:OnRowSelected(index, row)
			Trakpak3.SigEdit.sim_local_sigtype = row:GetColumnText(1)
			Trakpak3.SigEdit.SimLocalSignal()
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("Track Occupancy")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local cb = vgui.Create("DCheckBoxLabel",panel)
		cb:SetSize(1,24)
		cb:Dock(TOP)
		cb:SetText("Clear")
		cb:SetTextColor(Color(63,63,63))
		function cb:OnChange(value)
			Trakpak3.SigEdit.sim_local_occupied = value
			if value then self:SetText("Occupied") else self:SetText("Clear") end
			Trakpak3.SigEdit.SimLocalSignal()
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("Route Path")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local cb = vgui.Create("DCheckBoxLabel",panel)
		cb:SetSize(1,24)
		cb:Dock(TOP)
		cb:SetText("Main")
		cb:SetTextColor(Color(63,63,63))
		function cb:OnChange(value)
			Trakpak3.SigEdit.sim_local_diverging = value
			if value then self:SetText("Diverging") else self:SetText("Main") end
			Trakpak3.SigEdit.SimLocalSignal()
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("Route Speed")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local combox = vgui.Create("DComboBox",panel)
		combox:SetSize(1,24)
		combox:Dock(TOP)
		combox:SetSortItems(false)
		combox:SetValue("FULL")
		Trakpak3.SigEdit.sim_local_speed = "FULL"
		
		combox:AddChoice("FULL")
		combox:AddChoice("LIMITED")
		combox:AddChoice("MEDIUM")
		combox:AddChoice("SLOW")
		combox:AddChoice("RESTRICTED")
		combox:AddChoice("STOP/DANGER")
		function combox:OnSelect(index, value)
			Trakpak3.SigEdit.sim_local_speed = value
			Trakpak3.SigEdit.SimLocalSignal()
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("CTC State")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local combox = vgui.Create("DComboBox",panel)
		combox:SetSize(1,24)
		combox:Dock(TOP)
		combox:SetSortItems(false)
		combox:SetValue("ALLOW")
		Trakpak3.SigEdit.sim_ctc = 1
		
		combox:AddChoice("HOLD")
		combox:AddChoice("ALLOW")
		combox:AddChoice("FORCE")
		function combox:OnSelect(index, value)
			local ctc
			if value=="HOLD" then
				ctc = 0
			elseif value=="ALLOW" then
				ctc = 1
			else
				ctc = 2
			end
			Trakpak3.SigEdit.sim_ctc = ctc
			Trakpak3.SigEdit.SimLocalSignal()
		end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(TOP)
		label:SetText("Signal Tags")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local abox = vgui.Create("DTextEntry",panel)
		abox:SetSize(1,24)
		abox:Dock(BOTTOM)
		abox:SetEnabled(false)
		Trakpak3.SigEdit.panels.sim_abox = abox
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,32)
		label:Dock(BOTTOM)
		label:SetText("Calculated Aspect")
		label:SetContentAlignment(5)
		label:SetTextColor(Color(63,63,63))
		
		local scroll = vgui.Create("DScrollPanel",panel)
		scroll:SetSize(1,96)
		scroll:Dock(FILL)
		Trakpak3.SigEdit.panels.tagscroll = scroll
		
		
		local label = vgui.Create("DLabel",page5)
		label:Dock(BOTTOM)
		label:SetSize(1,64)
		--label:SetWrap(true)
		label:SetContentAlignment(5)
		Trakpak3.SigEdit.UpdateLogLabel(label)
		Trakpak3.SigEdit.panels.sim_loglabel = label
		label:DockMargin(8,8,8,8)
		
		local label = vgui.Create("DLabel",page5)
		label:SetSize(1,128)
		label:Dock(TOP)
		label:SetWrap(true)
		label:SetContentAlignment(8)
		label:SetText("This is where you can test all the Aspects, Signal Types, and Logic you've made. Note that you must write the Logic Function (in the Logic Editor) before this will work.")
		label:DockMargin(8,8,8,8)
		
		--Save File Page 6
		
		local page6 = vgui.Create("DPanel",sheet)
		page6:SetBackgroundColor(Color(63,63,63))
		sheet:AddSheet("Save Signal System",page6,"icon16/bullet_disk.png",false,false,"Save the system to a text file for later editing and use.")
		
		local label = vgui.Create("DLabel",page6)
		label:SetSize(1,64)
		label:SetText("Here's where you save your finished or in-progress signal system so you can edit it later or use it in maps. Were you expecting something more fancy?")
		label:Dock(TOP)
		label:SetContentAlignment(5)
		
		local spanel = vgui.Create("DPanel",page6)
		spanel:SetSize(1,96)
		spanel:Dock(TOP)
		
		local panel = vgui.Create("DPanel",spanel)
		panel:SetSize(384,1)
		panel:Dock(LEFT)
		function panel:Paint() end
		
		local panel = vgui.Create("DPanel",spanel)
		panel:SetSize(384,1)
		panel:Dock(RIGHT)
		function panel:Paint() end
		
		local panel = vgui.Create("DPanel",spanel)
		panel:Dock(FILL)
		function panel:Paint() end
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,24)
		label:SetTextColor(Color(63,63,63))
		label:SetText("Signal System Name")
		label:Dock(TOP)
		label:SetContentAlignment(5)
		
		local textbox = vgui.Create("DTextEntry",panel)
		textbox:SetSize(1,24)
		textbox:SetValue(Trakpak3.SigEdit.sysname or "")
		textbox:Dock(TOP)
		
		local button = vgui.Create("DButton",panel)
		button:SetSize(128,48)
		button:Dock(FILL)
		button:SetText("Save Signal System")
		
		button.DoClick = function()
			local sysname = textbox:GetValue() or ""
			if sysname!="" then
				Trakpak3.SigEdit.sysname = sysname
				Trakpak3.SigEdit.SaveSigEdit(Trakpak3.SigEdit.sysname)
			else
				local badlabel = vgui.Create("DLabel",page6)
				badlabel:SetSize(384,64)
				badlabel:Dock(TOP)
				badlabel:SetText("Please enter a valid name for your signaling system.")
				badlabel:SetColor(Color(255,0,0))
				badlabel:SetContentAlignment(5)
				LocalPlayer():EmitSound("buttons/button5.wav")
			end
		end
		
		Trakpak3.SigEdit.PopulateRules()
		Trakpak3.SigEdit.PopulateTypes()
		Trakpak3.SigEdit.PopulateTags()
	end
	
end 
--New/Edit Rule
function Trakpak3.SigEdit.AddRule(name, speed, description, color, order)
	order = order or (#Trakpak3.SigEdit.rules + 1)
	print(name, speed, description, color, order)
	Trakpak3.SigEdit.rules[order] = {name = name, speed = speed or "FULL", description = description or "No Description", color = color or "White"}
end

--Move Up/Down
function Trakpak3.SigEdit.NudgeRule(list, offset)
	local index = list:GetSelectedLine()
	if not index then return end
	local rules = Trakpak3.SigEdit.rules
	if ((index>1) and (offset==1)) or ((index<#rules) and (offset==-1)) then
		
		local rule_index = rules[index]
		local rule_adjacent = rules[index-offset]
		
		rules[index-offset] = rule_index
		rules[index] = rule_adjacent
		--print("Adjusted rules:\n")
		--PrintTable(rules)
		return index - offset
	else
		return index
	end
	
end

--Delete rule
function Trakpak3.SigEdit.PopRule(index)
	if not index then return end
	table.remove(Trakpak3.SigEdit.rules, index)
end

--[[
Trakpak3.SigEdit.AddRule("292 Stop","STOP/DANGER","Stop.")
Trakpak3.SigEdit.AddRule("291 Stop And Proceed","RESTRICTED","Stop, then proceed at RESTRICTED speed.")
Trakpak3.SigEdit.AddRule("290 Restricting","RESTRICTED","Proceed at RESTRICTED speed.")
Trakpak3.SigEdit.AddRule("289 Approach","FULL","Proceed prepared to stop at next signal.")
Trakpak3.SigEdit.AddRule("288 Clear","FULL","Proceed.")
]]--

--Populate/Refresh Rules List
function Trakpak3.SigEdit.PopulateRules()
	for _, list in pairs(Trakpak3.SigEdit.panels.rules) do
		if list then
			list:Clear()
			local rules = Trakpak3.SigEdit.rules
			if rules and not table.IsEmpty(rules) then
				for n = 1, #rules do
					local rule = rules[n]
					list:AddLine(rule.name, rule.speed, rule.description, rule.color)
				end
			end
		end
	end
end

--New Tag
function Trakpak3.SigEdit.AddTag(tagname)
	Trakpak3.SigEdit.tags[tagname] = true
end

--Remove Tag
function Trakpak3.SigEdit.DeleteTag(tagname)
	Trakpak3.SigEdit.tags[tagname] = nil
end

--Populate Tag List
function Trakpak3.SigEdit.PopulateTags(list)
	--The regular boxes
	for _, list in pairs(Trakpak3.SigEdit.panels.tags) do
		if list then
			list:Clear()
			local tags = Trakpak3.SigEdit.tags
			if tags and not table.IsEmpty(tags) then
				for k, v in pairs(tags) do
					if v then list:AddLine(k) end
				end
				list:SortByColumn(1)
			end
		end
	end
	
	--the signal sim scroll box
	local scroll = Trakpak3.SigEdit.panels.tagscroll
	
	scroll:Clear()
	Trakpak3.SigEdit.sim_local_tags = {}
		
	for k, v in pairs(Trakpak3.SigEdit.tags) do
		local cb = vgui.Create("DCheckBoxLabel",scroll)
		cb:SetSize(1,24)
		cb:Dock(TOP)
		cb:SetText(k)
		cb:SetTextColor(Color(63,63,63))
		function cb:OnChange(value)
			Trakpak3.SigEdit.sim_local_tags[k] = value
			--PrintTable(Trakpak3.SigEdit.sim_local_tags)
			Trakpak3.SigEdit.SimLocalSignal()
		end
	end
end

--New Sigtype
function Trakpak3.SigEdit.AddSigType(name)
	Trakpak3.SigEdit.sigtypes[name] = {test=true}
end

--Remove Sigtype
function Trakpak3.SigEdit.DeleteSigType(name)
	Trakpak3.SigEdit.sigtypes[name] = nil
end

--Populate Type List
function Trakpak3.SigEdit.PopulateTypes()
	for _, list in pairs(Trakpak3.SigEdit.panels.types) do
		if list then
			list:Clear()
			local sigtypes = Trakpak3.SigEdit.sigtypes
			if sigtypes and not table.IsEmpty(sigtypes) then
				for k, v in pairs(sigtypes) do
					if v then list:AddLine(k) end
				end
				list:SortByColumn(1)
			end
		end
	end
end

--[[
Trakpak3.SigEdit.AddTag("abs")
Trakpak3.SigEdit.AddTag("lunar")
Trakpak3.SigEdit.AddTag("dwarf")

Trakpak3.SigEdit.AddSigType("cl_high")
Trakpak3.SigEdit.AddSigType("cl_high_l1")
Trakpak3.SigEdit.AddSigType("cl_high_l2")
Trakpak3.SigEdit.AddSigType("cl_high_l3")
Trakpak3.SigEdit.AddSigType("cl_dwarf")
Trakpak3.SigEdit.AddSigType("cl_dwarf_l")
]]--

--Model Viewer Controls
Trakpak3.SigEdit.intmodels = {}
Trakpak3.SigEdit.intskins = {}
Trakpak3.SigEdit.intbodygroups = {}
Trakpak3.SigEdit.intcycles = {}
for n=1,6 do
	Trakpak3.SigEdit.intmodels[n] = "models/trakpak3_us/signals/colorlight/rygl.mdl"
	Trakpak3.SigEdit.intskins[n] = nil
	Trakpak3.SigEdit.intbodygroups[n] = {}
	Trakpak3.SigEdit.intcycles[n] = nil
end

function Trakpak3.SigEdit.AdjustCamera(modelviewer,distance)
	local ent = modelviewer:GetEntity()
	if ent then
		modelviewer:SetCamPos(Vector(-(distance or 48),0,0))
		modelviewer:SetLookAng(Angle())
	end
end

function Trakpak3.SigEdit.UpdateModel(ent, index)
	local skin = Trakpak3.SigEdit.intskins[index]
	local bodygroups = Trakpak3.SigEdit.intbodygroups[index]
	local cycle = Trakpak3.SigEdit.intcycles[index]
	ent:SetAngles(Angle(0,180,0))
	--skin
	if skin then ent:SetSkin(tonumber(skin) or 0) end
	--bodygroups
	if bodygroups then
		for k, v in pairs(bodygroups) do
			ent:SetBodygroup(k, tonumber(v) or 0)
		end
	end
	--anim cycle
	if cycle then
		if Trakpak3.SigEdit.init_anim[index] then
			Trakpak3.SigEdit.init_anim[index] = false
			ent.AutomaticFrameAdvance = false
			ent:ResetSequence("range")
		end
		ent:SetCycle(tonumber(cycle) or 0)
	end
end

function Trakpak3.SigEdit.SetModelInfo(data)
	Trakpak3.SigEdit.intskins[1] = data.skin1
	Trakpak3.SigEdit.intbodygroups[1] = string.Explode(" ",data.bg1) or {}
	Trakpak3.SigEdit.intcycles[1] = data.cycle1
	
	Trakpak3.SigEdit.intskins[2] = data.skin2
	Trakpak3.SigEdit.intbodygroups[2] = string.Explode(" ",data.bg2) or {}
	Trakpak3.SigEdit.intcycles[2] = data.cycle2
	
	Trakpak3.SigEdit.intskins[3] = data.skin3
	Trakpak3.SigEdit.intbodygroups[3] = string.Explode(" ",data.bg3) or {}
	Trakpak3.SigEdit.intcycles[3] = data.cycle3
	
	--print(data.cycle1, data.cycle2, data.cycle3)
end

--Config Controls
function Trakpak3.SigEdit.IntFillBoxes()
	local aspect = Trakpak3.SigEdit.int_aspect
	local sigtype = Trakpak3.SigEdit.int_sigtype
	--print(aspect, sigtype)
	if aspect and sigtype then
		local data = Trakpak3.SigEdit.sigtypes[sigtype][aspect]

		if data then
			--print("Filling In Data:")
			--PrintTable(data)
			Trakpak3.SigEdit.panels.cfg.skinbox1:SetValue(data.skin1 or "")
			Trakpak3.SigEdit.panels.cfg.bgbox1:SetValue(data.bg1 or "")
			Trakpak3.SigEdit.panels.cfg.cyclebox1:SetValue(data.cycle1 or "")
			
			Trakpak3.SigEdit.panels.cfg.skinbox2:SetValue(data.skin2 or "")
			Trakpak3.SigEdit.panels.cfg.bgbox2:SetValue(data.bg2 or "")
			Trakpak3.SigEdit.panels.cfg.cyclebox2:SetValue(data.cycle2 or "")
			
			Trakpak3.SigEdit.panels.cfg.skinbox3:SetValue(data.skin3 or "")
			Trakpak3.SigEdit.panels.cfg.bgbox3:SetValue(data.bg3 or "")
			Trakpak3.SigEdit.panels.cfg.cyclebox3:SetValue(data.cycle3 or "")
			
			Trakpak3.SigEdit.SetModelInfo(data)
		else
			--print("No data found for "..sigtype.." aspect "..aspect)
			for _, box in pairs(Trakpak3.SigEdit.panels.cfg) do box:SetValue("") end
			--Trakpak3.SigEdit.SetModelInfo()
		end
	end
end

function Trakpak3.SigEdit.IntAssignData()
	local aspect = Trakpak3.SigEdit.int_aspect
	local sigtypes = Trakpak3.SigEdit.panels.types[2]:GetSelected()
	local data = {}
	
	data.skin1 = Trakpak3.SigEdit.panels.cfg.skinbox1:GetValue()
	data.bg1 = Trakpak3.SigEdit.panels.cfg.bgbox1:GetValue()
	data.cycle1 = Trakpak3.SigEdit.panels.cfg.cyclebox1:GetValue()
	
	data.skin2 = Trakpak3.SigEdit.panels.cfg.skinbox2:GetValue()
	data.bg2 = Trakpak3.SigEdit.panels.cfg.bgbox2:GetValue()
	data.cycle2 = Trakpak3.SigEdit.panels.cfg.cyclebox2:GetValue()
	
	data.skin3 = Trakpak3.SigEdit.panels.cfg.skinbox3:GetValue()
	data.bg3 = Trakpak3.SigEdit.panels.cfg.bgbox3:GetValue()
	data.cycle3 = Trakpak3.SigEdit.panels.cfg.cyclebox3:GetValue()
	
	print(data.cycle1, data.cycle2, data.cycle3)
	
	if aspect and sigtypes and data then
		
		for _, row in pairs(sigtypes) do
			local sigtype = row:GetColumnText(1)
			Trakpak3.SigEdit.sigtypes[sigtype][aspect] = data
		end
		
		
		Trakpak3.SigEdit.SetModelInfo(data)
		Trakpak3.SigEdit.IntFillBoxes()
	end
end

function Trakpak3.SigEdit.IntCopyData()
	
	local data = {}
	data.skin1 = Trakpak3.SigEdit.panels.cfg.skinbox1:GetValue()
	data.bg1 = Trakpak3.SigEdit.panels.cfg.bgbox1:GetValue()
	data.cycle1 = Trakpak3.SigEdit.panels.cfg.cyclebox1:GetValue()
	
	data.skin2 = Trakpak3.SigEdit.panels.cfg.skinbox2:GetValue()
	data.bg2 = Trakpak3.SigEdit.panels.cfg.bgbox2:GetValue()
	data.cycle2 = Trakpak3.SigEdit.panels.cfg.cyclebox2:GetValue()
	
	data.skin3 = Trakpak3.SigEdit.panels.cfg.skinbox3:GetValue()
	data.bg3 = Trakpak3.SigEdit.panels.cfg.bgbox3:GetValue()
	data.cycle3 = Trakpak3.SigEdit.panels.cfg.cyclebox3:GetValue()
	
	Trakpak3.SigEdit.clipboard = data
end

function Trakpak3.SigEdit.IntPasteData()
	local aspect = Trakpak3.SigEdit.int_aspect
	local sigtypes = Trakpak3.SigEdit.panels.types[2]:GetSelected()
	local data = Trakpak3.SigEdit.clipboard
	
	if aspect and sigtypes and data then
		
		for _, row in pairs(sigtypes) do
			local sigtype = row:GetColumnText(1)
			Trakpak3.SigEdit.sigtypes[sigtype][aspect] = data
		end
		
		
		Trakpak3.SigEdit.SetModelInfo(data)
		Trakpak3.SigEdit.IntFillBoxes()
	end
end

--Logic Editor Functions

Trakpak3.SigEdit.icon_cond = "icon16/lightning.png"
Trakpak3.SigEdit.icon_true = "icon16/monitor_add.png"
Trakpak3.SigEdit.icon_false = "icon16/monitor_delete.png"
Trakpak3.SigEdit.icon_return = "icon16/book_open.png"

Trakpak3.SigEdit.selectednode = 0

Trakpak3.SigEdit.dictionary = {
	["Equals"] = "==",
	["Does Not Equal"] = "=/=",
	["Is Less Than"] = "<",
	["Is Greater Than"] = ">",
	["Is Less Or Equal To"] = "<=",
	["Is Greater Or Equal To"] = ">=",
	["Is"] = "==",
	["Is Not"] = "=/=",
	
	["Track Occupancy"] = "OCCUPIED",
	["Route Diverging"] = "DIVERGING",
	["Route Speed"] = "SPEED",
	["Next Signal Aspect"] = "NEXTASPECT",
	["Next Signal Speed"] = "NEXTSPEED",
	["CTC State"] = "CTC"
}

Trakpak3.SigEdit.panels.logic_buttons_att = {}
Trakpak3.SigEdit.panels.logic_buttons_noatt = {}

function Trakpak3.SigEdit.CreateNodeTable(node,canattach)
	local id = Trakpak3.SigEdit.node_id
	local nodetable = {node = node, canattach = canattach}
	Trakpak3.SigEdit.panels.nodes[id] = nodetable
	Trakpak3.SigEdit.node_id = Trakpak3.SigEdit.node_id + 1
	
	local pnode = node:GetParentNode()
	local parent = 1
	if id>1 then
		parent = pnode:GetIndex()
	end
	nodetable.parent = parent
	nodetable.icon = node:GetIcon()
	nodetable.name = node:GetText()
	
	function node:GetIndex() return id end
	function node:DoClick()
		Trakpak3.SigEdit.selectednode = id
		local ntable = Trakpak3.SigEdit.panels.nodes[id]
		--PrintTable(ntable)
		if ntable then
			if ntable.isconditional then
				local condary = ntable.conditions
				local boxtext = condary[1]
				for n=2,#condary do boxtext = boxtext.." "..condary[n] end
				Trakpak3.SigEdit.panels.condition_box:SetValue(boxtext or "")
			else
				Trakpak3.SigEdit.panels.condition_box:SetValue("")
			end
			for k, v in pairs(Trakpak3.SigEdit.panels.logic_buttons_att) do
				v:SetEnabled(ntable.canattach)
			end
			for k, v in pairs(Trakpak3.SigEdit.panels.logic_buttons_noatt) do
				v:SetEnabled(not ntable.canattach)
			end
		end
	end
	
	return nodetable, id
end

function Trakpak3.SigEdit.GetNodeTable(node)
	for k, v in pairs(Trakpak3.SigEdit.panels.nodes) do
		if v.node==node then return v end
	end
end

function Trakpak3.SigEdit.CreateStartNode(tree)
	
	local start = tree:AddNode("START","icon16/bullet_go.png")
	local stable = Trakpak3.SigEdit.CreateNodeTable(start,true)

	if Trakpak3.SigEdit.panels.nodes[2] then
		stable.nextnode = 2
		Trakpak3.SigEdit.ConstructFromData()
	else
		Trakpak3.SigEdit.AddConditional(start)
	end
end

function Trakpak3.SigEdit.AddConditional(node)
	local cond_if = node:AddNode("IF",Trakpak3.SigEdit.icon_cond)
	local cond_then = cond_if:AddNode("THEN",Trakpak3.SigEdit.icon_true)
	local cond_else = cond_if:AddNode("ELSE",Trakpak3.SigEdit.icon_false)
	
	local nt_if, id_if = Trakpak3.SigEdit.CreateNodeTable(cond_if)
	local nt_then, id_then = Trakpak3.SigEdit.CreateNodeTable(cond_then, true)
	local nt_else, id_else = Trakpak3.SigEdit.CreateNodeTable(cond_else, true)
	
	nt_if.conditions = {}
	nt_if.isconditional = true
	nt_if.id_then = id_then
	nt_if.id_else = id_else
	
	cond_if:ExpandTo(true)

	print("Conditional: Assigning node "..nt_if.parent.." nextnode "..id_if)
	Trakpak3.SigEdit.panels.nodes[nt_if.parent].nextnode = id_if
	return id_if, id_then, id_else
end

function Trakpak3.SigEdit.SetCondition(id, sequence)
	--local id = Trakpak3.SigEdit.selectednode
	local nodetable = Trakpak3.SigEdit.panels.nodes[id]
	if nodetable and nodetable.node and nodetable.isconditional then
		nodetable.conditions = sequence
		local name = "IF"
		for n = 1, #sequence do name = name.." "..sequence[n] end
		
		nodetable.node:SetText(name)
		nodetable.name = name
	end
end

function Trakpak3.SigEdit.ApplyCondition()
	local index = Trakpak3.SigEdit.selectednode
	if index and (index>1) then
		local ntable = Trakpak3.SigEdit.panels.nodes[index]
		--PrintTable(ntable)
		if ntable and ntable.isconditional then
			local condition = Trakpak3.SigEdit.panels.condition_box:GetValue()
			if condition and (condition!="") then
				condition = string.Explode(" ",condition)
				Trakpak3.SigEdit.SetCondition(index,condition)
			end
		end
	end
end

function Trakpak3.SigEdit.AddReturn(node,aspect)
	local rtn = node:AddNode(aspect,Trakpak3.SigEdit.icon_return)
	local ntable, id = Trakpak3.SigEdit.CreateNodeTable(rtn)
	rtn:ExpandTo(true)
	ntable.aspect = aspect
	Trakpak3.SigEdit.panels.nodes[ntable.parent].nextnode = id
end

function Trakpak3.SigEdit.AddCText(text)
	local tbox = Trakpak3.SigEdit.panels.condition_box
	
	local current_text = tbox:GetValue() or ""
	local addtext
	if #current_text==0 then addtext = text else addtext = " "..text end
	tbox:SetValue(current_text..addtext)
	Trakpak3.SigEdit.ApplyCondition()
end

Trakpak3.SigEdit.dictionary2 = {
	["OCC"] = "true",
	["CLR"] = "false",
	["DV"] = "true",
	["MN"] = "false",
	
	["FULL"] = "5",
	["LIMITED"] = "4",
	["MEDIUM"] = "3",
	["SLOW"] = "2",
	["RESTRICTED"] = "1",
	["STOP/DANGER"] = "0",
	
	["FORCE"] = "2",
	["ALLOW"] = "1",
	["HOLD"] = "0"
}

function Trakpak3.SigEdit.WriteConditionText(ntable)
	local cond_ary = ntable.conditions
	
	local out = "("
	
	for n=1,#cond_ary do
		local term = cond_ary[n]
		if term=="or" then
			term = ") or ("
		end
		local term = Trakpak3.SigEdit.dictionary2[term] or term
		
		out = out.." "..term
	end
	
	return out.." )"
end

function Trakpak3.SigEdit.ExploreNode(ntable,ilevel)
	local nodes = Trakpak3.SigEdit.panels.nodes
	local indent = string.rep("\t", ilevel)
	if not ntable then
		return false
	elseif ntable.aspect then --Node is a return
		return indent.."return \""..(ntable.aspect).."\""
	elseif ntable.isconditional then --Node is a conditional - RECURSION TIME
		
		local out = indent.."if "..Trakpak3.SigEdit.WriteConditionText(ntable).." then\n"
		local thentable = nodes[nodes[ntable.id_then].nextnode]
		local nextresult = Trakpak3.SigEdit.ExploreNode(thentable,ilevel+1)
		if nextresult then
			out = out..nextresult.."\n"..indent.."else\n"
			local elsetable = nodes[nodes[ntable.id_else].nextnode]
			nextresult = Trakpak3.SigEdit.ExploreNode(elsetable,ilevel+1)
			if nextresult then
				out = out..nextresult.."\n"..indent.."end"
				return out
			else return false end
		else return false end
	end
end

function Trakpak3.SigEdit.WriteLogicFunction()
	local nodes = Trakpak3.SigEdit.panels.nodes
	local func_text = "function(OCCUPIED, DIVERGING, SPEED, NEXTASPECT, NEXTSPEED, TAGS, CTC)\n"
	local func_body = Trakpak3.SigEdit.ExploreNode(nodes[2],1)
	if func_body then --function wrote successfully
		func_text = func_text..func_body.."\nend"
		RunString("Trakpak3.SigEdit.LogicFunction = "..func_text)
		print("Wrote Logic function: \n")
		print(func_text)
		Trakpak3.SigEdit.func_text = func_text
	else
		Trakpak3.SigEdit.LogicFunction = function() return false end
		Trakpak3.SigEdit.func_text = nil
	end
	Trakpak3.SigEdit.UpdateLogLabel(Trakpak3.SigEdit.panels.sim_loglabel)
end

function Trakpak3.SigEdit.RebuildKids(node, old_list, old_id)
	local ntable = old_list[old_id]
	print("Old node ",old_id)
	PrintTable(ntable)
	print("\n")
	if ntable.nextnode then --Node had an attachment
		local ctable = old_list[ntable.nextnode]
		
		if ctable.isconditional then --child was a conditional
			local cond = ctable.conditions
			local old_then = ctable.id_then
			local old_else = ctable.id_else
			
			local id_if, id_then, id_else = Trakpak3.SigEdit.AddConditional(node)
			Trakpak3.SigEdit.SetCondition(id_if,cond)
			
			local newnode_then = Trakpak3.SigEdit.panels.nodes[id_then].node
			local newnode_else = Trakpak3.SigEdit.panels.nodes[id_else].node
			
			Trakpak3.SigEdit.RebuildKids(newnode_then,old_list,old_then)
			Trakpak3.SigEdit.RebuildKids(newnode_else,old_list,old_else)
		else --child was a return
			local aspect = ctable.aspect
			Trakpak3.SigEdit.AddReturn(node,aspect)
		end
	else print("Node had no attachments") end
end

function Trakpak3.SigEdit.ConstructFromData()
	--for n=1,#Trakpak3.SigEdit.panels.nodes do print(n, Trakpak3.SigEdit.panels.nodes[n].nextnode) end
	local old_nodes = table.Copy(Trakpak3.SigEdit.panels.nodes)
	Trakpak3.SigEdit.RebuildKids(old_nodes[1].node, old_nodes, 1)
end

--Simulator
function Trakpak3.SigEdit.SimNextSignal()
	local sigtype = Trakpak3.SigEdit.sim_next_sigtype
	local rule = Trakpak3.SigEdit.sim_next_rule
	local aspect
	
	if rule then aspect = rule.name else return end
	
	print("Simulating Next Signal: ", sigtype, aspect)
	
	if sigtype and aspect and (sigtype!="") and(aspect!="") then
		local data = Trakpak3.SigEdit.sigtypes[sigtype][aspect]
		Trakpak3.SigEdit.SetModelInfo(data)
		Trakpak3.SigEdit.SimLocalSignal()
	end
end

function Trakpak3.SigEdit.LogicFunction() return false end

function Trakpak3.SigEdit.SimLocalSignal()
	
	local speed_dict = {
		["FULL"] = 5,
		["LIMITED"] = 4,
		["MEDIUM"] = 3,
		["SLOW"] = 2,
		["RESTRICTED"] = 1,
		["STOP/DANGER"] = 0
	}
	
	local sigtype = Trakpak3.SigEdit.sim_local_sigtype
	if sigtype and sigtype!="" then
		local occupied = Trakpak3.SigEdit.sim_local_occupied
		local diverging = Trakpak3.SigEdit.sim_local_diverging
		local speed = speed_dict[Trakpak3.SigEdit.sim_local_speed]
		local tags = Trakpak3.SigEdit.sim_local_tags
		local nrule = Trakpak3.SigEdit.sim_next_rule
		local ctc = Trakpak3.SigEdit.sim_ctc
		if nrule then
			local nextaspect = nrule.name
			local nextspeed = speed_dict[nrule.speed]
			
			local aspect = Trakpak3.SigEdit.LogicFunction(occupied, diverging, speed, nextaspect, nextspeed, tags, ctc)
			--print("Simulating Local Signal: ",sigtype, aspect)
			if aspect then --Set Model Info
				local data = Trakpak3.SigEdit.sigtypes[sigtype][aspect]
				if data then
					Trakpak3.SigEdit.intskins[4] = data.skin1
					Trakpak3.SigEdit.intbodygroups[4] = string.Explode(" ",data.bg1) or {}
					Trakpak3.SigEdit.intcycles[4] = data.cycle1
					
					Trakpak3.SigEdit.intskins[5] = data.skin2
					Trakpak3.SigEdit.intbodygroups[5] = string.Explode(" ",data.bg2) or {}
					Trakpak3.SigEdit.intcycles[5] = data.cycle2
					
					Trakpak3.SigEdit.intskins[6] = data.skin3
					Trakpak3.SigEdit.intbodygroups[6] = string.Explode(" ",data.bg3) or {}
					Trakpak3.SigEdit.intcycles[6] = data.cycle3
					
					Trakpak3.SigEdit.panels.sim_abox:SetValue(aspect)
				end
			end
		end
	end
end

function Trakpak3.SigEdit.TestLogic()
	local test = Trakpak3.SigEdit.LogicFunction(false, false, 0, nil, 0, {})
	if test then return true else return false end
end

function Trakpak3.SigEdit.UpdateLogLabel(label)
	local valid = Trakpak3.SigEdit.TestLogic()
	if valid then --logic function is defined
		label:SetText("Logic Function OK!")
		label:SetTextColor(Color(0,255,0))
	else --logic function is not defined
		label:SetText("Logic Function is not written. Please press the \"Write Logic Function\"\nbutton in the Logic Editor page.")
		label:SetTextColor(Color(255,0,0))
	end
	label:SetContentAlignment(5)
end

--Save/Load
function Trakpak3.SigEdit.SaveSigEdit(sysname)
	Trakpak3.SigEdit.WriteLogicFunction()
	local ftable = {}
	ftable.sysname = sysname
	ftable.rules = Trakpak3.SigEdit.rules
	ftable.tags = Trakpak3.SigEdit.tags
	ftable.sigtypes = Trakpak3.SigEdit.sigtypes
	ftable.panels = {nodes = Trakpak3.SigEdit.panels.nodes}
	ftable.func_text = Trakpak3.SigEdit.func_text
	
	
	local json = util.TableToJSON(ftable, true)
	file.CreateDir("trakpak3/signalsystems")
	file.Write("trakpak3/signalsystems/"..sysname..".txt", json)
	local gray = Color(127,255,255)
	chat.AddText(gray, "File saved as ",Color(255,127,127),"data",gray,"/trakpak3/signalsystems/"..sysname..".txt! To include it with your map, change its extension to .lua and place it in ",Color(0,127,255),"lua",gray,"/trakpak3/signalsystems/!")
end

function Trakpak3.SigEdit.LoadSigEdit(sysname)
	local json = file.Read("trakpak3/signalsystems/"..sysname..".txt", "DATA")
	if json then
		local ftable = util.JSONToTable(json)
		Trakpak3.SigEdit.sysname = ftable.sysname
		Trakpak3.SigEdit.rules = ftable.rules
		Trakpak3.SigEdit.tags = ftable.tags
		Trakpak3.SigEdit.sigtypes = ftable.sigtypes
		Trakpak3.SigEdit.panels.nodes = ftable.panels.nodes
		--chat.AddText(Color(127,255,255), "Loaded SigEdit file data/trakpak3/signalsystems/"..sysname..".txt successfully.")
		return true
	else
		chat.AddText(Color(127,255,255),"Could not find SigEdit file data/trakpak3/signalsystems/"..sysname..".txt!")
		return false
	end
end