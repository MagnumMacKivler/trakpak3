--Sent by server when a player gets into a seat; seat must be placed by map.
net.Receive("Trakpak3_SetMapSeat", function(len)
	local ent = net.ReadEntity()
	local key = net.ReadString()
	
	local Vehicles = list.Get("Vehicles")
	
	ent.HandleAnimation = Vehicles[key].Members.HandleAnimation
end)