
--Trakpak3 E2 Functions
E2Lib.RegisterExtension("trakpak3", false, "E2 function library for interfacing with Trakpak3 tools, entities, and systems.")
--[[

Some notes about E2 and Prop Protection...

E2Lib is defined in lua/entities/gmod_wire_expression2/core/e2lib.lua

E2Lib.isOwner takes two parameters, "self" and the entity in question. The "Self" appears to be supplied by the e2function line and contains a bunch of internal data about the E2 (though not necessarily the entity table).

]]--


local validPhysics = E2Lib.validPhysics
local getOwner     = E2Lib.getOwner
local isOwner      = E2Lib.isOwner

--Auto Coupler Functions

__e2setcost(10)

--QuickSetup a car. Returns the number of couplers created
e2function number entity:quickSetupAutoCouplers(number tolerance, number slack, number ropewidth)
	if not (validPhysics(this) and isOwner(self, this)) then return 0 end
	
	local cf, cr = Trakpak3.AutoCoupler.QuickSetup(this, tolerance, slack, ropewidth)
	if cf and cr then return 2 elseif cf or cr then return 1 else return 0 end
end

__e2setcost(5)

--Remove the AutoCouplers from a car. Return 1 on success.
e2function number entity:clearAutoCouplers()
	if not (validPhysics(this) and isOwner(self, this)) then return 0 end
	
	local deleted = Trakpak3.AutoCoupler.ClearCar(this)
	
	if deleted then return 1 else return 0 end
	
end

__e2setcost(1)

--Check whether or not an entity has autocouplers
e2function number entity:hasAutoCouplers()
	if not validPhysics(this) then return 0 end
	
	if this.TP3AC then return 1 else return 0 end
	
end

--Return whether the car is coupled in the specified direction. If direction is 0, return the number of couplings.
e2function number entity:isAutoCoupled(number direction)
	if not validPhysics(this) then return 0 end
	
	if not this.TP3AC then return 0 end
	
	if direction > 0 then 
		if not this.TP3AC[1] then return 0 end
		if this.TP3AC[1].coupled then return 1 else return 0 end
	elseif direction < 0 then
		if not this.TP3AC[-1] then return 0 end
		if this.TP3AC[-1].coupled then return 1 else return 0 end
	else -- ==0
		local c = 0
		if this.TP3AC[1] and this.TP3AC[1].coupled then c = c + 1 end
		if this.TP3AC[-1] and this.TP3AC[-1].coupled then c = c + 1 end
		
		return c
	end
	
end

__e2setcost(5)