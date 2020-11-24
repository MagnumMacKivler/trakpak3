--Remote Switcher (Serverside)
util.AddNetworkString("tp3_remoteswitcher")

net.Receive("tp3_remoteswitcher",function(len, ply)
	local stand = net.ReadEntity()
	if stand and stand:IsValid() and stand:GetClass()=="tp3_switch_lever_anim" then
		stand:Use(ply)
	end
end)