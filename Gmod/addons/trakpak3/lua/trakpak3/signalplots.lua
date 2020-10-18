--MsgC(Trakpak3.Magenta,"Running Signal Plots\n")

--[[

============
Signal Plots
============

Each animated signal needs a plot that maps the desired bodygroup combination to frames on the animations.

"Frame" is the frame in the sequence relative to the starting frame (if an sequence uses frames 10 to 20 in an SMD, then Sequence Frame 0 is SMD Frame 10).
"BG" is a table of bodygroup part numbers to assign when the model's animation is closest to the associated frame. For example, "{1, 0, 2}" will set the first bodygroup to 1, the second bodygroup to 0, and the third bodygroup to 2.

Trakpak3.SignalPlots["<modelpath>"] = {
	{ Frame0, BG0 },
	{ Frame1, BG1 },
	{ Frame2, BG2 },
	{ ... }
}

To include custom signals with your addon, make a file <youraddon>/lua/trakpak3/signalplots.lua and include plots as shown above. See Below for examples.

]]--

--UQ Semaphores (High)

Trakpak3.SignalPlots["models/trakpak3_us/signals/semaphore_uq/ryg.mdl"] = {
	{5,{1}},
	{7.5,{0}},
	{10,{4}},
	
	{20,{4}},
	{22.5,{0}},
	{30,{6}}
}
Trakpak3.SignalPlots["models/trakpak3_us/signals/semaphore_uq/rlg.mdl"] = {
	{5,{1}},
	{7.5,{0}},
	{10,{3}},
	
	{20,{3}},
	{22.5,{0}},
	{30,{6}}
}