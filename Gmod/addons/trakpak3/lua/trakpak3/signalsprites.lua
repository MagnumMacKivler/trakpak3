--Find all signal files in trakpak3/signalsprites and send them to client
local sigfiles = file.Find("trakpak3/signalsprites/*.lua","LUA")
for k, file in pairs(sigfiles) do
	AddCSLuaFile("trakpak3/signalsprites/"..file)
end