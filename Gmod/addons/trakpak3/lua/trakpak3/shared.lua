--SHARED

--Get's the "Root" entity, the parent of all parents.
function Trakpak3.GetRoot(ent)
	if not ent:IsValid() then return end
	while ent:GetParent():IsValid() do
		ent = ent:GetParent()
	end
	return ent
end

--Custom Vehicles

--Footprint
local function HandleStandingAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_IDLE ) 
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
	name = "Trakpak3.derail.clang",
	sound = "trakpak3/switchstands/manual/derail_clang.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 80,
	pitch = {95, 105}
})
sound.Add({
	name = "Trakpak3.switchstand.latch_lift",
	sound = "trakpak3/switchstands/manual/latch_lift.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name = "Trakpak3.switchstand.latch_drop",
	sound = "trakpak3/switchstands/manual/latch_drop.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name = "Trakpak3.switchstand.bethlehem_latch_lift",
	sound = "trakpak3/switchstands/manual/bethlehem_latch_lift.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name = "Trakpak3.switchstand.bethlehem_latch_drop",
	sound = "trakpak3/switchstands/manual/bethlehem_latch_drop.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name = "Trakpak3.switchstand.latch_contact",
	sound = "trakpak3/switchstands/manual/latch_contact.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name = "Trakpak3.switchstand.latch_close",
	sound = "trakpak3/switchstands/manual/latch_close.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})

sound.Add({
	name = "Trakpak3.switchstand.lever_hittop",
	sound = "trakpak3/switchstands/manual/latch_close.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})
sound.Add({
	name = "Trakpak3.switchstand.lever_hitbottom",
	sound = "trakpak3/switchstands/manual/latch_lift.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	pitch = 100
})

sound.Add({
	name = "Trakpak3.tracksounds.frog1",
	sound = {
		"trakpak3/tracksounds/clanc_1.wav",
		"trakpak3/tracksounds/clanc_2.wav",
		"trakpak3/tracksounds/clanc_3.wav",
		"trakpak3/tracksounds/clanc_4.wav",
		"trakpak3/tracksounds/clanc_5.wav",
		"trakpak3/tracksounds/clanc_6.wav",
		"trakpak3/tracksounds/clanc_7.wav",
		"trakpak3/tracksounds/clanc_8.wav",
	},
	level = 75,
	volume = 1,
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
--Auto Coupler Sounds
sound.Add({
	name = "Trakpak3.autocoupler.couple",
	sound = "trakpak3/couplers/couple.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 80,
	pitch = 100
})
sound.Add({
	name = "Trakpak3.autocoupler.uncouple",
	sound = "trakpak3/couplers/uncouple.wav",
	channel = CHAN_AUTO,
	volume = 1,
	level = 80,
	pitch = 100
})


--Ranger Class Blacklisting: Use this function to add NPC classes you don't want to trigger block detection, auto switches, or frogs! Does not respect wildcards.
function Trakpak3.BlacklistClass(class)
	if not Trakpak3.Blacklist then Trakpak3.Blacklist = {} end
	Trakpak3.Blacklist[class] = true
	
end

function Trakpak3.IsBlacklisted(ent) --Check if a specific entity would be blacklisted.
	if not ent:IsValid() then return true end
	if ent:IsPlayer() then return true end --Automatically fail all players
	local class = ent:GetClass()
	if not Trakpak3.Blacklist then return false end
	
	if Trakpak3.Blacklist[class] then return true end --The class is in the blacklist
	
	if string.StartsWith(class,"npc_") then return true end --The class is an NPC (Hardcoded)
	
	--Leave this for future use, in case multiple wildcards are needed?:
	
	--[[
	if not Trakpak3.Blacklist then return false end
	for c, v in pairs(Trakpak3.Blacklist) do
		if string.EndsWith(c,"*") then --Has a trailing wildcard
			if string.Left(class, #c - 1)==string.Left(c, #c - 1) then --It matches the wildcard
				return true
			end
		elseif class==c then
			return true
		end
	end
	]]--
	
	return false --No criteria were met, return OK
	
end

--Convenience function for trace filters.
function Trakpak3.TraceFilter(ent)
	return not Trakpak3.IsBlacklisted(ent)
end

--Blacklist all NPCs and combine balls
--Trakpak3.BlacklistClass("npc_*") --includes thrown grenades. This is hardcoded into the IsBlacklisted function
Trakpak3.BlacklistClass("prop_combine_ball")

--Blacklist all Trakpak3 entities that could possibly cause a problem with signals
Trakpak3.BlacklistClass("tp3_switch")
Trakpak3.BlacklistClass("tp3_diamond")
Trakpak3.BlacklistClass("tp3_switch_lever_anim")
Trakpak3.BlacklistClass("tp3_signal_master")
Trakpak3.BlacklistClass("tp3_signal_slave")
Trakpak3.BlacklistClass("tp3_moveable_bridge")
Trakpak3.BlacklistClass("tp3_turntable")
Trakpak3.BlacklistClass("tp3_transfertable")
Trakpak3.BlacklistClass("tp3_crossing_gate")
Trakpak3.BlacklistClass("tp3_sign_prop")
Trakpak3.BlacklistClass("tp3_sign_auto")
Trakpak3.BlacklistClass("tp3_rotary_dumper")

Trakpak3.BlacklistClass("prop_dynamic") --Primarily for use with moveable bridges.

Trakpak3.BlacklistClass("gmod_wire_hologram") --Because apparently these can be solid sometimes. Lmao source go home you're drunk

--Bodygroup Retrieval
--Get the bodygroups as a simple list
function Trakpak3.GetBodygroups(ent)
	local bglist = {}
	
	for n = 2, #ent:GetBodyGroups() do --The table starts at 1 but includes the reference mesh (0)
		bglist[n-1] = ent:GetBodygroup(n-1)
	end
	
	return bglist
end