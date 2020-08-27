AddCSLuaFile()

DEFINE_BASECLASS( "base_wire_entity" )
--DEFINE_BASECLASS( "base_gmodentity" )
ENT.PrintName = "Trakpak3 Cab Signal Box"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Receiver for Cab Signal and ATS indications"
ENT.Instructions = "Spawn with the tool and use wiremod"
ENT.RenderGroup = RENDERGROUP_BOTH
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
local function GetRoot(ent) --Finds the root (master parent) entity in a chain
	while IsValid(ent:GetParent()) do
		ent = ent:GetParent()
	end
	return ent
end
if CLIENT then
	function ENT:Draw()
		self:DoNormalDraw(true,false)
		if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then
			self:DrawEntityOutline()
			
		end
		Wire_Render(self)
	end
end
function ENT:SetupSpeedInfo(s,r,u) --Sanity check the speed values, assign default otherwise
	local s_good = s and (tonumber(s)>=0)
	local r_good = r and (tonumber(r)>=0)
	local u_good = (u=="mph") or (u=="kph") or (u=="ins")
	
	if s_good and r_good and u_good then
		self.spadspeed = tonumber(s)
		self.restrictingspeed = tonumber(r)
		self.units = u
	else
		self.spadspeed = 5
		self.restrictingspeed = 15
		self.units = "mph"
	end
	self:SetOverlayText("SPAD Trip: "..self.spadspeed.." "..self.units.."\nRestricting Trip: "..self.restrictingspeed.." "..self.units)
end
local aspectnames = {
	[0] = "Off",
	[1] = "Stop",
	[2] = "Restricting",
	[3] = "Approach",
	[4] = "Advance Approach",
	[5] = "Clear"
}
local speedmul = {mph = 17.6, kph = 10.93, ins = 1.0}
function ENT:Initialize()
	
	if SERVER then
		--Index Counter (abandoned)
		--local count = self.Owner:GetNWInt("tp3_cabsignal_box_count")
		--self.Owner:SetNWInt("tp3_cabsignal_box_count", count+1)
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		
		--Wire Input Creation
		local names = {"Enable","Reset"}
		local types = {"NORMAL","NORMAL"}
		local descs = {"Required",""}
		WireLib.CreateSpecialInputs(self, names, types, descs)
		
		--Wire Output Creation
		local names = {"NextSignal","NextSignalAspectNum","NextSignalAspectName","EmBrake","Distance"}
		local types = {"ENTITY","NORMAL","STRING","NORMAL","NORMAL"}
		local descs = {}
		WireLib.CreateSpecialOutputs(self, names, types, descs)
		WireLib.TriggerOutput(self,"NextSignalAspectName","Off")
		
		--Variable Init
		self.nextsignal = NULL
		self.enabled = false
		
		--Hook into signaling system to update next signal aspect
		hook.Add("TP3_BlockUpdate","tp3_cabsignal_box_"..self:EntIndex(),function(target, data)
			if self.enabled then self:UpdateSignalState(target, data) end
		end)
	end

end
--Wire Input Handler
function ENT:TriggerInput(iname, value)
	if iname=="Enable" then
		if value>0 then
			self.enabled = true
		else
			self.enabled = false
		end
		print("Enabled: ",self.enabled)
	elseif iname=="Reset" then
		if value>0 then
			self.nextsignal = nil
			self.nextsignalent = nil
			WireLib.TriggerOutput(self,"NextSignal",NULL)
			WireLib.TriggerOutput(self,"NextSignalAspectNum",0)
			WireLib.TriggerOutput(self,"NextSignalAspectName","Off")
			WireLib.TriggerOutput(self,"EmBrake",0)
			WireLib.TriggerOutput(self,"Distance",0)
		end
	end
end

