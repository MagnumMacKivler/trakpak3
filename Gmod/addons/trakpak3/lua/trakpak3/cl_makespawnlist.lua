local id = 201630 --20 (T), 16 (P), 3 (3), 0

local function prettify(name)
	local words = string.Explode("_",name)
	local newname = ""
	for n = 1, #words do
		local word = words[n]
		local start = string.upper(word[1])
		word = string.SetChar(word,1,start)
		if n > 1 then newname = newname.." " end
		newname = newname..word
	end
	
	return newname
end

local function getSubFolderModels(dir)
	--dir is formatted "folder/folder/folder"
	local files, folders = file.Find(dir.."/*","THIRDPARTY")
	local da = string.Explode("/",dir)
	local dirname = da[#da]
	
	local contents = {}
	
	--Add all files in main folder
	
	for k, filename in pairs(files) do
		if string.Right(filename,3)=="mdl" then
			table.insert(contents, {
				type = "model",
				model = dir.."/"..filename
			})
		end
	end
	
	--Perform Recursively for all subfolders
	
	if #folders > 0 then
		for k, foldername in pairs(folders) do
			--print("found subfolder: "..foldername)
			local sfc = getSubFolderModels(dir.."/"..foldername)
			table.insert(contents, {
				type = "header",
				text = prettify(foldername)
			})
			table.Add(contents,sfc)
		end
	end
	
	return contents
	
end


--[[
local function makeSpawnlistFromFolder(dir, parent)
	--dir is formatted "folder/folder/folder"
	
	local myid = id
	local files, folders = file.Find(dir.."/*","THIRDPARTY")
	
	print("Searching folder "..dir..", id "..myid..", parent "..parent)
	
	local da = string.Explode("/",dir)
	local dirname = da[#da]
	
	--Add all files in folder
	local contents = {}
	
	for k, filename in pairs(files) do
		if string.Right(filename,3)=="mdl" then
			table.insert(contents, {
				type = "model",
				model = dir.."/"..filename
			})
		end
	end
	
	--if dir=="models/trakpak3_us/signals/colorlight" then PrintTable(contents) end
	
	spawnmenu.AddPropCategory("Trakpak3_"..myid, dirname, contents, "icon16/folder_table.png", myid, parent)
	id = id + 1
	
	--Do for all subfolders recursively
	
	if #folders > 0 then
		for k, foldername in pairs(folders) do
			makeSpawnlistFromFolder(dir.."/"..foldername, myid)
			id = id + 1
		end
	end
	
end
]]--

hook.Add("PopulatePropMenu","Trakpak3_GenSpawnlist",function()
	--Create base category
	local myid = id
	spawnmenu.AddPropCategory("Trakpak3_Base","Trakpak3",{},"icon16/folder_table.png",myid,0)
	id = id + 1
	
	--Start the recursive chains of subfolders
	local files, folders = file.Find("models/trakpak3_*","THIRDPARTY")
	if #folders > 0 then
		for k, foldername in pairs(folders) do
			--makeSpawnlistFromFolder("models/"..foldername, myid)
			local contents = getSubFolderModels("models/"..foldername)
			spawnmenu.AddPropCategory("Trakpak3_"..id, foldername, contents, "icon16/folder_table.png", id, myid)
			id = id + 1
		end
	end
	
	--PrintTable(getSubFolderModels("models/trakpak3_ca"))
	
end)