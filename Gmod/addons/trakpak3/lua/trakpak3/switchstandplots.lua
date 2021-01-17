--[[

==================
Switch Stand Plots
==================

Each switch stand needs a plot that maps the switch throw fraction to frames on the animations.

"Frame" is the frame in the sequence relative to the starting frame (if an sequence uses frames 10 to 20 in an SMD, then Sequence Frame 0 is SMD Frame 10).
"Fraction" is a decimal value from 0 to 1 representing how far the switch blades/points move. 0 is start, 1 is end, 0.5 is halfway through, etc.

Trakpak3.SwitchStandPlots["<modelpath>"] = {
	{ Frame0, Fraction0 },
	{ Frame1, Fraction1 },
	{ Frame2, Fraction2 },
	{ ... }
}

To include custom switch stands with your addon, make a file <youraddon>/lua/trakpak3/switchstandplots.lua and include plots as shown above. See Below for examples.

]]--

--RACOR 112E
local r112 = {
	{0,0},
	{25,0},
	{30,1/9},
	{35,4/9},
	{40,1},
	{60,1}
}
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/racor_112e_right.mdl"] = r112
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/racor_112e_left.mdl"] = r112

--Bethlehem Steel 51A
local b51a = {
	{0,0},
	{15,0},
	{50,0.55},
	{65,0.6},
	{73,0.95},
	{90,0.95},
	{95,1},
	{100,1}
}
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/bethlehem_51a_right.mdl"] = b51a
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/bethlehem_51a_left.mdl"] = b51a

--Racor 22 and 22E
local r22 = {
	{0,0},
	{15,0},
	{50,0.5},
	{70,0.6},
	{75,0.6},
	{80,0.7},
	{83,1},
	{90,1}
}
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/racor_22_right.mdl"] = r22
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/racor_22_left.mdl"] = r22

local r22e = {
	{0,0},
	{15,0},
	{60,0.5},
	{80,0.62},
	{85,0.62},
	{90,0.7},
	{95,1},
	{120,1}
	
}
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/racor_22e_right.mdl"] = r22e
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/racor_22e_left.mdl"] = r22e

--GRS Model 5
local g5 = {}
g5["throw_open"] = {
	{0,0},
	{90,0},
	{180,1},
	{270,1}
}
g5["throw_open_fast"] = {
	{0,0},
	{45,0},
	{135,1},
	{180,1}
}
g5["throw_close"] = g5["throw_open"]
g5["throw_close_fast"] = g5["throw_open_fast"]

Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/grs_model5_lh_left.mdl"] = g5
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/grs_model5_lh_right.mdl"] = g5
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/grs_model5_rh_left.mdl"] = g5
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/grs_model5_rh_right.mdl"] = g5

--Armstrong (Interlocking Lever Frame)
Trakpak3.SwitchStandPlots["models/trakpak3_us/switchstands/armstrong.mdl"] = {
	{0,0},
	{10,0},
	{30,1},
	{40,1}
}