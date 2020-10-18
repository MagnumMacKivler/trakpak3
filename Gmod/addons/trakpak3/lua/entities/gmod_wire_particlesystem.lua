AddCSLuaFile()

DEFINE_BASECLASS("base_wire_entity")

ENT.PrintName = "Wire Particle System"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Emit Particles"
ENT.WireDebugName = "Particle System"

if SERVER then
	function ENT:Setup(effect)
		self.effectname = effect or ""
		self:SetNWString("effectname",self.effectname)
		self:SetOverlayText(self.effectname)
	end
end

--Shamelessly stolen and then modified from wire buttons to act as a parenting checker
if CLIENT then
	local halo_ent, halo_color

	function ENT:Draw()
		self:DoNormalDraw(true,false)
		if LocalPlayer():GetEyeTrace().Entity == self and EyePos():Distance( self:GetPos() ) < 512 then
			--Set Parented Indicator
			if self:GetParent():IsValid() then
				halo_ent = self
				halo_color = Color(0,255,0)
			else
				halo_ent = self
				halo_color = Color(255,0,0)
			end
		end
		Wire_Render(self)
	end

	hook.Add("PreDrawHalos", "Wiremod_particlesystem_overlay_halos", function()
		if halo_ent then
			halo.Add({halo_ent}, halo_color, 6, 6, 2, true, true)
			halo_ent = nil
		end
	end)
	
	hook.Add("PostDrawHUD", "Wiremod_particlesystem_axes",function()
		local tr = LocalPlayer():GetEyeTrace()
		if tr.Hit and tr.Entity:GetClass()=="gmod_wire_particlesystem" and EyePos():Distance( tr.Entity:GetPos() ) < 512 then
			--check for tr.Entity in the above line!
			cam.Start3D()
			
			local radius = 2*tr.Entity:BoundingRadius()
			local lorigin = tr.Entity:GetPos()
			local lx = tr.Entity:GetForward()
			local ly = -tr.Entity:GetRight()
			local lz = tr.Entity:GetUp()
			
			render.DrawLine(lorigin, lorigin + radius*lx, Color(255,0,0))
			render.DrawLine(lorigin, lorigin + radius*ly, Color(0,255,0))
			render.DrawLine(lorigin, lorigin + radius*lz, Color(0,0,255))
			
			cam.End3D()
		end
	end)
	
end

function ENT:Initialize()
	
	if SERVER then
		
		--Physics
		--self:SetModel("models/hunter/plates/plate025x025.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		
		--Init Variables
		self.play = false
		self:SetNWFloat("autorepeat",0)
		
		--Make Wire inputs
		if WireLib then
			local names = {"A", "Effect", "RepeatInterval"}
			local types = {"NORMAL", "STRING", "NORMAL"}
			local descs = {}
			self.Inputs = WireLib.CreateSpecialInputs(self, names, types, descs)
		end
		
	end
	if CLIENT then
		
		self.playing = false
		self.effectname = ""
		
	end
	
end



--Wire Input Handler
function ENT:TriggerInput(iname, value)
	if CLIENT or not WireAddon then return end
	if iname=="A" then
		self:SetNWBool("play",value>0)
	elseif iname=="Effect" then
		local ename = self.effectname
		if value~="" then ename = value end
		self:SetNWString("effectname",ename)
		self:SetOverlayText(ename)
	elseif iname=="RepeatInterval" then
		local auto = 0
		if value>0 then auto = value end
		self:SetNWFloat("autorepeat",auto)
	end
end

--Helper function for starting a new effect
function ENT:HandleNewEffect(ename)
	if SERVER then return end
	if ename and ename ~= "" then
		self.playing = true
		self.effectname = ename
		if self.psus then self.psus:StopEmission() end
		PrecacheParticleSystem(ename)
		--self.psus = CreateParticleSystem(self, ename, PATTACH_ABSORIGIN_FOLLOW)
		local cpoint1 = { ["attachtype"] = PATTACH_ABSORIGIN_FOLLOW, ["entity"] = self, ["position"] = Vector(0,0,0) }
		local controlpoints = { [1] = cpoint1 }
		self.psus = self:CreateParticleEffect(ename,0,controlpoints)
		self.psus:StartEmission()
		self.timestamp = CurTime()
		--self:EmitSound("buttons/blip1.wav")
	else
		if self.psus then self.psus:StopEmission() end
		self.playing = false
	end
end

function ENT:Think()
	if CLIENT then
		
		local play = self:GetNWBool("play") or false
		
		if play then --General playing
		
			local effect = self:GetNWString("effectname") or ""
			--print(effect)
			if not self.playing then --Startup
				
				self:HandleNewEffect(effect)
				
			else --currently playing
				
				--Auto Restart
				local interval = self:GetNWFloat("autorepeat") or 0
				if (interval > 0) and self.psus and (CurTime() >= (self.timestamp+interval)) then
					self:HandleNewEffect(self.effectname)
				end
				
				--Effect Change
				if effect ~= self.effectname then
				
					self:HandleNewEffect(effect)
					
				end
				
			end
			
		elseif not play and self.playing then --Manual shutoff
			
			self:HandleNewEffect(nil)
			
		end
		
		self:SetNextClientThink(CurTime()) --Execute super fast to keep up with CurTime
		return true
	end
end

--Kill the particles on remove
function ENT:OnRemove()
	if SERVER then return end
	if self.psus then self.psus:StopEmission(false,true) end
end

duplicator.RegisterEntityClass("gmod_wire_particlesystem", WireLib.MakeWireEnt, "Data", "effectname")