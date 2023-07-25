--Clientside Node Setup as well as debug and "pack" receiving functions

--Functions for editing individual nodes
function Trakpak3.GetUniqueNodeID()
	if not Trakpak3.NodeList then
		Trakpak3.NodeList = {}
		return 1
	end
	for n=1,table.Count(Trakpak3.NodeList) do
		if not Trakpak3.NodeList[n] then
			return n
		end
	end
	return table.Count(Trakpak3.NodeList) + 1
end

function Trakpak3.NewNode(id, position)
	if not Trakpak3.NodeList then
		Trakpak3.NodeList = {[id] = position}
	else
		Trakpak3.NodeList[id] = position
	end
	Trakpak3.AutosaveLog("nodetools") --Record Delta for Autosave
end

function Trakpak3.DeleteNode(id)
	if not Trakpak3.NodeList then return end
	Trakpak3.NodeList[id] = nil
	Trakpak3.AutosaveLog("nodetools") --Record Delta for Autosave
end

function Trakpak3.FindNode(position, threshold)
	if not Trakpak3.NodeList then return end
	local distances = {}
	for id, pos in pairs(Trakpak3.NodeList) do
		local d = position:Distance(pos)
		if d<=threshold then
			distances[id] = d
		end
	end
	
	if table.Count(distances)==0 then return end
	local out_id = nil
	local min_dist = 65536 --Double the length of the hammer grid, no two nodes could possibly be further away than this
	for id, dist in pairs(distances) do
		if dist<min_dist then
			out_id = id
			min_dist = dist
		end
	end
	return out_id
end

--Functions for managing node chains
--Deprecated
--[[
function Trakpak3.GetUniqueNodeChainID()
	if not Trakpak3.NodeChainList then
		Trakpak3.NodeChainList = {}
		return 1
	end
	for n=1,table.Count(Trakpak3.NodeChainList) do
		if not Trakpak3.NodeChainList[n] then
			return n
		end
	end
	return table.Count(Trakpak3.NodeChainList) + 1
end
]]--

function Trakpak3.NewNodeChain(id, handlepos, nodes, skips)
	if not Trakpak3.NodeChainList then Trakpak3.NodeChainList = {} end
	Trakpak3.NodeChainList[id] = {Nodes = nodes or {}, Skips = skips or {}, Pos = handlepos}
end

function Trakpak3.DeleteNodeChain(id)
	if not Trakpak3.NodeChainList then return end
	Trakpak3.NodeChainList[id] = nil
end

function Trakpak3.FindNodeChainHandle(position, threshold)
	if not Trakpak3.NodeChainList then return end
	local distances = {}
	for id, chain in pairs(Trakpak3.NodeChainList) do
		local d = position:Distance(chain.Pos)
		if d<=threshold then
			distances[id] = d
		end
	end
	
	if table.Count(distances)==0 then return end
	local out_id = nil
	local min_dist = 65536 --Double the length of the hammer grid, no two handles could possibly be further away than this
	for id, dist in pairs(distances) do
		if dist<min_dist then
			out_id = id
			min_dist = dist
		end
	end
	return out_id
end

function Trakpak3.IsNodeInChain(node_id, chain_id)
	if not Trakpak3.NodeChainList then return false end
	if not Trakpak3.NodeChainList[chain_id] then return false end
	for seq, n_id in pairs(Trakpak3.NodeChainList[chain_id].Nodes) do
		if node_id==n_id then
			return true, seq
		end
	end
end

--Cheap(ish) way of finding whether or not a node has been referenced
function Trakpak3.IsNodeChained(node_id)
	if not Trakpak3.NodeList or not Trakpak3.NodeChainList then return false end
	for c_id, chain in pairs(Trakpak3.NodeChainList) do
		if Trakpak3.IsNodeInChain(node_id, c_id) then return true end
	end
end

function Trakpak3.FindChainsWithNode(node_id) --Used for deletions
	if not Trakpak3.NodeChainList then return end
	local outs = {}
	for chain_id, chain in pairs(Trakpak3.NodeChainList) do
		for seq, id in pairs(chain.Nodes) do
			if id==node_id then
				table.insert(outs,chain_id)
				break
			end
		end
	end
	return outs
end

function Trakpak3.AddNodeToChain(chain_id, node_id, skip, beforenode)
	if not Trakpak3.NodeChainList then return end
	local chain = Trakpak3.NodeChainList[chain_id]
	if not chain then return end
	
	if beforenode then --Insert
		for seq, n_id in pairs(chain.Nodes) do
			if n_id==beforenode then
				table.insert(chain.Nodes, seq, node_id)
				table.insert(chain.Skips, seq, skip)
				break
			end
		end
	else --Add to end
		local seq = table.Count(chain.Nodes) + 1
		chain.Nodes[seq] = node_id
		chain.Skips[seq] = skip or false
	end
	Trakpak3.AutosaveLog("nodetools") --Record Delta for Autosave
