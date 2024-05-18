Trakpak3.MapVehicleScripts = {}

--Assign all map-placed vehicles the appropriate animation
function Trakpak3.CHECK_MAP_VEHICLES()
	local Vehicles = list.Get("Vehicles") --Master list containing vehicle generation scripts
	
	--for k, veh in pairs(ents.FindByClass("prop_vehicle_*")) do --For every prop_vehicle_<whatever> do
	-- findByClass already does ents.GetAll(), and it's more expensive on top of that because it's string comparing every entity.
	-- not all vehicles may have prop_vehicle in their name, as well. 

	for k, veh in pairs(ents.GetAll()) do 
		if not veh:IsVehicle() then continue end -- Skip this iteration if it's not a vehicle, checks class, less expensive
		if veh:CreatedByMap() then --Vehicle was included with the map and not spawned/duped/whatever
			
			if veh.genscript then --Vehicle has a preferred generation script already, corresponding to a table entry in the Vehicles table.
				local vtable = Vehicles[veh.genscript]
				if vtable then
					veh.HandleAnimation = vtable.Members.HandleAnimation
					Trakpak3.MapVehicleScripts[veh:EntIndex()] = veh.genscript
				end
			else --Search the vehicle table and assign one based on class and model
				for key, vtable in pairs(Vehicles) do
					if (veh:GetClass()==vtable.Class) and (veh:GetModel()==vtable.Model) and vtable.Members then
						veh.HandleAnimation = vtable.Members.HandleAnimation
						Trakpak3.MapVehicleScripts[veh:EntIndex()] = key
						break
					end
				end
			end
			
		end
		
	end
end

--hook.Add("InitPostEntity","Trakpak3_MapVehicleAnims",checkMapVehicles)
--hook.Add("PostCleanupMap","Trakpak3_MapVehicleAnims",checkMapVehicles)

--Set the local animation function for the player who gets in to the map vehicle
--util.AddNetworkString("Trakpak3_SetMapSeat")
hook.Add("PlayerEnteredVehicle","Trakpak3_PlayerInVehicle",function(ply, veh)
	if veh:CreatedByMap() and Trakpak3.MapVehicleScripts[veh:EntIndex()] then
		--net.Start("Trakpak3_SetMapSeat")
		net.Start("trakpak3")
			net.WriteString("trakpak3_setmapseat")
			net.WriteEntity(veh)
			net.WriteString(Trakpak3.MapVehicleScripts[veh:EntIndex()])
		net.Send(ply)
	end
end)

--Assign the "genscript" keyvalue if needed
hook.Add("EntityKeyValue","Trakpak3_MapSeatSpecific",function(ent, key, value)
	if key=="genscript" then ent.genscript = value end
end)