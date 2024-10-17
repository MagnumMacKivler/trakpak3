
Trakpak3.AutoCoupler = {}
local AutoCoupler = Trakpak3.AutoCoupler
AutoCoupler.LocalAxes = {
	[1] = Vector(1,0,0),
	[2] = Vector(0,1,0),
	[3] = Vector(0,0,1),
	--[-1] = Vector(-1,0,0),
	--[-2] = Vector(0,-1,0),
	--[-3] = Vector(0,0,-1),
}

local CurTime = CurTime
local SysTime = SysTime
local abs = math.abs
local max = math.max

--Find the largest axis (1 2 3 / X Y Z / Do Re Mi baby you and me girl) and the dimensions in either direction.
function AutoCoupler.GetLongestAxis(ent)
	if not (ent and ent:IsValid()) then return end
	local maxs = ent:OBBMaxs()
	local mins = ent:OBBMins()
	local box = maxs - mins
	local bigsize = 0
	local bigaxis
	for n = 1, 3 do
		if box[n] > bigsize then
			bigsize = box[n]
			bigaxis = n
		end
	end
	
	return bigaxis, maxs[bigaxis], math.abs(mins[bigaxis])
end

if SERVER then
	
	AutoCoupler.AllCouplers = {} --table of coupler objects to be slow checked
	AutoCoupler.LastIndex = 0
	
	AutoCoupler.FastChecks = {} --table of coupler pairs to be fast checked

	AutoCoupler.DecoupleChecks = {} --table of coupler pairs to check decoupling distance
	AutoCoupler.DecoupleDistance = 128 --Distance to consider two cars decoupled
	
	AutoCoupler.Assemblies = {}
	
	AutoCoupler.CPUTimeAvg = 0
	AutoCoupler.CPUTimeInst = 0
	
	--Benchmarking
	local printperf = function()
		--print("Auto Coupler Stats:\n",table.Count(AutoCoupler.AllCouplers).." couplers total, "..#AutoCoupler.FastChecks.." fast check pairs, "..math.Round(AutoCoupler.CPUTimeInst).."/"..math.Round(AutoCoupler.CPUTimeAvg).." microseconds CPU time (instantaneous/avg).")
	end
	
	concommand.Add("tp3_autocoupler_perf", printperf, nil, "Display the current performance stats of the Trakpak3 Autocoupler system.")
	concommand.Add("tp3_autocoupler_printall",function() for n = 1, AutoCoupler.LastIndex do print(n, AutoCoupler.AllCouplers[n]) end end)
	
	--Create a new autocoupler object
	function AutoCoupler.NewCoupler(car, axis, sign, truck, edge, tolerance, slack, ropewidth)
		if not (car and car:IsValid() and truck and truck:IsValid() and axis ) then return end
		tolerance = math.Clamp(tolerance or 48, 0, 96)
		slack = math.Clamp(slack or 6, 0, 16)
		ropewidth = math.Clamp(ropewidth or 2,0,8)
		
		--Get a unique index
		local index
		--print("NEW COUPLER")
		for n = 1, AutoCoupler.LastIndex do --Check and see if an earlier slot is open
			if not AutoCoupler.AllCouplers[n] then --Index is free
				index = n
				--print("FOUND EMPTY SLOT AT: "..n)
				break
			end
		end
		
		if not index then --couldn't find an empty slot, make a new one
			index = AutoCoupler.LastIndex + 1
			AutoCoupler.LastIndex = index
		end
		
		--print("ASSIGNING INDEX "..index)
		
		
		
		local coupler = {
			index = index,
			car = car,
			truck = truck,
			axis = axis,
			sign = sign,
			edge = edge,
			tolerance = tolerance,
			slack = slack,
			ropewidth = ropewidth,
			coupled = false,
			decoupling = false,
		}
		
		--Add to the global table
		AutoCoupler.AllCouplers[index] = coupler
		
		--Object Methods
		
		--Validity Check
		function coupler:IsValid()
			return self.car and self.truck and self.car:IsValid() and self.truck:IsValid()
		end
		
		--Retrieve validated entities
		function coupler:GetCar()
			if self:IsValid() then return self.car end
		end
		function coupler:GetTruck()
			if self:IsValid() then return self.truck end
		end
		function coupler:GetCoupled()
			if self:IsValid() then return self.coupled end
		end
		
		--Get World Directional Axis
		function coupler:GetDir()
			if not self:IsValid() then return end
			local v
			if self.axis==1 then
				v = self.car:GetForward()
			elseif self.axis==2 then
				v = -self.car:GetRight()
			elseif self.axis==3 then
				v = self.car:GetUp()
			end
			
			if v then return v*self.sign end
		end
		
		--Get the coupler speed in the relevant direction
		function coupler:GetSpeed(dir)
			if not self:IsValid() then return end
			if not dir then dir = self:GetDir() end
			
			return self.car:GetVelocity():Dot(dir)
		end
		
		--Get the world space edge position
		function coupler:GetEdgePos(dir)
			if not self:IsValid() then return end
			if not dir then dir = self:GetDir() end
			
			return self.car:GetPos() + dir*self.edge
		end
		
		--Can this coupler receive a connection?
		function coupler:CanCouple(requestor)
			if not self:IsValid() then return false end
			if self.coupled or self.decoupling then return false end
			--Prop protection check
			if requestor and self.car.CPPICanTool then
				if requestor:IsValid() and requestor:IsPlayer() then
					if (not self.car:CPPICanTool(requestor, "rope")) then return false end
				else --Requestor is invalid or not a player
					return false
				end
			end
			return true
		end
		
		--Make connection
		function coupler:Connect(coupler2)
			if not ( self:IsValid() and coupler2 and coupler2:IsValid() ) then return false end
			
			if not ( self:CanCouple() and coupler2:CanCouple() ) then return false end
			
			local slack = (self.slack + coupler2.slack) / 2
			local phys1 = self.truck:GetPhysicsObject()
			local phys2 = coupler2.truck:GetPhysicsObject()
			
			local ropewidth = max(self.ropewidth, coupler2.ropewidth)
			if not ( phys1 and phys2 and phys1:IsValid() and phys2:IsValid() ) then return false end
			
			
			--Make ropes
			local rope
			if slack > 0 then --Slack-style coupling
				local midpoint = ( self.truck:LocalToWorld(phys1:GetMassCenter()) + coupler2.truck:LocalToWorld(phys2:GetMassCenter()) )/2
				rope = constraint.Rope(self.truck, coupler2.truck, 0, 0, self.truck:WorldToLocal(midpoint), coupler2.truck:WorldToLocal(midpoint), slack, 0, 0, ropewidth, "")
			else --Traditional drawbar
				local mc1 = self.truck:LocalToWorld(phys1:GetMassCenter())
				local mc2 = coupler2.truck:LocalToWorld(phys2:GetMassCenter())
				local p1 = mc1 + 0.25*(mc2 - mc1)
				local p2 = mc2 + 0.25*(mc1 - mc2)
				local length = (p2-p1):Length()
				rope = constraint.Rope(self.truck, coupler2.truck, 0, 0, self.truck:WorldToLocal(p1), coupler2.truck:WorldToLocal(p2), length, 0, 0, ropewidth, "", true)
			end
			
			if rope then --success!
				self.coupled = coupler2
				coupler2.coupled = self
				self.truck:EmitSound("Trakpak3.autocoupler.couple") --Coupler Sound
				
				--Set Network Vars for RLC Delta Slack Sounds. Only set on one entity to avoid duplicating sounds
				self.truck:SetNWEntity("tp3ac_coupledent", coupler2.truck)
				self.truck:SetNWFloat("tp3ac_distance",(self.truck:GetPos() - coupler2.truck:GetPos()):Length())
				self.truck:SetNWFloat("tp3ac_slack", slack)
				
				--These can be retrieved on the client as follows:
				--local coupledent = entity:GetNWEntity("tp3ac_coupledent") --Entity that is autocoupled, or NULL entity if not
				--local distance = entity:GetNWFloat("tp3ac_distance") --Linear distance between entity coordinate centers at the moment the coupling was made, or 0 if not coupled.
				--local slack = entity:GetNWFloat("tp3ac_slack") --Amount of slack in the coupling. Default is 6. Will be 0 if not coupled or if the coupling is a solid drawbar.
				
				return true
			end
			return false
		end
		
		--Disconnect
		function coupler:Disconnect()
			if self:IsValid() then
				if self.coupled then --Is theoretically coupled to something
					local playsound
					if self.coupled:IsValid() then --both are valid
						--Add to DecouplingChecker
						self.coupled.decoupling = true
						self.decoupling = true
						table.insert(AutoCoupler.DecoupleChecks, {self, self.coupled})
						playsound = true
						
						--Clear Network Vars for RLC Delta Slack Sounds.
						self.coupled.truck:SetNWEntity("tp3ac_coupledent", NULL)
						self.coupled.truck:SetNWFloat("tp3ac_distance", 0)
						self.coupled.truck:SetNWFloat("tp3ac_slack", 0)
					end 
					--Try to break ropes
					local ropesremoved = constraint.RemoveConstraints(self.truck, "Rope")
					if ropesremoved or playsound then
						self.truck:EmitSound("Trakpak3.autocoupler.uncouple") --Decoupling Sound
					end

					--The couplers now no longer know each other
					self.coupled.coupled = false
					self.coupled = false
				else --Not coupled to anything
					--Try to break ropes anyway
					local ropesremoved = constraint.RemoveConstraints(self.truck, "Rope")
					if ropesremoved then
						self.truck:EmitSound("Trakpak3.autocoupler.uncouple") --Decoupling Sound
					end
				end
				
				--Clear Network Vars for RLC Delta Slack Sounds.
				self.truck:SetNWEntity("tp3ac_coupledent", NULL)
				self.truck:SetNWFloat("tp3ac_distance", 0)
				self.truck:SetNWFloat("tp3ac_slack", 0)
				
			else --You're invalid
				if self.coupled then self.coupled.coupled = false end
				self.coupled = false
			end
		end
		
		--Find/Monitor the roped entity to determine coupling status
		function coupler:CheckCoupled()
			if not self:IsValid() then return end
			local con = constraint.FindConstraint(self.truck, "Rope")
			local other
			if con then --There is a table at least
				local e1, e2 = con.Ent1, con.Ent2
				if e1==self.truck then other = e2 elseif e2==self.truck then other = e1 end
				if not other:IsValid() then other = nil end
			end
			
			if other and other.TP3C then -- Roped entity has a TP3 coupler associated with it
				self.coupled = other.TP3C
				other.TP3C.coupled = self
			elseif not other and self.coupled then --Entity was roped, but now isn't
				self:Disconnect()
			end
		end
		
		--Delete the coupler
		function coupler:Delete()
			
			--print("DELETING "..self.index)
			if self.truck and self.truck:IsValid() then
				self.truck.TP3C = nil
				duplicator.ClearEntityModifier(self.truck, "Trakpak3_AutoCoupler_Truck")
			end
			
			if self.car and self.car:IsValid() then
				if self.car.TP3AC then
					self.car.TP3AC[self.sign] = nil 
					self.car.TP3AC_Dupe[self.sign] = nil
					if self.sign==1 then
						self.car:SetNWFloat("TP3AC_edge_f", 0)
					elseif self.sign==-1 then
						self.car:SetNWFloat("TP3AC_edge_r", 0)
					end
				end
				
				if car.TP3AC_Dupe and car.TP3AC_Dupe[-self.sign] then --Data still exists for the other coupler on this car
					duplicator.StoreEntityModifier(self.car,"Trakpak3_AutoCoupler",self.car.TP3AC_Dupe)
				else --That's the last one
					self.car.TP3AC = nil
					self.car.TP3AC_Dupe = nil
					duplicator.ClearEntityModifier(self.car,"Trakpak3_AutoCoupler")
					car:SetNWInt("TP3AC_axis",0)
				end
			end
			
			AutoCoupler.AllCouplers[self.index] = nil
		end
		
		--Bolster Edge Calculation
		local disp = (truck:GetPos() - car:GetPos())*Vector(1,1,0)
		coupler.bolster = disp:Dot(coupler:GetDir())
		
		--Car/truck Data
		if not car.TP3AC then car.TP3AC = {} end
		car.TP3AC[sign] = coupler
		truck.TP3C = coupler
		
		car:SetNWInt("TP3AC_axis",axis)
		if sign==1 then
			car:SetNWFloat("TP3AC_edge_f", edge)
		elseif sign==-1 then
			car:SetNWFloat("TP3AC_edge_r", edge)
		end
		
		--Duplicator Compatibility
		if not car.TP3AC_Dupe then car.TP3AC_Dupe = {} end --Note: this is in the main level, the coupler data is in a sublevel below:
		car.TP3AC_Dupe.oldcarid = car:EntIndex()
		car.TP3AC_Dupe[sign] = {truckid = truck:EntIndex(), axis = axis, tolerance = tolerance, edge = edge, slack = slack, ropewidth = ropewidth}
		duplicator.StoreEntityModifier(car,"Trakpak3_AutoCoupler",car.TP3AC_Dupe)
		
		duplicator.StoreEntityModifier(truck,"Trakpak3_AutoCoupler_Truck", {oldcarid = car:EntIndex(), index = sign}) --TruckData
		
		--Find any models/couplers that may be coupled at time of creation
		coupler:CheckCoupled()
		
		
		
		return coupler
	end
	
	--Return a table of all props axised to only one other prop
	function AutoCoupler.FindTrucks(ent, originalent, entlog, rtable)
		if not entlog then entlog = {} end 
		if not rtable then rtable = {} end
		if not originalent then originalent = ent end
		
		if not (ent and ent:IsValid()) then return rtable end
		
		entlog[ent] = true
		
		local contable = constraint.GetTable(ent)
		--PrintTable(contable)
		local count = 0
		for _, con in pairs(contable) do
			if con.Type=="Axis" then
				count = count + 1
				local e1 = con.Ent1
				local e2 = con.Ent2
				--Explore the next entity if it's one that hasn't been explored yet
				if (e1==ent) and not entlog[e2] then
					AutoCoupler.FindTrucks(e2, originalent, entlog, rtable)
				elseif (e2==ent) and not entlog[e1] then
					AutoCoupler.FindTrucks(e1, originalent, entlog, rtable)
				end
			end
		end
		
		if (count==1) and (ent!=originalent) then table.insert(rtable, ent) end
		
		return rtable
	end
	
	--Find the furthest trucks from the center of the carbody; i.e. the ones that would actually get coupled.
	function AutoCoupler.FindFurthestTrucks(car, axis, limit_f, limit_r)
		if not (car and car:IsValid()) then return end
		local trucks = AutoCoupler.FindTrucks(car)
		--print(#trucks.." trucks")
		local dir = AutoCoupler.LocalAxes[math.abs(axis)]
		
		if not (dir and (#trucks > 0) ) then return end
		
		local fartruck_f, fartruck_r
		local maxdot = 0
		local mindot = 0
		

		
		for _, truck in ipairs(trucks) do
			local dot = car:WorldToLocal(truck:GetPos()):Dot(dir)
			--print(dot)
			if (dot > maxdot) and (dot < limit_f) then
				maxdot = dot
				fartruck_f = truck
			elseif (dot < mindot) and (dot > -limit_r) then
				mindot = dot
				fartruck_r = truck
			end
		end
		
		return fartruck_f, fartruck_r, maxdot, math.abs(mindot) --lol fart truck
		
	end
	
	
	--Automatically figure out all necessary info for autocoupler and set it up
	function AutoCoupler.QuickSetup(car, tolerance, slack, ropewidth)
		if not (car and car:IsValid()) then return end
		
		local axis, edge_f, edge_r = AutoCoupler.GetLongestAxis(car)
		--print(axis, edge_f, edge_r)
		if not (axis and edge_f and edge_r) then return end
		local truck_f, truck_r, truckdist_f, truckdist_r = AutoCoupler.FindFurthestTrucks(car, axis, edge_f, edge_r)
		--print(truck_f, truck_r, truckdist_f, truckdist_r)
		
		slack = slack or 6
		tolerance = tolerance or 48
		ropewidth = ropewidth or 2
		
		local cf, cr
		
		--print(truck_f, radius_f, edge_f, slack)
		if truck_f and edge_f and slack then
			cf = AutoCoupler.NewCoupler(car, axis, 1, truck_f, edge_f - slack/2 - 4, tolerance, slack, ropewidth)
		end
		--print(truck_r, radius_r, edge_r, slack)
		if truck_r and edge_r and slack then
			cr = AutoCoupler.NewCoupler(car, axis, -1, truck_r, edge_r - slack/2 - 4, tolerance, slack, ropewidth)
		end
		
		return cf, cr
	end
	
	--Clear a car
	function AutoCoupler.ClearCar(car)
		local deleted = false
		if car.TP3AC or car.TP3AC_Dupe then
			local cf = car.TP3AC[1]
			local cr = car.TP3AC[-1]
			
			if cf then
				cf:Delete()
				deleted = true
			end
			if cr then
				cr:Delete()
				deleted = true
			end
			
			if deleted then return true end --Return whether or not couplers were deleted
		end
	end
	
	--Duplicator support. I don't want to override Entity:PostEntityPaste for prop_physics so this system will have to do instead.
	--Basically, each spawned piece puts info into a global table, and when all the pieces are present, the couplers are regenerated.
	--This system should work based on the fact that duplicator/AD2 prevents you from spawning multiple dupes at once.
	
	local function checkAll(ply, oldcarid)
		local cartable = AutoCoupler.Assemblies[ply][oldcarid]
		--PrintTable(cartable) print("\n")
		local has_f, has_r, hascar
		if cartable[0] then
			hascar = true
		end
		if cartable.needs_f != nil then
			if cartable[1] or (not cartable.needs_f) then has_f = true end
		end
		if cartable.needs_r != nil then
			if cartable[-1] or (not cartable.needs_r) then has_r = true end
		end
		
		if hascar and has_f and has_r then
			local car = Entity(cartable[0])
			if car and car:IsValid() and car.TP3AC_Dupe then
				if car.TP3AC_Dupe[1] then car.TP3AC_Dupe[1].truckid = cartable[1] end
				if car.TP3AC_Dupe[-1] then car.TP3AC_Dupe[-1].truckid = cartable[-1] end
				AutoCoupler.RestoreCar(car)
				AutoCoupler.Assemblies[ply][oldcarid] = nil
			else
				AutoCoupler.Assemblies[ply][oldcarid] = nil
				chat.AddText("The car you have just spawned in is either invalid or has missing autocoupler data. Please remove the autocouplers and try again.")
			end
		end
	end
	
	--Car Dupe Mod
	duplicator.RegisterEntityModifier("Trakpak3_AutoCoupler",function(ply, car, CouplerData)
		car.TP3AC = nil
		car.TP3AC_Dupe = CouplerData
		--PrintTable(CouplerData) print("\n")
		
		--CouplerData Members: oldcarid, 1, -1
		local oldcarid = CouplerData.oldcarid
		
		local ass = AutoCoupler.Assemblies
		
		if not ass[ply] then --First entity for this player
			ass[ply] = {}
		end
		
		local plist = ass[ply]
		
		if not plist[oldcarid] then --First entity for this car
			plist[oldcarid] = {}
		end
		
		local cartable = plist[oldcarid]
		cartable[0] = car:EntIndex()
		
		if CouplerData[1] then cartable.needs_f = true else cartable.needs_f = false end
		if CouplerData[-1] then cartable.needs_r = true else cartable.needs_r = false end
		
		--Check if we have everything
		checkAll(ply, oldcarid)
		
	end)
	
	--Truck Dupe Mod
	duplicator.RegisterEntityModifier("Trakpak3_AutoCoupler_Truck",function(ply, truck, TruckData)
		--TruckData Members: oldcarid, index
		local oldcarid = TruckData.oldcarid
		local index = TruckData.index
		
		truck.TP3C = nil
		
		local ass = AutoCoupler.Assemblies
		
		if not ass[ply] then --First entity for this player
			ass[ply] = {}
		end
		
		local plist = ass[ply]
		
		if not plist[oldcarid] then --First entity for this car
			plist[oldcarid] = {}
		end
		
		local cartable = plist[oldcarid]
		cartable[index] = truck:EntIndex()
		
		--Check if we have everything
		checkAll(ply, oldcarid)
		
	end)
	
	--Generate new couplers from stored data after duplication
	function AutoCoupler.RestoreCar(car)
		if car.TP3AC_Dupe then
			local cf = car.TP3AC_Dupe[1]
			local cr = car.TP3AC_Dupe[-1]
			
			if cf then
				local truck = Entity(cf.truckid)
				AutoCoupler.NewCoupler(car, cf.axis, 1, truck, cf.edge, cf.tolerance, cf.slack)
			end
			if cr then
				local truck = Entity(cr.truckid)
				AutoCoupler.NewCoupler(car, cr.axis, -1, truck, cr.edge, cr.tolerance, cr.slack)
			end
		end
	end
	
	
	
	--Run the Auto Coupler Script
	
	local timestamp
	
	hook.Add("Think","Trakpak3_AutoCoupler",function()
		local starttime = SysTime() --For benchmarking
		if not timestamp then timestamp = CurTime() end
		
		--Run "Slow" checker; pick through all the cars and decide which ones need to be upgraded to fast
		if CurTime() - timestamp > 0.2 then
			timestamp = CurTime()
			
			table.Empty(AutoCoupler.FastChecks) --Clear the table, to be repopulated as required
			
			--Check couplers against other couplers
			for index, coupler in pairs(AutoCoupler.AllCouplers) do
				if coupler:IsValid() then --Coupler and truck are all valid
					coupler:CheckCoupled() --Check and see if rope/coupled state changed
					if coupler:CanCouple() then --Car can physically receive a coupling
						local car, truck = coupler.car, coupler.truck
						local physc, physt = car:GetPhysicsObject(), truck:GetPhysicsObject()
						
						if physc and physt and physc:IsValid() and physt:IsValid() then
							local unfrozen = physc:IsMotionEnabled() and physt:IsMotionEnabled()
							local dir = coupler:GetDir()
							if unfrozen and (coupler:GetSpeed(dir) > 1) then --Car is unfrozen and moving in the appropriate direction
								local owner
								if car.CPPIGetOwner then owner = car:CPPIGetOwner() end --or nil if PP doesn't exist
								--Iterate over the other trucks
								for index2, coupler2 in pairs(AutoCoupler.AllCouplers) do
									local car2, truck2 = coupler2.car, coupler2.truck
									
									if (index != index2) and (car != car2) and (truck != truck2) then --Don't check against oneself
										if coupler2:CanCouple(owner) then --Coupler2 is valid and prop protection is OK
											
											--Check relative velocities
											local vr = car:GetVelocity() - car2:GetVelocity()
											if vr:Length2DSqr() < 264*264 then --Car velocity is within 15 mph
												--Check Positions
												local p2 = coupler2:GetEdgePos()
												local disp = p2 - coupler:GetEdgePos(dir)
												local disp_alt = p2 - car:GetPos()
												if (disp:Length2DSqr() < 512*512) and (abs(disp.z) < 256) and (disp_alt:Dot(dir) > 0 ) then --Couplers are within a 512x256 cylinder and facing towards each other
													table.insert(AutoCoupler.FastChecks, {coupler, coupler2}) --Add to fast checks
												end
											end
										end
									end

								end
								
							end
							
						else --Either the truck or car has no valid physics
							coupler:Delete()
						end
					end

				else --Coupler is invalid; either the car or the truck is invalid
					coupler:Delete()
				end
			end
			
			--Check decoupled cars to reset the value once distance gets big enough
			for index, data in ipairs(AutoCoupler.DecoupleChecks) do
				local c1 = data[1]
				local c2 = data[2]
				
				local c1v = c1 and c1:IsValid()
				local c2v = c2 and c2:IsValid()
				
				if c1v and c2v then
					local dist2 = (c1:GetEdgePos() - c2:GetEdgePos()):Length2DSqr()
					if dist2 > (AutoCoupler.DecoupleDistance*AutoCoupler.DecoupleDistance) then
						c1.decoupling = false
						c2.decoupling = false
						table.remove(AutoCoupler.DecoupleChecks, index)
						
					end
				else --One of the cars wasn't valid
					
					if c1v then
						c1.decoupling = false
					else
						c1:Delete()
					end
					if c2v then
						c2.decoupling = false
					else
						c2:Delete()
					end
					
					table.remove(AutoCoupler.DecoupleChecks, index)
				end
			end
			
		end --End of slow code
		--The rest is fast code
		
		--Fast Check code, used to precisely determine when to couple two couplers.
		for _, data in ipairs(AutoCoupler.FastChecks) do
			local c1 = data[1]
			local c2 = data[2]
			
			local check = true
			if not c1:IsValid() then
				check = false
				c1:Delete()
			end
			if not c2:IsValid() then
				check = false
				c2:Delete()
			end
			
			local tol = max(c1.tolerance, c2.tolerance)
			
			if c1:CanCouple() and c2:CanCouple() then
				
				local tdist2 = (c1.truck:GetPos() - c2.truck:GetPos()):Length2DSqr()
				local icd = (c1.edge - c1.bolster) + (c2.edge - c2.bolster) --Ideal Coupling Distance, i.e. on straight track
				
				--Check tolerance
				if tdist2 < (icd*icd) then
					--Do a line projection to find distance to line
					local dir = c1:GetDir()
					local disp = c2:GetEdgePos() - c1.car:GetPos()
					
					local distance = disp:Dot(dir)
					
					local hyp2 = disp:Length2DSqr()
					local dtl2 = hyp2 - distance*distance
					if dtl2 < (tol*tol) then --Couple!!!
					
						c1:Connect(c2) 
						
					end
				end
			end
		end
		
		--Benchmarking
		local cputime = (SysTime() - starttime)*1000000 --in microseconds

		AutoCoupler.CPUTimeAvg = 0.9*AutoCoupler.CPUTimeAvg + 0.1*cputime
		AutoCoupler.CPUTimeInst = cputime
		
	end)
	
	--Send Autocoupler Data to Client
	function AutoCoupler.SendCouplerData(car, ply, gui)
		if not (car and ply and car:IsValid() and ply:IsValid()) then return end
		

		Trakpak3.NetStart("autocoupler_senddata")
			net.WriteEntity(car)
			net.WriteBool(gui)
			if car.TP3AC_Dupe then
				net.WriteBool(true)
				net.WriteTable(car.TP3AC_Dupe)
			else
				net.WriteBool(false)
			end
		net.Send(ply)

	end
	
	--Tool Functions
	function AutoCoupler.LeftClick(tool, tr)
		if not (tool and tr) then return end
		local ply = tool:GetOwner()
		local stage = tool:GetStage()
		
		if ply and ply:IsValid() then
			local ent = tr.Entity
			if not (ent and ent:IsValid()) then return end
			
			--Prop Protection Check
			if ent.CPPICanTool then
				if not ent:CPPICanTool(ply, "tp3_autocoupler") then return end
			end
			
			if stage==0 then --Auto Solve
				if not ent.TP3AC then
					local slack = math.Clamp(tool:GetClientNumber("slack",6),0,16)
					local tolerance = math.Clamp(tool:GetClientNumber("tolerance",48),0,96)
					local ropewidth = math.Clamp(tool:GetClientNumber("ropewidth",2),0,8)
					
					
					AutoCoupler.QuickSetup(ent, tolerance, slack, ropewidth)
					AutoCoupler.SendCouplerData(ent, ply, false)
					Trakpak3.NetStart("autocoupler_message")
						net.WriteString("AutoCouplers have been set up for Entity: "..tostring(ent).."!")
						net.WriteString("buttons/bell1.wav")
					net.Send(ply)
					return true --Fire Effect
				else --Coupler data already exists
					AutoCoupler.SendCouplerData(ent, ply, false)
					return true --Fire Effect
				end
			elseif stage==1 then --Pick truck
				Trakpak3.NetStart("autocoupler_sendtruck")
					net.WriteEntity(ent)
				net.Send(ply)
				tool:SetStage(0)
				return true
			end
		end
		
	end
	
	function AutoCoupler.RightClick(tool, tr)
		if not (tool and tr) then return end
		local ply = tool:GetOwner()
		local stage = tool:GetStage()
		
		if ply and ply:IsValid() and (stage==0) then
			local ent = tr.Entity
			if ent and ent:IsValid() and tr.HitNonWorld then
				--Prop Protection Check
				if ent.CPPICanTool then
					if not ent:CPPICanTool(ply, "tp3_autocoupler") then return end
				end
				
				AutoCoupler.SendCouplerData(ent, ply, true)
			else --Hit world
				Trakpak3.NetStart("autocoupler_openexisting")
				net.Send(ply)
			end
			return true --Fire Effect
		end
	end
	
	function AutoCoupler.Reload(tool, tr)
		if not (tool and tr) then return end
		local ply = tool:GetOwner()
		local stage = tool:GetStage()
		
		
		
		if ply and ply:IsValid() then
			if stage==0 then --Clear
				
				local ent = tr.Entity
				if not (ent and ent:IsValid()) then --Deselect
					Trakpak3.NetStart("autocoupler_deselect")
					net.Send(ply)
					return true
				end
				--Prop Protection Check
				if ent.CPPICanTool then
					if not ent:CPPICanTool(ply, "tp3_autocoupler") then return end
				end
				
				local cleared = AutoCoupler.ClearCar(ent)
				if cleared then
					Trakpak3.NetStart("autocoupler_message")
						net.WriteString("Deleted all couplers from Entity: "..tostring(ent).."!")
						net.WriteString("physics/metal/metal_box_break1.wav")
					net.Send(ply)
					AutoCoupler.SendCouplerData(ent, ply, false)
				end
				
				Trakpak3.NetStart("autocoupler_deselect") --Deselect
				net.Send(ply)
				return true --Fire Effect
			elseif stage==1 then --Cancel
				tool:SetStage(0)
			end
		end
	end
	
	--Got an Update/Clear command from client
	Trakpak3.Net["autocoupler_tool"] = function(len, ply)
		local car = net.ReadEntity()
		if not (car and car:IsValid()) then return end
		
		--Prop Protection Check
		if car.CPPICanTool then
			if not car:CPPICanTool(ply, "tp3_autocoupler") then return end
		end
		
		local delete = net.ReadBool()
		if delete then
			AutoCoupler.ClearCar(car)
			AutoCoupler.SendCouplerData(ent, ply, false)
		else
			local data = net.ReadTable()
			--PrintTable(data)
			local cf, cr = data[1], data[-1]
			
			AutoCoupler.ClearCar(car) --Delete Existing
			
			--Create New
			if cf then
				AutoCoupler.NewCoupler(car, cf.axis, 1, Entity(cf.truckid), cf.edge, cf.tolerance, cf.slack, cf.ropewidth)
			end
			if cr then
				AutoCoupler.NewCoupler(car, cr.axis, -1, Entity(cr.truckid), cr.edge, cr.tolerance, cr.slack, cr.ropewidth)
			end
			
			AutoCoupler.SendCouplerData(car, ply, false)
			Trakpak3.NetStart("autocoupler_message")
				net.WriteString("Updated couplers on: "..tostring(car)..".")
				net.WriteString("buttons/button3.wav")
			net.Send(ply)
		end
	end
	
	--Client has requested to pick a truck
	Trakpak3.Net["autocoupler_request_truck"] = function(len, ply)
		
		local tool = ply:GetTool("tp3_autocoupler")
		if tool then
			tool:SetStage(1)
		end
	end
	
	--Client is decoupling a car
	Trakpak3.Net["autocoupler_e_decouple"] = function(len, ply)
		local car = net.ReadEntity()
		if not (car and car:IsValid()) then return end
		
		--Prop Protection Check
		if car.CPPICanTool then
			if not car:CPPICanTool(ply, "rope") then return end
		end
		
		local front = net.ReadBool()
		local index
		if front then index = 1 else index = -1 end
		
		if car.TP3AC then
			local coupler = car.TP3AC[index]
			if coupler then coupler:Disconnect() end
		end
	end
	
end

if CLIENT then
	
	local black = Color(0,0,0)
	local white = Color(255,255,255)
	local red = Color(255,0,0)
	local green = Color(0,255,0)
	local blue = Color(0,0,255)
	local yellow = Color(255,255,0)
	
	local LocalPlayer = LocalPlayer
	
	local caraxis
	local dct_cvar
	
	local decouplingtime
	local decouplingcar
	local decouplingsign
	local decouplinglock
	local decoupling_prog
	
	AutoCoupler.SelectedData = {}
	
	--View Data, run AutoCoupler.OpenEditor
	Trakpak3.Net["autocoupler_senddata"] = function(len, ply)
		local car = net.ReadEntity()
		local gui = net.ReadBool()
		local hasdata = net.ReadBool()
		
		if car and car:IsValid() and not car:IsDormant() then
			AutoCoupler.SelectedCar = car
			if hasdata then
				AutoCoupler.SelectedData = net.ReadTable()
				local sel = AutoCoupler.SelectedData
				if sel[1] and sel[1].axis then caraxis = sel[1].axis elseif sel[-1] and sel[-1].axis then caraxis = sel[-1].axis end
				
			else
				AutoCoupler.SelectedData = {}
				caraxis = nil
			end
			if gui then AutoCoupler.OpenEditor(car) end
		end
	end
	
	Trakpak3.Net["autocoupler_deselect"] = function(len, ply)
		AutoCoupler.SelectedCar = nil
		AutoCoupler.SelectedData = {}
		caraxis = nil
	end
	
	Trakpak3.Net["autocoupler_openexisting"] = function(len, ply)
		local car = AutoCoupler.SelectedCar
		if not (car and car:IsValid()) then return end
		AutoCoupler.OpenEditor(car)
	end
	
	--Generic Print Message
	Trakpak3.Net["autocoupler_message"] = function(len, ply)
		local msg = net.ReadString()
		chat.AddText(msg)
		local snd = net.ReadString()
		if snd and (snd != "")then
			surface.PlaySound(snd)
		end
	end
	
	local sx, sy = 512, 512
	local ex = ScrW()/2 - sx/2
	local ey = ScrH()/2 - sy/2
	local destination
	local frame
	
	--Open the editor window
	function AutoCoupler.OpenEditor(car)
		
		local delete_f = false
		local delete_r = false
		
		frame = vgui.Create("DFrame")
		
		
		frame:SetSize(sx, sy)
		frame:SetPos(ex, ey)
		frame:SetTitle("Trakpak3 AutoCoupler Editor")
		frame:MakePopup()
		function frame:OnRemove()
			if self then
				ex, ey = self:GetPos() --Store for next time
			end
		end
		frame:SetSizable(false)
		frame:SetScreenLock(true)
		
		--Header info
		local panel = vgui.Create("DPanel",frame)
		panel:SetSize(1,48)
		panel:Dock(TOP)
		
		local label = vgui.Create("DLabel",panel)
		label:SetSize(1,1)
		label:Dock(FILL)
		label:SetText(tostring(car).."\n"..car:GetModel())
		label:SetContentAlignment(5)
		label:SetTextColor(black)
		
		--Save/Cancel Menu
		local panel = vgui.Create("DPanel",frame)
		panel:SetSize(1,48)
		panel:Dock(BOTTOM)
		panel.Paint = function() end
		
		local button = vgui.Create("DButton",panel) --Cancel Button
		button:SetSize(128,1)
		button:Dock(RIGHT)
		button:DockMargin(8,2,8,2)
		button:SetText("Cancel")
		function button:DoClick()
			frame:Close()
		end
		
		local button = vgui.Create("DButton",panel) --Save Button
		button:SetSize(128,1)
		button:Dock(LEFT)
		button:DockMargin(8,2,8,2)
		button:SetText("Save & Close")
		function button:DoClick()
			if delete_f then AutoCoupler.SelectedData[1] = nil end
			if delete_r then AutoCoupler.SelectedData[-1] = nil end
			
			local delete = not ( AutoCoupler.SelectedData[1] or AutoCoupler.SelectedData[-1] )
			if car and car:IsValid() and (not car:IsDormant()) then
				Trakpak3.NetStart("autocoupler_tool")
					net.WriteEntity(car)
					net.WriteBool(delete)
					if not delete then
						net.WriteTable(AutoCoupler.SelectedData)
					end
					net.SendToServer()
				frame:Close()
			end
		end
		
		--Coupler Panels
		local sel = AutoCoupler.SelectedData
		
		--Rear Coupler
		local panel = vgui.Create("DPanel",frame)
		panel:SetSize(192,1)
		panel:Dock(LEFT)
		
		local lbl = vgui.Create("DLabel",panel)
		lbl:SetSize(1,24)
		lbl:Dock(TOP)
		lbl:DockMargin(8,8,8,16)
		lbl:SetText("Rear Coupler")
		lbl:SetTextColor(black)
		lbl:SetContentAlignment(5)
		
		if sel[-1] then --Data exists for Rear Coupler
			local c = sel[-1]
			
			--Truck Indicator
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Truck (Click to Change):")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local button = vgui.Create("DButton",panel)
			button:SetSize(1,24)
			button:Dock(TOP)
			button:SetText(tostring(Entity(c.truckid)))
			function button:DoClick()
				destination = -1
				Trakpak3.NetStart("autocoupler_request_truck")
				net.SendToServer()
				frame:Close()
			end
			
			--Coupler Edge
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Coupler Distance:")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local num = vgui.Create("DNumberWang",panel)
			num:SetSize(64,24)
			num:Dock(TOP)
			num:DockMargin(120,2,2,2)
			num:SetDecimals(0)
			num:SetInterval(1)
			num:SetMin(0)
			num:SetMax(2000)
			num:SetValue(math.Round(c.edge))
			
			function num:OnValueChanged(val) c.edge = tonumber(val) or 100 end
			
			--Tolerance
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Horizontal Tolerance:")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local num = vgui.Create("DNumberWang",panel)
			num:SetSize(64,24)
			num:Dock(TOP)
			num:DockMargin(120,2,2,2)
			num:SetDecimals(0)
			num:SetInterval(1)
			num:SetValue(math.Round(c.tolerance))
			num:SetMin(0)
			num:SetMax(96)
			function num:OnValueChanged(val) c.tolerance = tonumber(val) or 48 end
			
			--Slack
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Coupler Slack (0 means Rigid):")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local num = vgui.Create("DNumberWang",panel)
			num:SetSize(64,24)
			num:Dock(TOP)
			num:DockMargin(120,2,2,2)
			num:SetDecimals(0)
			num:SetInterval(1)
			num:SetValue(math.Round(c.slack))
			num:SetMin(0)
			num:SetMax(16)
			function num:OnValueChanged(val) c.slack = tonumber(val) or 6 end
			
			--Rope Width
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Rope Width:")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local num = vgui.Create("DNumberWang",panel)
			num:SetSize(64,24)
			num:Dock(TOP)
			num:DockMargin(120,2,2,2)
			num:SetDecimals(0)
			num:SetInterval(1)
			num:SetValue(math.Round(c.ropewidth))
			num:SetMin(0)
			num:SetMax(8)
			function num:OnValueChanged(val) c.ropewidth = tonumber(val) or 2 end
			
			--Delete Button
			local deleto = vgui.Create("DCheckBoxLabel", panel)
			deleto:SetSize(1,24)
			deleto:Dock(TOP)
			deleto:DockMargin(8,2,2,2)
			deleto:SetText("Delete Coupler?")
			deleto:SetTextColor(black)
			function deleto:OnChange(val) delete_r = val end
			delete_r = false
		else --No data exists
			local button = vgui.Create("DButton",panel)
			button:SetSize(128,24)
			button:Dock(FILL)
			button:DockMargin(32,64,32,64)
			button:SetText("Select Truck")
			function button:DoClick()
				destination = -1
				Trakpak3.NetStart("autocoupler_request_truck")
				net.SendToServer()
				frame:Close()
			end
		end
		
		--Front Coupler
		local panel = vgui.Create("DPanel",frame)
		panel:SetSize(192,1)
		panel:Dock(RIGHT)
		
		local lbl = vgui.Create("DLabel",panel)
		lbl:SetSize(1,24)
		lbl:Dock(TOP)
		lbl:DockMargin(8,8,8,16)
		lbl:SetText("Front Coupler")
		lbl:SetTextColor(black)
		lbl:SetContentAlignment(5)
		
		if sel[1] then --Data exists for Front Coupler
			local c = sel[1]
			
			--Truck Indicator
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Truck (Click to Change):")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local button = vgui.Create("DButton",panel)
			button:SetSize(1,24)
			button:Dock(TOP)
			button:SetText(tostring(Entity(c.truckid)))
			function button:DoClick()
				destination = 1
				Trakpak3.NetStart("autocoupler_request_truck")
				net.SendToServer()
				frame:Close()
			end
			
			--Coupler Edge
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Coupler Distance:")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local num = vgui.Create("DNumberWang",panel)
			num:SetSize(64,24)
			num:Dock(TOP)
			num:DockMargin(120,2,2,2)
			num:SetDecimals(0)
			num:SetInterval(1)
			num:SetMin(0)
			num:SetMax(2000)
			num:SetValue(math.Round(c.edge))
			function num:OnValueChanged(val) c.edge = tonumber(val) or 100 end
			
			--Tolerance
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Horizontal Tolerance:")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local num = vgui.Create("DNumberWang",panel)
			num:SetSize(64,24)
			num:Dock(TOP)
			num:DockMargin(120,2,2,2)
			num:SetDecimals(0)
			num:SetInterval(1)
			num:SetValue(math.Round(c.tolerance))
			num:SetMin(0)
			num:SetMax(96)
			function num:OnValueChanged(val) c.tolerance = tonumber(val) or 48 end
			
			--Slack
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Coupler Slack (0 means Rigid):")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local num = vgui.Create("DNumberWang",panel)
			num:SetSize(64,24)
			num:Dock(TOP)
			num:DockMargin(120,2,2,2)
			num:SetDecimals(0)
			num:SetInterval(1)
			num:SetValue(math.Round(c.slack))
			num:SetMin(0)
			num:SetMax(16)
			function num:OnValueChanged(val) c.slack = tonumber(val) or 6 end
			
			--Rope Width
			local lbl = vgui.Create("DLabel",panel)
			lbl:SetSize(1,24)
			lbl:Dock(TOP)
			lbl:DockMargin(8,2,2,2)
			lbl:SetText("Rope Width:")
			lbl:SetTextColor(black)
			lbl:SetContentAlignment(4)
			
			local num = vgui.Create("DNumberWang",panel)
			num:SetSize(64,24)
			num:Dock(TOP)
			num:DockMargin(120,2,2,2)
			num:SetDecimals(0)
			num:SetInterval(1)
			num:SetValue(math.Round(c.ropewidth))
			num:SetMin(0)
			num:SetMax(8)
			function num:OnValueChanged(val) c.ropewidth = tonumber(val) or 2 end
			
			--Delete Button
			local deleto = vgui.Create("DCheckBoxLabel", panel)
			deleto:SetSize(1,24)
			deleto:Dock(TOP)
			deleto:DockMargin(8,2,2,2)
			deleto:SetText("Delete Coupler?")
			deleto:SetTextColor(black)
			function deleto:OnChange(val) delete_f = val end
			delete_f = false
		else --No data exists
			local button = vgui.Create("DButton",panel)
			button:SetSize(128,24)
			button:Dock(FILL)
			button:DockMargin(32,64,32,64)
			button:SetText("Select Truck")
			function button:DoClick()
				destination = 1
				Trakpak3.NetStart("autocoupler_request_truck")
				net.SendToServer()
				frame:Close()
			end
		end
		
		--Center Panel
		local panel = vgui.Create("DPanel",frame)
		panel:Dock(FILL)
		panel:DockMargin(2,2,2,2)
		
		--Axis Selector
		local lbl = vgui.Create("DLabel",panel)
		lbl:SetSize(1,24)
		lbl:Dock(TOP)
		lbl:DockMargin(8,2,2,2)
		lbl:SetText("Local Axis:")
		lbl:SetTextColor(black)
		lbl:SetContentAlignment(4)
		
		local cbox = vgui.Create("DComboBox",panel)
		cbox:SetSize(1,24)
		cbox:Dock(TOP)
		cbox:AddChoice("X (Red)",1)
		cbox:AddChoice("Y (Green)",2)
		cbox:AddChoice("Z (Blue)",3)
		
		local axis
		if sel[1] and sel[1].axis then axis = sel[1].axis elseif sel[-1] and sel[-1].axis then axis = sel[-1].axis else axis = AutoCoupler.GetLongestAxis(car) end
		caraxis = axis
		if axis then
			
			function cbox:OnSelect(idx, val, data)
				if sel[1] then sel[1].axis = data end
				if sel[-1] then sel[-1].axis = data end
				caraxis = data
			end
			
			if axis==1 then
				cbox:SetValue("X (Red)")
			elseif axis==2 then
				cbox:SetValue("Y (Green)")
			elseif axis==3 then
				cbox:SetValue("Z (Blue)")
			end
			
		else
			cbox:SetText("No Axis")
			cbox:SetEnabled(false)
			caraxis = nil
		end
		
		--Swap Button
		local button = vgui.Create("DButton",panel)
		button:SetSize(1,24)
		button:Dock(BOTTOM)
		button:SetText("<- Swap Data ->")
		if sel[1] or sel[-1] then
			function button:DoClick()
				if car and car:IsValid() and (not car:IsDormant()) then
				
					local temp = sel[1]
					sel[1] = sel[-1]
					sel[-1] = temp
				
					Trakpak3.NetStart("autocoupler_tool")
						net.WriteEntity(car)
						net.WriteBool(false)
						if not delete then net.WriteTable(AutoCoupler.SelectedData) end
					net.SendToServer()
					frame:Close()
				end
				
			end
		else
			button:SetEnabled(false)
		end
	end
	
	--Received truck selection from server
	Trakpak3.Net["autocoupler_sendtruck"] = function(len,ply)
		local truck = net.ReadEntity()
		if truck and truck:IsValid() and not truck:IsDormant() and destination and AutoCoupler.SelectedCar then
			if not AutoCoupler.SelectedData[destination] then
				local axis, edge_f, edge_r = AutoCoupler.GetLongestAxis(AutoCoupler.SelectedCar)
				local tool = LocalPlayer():GetTool("tp3_autocoupler")
				
				if not (axis and edge_f and edge_r and tool) then return end
				
				local tolerance = math.Round(tool:GetClientNumber("tolerance", 48))
				local slack = math.Round(tool:GetClientNumber("slack", 6))
				local ropewidth = math.Round(tool:GetClientNumber("ropewidth", 2))
				AutoCoupler.SelectedData[destination] = {axis = axis, tolerance = tolerance, slack = slack, ropewidth = ropewidth}
				if destination==1 then
					AutoCoupler.SelectedData[1].edge = edge_f - slack/2 - 2
				elseif destination==-1 then
					AutoCoupler.SelectedData[-1].edge = edge_r - slack/2 - 2
				end
			end
			
			AutoCoupler.SelectedData[destination].truckid = truck:EntIndex()
			AutoCoupler.OpenEditor(AutoCoupler.SelectedCar)
			destination = nil
			
		end
	end
	
	--Tool Panel
	function AutoCoupler.ToolPanel(pnl)
		
		local lbl = vgui.Create("DLabel",pnl)
		lbl:SetSize(1,160)
		lbl:SetText("Sets up automatic couplers on a piece of rolling stock. These couplers will automatically connect to other couplers with ropes.\n\nAutocouplers should be attached to the carbody for most simple rolling stock (typical freight cars, diesel locomotives, etc.). Span-bolstered rolling stock should have them on the carbody or the bolster (whichever has the actual coupler on it). Multi-unit articulated cars (well cars, steam locomotives with tenders, etc.) should have couplers on the first and last carbodies.\n\nThe following values are defaults and can be adjusted manually for each coupler.")
		lbl:SetTextColor(black)
		lbl:SetWrap(true)
		pnl:AddPanel(lbl)
		
		--Tolerance
		local slider = vgui.Create("DNumSlider",pnl)
		slider:SetText("Default Tolerance")
		slider:SetMinMax(0,96)
		slider:SetDecimals(0)
		slider:SetValue()
		slider:SetConVar("tp3_autocoupler_tolerance")
		slider:SetDark(true)
		pnl:AddPanel(slider)
		
		--Slack
		local slider = vgui.Create("DNumSlider",pnl)
		slider:SetText("Default Slack")
		slider:SetMinMax(0,16)
		slider:SetDecimals(0)
		slider:SetConVar("tp3_autocoupler_slack")
		slider:SetDark(true)
		pnl:AddPanel(slider)
		
		--Rope Width
		local slider = vgui.Create("DNumSlider",pnl)
		slider:SetText("Default Rope Width")
		slider:SetMinMax(0,8)
		slider:SetDecimals(0)
		slider:SetConVar("tp3_autocoupler_ropewidth")
		slider:SetDark(true)
		pnl:AddPanel(slider)
		
		--Decouple Hold Time
		local lbl = vgui.Create("DLabel",pnl)
		lbl:SetSize(1,48)
		lbl:SetText("If you stand close to a railcar and look at it, you can decouple it by holding +Use for a certain number of seconds.")
		lbl:SetTextColor(black)
		lbl:SetWrap(true)
		pnl:AddPanel(lbl)
		
		local slider = vgui.Create("DNumSlider",pnl)
		slider:SetText("+Use Decoupler Hold Time")
		slider:SetMinMax(0.5,5)
		slider:SetDecimals(1)
		slider:SetConVar("tp3_autocoupler_decoupletime")
		slider:SetDark(true)
		pnl:AddPanel(slider)
		
	end
	
	--To store input bindings
	local key_e
	local key_m1
	
	--Draw HUD for tool/decoupler
	function AutoCoupler.DrawHUD()
		cam.Start2D()
				
			local car = AutoCoupler.SelectedCar
			
			local tsd0, tsd1, tsd2, tsdf
			local truck_f, truck_r
			
			
			local ply = LocalPlayer()
			local wep = ply:GetActiveWeapon()
			local tool = ply:GetTool()
			if car and car:IsValid() and wep and wep:IsValid() and wep:GetClass()=="gmod_tool" and tool and tool:GetMode()=="tp3_autocoupler" then
				cam.Start3D()
					local pos = car:GetPos()
					local vx = car:GetForward()
					local vy = -car:GetRight()
					local vz = car:GetUp()
					
					if caraxis==1 then
						local p = pos + 64*vx
						render.DrawLine(pos, p, red)
						tsdf = p:ToScreen()
					else
						render.DrawLine(pos, pos + 16*vx, red)
					end
					
					if caraxis==2 then
						local p = pos + 64*vy
						render.DrawLine(pos, p, green)
						tsdf = p:ToScreen()
					else
						render.DrawLine(pos, pos + 16*vy, green)
					end
					
					if caraxis==3 then
						local p = pos + 64*vz
						render.DrawLine(pos, p, blue)
						tsdf = p:ToScreen()
					else
						render.DrawLine(pos, pos + 16*vz, blue)
					end
					
					tsd0 = pos:ToScreen()
					
					
					local cf = AutoCoupler.SelectedData[1]
					local cr = AutoCoupler.SelectedData[-1]
					
					if cf then
						truck_f = Entity(cf.truckid)
						if truck_f and truck_f:IsValid() and not truck_f:IsDormant() then
							local vc = AutoCoupler.LocalAxes[cf.axis]
							local cpos = car:LocalToWorld(cf.edge*vc)
							local vcw
							if cf.axis==1 then
								vcw = car:GetForward()
							elseif cf.axis==2 then
								vcw = -car:GetRight()
							elseif cf.axis==3 then
								vcw = car:GetUp()
							end
							local vp = vcw:Cross(Vector(0,0,1))
							vp:Normalize()
							
							local tpos = truck_f:GetPos()
							
							render.DrawLine(cpos + cf.tolerance*vp, cpos - cf.tolerance*vp, yellow) --Horizontal
							render.DrawLine(cpos + Vector(0,0,8), cpos - Vector(0,0,8), yellow) --Vertical
							render.DrawLine(cpos, tpos, white) --Coupler to Truck
							
							tsd1 = tpos:ToScreen()
							
						end
					end
					if cr then
						truck_r = Entity(cr.truckid)
						if truck_r and truck_r:IsValid() and not truck_r:IsDormant() then
							local vc = AutoCoupler.LocalAxes[cr.axis]
							local cpos = car:LocalToWorld(-cr.edge*vc)
							local vcw
							if cr.axis==1 then
								vcw = car:GetForward()
							elseif cr.axis==2 then
								vcw = -car:GetRight()
							elseif cr.axis==3 then
								vcw = car:GetUp()
							end
							local vp = vcw:Cross(Vector(0,0,1))
							vp:Normalize()
							
							local tpos = truck_r:GetPos()
							
							render.DrawLine(cpos + cr.tolerance*vp, cpos - cr.tolerance*vp, yellow) --Horizontal
							render.DrawLine(cpos + Vector(0,0,8), cpos - Vector(0,0,8), yellow) --Vertical
							render.DrawLine(cpos, tpos, white) --Coupler to Truck
							
							tsd2 = tpos:ToScreen()
							
						end
					end
					
				cam.End3D()
				
				if tsd0 then draw.SimpleTextOutlined(tostring(car),"DermaDefault",tsd0.x, tsd0.y, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, black) end
				if tsd1 then
					draw.SimpleTextOutlined("Front","DermaDefault",tsd1.x, tsd1.y - 16, yellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, black)
					draw.SimpleTextOutlined(tostring(truck_f),"DermaDefault",tsd1.x, tsd1.y, yellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, black)
				end
				if tsd2 then
					draw.SimpleTextOutlined("Rear","DermaDefault",tsd2.x, tsd2.y - 16, yellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, black)
					draw.SimpleTextOutlined(tostring(truck_r),"DermaDefault",tsd2.x, tsd2.y, yellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, black)
				end
				if tsdf then
					local c
					local d
					if caraxis==1 then
						c = red
						d = "(X)"
					elseif caraxis==2 then 
						c = green 
						d = "(Y)"
					elseif caraxis==3 then
						c = blue
						d = "(Z)"
					end
					draw.SimpleTextOutlined("Forward "..d,"DermaDefault",tsdf.x, tsdf.y, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, black)
				end
			end
		
		--Decoupling HUD
		
		if Trakpak3.InitPostEntity and not (key_e and key_m1) then
			key_e = string.upper(input.LookupBinding("+use"))
			key_m1 = string.upper(input.LookupBinding("+attack"))
		end
		
		local vehicle_ok = nil
		
		if ply:InVehicle() then
			local veh = ply:GetVehicle()
			if veh and veh:IsValid() and veh:GetNWBool( "TP3AC_AllowDecouple" ) then
				vehicle_ok = true
			else
				vehicle_ok = false
			end
		end
		
		local key
		if vehicle_ok then
			key = key_m1
		else
			key = key_e
		end
		
		local sx, sy = 128, 24
		
		if decouplingcar then
			if decouplingtime then --In Process
				if not decoupling_prog then --Create Progress Bar
					decoupling_prog = vgui.Create("DProgress")
					
					decoupling_prog:SetPos(ScrW()/2 - sx/2, ScrH()/2 - sy/2 + 88)
					decoupling_prog:SetSize(sx,sy)
				end
				
				local holdtime = 1
				
				if not dct_cvar then
					dct_cvar = GetConVar("tp3_autocoupler_decoupletime")
				end
				if dct_cvar then
					holdtime = math.Clamp(0.5, dct_cvar:GetFloat(), 5)
				end
				
				local frac = math.Clamp((CurTime() - decouplingtime)/holdtime, 0, 1)
				decoupling_prog:SetFraction(frac)
				
				draw.SimpleTextOutlined("Decoupling...", "DermaDefault",ScrW()/2, ScrH()/2 + 64, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, black)
				
			else --Not decoupling
				if decoupling_prog and decoupling_prog:IsValid() then
					decoupling_prog:Remove()
					decoupling_prog = nil
				end
				draw.SimpleTextOutlined("Hold "..key.." to decouple...", "DermaDefault", ScrW()/2, ScrH()/2 + 64, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, black)
			end
		else
			if decoupling_prog and decoupling_prog:IsValid() then
				decoupling_prog:Remove()
				decoupling_prog = nil
			end
		end
		
		cam.End2D()
		
	end
	
	hook.Add("PostDrawEffects","TP3_AutoCoupler_DrawHUD",function()
		if Trakpak3.InitPostEntity then
			AutoCoupler.DrawHUD()
		end
	end)
	
	-- +Use Decoupling Checker
	hook.Add("Think","TP3_AutoCoupler_Decoupler",function()
		local ply = LocalPlayer()
		
		
		
		local vehicle_ok = nil
		
		if ply:InVehicle() then
			local veh = ply:GetVehicle()
			if veh and veh:IsValid() and veh:GetNWBool( "TP3AC_AllowDecouple" ) then
				vehicle_ok = true
			else
				vehicle_ok = false
			end
		end
		
		local key = IN_USE
		if vehicle_ok then key = IN_ATTACK end
		
		if not decouplingtime then
			local tr = ply:GetEyeTrace()
			local car = tr.Entity
			
			if car and car:IsValid() and (vehicle_ok != false) then
				
				
				local axis = car:GetNWInt("TP3AC_axis")
				local edge_f = car:GetNWInt("TP3AC_edge_f")
				local edge_r = car:GetNWInt("TP3AC_edge_r")
				
				if (axis and (axis > 0)) and ( (edge_f and (edge_f > 0)) or (edge_r and (edge_r > 0)) ) then --Car has AutoCouplers
					
					local dir
					if axis==1 then
						dir = car:GetForward()
					elseif axis==2 then
						dir = -car:GetRight()
					elseif axis==3 then
						dir = car:GetUp()
					end
					
					if dir then --Measure Distance
						
						local disp = ply:GetPos() - car:GetPos()
						local dist = disp:Dot(dir)
						local rad2 = (disp:LengthSqr() - dist*dist)
						
						local inzone
						
						if rad2 < 128*128 then --Player is close enough to the line
							decouplingcar = car
							if (edge_f > 0) and (abs(dist-edge_f) < 128) then
								inzone = 1
							elseif (edge_r > 0) and (abs(dist+edge_r) < 128) then
								inzone = -1
							end
						end
						
						if inzone then
							decouplingcar = car
							
							if ply:KeyDown(key) and not decouplinglock then --Holding E
								decouplinglock = true
								if inzone==1 then
									decouplingtime = CurTime()
									decouplingsign = 1
								elseif inzone==-1 then
									decouplingtime = CurTime()
									decouplingsign = -1
								end
								
							elseif decouplinglock and not ply:KeyDown(key) then --Not holding E
								decouplinglock = false
							end
						else --Not in zone
							decouplingcar = nil
						end
					end
				else --car does not have autocouplers
					decouplingcar = nil
				end
			else --Not looking at a valid entity, or in a seat
				decouplingcar = nil
			end
		
		else --Holding Decoupling 
			if decouplingcar and decouplingsign and ply:KeyDown(key) then --Still Holding
				
				local holdtime = 1
				
				if not dct_cvar then
					dct_cvar = GetConVar("tp3_autocoupler_decoupletime")
				end
				if dct_cvar then
					holdtime = math.Clamp(0.5, dct_cvar:GetFloat(), 5)
				end
				
				if CurTime() > (decouplingtime + holdtime) then --Pop it!
				
					Trakpak3.NetStart("autocoupler_e_decouple")
						net.WriteEntity(decouplingcar)
						if decouplingsign==1 then
							net.WriteBool(true)
						elseif decouplingsign==-1 then
							net.WriteBool(false)
						end
					net.SendToServer()
					
					decouplingtime = nil
					decouplingsign = nil
				end
				
			else --Let go!
				decouplinglock = false
				decouplingtime = nil
				decouplingsign = nil
			end
		end
		
	end)
	
end
