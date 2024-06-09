--Sent by server when a player gets into a seat; seat must be placed by map.
--[[
net.Receive("Trakpak3_SetMapSeat", function(len)
	local ent = net.ReadEntity()
	local key = net.ReadString()
	
	local Vehicles = list.Get("Vehicles")
	
	ent.HandleAnimation = Vehicles[key].Members.HandleAnimation
end)
]]--
Trakpak3.Net.trakpak3_setmapseat = function(len,ply)
	local ent = net.ReadEntity()
	local key = net.ReadString()
	
	local Vehicles = list.Get("Vehicles")
	
	if ent and ent:IsValid() then ent.HandleAnimation = Vehicles[key].Members.HandleAnimation end
end

--Special Thirdperson rules for turntables and transfer tables
local max = math.max

hook.Add("CalcVehicleView", "Trakpak3_VehicleView", function(veh, ply, view)
	if ( veh.GetThirdPersonMode == nil ) or ply:GetViewEntity() != ply then return end

	--
	-- If we're not in third person mode - then get outa here stalker
	--
	if (not veh:GetThirdPersonMode()) or not (veh and veh:IsValid()) then return end
	
	local ttable = Trakpak3.GetRoot(veh)
	local class = ttable:GetClass()
	
	if ttable and ttable:IsValid() and ((class=="tp3_turntable") or (class=="tp3_transfertable")) then
		local center = ttable:GetPos()
		center.z = view.origin.z
		
		local maxs, mins = ttable:GetRenderBounds()
		local boxsize = maxs - mins
		
		local radius = max(boxsize.x, boxsize.y, boxsize.z)
		radius = radius + radius*veh:GetCameraDistance()
		
		local target = center + view.angles:Forward()*radius
		
		local ht = {
			start = center,
			endpos = target,
			maxs = Vector(4,4,4),
			mins = Vector(-4,-4,-4),
			filter = Trakpak3.TraceFilter,
			collisiongroup = COLLISION_GROUP_WORLD
		}
		
		local tr = util.TraceHull(ht)
		
		view.origin = tr.HitPos
		view.drawviewer = true
		
		return view
		
	end
end)