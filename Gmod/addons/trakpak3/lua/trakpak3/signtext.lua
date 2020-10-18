--MsgC(Trakpak3.Magenta,"Running Sign Library\n")

util.AddNetworkString("tp3_register_sign")

--will be triggered when each player intializes clientside
net.Receive("tp3_register_sign", function(mlen, ply)
	print("[Trakpak3] Sending sign data...")
	for _, sign in pairs(ents.FindByClass("tp3_sign_*")) do
		--Send Text Data to Client
		--PrintTable(sign.text_data)
		sign:UpdateSign(ply)
	end
end)