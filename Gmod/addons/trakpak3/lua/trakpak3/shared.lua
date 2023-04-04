--SHARED

--Custom Vehicles

--Footprint
local function HandleStandingAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_IDLE ) 
end

--List of sounds used by the frogs
Trakpak3.FrogSounds = {
	"trakpak3/frog/clanc_1",
	"trakpak3/frog/clanc_2",
	"trakpak3/frog/clanc_3",
	"trakpak3/frog/clanc_4",
	"trakpak3/frog/clanc_5",
	"trakpak3/frog/clanc_6",
	"trakpak3/frog/clanc_7",
	"trakpak3/frog/clanc_8"
}

--Function to play a random clank sound
function Trakpak3.FrogClank(ent)
	ent:EmitSound(Trakpak3.FrogSounds[math.random(1,#Trakpak3.FrogSounds)],75,math.random(95,105))
end

local V = {
	Name = "Trakpak3 Footprints",
	Model = "models/trakpak3_common/vehicles/footprints.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = "Trakpak3",

	Author = "Magnum",
	Information = "Used for standing and operating stuff.",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleStandingAnimation
	}
}
list.Set( "Vehicles", "tp3_footprints", V )

--Sound Scripts
sound.Add({
	name="Trakpak3.derail.clang",
	sound = "trakpak3/switchstands/manual/derail_clang.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 80,
	pitch = {95, 105}
})
sound.Add({
	name="Trakpak3.switchstand.latch_lift",
	sound = "trakpak3/switchstands/manual/latch_lift.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.latch_drop",
	sound = "trakpak3/switchstands/manual/latch_drop.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.bethlehem_latch_lift",
	sound = "trakpak3/switchstands/manual/bethlehem_latch_lift.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.bethlehem_latch_drop",
	sound = "trakpak3/switchstands/manual/bethlehem_latch_drop.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.latch_contact",
	sound = "trakpak3/switchstands/manual/latch_contact.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.latch_close",
	sound = "trakpak3/switchstands/manual/latch_close.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})

sound.Add({
	name="Trakpak3.switchstand.lever_hittop",
	sound = "trakpak3/switchstands/manual/latch_close.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.lever_hitbottom",
	sound = "trakpak3/switchstands/manual/latch_lift.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
--[[
sound.Add({
	name="Trakpak3.switchstand.blades_close_a",
	sound = {
		"trakpak3/switchstands/manual/manualjunctiona01.wav",
		"trakpak3/switchstands/manual/manualjunctiona02.wav",
		"trakpak3/switchstands/manual/manualjunctiona03.wav",
		"trakpak3/switchstands/manual/manualjunctiona04.wav",
		"trakpak3/switchstands/manual/manualjunctiona05.wav",
		"trakpak3/switchstands/manual/manualjunctiona06.wav",
		"trakpak3/switchstands/manual/manualjunctiona07.wav",
		"trakpak3/switchstands/manual/manualjunctiona08.wav",
		"trakpak3/switchstands/manual/manualjunctiona09.wav"
	},
	channel = CHAN_AUTO,
	volume = 1,
	level = 70,
	pitch = 100
})
sound.Add({
	name="Trakpak3.switchstand.blades_close_b",
	sound = {
		"trakpak3/switchstands/manual/manualjunctionb01.wav",
		"trakpak3/switchstands/manual/manualjunctionb02.wav",
		"trakpak3/switchstands/manual/manualjunctionb03.wav",
		"trakpak3/switchstands/manual/manualjunctionb04.wav",
		"trakpak3/switchstands/manual/manualjunctionb05.wav",
		"trakpak3/switchstands/manual/manualjunctionb06.wav",
		"trakpak3/switchstands/manual/manualjunctionb07.wav",
		"trakpak3/switchstands/manual/manualjunctionb08.wav"
	},
	channel = CHAN_AUTO,
	volume = 1,
	level = 70,
	pitch = 100
})
]]--
sound.Add({
	name = "Trakpak3.switchstand.machine_lv",
	sound = "trakpak3/switchstands/switchmachine/throw_lv.wav",
	channel = CHAN_AUTO,
	volume = 0.75,
	level = 70,
	pitch = 100
})
sound.Add({
	name = "Trakpak3.switchstand.machine_hv",
	sound = "trakpak3/switchstands/switchmachine/throw_hv.wav",
	channel = CHAN_AUTO,
	volume = 0.75,
	level = 70,
	pitch = 100
})