end

function Trakpak3.RemoveNodeFromChain(chain_id, node_id)
	if not Trakpak3.NodeChainList then return end
	local chain = Trakpak3.NodeChainList[chain_id]
	if not chain then return end
	
	for seq, id in pairs(chain.Nodes) do
		if id==node_id then
			table.remove(chain.Nodes,seq)
			table.remove(chain.Skips,seq)
			break
		end
	end
	Trakpak3.AutosaveLog("nodetools") --Record Delta for Autosave
end

function Trakpak3.SetNodeSkip(chain_id, node_id, skip)
	if not Trakpak3.NodeChainList then return end
	local chain = Trakpak3.NodeChainList[chain_id]
	if not chain then return end
	
	for seq, id in pairs(chain.Nodes) do
		if id==node_id then
			chain.Skips[seq] = skip
			break
		end
	end
	Trakpak3.AutosaveLog("nodetools") --Record Delta for Autosave
end

--Wipe and start over
function Trakpak3.ClearNodes()
	Trakpak3.NodeList = {}
	Trakpak3.NodeChainList = {}
	if Trakpak3.Blocks and not table.IsEmpty(Trakpak3.Blocks) then
		for name, data in pairs(Trakpak3.Blocks) do
			Trakpak3.NewNodeChain(name, data.pos)
		end
	end
	Trakpak3.AutosaveLog("nodetools") --Record Delta for Autosave
end

--Tell the server it's okay to send the blockpack
hook.Add("InitPostEntity","Trakpak3_RequestBlockPack",function()
	--net.Start("tp3_request_blockpack")
	net.Start("trakpak3")
	net.WriteString("tp3_request_blockpack")
	net.SendToServer()
end)

--Receive blocks
--[[
net.Receive("tp3_blockpack", function(mlen)

	print("[Trakpak3] Block Pack Received.")
	local JSON = net.ReadData(mlen)
	JSON = util.Decompress(JSON)
	local alldata = util.JSONToTable(JSON)
	Trakpak3.Blocks = alldata.BlockData
	Trakpak3.BlockDims = {}
	Trakpak3.NodeList = alldata.NodeList
	if Trakpak3.Blocks and not table.IsEmpty(Trakpak3.Blocks) then
		Trakpak3.NodeChainList = {}
		for name, data in pairs(Trakpak3.Blocks) do
			Trakpak3.NewNodeChain(name, data.pos, data.nodes, data.skips)
			Trakpak3.BlockDims[name] = {lw = data.lw, h = data.h, offset = data.offset, occupied = data.occupied}
			--PrintTable(Trakpak3.BlockDims[name])
		end
	end
end)
]]--
Trakpak3.Net.tp3_blockpack = function(len,ply)
	print("[Trakpak3] Block Pack Received.")
	local data = net.ReadData(len/8)
	local JSON = util.Decompress(data)
	local alldata = util.JSONToTable(JSON)
	
	--local alldata = net.ReadTable()
	Trakpak3.Blocks = alldata.BlockData
	Trakpak3.BlockDims = {}
	Trakpak3.NodeList = alldata.NodeList
	if Trakpak3.Blocks and not table.IsEmpty(Trakpak3.Blocks) then
		Trakpak3.NodeChainList = {}
		for name, data in pairs(Trakpak3.Blocks) do
			Trakpak3.NewNodeChain(name, data.pos, data.nodes, data.skips)
			Trakpak3.BlockDims[name] = {lw = data.lw, h = data.h, offset = data.offset, occupied = data.occupied}
		end
	end
end

--Reveive Cab Signal Positions
--[[
net.Receive("tp3_cabsignal_pospack", function(mlen)
	--local JSON = net.ReadData(mlen)
	--JSON = util.Decompress(JSON)
	--Trakpak3.CS_Positions = util.JSONToTable(JSON)
end)
]]--
Trakpak3.Net.tp3_cabsignal_pospack = function(len,ply)
	Trakpak3.CS_Positions = net.ReadTable()
end

--Receive Signal Positions themselves
--[[
net.Receive("tp3_signalpack",function(mlen)
	local JSON = net.ReadData(mlen)
	JSON = util.Decompress(JSON)
	Trakpak3.Signals = util.JSONToTable(JSON)
end)
]]--
Trakpak3.Net.tp3_signalpack = function(len,ply)
	Trakpak3.Signals = net.ReadTable()
end