--What to do when this box passes through a cab signal trigger in the proper direction
function ENT:PassSignal(home_signal, next_signal)
	print("Passed Signal!")
	--Get the signal entity we just passed
	local homesig, homevalid = FindByTargetname(home_signal)
	if not homevalid then return end 
	
	--Check if it's a valid signal (JIC)
	if tp3_allowedsignalclasses then
		if not tp3_allowedsignalclasses[homesig.ClassName] then return end
	else
		return
	end
	
	--Get Home Aspect
	local home_aspect = homesig.signalstate
	--Test SPAD
	if home_aspect==1 then
		local root = GetRoot(self)
		local speed = root:GetVelocity():Length()
		
		if speed > self.spadspeed*speedmul[self.units] then
			WireLib.TriggerOutput(self,"EmBrake",1) --Dump the air!
			timer.Simple(1,function()
				WireLib.TriggerOutput(self,"EmBrake",0) --Reset after 1 second
			end)
		end
		
	elseif home_aspect==2 then --Test SPAR
		local root = GetRoot(self)
		local speed = root:GetVelocity():Length()
		
		if speed > self.restrictingspeed*speedmul[self.units] then
			WireLib.TriggerOutput(self,"EmBrake",1) --Dump the air!
			timer.Simple(1,function()
				WireLib.TriggerOutput(self,"EmBrake",0) --Reset after 1 second
			end)
		end
	end
	
	--Get Next signal
	local nextsig, nextvalid = FindByTargetname(next_signal)
	print(next_signal,nextsig,nextvalid)
	if nextvalid and tp3_allowedsignalclasses[nextsig.ClassName] then
		self.nextsignal = next_signal
		self.nextsignalent = nextsig
		local next_aspect = nextsig.signalstate
		WireLib.TriggerOutput(self,"NextSignal",nextsig)
		WireLib.TriggerOutput(self,"NextSignalAspectNum",next_aspect)
		WireLib.TriggerOutput(self,"NextSignalAspectName",aspectnames[next_aspect])
	else
		self.nextsignal = nil
		self.nextsignalent = nil
		WireLib.TriggerOutput(self,"NextSignal",NULL)
		WireLib.TriggerOutput(self,"NextSignalAspectNum",0)
		WireLib.TriggerOutput(self,"NextSignalAspectName","Off")
		WireLib.TriggerOutput(self,"Distance",0)
	end
end

--Update next signal state
function ENT:UpdateSignalState(target_ent, target_data)
	--Is this my signal?
	if target_ent==self.nextsignal then
		--Is this a signal aspect (as opposed to a block update)?
		if (target_data==true) or (target_data==false) then return end
		
		WireLib.TriggerOutput(self,"NextSignalAspectNum",target_data)
		WireLib.TriggerOutput(self,"NextSignalAspectName",aspectnames[target_data])
		
	end
end

function ENT:Think()
	--Calculate the rough distance between the box and the next signal (straight line)
	if self.nextsignal and self.nextsignalent and IsValid(self.nextsignalent) then
		local Dist = (self:GetPos() - self.nextsignalent:GetPos()):Length()
		WireLib.TriggerOutput(self,"Distance",math.Round(Dist))
	end
end
--[[
function ENT:OnDuplicated(data)
	self.spadspeed = data.spadspeed or 5
	self.restrictingspeed = data.restrictingspeed or 15
	self.units = data.units or "mph"
	
	self:SetOverlayText("SPAD Trip: "..self.spadspeed.." "..self.units.."\nRestricting Trip: "..self.restrictingspeed.." "..self.units)
end
]]--

cleanup.Register("Cab Signal Boxes")

--Shamelessly stolen from wiremod
duplicator.RegisterEntityClass("tp3_cabsignal_box",function(ply, Data)
	local ent = duplicator.GenericDuplicatorFunction(ply, Data)
	
	if not IsValid(ent) then return false end

	ent.spadspeed = Data.spadspeed or 5
	ent.restrictingspeed = Data.restrictingspeed or 15
	ent.units = Data.units or "mph"
	ent:SetPlayer(ply)
	--hook.Run("PlayerSpawnedSENT",ply,ent)
	ent:SetOverlayText("SPAD Trip: "..ent.spadspeed.." "..ent.units.."\nRestricting Trip: "..ent.restrictingspeed.." "..ent.units)
	
	undo.Create("tp3_cabsignal_box (dupe)")
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone Cab Signal Box (Press Again to Undo Dupe)")
	undo.Finish()
	cleanup.Add(ply,"Cab Signal Boxes",ent)
	
	ply:AddCount("tp3_cabsignal_boxes",ent)
end, "Data")

--Abandoned spawn limit shit
--[[
function ENT:OnRemove()
	if SERVER then
		local count = self.Owner:GetNWInt("tp3_cabsignal_box_count")
		if count > 0 then self.Owner:SetNWInt("tp3_cabsignal_box_count", count-1) end
	end
end

function ENT:OnDuplicated()
	--Index Counter
	local count = self.Owner:GetNWInt("tp3_cabsignal_box_count")
	self.Owner:SetNWInt("tp3_cabsignal_box_count", count+1)
end
]]--