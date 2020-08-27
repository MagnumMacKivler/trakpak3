AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Switch Controller"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Control Switches via Hammer I/O"
ENT.Instructions = "Place in Hammer"

ENT.BroadcastChanges = false --This will be set in the individual entities by the signals that need it

local function FindByTargetname(name)
	if name and name!="" then
		local result = ents.FindByName(name)[1]
		if IsValid(result) then
			return result, true
		else
			return nil, false
		end
	else
		return nil, false
	end
end
local function fif(condition, result_true, result_false)
	if condition then
		return result_true
	else
		return result_false
	end
end
local function btn(boolean)
	if boolean then
		return 1
	else
		return 0
	end
end
function ENT:EnableBroadcast() --Enable switch update broadcasting
	self.BroadcastChanges = true
	if self.switchstate!=nil then hook.Run("TP3_SwitchUpdate",self:GetName(),self.switchstate) end
end
function ENT:Initialize() --This is called when Source spawns the entity in
	if CLIENT then return end
	
	--Initialize Variables
	
	self.switchstate = self.startopen=="1" --boolean initial state
	self.prop_mn = FindByTargetname(self.prop_mn) --Single Entitites
	self.prop_dv = FindByTargetname(self.prop_dv)
	self.levers = ents.FindByName(self.lever) or {} --Note, These returns a table of multiple entities
	self.opensound = self.opensound or "" --String sound paths
	self.closesound = self.closesound or ""
	if (self.closesound=="") then self.closesound = self.opensound end
	self.autothrow = (self.autothrow=="1")
	
	if self.autothrow then
		if IsValid(self.prop_mn) then
			local att = self.prop_mn:LookupAttachment("autopoint_1")
			if att then self.point_mn = self.prop_mn:GetAttachment(att)["Pos"] end --Attachment info returns serverside, amazingly
		end
		if IsValid(self.prop_dv) then
			local att = self.prop_dv:LookupAttachment("autopoint_1")
			if att then self.point_dv = self.prop_dv:GetAttachment(att)["Pos"] end
		end
		if not (self.point_mn and self.point_dv) then self.autothrow = false end
	end
	
	--Custom Functions
	
	local function LeverSound(props, soundpath) --Play a sound on the lever
		--print(soundpath)
		soundpath = soundpath or ""
		for k, v in pairs(props) do
			if v:IsValid() and soundpath!="" then
				v:EmitSound(string.Trim(soundpath))
			end
		end
	end
	local function LeverAnimate(props, anim) --Does nothing for now
		
	end
	
	local function LeverBodygroup(props, groupnumber, partnumber) --Set Lever Bodygroups
		for k, v in pairs(props) do
			if v:IsValid() then
				v:SetBodygroup(groupnumber, partnumber)
			end
		end
	end
	
	local function TrackSolidity(prop, solid) --Set Solidity of Track Pieces
		
		if prop:IsValid() then
			prop:Fire(fif(solid, "EnableCollision", "DisableCollision"))
			prop:Fire(fif(solid, "TurnOn", "TurnOff"))
		end

	end
	
	self.SwitchSilent = function() --Change Switch State (no sound)
		--Handle Track Solidity/Vis Changes
		TrackSolidity(self.prop_mn, not self.switchstate)
		TrackSolidity(self.prop_dv, self.switchstate)
		
		--Make Lever do shit
		LeverBodygroup(self.levers, 1, btn(self.switchstate))
		--LeverAnimate(...)
		
		--Fire Hammer Outputs
		if self.switchstate then
			self:TriggerOutput("OnThrownDiverging",self)
		else
			self:TriggerOutput("OnThrownMain",self)
		end
		
		--Broadcast update if applicable
		if self.BroadcastChanges then hook.Run("TP3_SwitchUpdate",self:GetName(),self.switchstate) end
	end
	self.Switch = function()
		self.SwitchSilent()
		LeverSound(self.levers, fif(self.switchstate, self.opensound, self.closesound))
	end
	
	self.SwitchSilent()
	
end

function ENT:Think()
	if self.autothrow then
		if self.switchstate then --Scan MN
			local tr = {start = self.point_mn, endpos = self.point_mn + Vector(0,0,64), ignoreworld = true, filter = player.GetAll()}
			local trace = util.TraceLine(tr)
			if trace.hit then --Throw MN
				self.switchstate = false
				self.SwitchSilent()
			end
		else --Scan DV
			local tr = {start = self.point_dv, endpos = self.point_dv + Vector(0,0,64), ignoreworld = true, filter = player.GetAll()}
			local trace = util.TraceLine(tr)
			if trace.hit then --Throw DV
				self.switchstate = true
				self.SwitchSilent()
			end
		end
		self:NextThink(CurTime()+0.25) --Delay for 1/4 second before scanning again
	end
end

function ENT:AcceptInput( inputname, activator, caller, data )
	if inputname=="ThrowToggle" then
		self.switchstate = !self.switchstate --toggle state
		self.Switch()
	elseif inputname=="ThrowMain" then
		if self.switchstate then
			self.switchstate = false
			self.Switch()
		end
	elseif inputname=="ThrowDiverging" then
		if not self.switchstate then
			self.switchstate = true
			self.Switch()
		end
	end
end