--Receive Switches
--[[
net.Receive("tp3_switchpack",function(mlen)
	local JSON = net.ReadData(mlen)
	JSON = util.Decompress(JSON)
	Trakpak3.Switches = util.JSONToTable(JSON)
end)
]]--
Trakpak3.Net.tp3_switchpack = function(len,ply)
	Trakpak3.Switches = net.ReadTable()
end

--Receive Logic Gates
--[[
net.Receive("tp3_gatepack",function(mlen)
	local JSON = net.ReadData(mlen)
	JSON = util.Decompress(JSON)
	Trakpak3.LogicGates = util.JSONToTable(JSON)
end)
]]--
Trakpak3.Net.tp3_gatepack = function(len,ply)
	Trakpak3.LogicGates = net.ReadTable()
end

--Occupancy Update
--[[
net.Receive("tp3_block_hull_update", function()
	local block_name = net.ReadString()
	local occupied = net.ReadBool()
	if Trakpak3.BlockDims then
		if Trakpak3.BlockDims[block_name] then
			Trakpak3.BlockDims[block_name].occupied = occupied
		else
			print("[Trakpak3] Signal Block '"..block_name.."' does not exist.")
		end
	else
		print("[Trakpak3] Got a block update but blockpack does not exist, requesting a new one...")
		net.Start("tp3_request_blockpack")
		net.SendToServer()
	end
end)
]]--
Trakpak3.Net.tp3_block_hull_update = function(len,ply)
	local block_name = net.ReadString()
	local occupied = net.ReadBool()
	if Trakpak3.BlockDims then
		if Trakpak3.BlockDims[block_name] then
			Trakpak3.BlockDims[block_name].occupied = occupied
		else
			print("[Trakpak3] Signal Block '"..block_name.."' does not exist.")
		end
	else
		print("[Trakpak3] Got a block update but blockpack does not exist, requesting a new one...")
		net.Start("trakpak3")
		net.WriteString("tp3_request_blockpack")
		net.SendToServer()
	end
end
--[[
net.Receive("tp3_logic_gate_update", function()
	local name = net.ReadString()
	local occupied = net.ReadBool()
	if Trakpak3.LogicGates then
		if Trakpak3.LogicGates[name] then
			Trakpak3.LogicGates[name].occupied = occupied
		else
			print("[Trakpak3] Logic Gate '"..name.."' does not exist.")
		end
	else
		print("[Trakpak3] Got a logic gate update but logic gate info does not exist, requesting a new one...")
		net.Start("tp3_request_blockpack")
		net.SendToServer()
	end
end)
]]--
Trakpak3.Net.tp3_logic_gate_update = function(len,ply)
	local name = net.ReadString()
	local occupied = net.ReadBool()
	if Trakpak3.LogicGates then
		if Trakpak3.LogicGates[name] then
			Trakpak3.LogicGates[name].occupied = occupied
		else
			print("[Trakpak3] Logic Gate '"..name.."' does not exist.")
		end
	else
		print("[Trakpak3] Got a logic gate update but logic gate info does not exist, requesting a new one...")
		net.Start("trakpak3")
		net.WriteString("tp3_request_blockpack")
		net.SendToServer()
	end
end

--Rendering for tools

--Draws hull lines between node boxes
function Trakpak3.DrawHullLines(center1, center2, lw, h, color)
	--Get all 8 corners
	local x = lw/2
	local y = lw/2
	local z = h/2
	
	local corners = {
		Vector(-x, -y, -z),
		Vector(-x, -y, z),
		Vector(-x, y, -z),
		Vector(-x, y, z),
		Vector(x, -y, -z),
		Vector(x, -y, z),
		Vector(x, y, -z),
		Vector(x, y, z)
	}
	
	
	--Sign function
	local function sign(float)
		if float==0 then
			return 0
		elseif float>0 then
			return 1
		else
			return -1
		end
	end
	
	--xor function
	local function xor(a,b)
		return (a and not b) or (b and not a)
	end
	
	--nor3 function
	local function nor3(a,b,c)
		return (not a) and (not b) and (not c)
	end
	--vector rounding function
	local function vround(vector)
		return Vector(math.Round(vector.x), math.Round(vector.y), math.Round(vector.z))
	end
	
	--Get displacement
	local disp = vround(center2-center1)
	
	--Draw the lines
	for k, corner in pairs(corners) do
		
		local draw = false
		local match_x = sign(disp.x)==sign(corner.x)
		local match_y = sign(disp.y)==sign(corner.y)
		local match_z = sign(disp.z)==sign(corner.z)
		if sign(disp.z) == 0 then
			draw = xor(match_x, match_y)
		else
			draw = not (match_x and match_y and match_z) and not nor3(match_x, match_y, match_z)
		end
		
		if draw then
	
			local startpos = center1 + corner
			local endpos = center2 + corner
			render.DrawLine(startpos,endpos,color,true)
		end
	end
