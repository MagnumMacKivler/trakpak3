TOOL.Category = "Trakpak3 Dev Tools"
TOOL.Name = "Node Chainer"
TOOL.Command = nil
TOOL.Configname = ""

if CLIENT then
	
	--[[
	
	List of operations:
	
	Select/deselect a node chain handle (Left on handle)
	Clear a node chain (Reload on handle)
	Add a node to selected chain (Left on node)
	Remove node from selected chain (Reload on node)
	Insert a node to selected chain (Right on node, then Right on insertnode, Reload to cancel)
	Toggle a node's skip status (E + Left on node)
	
	]]--
	
	
	TOOL.Information_Normal = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
		{ name = "left_use", icon2 = "gui/e.png" }
	}

	TOOL.Information_Insert = {
		{ name = "right" },
		{ name = "reload" }
		
	}
	language.Add("Tool.tp3_node_chainer.name","Trakpak3 Node Chainer")
	language.Add("Tool.tp3_node_chainer.desc","Manages chains of Trakpak3 track nodes. For use by mappers only!")
	
	function TOOL:SetupGuiNormal()
		self.Information = self.Information_Normal
		language.Add("Tool.tp3_node_chainer.left","Select a node chain to edit. / Add node to the end of the selected chain.")
		language.Add("Tool.tp3_node_chainer.right", "Select a node to insert (before another node) into the chain.")
		language.Add("Tool.tp3_node_chainer.reload","Clear a node chain. / Remove node from the selected chain.")
		language.Add("Tool.tp3_node_chainer.left_use","Toggle a node's 'skip' status.")
	end
	
	function TOOL:SetupGuiInsert()
		self.Information = self.Information_Insert
		language.Add("Tool.tp3_node_chainer.right","Select a node to insert before.")
		language.Add("Tool.tp3_node_chainer.reload","Cancel insert.")
	end
	
	
	TOOL:SetupGuiNormal()
	Trakpak3.inserting = false
	TOOL.iflag = false
	
	function TOOL:Deploy()
		Trakpak3.inserting = false
		Trakpak3.SelectedNode = nil
		self:SetupGuiNormal()
	end
	
	--Left Click
	net.Receive("tp3_nc_leftclick", function()
	
		if Trakpak3.inserting then return end
		
		local tr = net.ReadString()
		if not tr then return end
		tr = util.JSONToTable(tr)
		if not tr then return end
		
		local use = net.ReadBool()
		
		if use then --Toggle Skip for node
			if Trakpak3.SelectedNodeChain then
				local node_id = Trakpak3.FindNode(tr.HitPos,GetConVar("tp3_node_editor_radius"):GetFloat() or 64)
				local valid, seq = Trakpak3.IsNodeInChain(node_id, Trakpak3.SelectedNodeChain)
				if valid then Trakpak3.SetNodeSkip(Trakpak3.SelectedNodeChain, node_id, not Trakpak3.NodeChainList[Trakpak3.SelectedNodeChain].Skips[seq]) end
			end
		else --Select/deselect chain; add node
			local node_id = Trakpak3.FindNode(tr.HitPos,GetConVar("tp3_node_editor_radius"):GetFloat() or 64)
			if node_id then --add node
				if Trakpak3.SelectedNodeChain then Trakpak3.AddNodeToChain(Trakpak3.SelectedNodeChain, node_id, false) end
			else --find a block
				local block_name = Trakpak3.FindNodeChainHandle(tr.HitPos,GetConVar("tp3_node_editor_radius"):GetFloat() or 64)
				if block_name then --select block
					Trakpak3.SelectedNodeChain = block_name
				else --deselect block
					Trakpak3.SelectedNodeChain = nil
				end
			end
		end
		
	end)
	
	--Right Click
	net.Receive("tp3_nc_rightclick", function()
		local tr = net.ReadString()
		if not tr then return end
		tr = util.JSONToTable(tr)
		if not tr then return end
		
		local node_id = Trakpak3.FindNode(tr.HitPos,GetConVar("tp3_node_editor_radius"):GetFloat() or 64)
		
		if node_id and Trakpak3.SelectedNodeChain then
			if not Trakpak3.inserting then --select node to insert
				Trakpak3.inserting = true
				Trakpak3.SelectedNode = node_id
				
			else --insert
				Trakpak3.AddNodeToChain(Trakpak3.SelectedNodeChain, Trakpak3.SelectedNode, false, node_id)
				Trakpak3.inserting = false
				Trakpak3.SelectedNode = nil
				
			end
		end
	end)
	
	--Reload
	net.Receive("tp3_nc_reload", function()
		local tr = net.ReadString()
		if not tr then return end
		tr = util.JSONToTable(tr)
		if not tr then return end
		
		if Trakpak3.inserting then --cancel insert
			Trakpak3.inserting = false
			Trakpak3.SelectedNode = nil
		else --remove node or clear chain
			local node_id = Trakpak3.FindNode(tr.HitPos,GetConVar("tp3_node_editor_radius"):GetFloat() or 64)
			if node_id and Trakpak3.SelectedNodeChain then --remove node from chain
				Trakpak3.RemoveNodeFromChain(Trakpak3.SelectedNodeChain,node_id)
			else --find node chain to clear
				local block_name = Trakpak3.FindNodeChainHandle(tr.HitPos,GetConVar("tp3_node_editor_radius"):GetFloat() or 64)
				if block_name then --clear block
					Trakpak3.NodeChainList[block_name].Nodes = {}
					Trakpak3.NodeChainList[block_name].Skips = {}
				end
			end
		end
		
	end)
	
	function TOOL:Think()
		if Trakpak3.inserting and not self.iflag then
			self.iflag = true
			self:SetupGuiInsert()
		elseif not Trakpak3.inserting and self.iflag then
			self.iflag = false
			self:SetupGuiNormal()
		end
	end
	
	function TOOL.BuildCPanel(panel) Trakpak3.NodeEditMenu(panel) end
	
end

--Fake hook calling on client since these hooks are predicted
if SERVER then
	util.AddNetworkString("tp3_nc_leftclick")
	util.AddNetworkString("tp3_nc_rightclick")
	util.AddNetworkString("tp3_nc_reload")
	function TOOL:LeftClick(tr)
		local ply = self:GetOwner()
		local json = util.TableToJSON(tr)
		local k_use = self:GetOwner():KeyDown(IN_USE)
		net.Start("tp3_nc_leftclick")
		net.WriteString(json)
		net.WriteBool(k_use)
		net.Send(ply)
		return true
	end
	function TOOL:RightClick(tr)
		local ply = self:GetOwner()
		local json = util.TableToJSON(tr)
		net.Start("tp3_nc_rightclick")
		net.WriteString(json)
		net.Send(ply)
		return true
	end
	function TOOL:Reload(tr)
		local ply = self:GetOwner()
		local json = util.TableToJSON(tr)
		net.Start("tp3_nc_reload")
		net.WriteString(json)
		net.Send(ply)
		return true
	end
end