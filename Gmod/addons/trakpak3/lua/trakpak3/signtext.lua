--MsgC(Trakpak3.Magenta,"Running Sign Library\n")
Trakpak3.SignText = {}
Trakpak3.SignText.Signs = {}
util.AddNetworkString("tp3_register_sign")

--will be triggered when each player intializes clientside

net.Receive("tp3_register_sign", function(mlen, ply)
	print("[Trakpak3] Sending sign data...")
	for _, ent in pairs(ents.FindByClass("tp3_sign_*")) do
		--Send Text Data to Client
		for index = 1,4 do
			local data = ent["text_data_"..index]
			if data then Trakpak3.SignText.SyncSign(ent,data,index,ply) end
		end
	end
end)

function Trakpak3.SignText.SyncSign(ent, data, index, ply)
	index = index or 1
	net.Start("tp3_register_sign")
		net.WriteEntity(ent)
		local json = util.TableToJSON(data)
		net.WriteString(json)
		net.WriteUInt(index,8)
	if ply then net.Send(ply) else net.Broadcast() end
end

function Trakpak3.SignText.UpdateSign(ent, data, index)
	index = index or 1
	if not Trakpak3.SignText.Signs[ent:EntIndex()] then Trakpak3.SignText.Signs[ent:EntIndex()] = {} end
	Trakpak3.SignText.Signs[ent:EntIndex()][index] = data
end