end

--Colors
Trakpak3.CURSOR = 			Color(0,0,255)
Trakpak3.SELECTED_NODE = 	Color(255,255,255)
Trakpak3.FREE_NODE = 		Color(0,255,0)
Trakpak3.FREE_CHAIN = 		Color(255,255,0)
Trakpak3.SELECTED_CHAIN = 	Color(0,255,255)
Trakpak3.SKIP = 			Color(63,63,63)

Trakpak3.CLEAR = Color(0,255,0)
Trakpak3.OCCUPIED = Color(255,0,0)

--Draw all the nodes on screen as well as the cursor
hook.Add("PostDrawTranslucentRenderables","TP3_NE_DRAW", function()
	local tewl = LocalPlayer():GetTool()
	local applicable_tools = {"tp3_node_editor","tp3_node_chainer"}
	local goodtool = false
	if tewl then
		for k, toolmode in pairs(applicable_tools) do
			if tewl.Mode==toolmode then
				goodtool = true
				break
			end
		end
	end
	if goodtool and LocalPlayer():GetActiveWeapon():GetClass()=="gmod_tool" then
		--Important info
		local tr = LocalPlayer():GetEyeTrace()
		local box_xy = GetConVar("tp3_node_editor_lw"):GetFloat() or 64
		local box_z = GetConVar("tp3_node_editor_h"):GetFloat() or 64
		local box_offset = GetConVar("tp3_node_editor_offset"):GetFloat() or 0
		--Draw node editor cursor
		if tewl.Mode=="tp3_node_editor" then 
			render.DrawWireframeBox(tr.HitPos + Vector(0,0,box_offset + box_z/2), Angle(), Vector(-box_xy/2, -box_xy/2, -box_z/2), Vector(box_xy/2, box_xy/2, box_z/2), Trakpak3.CURSOR, true)
		end
		
		--Draw all your existing nodes within render distance
		local rdist = (GetConVar("tp3_node_editor_drawdistance"):GetFloat() or 1024)^2
		local mypos = LocalPlayer():GetPos()
		local radius = GetConVar("tp3_node_editor_radius"):GetFloat() or 64
		if Trakpak3.NodeList then
			for id, pos in pairs(Trakpak3.NodeList) do
				if mypos:DistToSqr(pos)<=rdist then
					local nodecolor
					if id==Trakpak3.SelectedNode then --always make selected node white
						nodecolor = Trakpak3.SELECTED_NODE
					elseif Trakpak3.NodeChainList and Trakpak3.SelectedNodeChain and Trakpak3.IsNodeInChain(id, Trakpak3.SelectedNodeChain) then --determine if it's in the selected node chain
						nodecolor = Trakpak3.SELECTED_CHAIN
					elseif Trakpak3.NodeChainList and Trakpak3.IsNodeChained(id) then --draw chained but unselected
						nodecolor = Trakpak3.FREE_CHAIN
					else --draw free
						nodecolor = Trakpak3.FREE_NODE
					end
					
					local overlay = false
					if Trakpak3.SelectedNode and Trakpak3.SelectedNode==id then overlay = true end
					
					render.DrawWireframeSphere(pos,radius,8,8,nodecolor, not overlay)
					render.DrawWireframeBox(pos + Vector(0,0,box_offset + box_z/2), Angle(), Vector(-box_xy/2, -box_xy/2, -box_z/2), Vector(box_xy/2, box_xy/2, box_z/2), nodecolor, not overlay)
					
				end
			end
		end
		
		--Draw all node chain shit within render distance
		if Trakpak3.NodeChainList then
			for id, chain in pairs(Trakpak3.NodeChainList) do
				--PrintTable(chain.Pos)
				if mypos:DistToSqr(chain.Pos) then
					--Draw handles
					local chaincolor
					if id==Trakpak3.SelectedNodeChain then
						chaincolor = Trakpak3.SELECTED_CHAIN
					else
						chaincolor = Trakpak3.FREE_CHAIN
					end
					local overlay = false
					if Trakpak3.SelectedNode and Trakpak3.SelectedNode==id then overlay = true end
					
					render.DrawWireframeSphere(chain.Pos,radius,8,8,chaincolor, not overlay)
					
					--Draw Links (handle to first node)
					if Trakpak3.NodeList and chain.Nodes[1] then
						render.DrawLine(chain.Pos,Trakpak3.NodeList[chain.Nodes[1]] + Vector(0,0, box_offset + box_z/2), chaincolor, true)
					end
					
				end
				
				--Draw Links (Node to node)
				if Trakpak3.NodeList then
					if id==Trakpak3.SelectedNodeChain then --Hulls!
						for seq = 1, #chain.Nodes - 1 do
							local ofv = Vector(0,0, box_offset + box_z/2)
							local c1 = Trakpak3.NodeList[chain.Nodes[seq]] + ofv
							local c2 = Trakpak3.NodeList[chain.Nodes[seq+1]] + ofv
							
							if chain.Skips[seq] then --Skipped; use a single gray line instead of the hulls
								render.DrawLine(c1,c2,Trakpak3.SKIP,true)
							else
								Trakpak3.DrawHullLines(c1, c2, box_xy, box_z, Trakpak3.SELECTED_CHAIN)
							end
						end
					else --Regular old lines
						for seq = 1, #chain.Nodes - 1 do
							local ofv = Vector(0,0, box_offset + box_z/2)
							local c1 = Trakpak3.NodeList[chain.Nodes[seq]] + ofv
							local c2 = Trakpak3.NodeList[chain.Nodes[seq+1]] + ofv
							
							local linecolor = Trakpak3.FREE_CHAIN
							if chain.Skips[seq] then linecolor = Trakpak3.SKIP end
							render.DrawLine(c1,c2,linecolor,true)
						end
					end
				
				end
				
			end
		end
		
		--Draw Cab Signal sampling positions within render distance
		if Trakpak3.CS_Positions then
			for _, pos in pairs(Trakpak3.CS_Positions) do
				if mypos:DistToSqr(pos)<rdist then
					render.DrawLine(pos + Vector(-16,0,0), pos + Vector(16,0,0),Color(255,0,0),true)
					render.DrawLine(pos + Vector(0,-16,0), pos + Vector(0,16,0),Color(0,255,0),true)
					render.DrawLine(pos + Vector(0,0,-16), pos + Vector(0,0,16),Color(0,0,255),true)
					render.DrawWireframeBox(pos, Angle(), Vector(-16,-16,-16), Vector(16,16,16), Color(255,255,255,255), true)
				end
			end
		end
		
	elseif Trakpak3.ShowHulls then --Draw live-updated block occupancy hulls (tp3_showhulls active)
		local rdist = (GetConVar("tp3_node_editor_drawdistance"):GetFloat() or 1024)^2
		local mypos = LocalPlayer():GetPos()
		
		local incopyzone = false
		
		--Blocks and their Nodes
		if Trakpak3.NodeChainList then
			for block_name, chain in pairs(Trakpak3.NodeChainList) do
				--Determine Color
				local ChainColor
				if Trakpak3.BlockDims[block_name].occupied then
					ChainColor = Trakpak3.OCCUPIED
				else
					ChainColor = Trakpak3.CLEAR
				end
				
				--Draw Node Hulls
				if Trakpak3.NodeList and Trakpak3.BlockDims then
					local nodes = chain.Nodes
					local skips = chain.Skips
					local dims = Trakpak3.BlockDims[block_name]
					local seq_end = table.Count(nodes)
					
					for seq = 1, seq_end do
						local node_id = nodes[seq]
						if mypos:DistToSqr(Trakpak3.NodeList[node_id]) < rdist then
						
							render.DrawWireframeBox(Trakpak3.NodeList[node_id] + Vector(0,0,dims.offset + dims.h/2), Angle(), Vector(-dims.lw/2, -dims.lw/2, -dims.h/2), Vector(dims.lw/2, dims.lw/2, dims.h/2), ChainColor, true)
							
							if seq<seq_end then
								local c1 = Trakpak3.NodeList[ nodes[seq] ] + Vector(0,0,dims.offset + dims.h/2)
								local c2 = Trakpak3.NodeList[ nodes[seq+1] ] + Vector(0,0,dims.offset + dims.h/2)
								if skips[seq] then
									render.DrawLine(c1, c2, Trakpak3.SKIP, true)
								else
									Trakpak3.DrawHullLines(c1, c2, dims.lw, dims.h, ChainColor)
								end
							end
						end
					end 
				end
				--Draw Block Block
				if Trakpak3.Blocks and (Trakpak3.ShowHulls==2) then
					local bpos = Trakpak3.Blocks[block_name].pos
					if mypos:DistToSqr(bpos) < rdist then
					
						local mins = Vector(-64,-64,-8)
						local maxs = Vector(64,64,128)
						
						render.DrawWireframeBox(bpos,Angle(),mins,maxs,ChainColor)
						
						local text
						local tpos
						
						if mypos:WithinAABox(bpos+mins, bpos+maxs) then --Inside the box
							text = "Signal Block '"..block_name.."' (Press E to Copy to Clipboard)"
							tpos = { x = ScrW()/2, y = ScrH()/2, visible = true }
							
							incopyzone = true
							if not Trakpak3.Clipboard then
								Trakpak3.Clipboard = block_name
								--net.Start("tp3_clipboard")
									--net.WriteString(block_name)
								--net.SendToServer()
							end
						else --Outside the box
							text = "Signal Block '"..block_name.."'"
							tpos = (bpos + Vector(0,0,64)):ToScreen()
						end
						
						cam.Start2D()
							if tpos.visible then draw.SimpleTextOutlined(text,"DermaDefault",tpos.x, tpos.y, ChainColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0)) end
						cam.End2D()
					end
				end
			end
		end
		
		--Logic Gates
		if Trakpak3.LogicGates and (Trakpak3.ShowHulls==2) then
			for name, gate in pairs(Trakpak3.LogicGates) do
				--Determine Color
				local ChainColor
				if gate.occupied then
					ChainColor = Trakpak3.OCCUPIED
				else
					ChainColor = Trakpak3.CLEAR
				end
				
				--Draw Logic Gate Block
				local pos = gate.pos
				if mypos:DistToSqr(pos) < rdist then
					local mins = Vector(-64,-64,-64)
					local maxs = Vector(64,64,64)
					
					render.DrawWireframeBox(pos,Angle(),mins,maxs,ChainColor)
					
					local text
					local tpos
					
					if mypos:WithinAABox(pos+mins, pos+maxs) then --Inside the box
						text = "Logic Gate '"..name.."' (Press E to Copy to Clipboard)"
						tpos = { x = ScrW()/2, y = ScrH()/2, visible = true }
						
						incopyzone = true
						if not Trakpak3.Clipboard then
							Trakpak3.Clipboard = name
							--net.Start("tp3_clipboard")
								--net.WriteString(name)
							--net.SendToServer()
						end
					else --Outside the box
						text = "Logic Gate '"..name.."'"
						tpos = (pos + Vector(0,0,64)):ToScreen()
					end
					
					cam.Start2D()
						if tpos.visible then draw.SimpleTextOutlined(text,"DermaDefault",tpos.x, tpos.y, ChainColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0)) end
					cam.End2D()
				end
			end
		end
		
		--Signals
		if Trakpak3.Signals and (Trakpak3.ShowHulls==2) then
			local sigcolor = Color(255,255,255)
			for name, pos in pairs(Trakpak3.Signals) do
				if mypos:DistToSqr(pos) < rdist then
					local mins = Vector(-64,-64,-64)
					local maxs = Vector(64,64,64)
					
					render.DrawWireframeBox(pos,Angle(),mins,maxs,sigcolor)
					
					local text
					local tpos
					
					if mypos:WithinAABox(pos+mins, pos+maxs) then --Inside the box
						text = "Signal '"..name.."' (Press E to Copy to Clipboard)"
						tpos = { x = ScrW()/2, y = ScrH()/2, visible = true }
						
						incopyzone = true
						if not Trakpak3.Clipboard then
							Trakpak3.Clipboard = name
							--net.Start("tp3_clipboard")
								--net.WriteString(name)
							--net.SendToServer()
						end
					else --Outside the box
						text = "Signal '"..name.."'"
						tpos = (pos + Vector(0,0,64)):ToScreen()
					end
					
					cam.Start2D()
						if tpos.visible then draw.SimpleTextOutlined(text,"DermaDefault",tpos.x, tpos.y, sigcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0)) end
					cam.End2D()
				end
			end
		end
		
		--Switches
		if Trakpak3.Switches and (Trakpak3.ShowHulls==2) then
			local swicolor = Color(255,0,255)
			for name, pos in pairs(Trakpak3.Switches) do
				if mypos:DistToSqr(pos) < rdist then
					local mins = Vector(-64,-64,-8)
					local maxs = Vector(64,64,128)
					
					render.DrawWireframeBox(pos,Angle(),mins,maxs,swicolor)
					
					local text
					local tpos
					
					if mypos:WithinAABox(pos+mins, pos+maxs) then --Inside the box
						text = "Switch '"..name.."' (Press E to Copy to Clipboard)"
						tpos = { x = ScrW()/2, y = ScrH()/2, visible = true }
						
						incopyzone = true
						if not Trakpak3.Clipboard then
							Trakpak3.Clipboard = name
							--net.Start("tp3_clipboard")
								--net.WriteString(name)
							--net.SendToServer()
						end
					else --Outside the box
						text = "Switch '"..name.."'"
						tpos = (pos + Vector(0,0,64)):ToScreen()
					end
					
					cam.Start2D()
						if tpos.visible then draw.SimpleTextOutlined(text,"DermaDefault",tpos.x, tpos.y, swicolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0)) end
					cam.End2D()
				end
			end
		end
		
		if not incopyzone and Trakpak3.Clipboard then
			Trakpak3.Clipboard = false
			--net.Start("tp3_clipboard")
			--net.SendToServer()
		end
	end
