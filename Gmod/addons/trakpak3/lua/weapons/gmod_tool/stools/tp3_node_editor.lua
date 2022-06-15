TOOL.Category = "Trakpak3 Dev Tools"
TOOL.Name = "Node Editor"
TOOL.Command = nil
TOOL.Configname = ""

if CLIENT then
	--[[
	List of Operations
	
	Place a new node or move an existing one (Left)
	Select/Deselect a node (Right)
	Delete a node (Reload)
	
	
	]]--
	TOOL.Information = {"left","right","reload"}
	language.Add("Tool.tp3_node_editor.name","Trakpak3 Node Editor")
	language.Add("Tool.tp3_node_editor.desc","Places and removes track nodes. For use by mappers only!")
	
	language.Add("Tool.tp3_node_editor.left","Place new (or move selected) track node.")
	language.Add("Tool.tp3_node_editor.right","Select/deselect existing track node.")
	language.Add("Tool.tp3_node_editor.reload","Delete node.")
	
	--Left Click, make a new node
	--[[
	net.Receive("tp3_ne_leftclick", function()
		local tr = net.ReadString()
		if not tr then return end
		tr = util.JSONToTable(tr)
		if not tr then return end
		if not Trakpak3.SelectedNode then --New Node
			local id = Trakpak3.GetUniqueNodeID()
			Trakpak3.NewNode(id,tr.HitPos)
			--print("Added new node "..id.." at position: ",tr.HitPos)
		else --Move Selected
			Trakpak3.NewNode(Trakpak3.SelectedNode,tr.HitPos)
			--print("Moved node "..Trakpak3.SelectedNode.." to position: ",tr.HitPos)
		end
		
	end)
	]]--
	Trakpak3.Net.tp3_ne_leftclick = function(len,ply)
		local tr = net.ReadTable()
		if not Trakpak3.SelectedNode then --New Node
			local id = Trakpak3.GetUniqueNodeID()
			Trakpak3.NewNode(id,tr.HitPos)
			--print("Added new node "..id.." at position: ",tr.HitPos)
		else --Move Selected
			Trakpak3.NewNode(Trakpak3.SelectedNode,tr.HitPos)
			--print("Moved node "..Trakpak3.SelectedNode.." to position: ",tr.HitPos)
		end
	end
	
	--Right Click, select an existing node
	--[[
	net.Receive("tp3_ne_rightclick", function()
		local tr = net.ReadString()
		if not tr then return end
		tr = util.JSONToTable(tr)
		if not tr then return end
		
		local threshold = GetConVar("tp3_node_editor_radius"):GetFloat() or 64
		local new_id = Trakpak3.FindNode(tr.HitPos,threshold)
		if new_id then
			Trakpak3.SelectedNode = new_id
			print("[Trakpak3] Selected node "..new_id.." at position: ",Trakpak3.NodeList[new_id])
		else
			Trakpak3.SelectedNode = nil
			--print("Deselected node.")
		end
		
	end)
	]]--
	Trakpak3.Net.tp3_ne_rightclick = function(len,ply)
		local tr = net.ReadTable()
		
		local threshold = GetConVar("tp3_node_editor_radius"):GetFloat() or 64
		local new_id = Trakpak3.FindNode(tr.HitPos,threshold)
		if new_id then
			Trakpak3.SelectedNode = new_id
			print("[Trakpak3] Selected node "..new_id.." at position: ",Trakpak3.NodeList[new_id])
		else
			Trakpak3.SelectedNode = nil
			--print("Deselected node.")
		end
	end
	
	--Reload, delete selected node
	--[[
	net.Receive("tp3_ne_reload", function()
		local tr = net.ReadString()
		if not tr then return end
		tr = util.JSONToTable(tr)
		if not tr then return end
		
		local node_id = Trakpak3.FindNode(tr.HitPos,GetConVar("tp3_node_editor_radius"):GetFloat() or 64)
		
		if node_id then
		
			--Remove node from all chains, if any
			local chains = Trakpak3.FindChainsWithNode(node_id)
			if chains then
				for k, chain_id in pairs(chains) do
					Trakpak3.RemoveNodeFromChain(chain_id, node_id)
				end
			end
			
			--Kill the node itself
			if Trakpak3.SelectedNode==node_id then Trakpak3.SelectedNode = nil end
			Trakpak3.DeleteNode(node_id)
			--print("Deleted node "..Trakpak3.SelectedNode)
		end
	end)
	]]--
	Trakpak3.Net.tp3_ne_reload = function(len,ply)
		local tr = net.ReadTable()
		
		local node_id = Trakpak3.FindNode(tr.HitPos,GetConVar("tp3_node_editor_radius"):GetFloat() or 64)
		
		if node_id then
		
			--Remove node from all chains, if any
			local chains = Trakpak3.FindChainsWithNode(node_id)
			if chains then
				for k, chain_id in pairs(chains) do
					Trakpak3.RemoveNodeFromChain(chain_id, node_id)
				end
			end
			
			--Kill the node itself
			if Trakpak3.SelectedNode==node_id then Trakpak3.SelectedNode = nil end
			Trakpak3.DeleteNode(node_id)
			--print("Deleted node "..Trakpak3.SelectedNode)
		end
	end
	
	--Rendering function is shared by multiple tools and is thus moved to cl_tp3lib
	
	function TOOL.BuildCPanel(panel) Trakpak3.NodeEditMenu(panel) end
end

TOOL.ClientConVar = {
	radius = "64",
	lw = "96",
	h = "192",
	offset = "16",
	drawdistance = "8192"
}

--Fake hook calling on client since these hooks are predicted
if SERVER then
	--util.AddNetworkString("tp3_ne_leftclick")
	--util.AddNetworkString("tp3_ne_rightClick")
	--util.AddNetworkString("tp3_ne_reload")
	function TOOL:LeftClick(tr)
		local ply = self:GetOwner()
		--local json = util.TableToJSON(tr)
		--net.Start("tp3_ne_leftclick")
		--net.WriteString(json)
		net.Start("trakpak3")
		net.WriteString("tp3_ne_leftclick")
		net.WriteTable(tr)
		net.Send(ply)
		return true
	end
	function TOOL:RightClick(tr)
		local ply = self:GetOwner()
		--local json = util.TableToJSON(tr)
		--net.Start("tp3_ne_rightclick")
		--net.WriteString(json)
		net.Start("trakpak3")
		net.WriteString("tp3_ne_rightclick")
		net.WriteTable(tr)
		net.Send(ply)
		return true
	end
	function TOOL:Reload(tr)
		local ply = self:GetOwner()
		--local json = util.TableToJSON(tr)
		--net.Start("tp3_ne_reload")
		--net.WriteString(json)
		net.Start("trakpak3")
		net.WriteString("tp3_ne_reload")
		net.WriteTable(tr)
		net.Send(ply)
		return true
	end
end