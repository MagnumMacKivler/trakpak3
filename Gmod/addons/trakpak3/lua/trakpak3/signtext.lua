--MsgC(Trakpak3.Magenta,"Running Sign Library\n")
Trakpak3.SignText = {}
Trakpak3.SignText.Signs = {}
--util.AddNetworkString("tp3_register_sign")

--Return pack of sign data
Trakpak3.GetSignPack = function()
	if Trakpak3.SignTextPack then return Trakpak3.SignTextPack end
	
	Trakpak3.SignTextPack = {}
	local stpack = Trakpak3.SignTextPack
	for _, ent in pairs(ents.FindByClass("tp3_sign_*")) do
		for index=1,4 do
			local data = ent["text_data_"..index]
			if data then
				local signtable = {
					ent = ent, --For tp3_sign_world, this will be nil on client because it's not networked.
					data = data,
					index = index
				}
				table.insert(stpack,signtable)
			end
		end
	end
	
	if table.IsEmpty(stpack) then
		return nil
	else
		return stpack
	end
end


--Send a live update
function Trakpak3.SignText.SyncSign(ent, data, index, ply)
	index = index or 1
	--net.Start("tp3_register_sign")
	net.Start("trakpak3")
		net.WriteString("tp3_register_sign")
		net.WriteEntity(ent)
		local json = util.TableToJSON(data)
		net.WriteString(json)
		net.WriteUInt(index,16)
	if ply then net.Send(ply) else net.Broadcast() end
end

function Trakpak3.SignText.UpdateSign(ent, data, index)
	index = index or 1
	if not Trakpak3.SignText.Signs[ent:EntIndex()] then Trakpak3.SignText.Signs[ent:EntIndex()] = {} end
	Trakpak3.SignText.Signs[ent:EntIndex()][index] = data
end