end)

--Copy to Clipboard
--[[
net.Receive("tp3_clipboard", function(len)
	local text = LocalPlayer():GetNWString("tp3_clipboard")
	if text and (text!="") then
		SetClipboardText(text)
		LocalPlayer():EmitSound("buttons/button18.wav")
		chat.AddText("Copied '"..text.."' to clipboard.")
	end
end)
]]--

hook.Add("KeyPress","Trakpak3_Clipboard",function(ply, key)
	if key==IN_USE and Trakpak3.Clipboard then
		SetClipboardText(Trakpak3.Clipboard)
		LocalPlayer():EmitSound("buttons/button18.wav")
		chat.AddText("Copied '"..Trakpak3.Clipboard.."' to clipboard.")
	end
end)

--Save/Load
function Trakpak3.SaveNodeFile()
	local ftable = {}
	if Trakpak3.NodeList then ftable.NodeList = Trakpak3.NodeList end
	if Trakpak3.NodeChainList then ftable.NodeChainList = Trakpak3.NodeChainList end
	local json = util.TableToJSON(ftable, true)
	file.CreateDir("trakpak3/nodes")
	file.Write("trakpak3/nodes/"..game.GetMap()..".txt", json)
	local gray = Color(127,255,255)
	chat.AddText(gray, "File saved as ",Color(255,127,127),"data",gray,"/trakpak3/nodes/"..game.GetMap()..".txt! To include it with your map, change its extension to .lua and place it in ",Color(0,127,255),"lua",gray,"/trakpak3/nodes/!")
	Trakpak3.AutosaveClear("nodetools")
