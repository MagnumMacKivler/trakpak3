local id = 201630 --20 (T), 16 (P), 3 (3), 0

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

--[[
hook.Add("PopulatePropMenu","Trakpak3_GenSpawnlist",function()
	--Create base category
	local myid = id
	spawnmenu.AddPropCategory("Trakpak3_Base","Trakpak3",{},"icon16/folder_table.png",myid,0)
	spawnmenu.AddPropCategory("Trakpak3_1","trakpak3_rsg",{},"icon16/folder_table.png",myid+1,myid)
	spawnmenu.AddPropCategory("Trakpak3_2","trakpak3_us",{},"icon16/folder_table.png",myid+2,myid)
	id = id + 1
	
	--Start the recursive chains of subfolders
	local files, folders = file.Find("models/trakpak3_*","THIRDPARTY")
	if #folders > 0 then
		for k, foldername in pairs(folders) do
			makeSpawnlistFromFolder("models/"..foldername, myid)
			id = id + 1
		end
	end
	
end)
]]--
