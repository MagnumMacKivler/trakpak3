AddCSLuaFile()

DEFINE_BASECLASS( "tp3_base_entity" )
ENT.PrintName = "Trakpak3 Track Node"
ENT.Author = "Magnum MacKivler"
ENT.Purpose = "Signal Block Detection Node"
ENT.Instructions = "Place in Hammer"

--Simply acts as a pointer to the next node, like a path_track.
if SERVER then
	
	--Keyvalue Handler
	ENT.KeyValueMap = {
		target = "string",
		notrace = "boolean",
		hullmin = "vector",
		hullmax = "vector"
	}
	
	--Create global table for node info
	if not Trakpak3.NODELIST then
		Trakpak3.NODELIST = {}
	end
	util.AddNetworkString("tp3_showhulls")
	
	--Package and send out the node list table when requested by a player
	net.Receive("tp3_showhulls", function(length, ply)
		local stringout = util.TableToJSON(Trakpak3.NODELIST)
		if stringout then
			--stringout = util.Compress(stringout)
			if stringout then
				net.Start("tp3_showhulls")
				--net.WriteData(stringout, #stringout)
				net.WriteString(stringout)
				net.Send(ply)
			end
		end
	end)
	function ENT:Initialize()
		self:RegisterEntity("target",self.target)
		if true then
			--self.hullmin = Trakpak3.HammerStringToVector(self.hullmin)
			--self.hullmax = Trakpak3.HammerStringToVector(self.hullmax)
			--self.notrace = self.notrace=="1"
			--local targetent, valid = Trakpak3.FindByTargetname(self.target)
			local index = nil
			if self.target_valid then index = self.target_ent:EntIndex() end
			local nodeinfo = {
				origin = self:GetPos(),
				mins = self.hullmin,
				maxs = self.hullmax,
				notrace = self.notrace,
				occupied = false,
				target_id = index
			}
			--PrintTable(nodeinfo)
			Trakpak3.NODELIST[self:EntIndex()] = nodeinfo
		end
	end
end

if CLIENT then
	
	--Unpack node list from net message
	net.Receive("tp3_showhulls", function()
		if tp3_showhulls then
			local stringout = net.ReadString()
			--if stringout then stringout = util.Decompress(stringout) end
			if stringout then
				local tableout = util.JSONToTable(stringout)
				if tableout then
					TP3_NODELIST = tableout
					--print("Received Node List!")
				else
					print("Could not convert node list to table!")
				end
			else
				print("Could not parse string from net message!")
			end
		end
	end)
	
	local function DrawHullBox(info)
		--Get local mins and maxes
		local mymax = info.maxs
		local mymin = info.mins
		
		--Draw Box
		render.DrawWireframeBox(info.origin,Angle(),mymin,mymax,Color(255,255,0),true)
	end
	local function DrawLines(info, targetinfo)
		--Get local mins and maxes
		local mymax = info.maxs
		local mymin = info.mins
		
		if targetinfo then
			
			local notrace = info.notrace
			local occupied = info.occupied
			local linecolor = Color(0,255,0)
			if notrace then
				linecolor = Color(191,191,191)
			elseif occupied then
				linecolor = Color(255,0,0)
			end
			--Get all 8 corners of the box
			local corners = {
				mymin,
				Vector(mymax.x, mymin.y, mymin.z),
				Vector(mymin.x, mymax.y, mymin.z),
				Vector(mymax.x, mymax.y, mymin.z),
				Vector(mymin.x, mymin.y, mymax.z),
				Vector(mymax.x, mymin.y, mymax.z),
				Vector(mymin.x, mymax.y, mymax.z),
				mymax
			}
			--get displacement
			local disp = targetinfo.origin - info.origin
			
			local function sign(float)
				if float==0 then
					return 0
				elseif float>0 then
					return 1
				else
					return -1
				end
			end
			
			--draw lines
			for _, corner in pairs(corners) do
				
				local matches = 0
				local lookfor = 1
				if sign(corner.x)==sign(disp.x) then matches = matches + 1 end
				if sign(corner.y)==sign(disp.y) then matches = matches + 1 end
				if sign(corner.z)==sign(disp.z) then lookfor = 2 end
				
				if matches==lookfor then
			
					local startpos = info.origin + corner
					local endpos = targetinfo.origin + corner
					render.DrawLine(startpos,endpos,linecolor,true)
				end
			end
		end
	end
	
	hook.Add("PostDrawOpaqueRenderables","tp3_showhulls",function()
		if tp3_showhulls and TP3_NODELIST then
			for _, node in pairs(TP3_NODELIST) do
				DrawHullBox(node)
				local id = node.target_id
				if id then
					DrawLines(node, TP3_NODELIST[id])
				end
			end
		end
	end)
	
	--Create Console commands
	concommand.Add("tp3_showhulls",function()
		print("Showing all signal hull paths.")
		tp3_showhulls = true
		net.Start("tp3_showhulls")
		net.SendToServer()
	end, nil, "Show the paths traced by the track nodes, for debugging purposes")
		
	concommand.Add("tp3_hidehulls",function()
		print("Hiding all signal hull paths.")
		tp3_showhulls = false
	end, nil, "Hide the signal paths")
end