end

function Trakpak3.LoadNodeFile()
	local json = file.Read("trakpak3/nodes/"..game.GetMap()..".txt", "DATA")
	if json then
		local ftable = util.JSONToTable(json)
		Trakpak3.NodeList = ftable.NodeList
		Trakpak3.NodeChainList = ftable.NodeChainList
		chat.AddText(Color(127,255,255), "Loaded node file data/trakpak3/nodes/"..game.GetMap()..".txt successfully.")
	else
		chat.AddText(Color(127,255,255),"Could not find node file data/trakpak3/nodes/"..game.GetMap()..".txt!")
	end
end

--Tool menu panel for node editing tools
function Trakpak3.NodeEditMenu(panel)

	--Draw Distance
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetMin(512)
	slider:SetMax(16384)
	slider:SetText("Node Draw Distance")
	slider:SetDecimals(0)
	slider:SetConVar("tp3_node_editor_drawdistance")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
	--Click Radius
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetMin(16)
	slider:SetMax(256)
	slider:SetText("Node Click Radius")
	slider:SetDecimals(0)
	slider:SetConVar("tp3_node_editor_radius")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
	--Box LW
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetMin(32)
	slider:SetMax(512)
	slider:SetText("Node Box Width")
	slider:SetDecimals(0)
	slider:SetConVar("tp3_node_editor_lw")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
	--Box H
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetMin(32)
	slider:SetMax(512)
	slider:SetText("Node Box Height")
	slider:SetDecimals(0)
	slider:SetConVar("tp3_node_editor_h")
	slider:SetDark(true)
	panel:AddPanel(slider)
	
	--Box Offset
	local slider = vgui.Create("DNumSlider",panel)
	slider:SetMin(-64)
	slider:SetMax(64)
	slider:SetText("Node Box Offset (Height Off Ground)")
	slider:SetDecimals(0)
	slider:SetConVar("tp3_node_editor_offset")
	slider:SetDark(true)
	panel:AddPanel(slider)
		
	--Save Button
	local button = vgui.Create("DButton",panel)
	button:SetText("Save Node File")
	button.DoClick = function()
		LocalPlayer():EmitSound("buttons/button3.wav")
		local AYS = vgui.Create("DFrame")
		AYS:SetPos((ScrW() - 272)/2,(ScrH() - 128)/2)
		AYS:SetSize(272,128)
		AYS:SetTitle("Save Node File?")
		AYS:MakePopup()
		AYS:DockPadding(32,32,32,16)
		
		local warning = vgui.Create("DLabel",AYS)
		warning:SetText("This will override the file in\ndata/trakpak3/nodes/.")
		warning:SetSize(1,48)
		warning:Dock(TOP)
		
		local yesbutton = vgui.Create("DButton", AYS)
		yesbutton:SetText("Save")
		yesbutton.DoClick = function()
			Trakpak3.SaveNodeFile()
			AYS:Close()
		end
		yesbutton:Dock(LEFT)
		
		local nobutton = vgui.Create("DButton", AYS)
		nobutton:SetText("Cancel")
		nobutton:SetColor(Color(255,0,0))
		nobutton.DoClick = function()
			AYS:Close()
		end
		nobutton:Dock(RIGHT)
	end
	panel:AddPanel(button)
		
	--Load Button
	local button = vgui.Create("DButton",panel)
	button:SetText("Load Node File")
	button.DoClick = function()
		
		LocalPlayer():EmitSound("buttons/button3.wav")
		local AYS = vgui.Create("DFrame")
		AYS:SetPos((ScrW() - 272)/2,(ScrH() - 128)/2)
		AYS:SetSize(272,128)
		AYS:SetTitle("Load Node File?")
		AYS:MakePopup()
		AYS:DockPadding(32,32,32,16)
		
		local warning = vgui.Create("DLabel",AYS)
		warning:SetText("This will override current nodes.")
		warning:Dock(TOP)
		
		local yesbutton = vgui.Create("DButton", AYS)
		yesbutton:SetText("Load")
		yesbutton.DoClick = function()
			Trakpak3.LoadNodeFile()
			AYS:Close()
		end
		yesbutton:Dock(LEFT)
		
		local nobutton = vgui.Create("DButton", AYS)
		nobutton:SetText("Cancel")
		nobutton:SetColor(Color(255,0,0))
		nobutton.DoClick = function()
			AYS:Close()
		end
		nobutton:Dock(RIGHT)
	end
	panel:AddPanel(button)
		
	--Clear Button
	local button = vgui.Create("DButton",panel)
	button:SetText("Clear Node Info")
	button.DoClick = function()
		
		LocalPlayer():EmitSound("buttons/button3.wav")
		local AYS = vgui.Create("DFrame")
		AYS:SetPos((ScrW() - 272)/2,(ScrH() - 128)/2)
		AYS:SetSize(272,128)
		AYS:SetTitle("Clear Nodes?")
		AYS:MakePopup()
		AYS:DockPadding(32,32,32,16)
		
		local warning = vgui.Create("DLabel",AYS)
		warning:SetText("Anything not saved will be lost.")
		warning:Dock(TOP)
		
		local yesbutton = vgui.Create("DButton", AYS)
		yesbutton:SetText("Clear")
		yesbutton.DoClick = function()
			Trakpak3.ClearNodes()
			AYS:Close()
		end
		yesbutton:Dock(LEFT)
		
		local nobutton = vgui.Create("DButton", AYS)
		nobutton:SetText("Cancel")
		nobutton:SetColor(Color(255,0,0))
		nobutton.DoClick = function()
			AYS:Close()
		end
		nobutton:Dock(RIGHT)

	end
	panel:AddPanel(button)
	
	--Hulls Button
	local button = vgui.Create("DButton", panel)
	button:SetText("Toggle Map Block Hulls")
	button.DoClick = function()
		LocalPlayer():EmitSound("buttons/button9.wav")
		if not Trakpak3.ShowHulls then
			Trakpak3.ShowHulls = true
			print("[Trakpak3] Showing Trakpak3 Block Hulls.")
		else
			Trakpak3.ShowHulls = false
			print("[Trakpak3] Hiding Trakpak3 Block Hulls.")
		end
	end
	panel:AddPanel(button)
		
	--Auto Save Button
	local button = vgui.Create("DButton",panel)
	button:SetText("Autosave Menu")
	button.DoClick = function() Trakpak3.AutosaveMenu() end
	panel:AddPanel(button)
	
end

--Showhulls Console Command
concommand.Add("tp3_showhulls", function(ply, cmd, args)
	local to = args[1]
	if to=="2" then
		Trakpak3.ShowHulls = 2
		print("[Trakpak3] Showing Trakpak3 Full Debug.")
	elseif to=="1" then
		Trakpak3.ShowHulls = 1
		print("[Trakpak3] Showing Trakpak3 Block Hulls.")
	elseif to=="0" then
		Trakpak3.ShowHulls = false
		print("[Trakpak3] Hiding Trakpak3 Block Hulls.")
	else
		if not Trakpak3.ShowHulls then
			Trakpak3.ShowHulls = 1
			print("[Trakpak3] Showing Trakpak3 Block Hulls.")
		else
			Trakpak3.ShowHulls = false
			print("[Trakpak3] Hiding Trakpak3 Block Hulls.")
		end
	end
	
end)