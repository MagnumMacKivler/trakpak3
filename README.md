# Trakpak 3 Developer Resources

Trakpak 3.0 Release Version, Copyright 2019-2021 by Magnum MacKivler

Trakpak3 is officially released! If you're trying to install it just to use it in-game, please use the [Workshop Addon](https://steamcommunity.com/sharedfiles/filedetails/?id=2379202601) instead. The files on this Github are intended for mappers and developers.

## Instructions for Installation (For Mappers)

1. Download the [Latest Release](https://github.com/MagnumMacKivler/trakpak3/releases)'s Source Code zip file and navigate into the `trakpak3-master` folder.
2. Navigate into the `Hammer` folder and place `trakpak3.fgd` into `GarrysMod/bin`.
3. Download the test VMFs to wherever you want Hammer to load them from (typically `GarrysMod/bin` but I recommend making a subfolder for VMFs).
4. Navigate into the `Gmod` folder and merge `addons` and `data` with your Garry's Mod's `addons` and `data` folders.

*The following step is required to get Gmod Hammer to load from the legacy addon you made:*

5. Merge `cfg` with your Garry's Mod's `cfg` folder (this will overwrite your `mount.cfg` file!).

**OR**

5. Open your existing `cfg/mount.cfg` and add the following line inside the {} block:

`"trakpak3"	"C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod\addons\trakpak3" // Trakpak3`

(Obviously, if you have Steam installed on a different drive (not C:\), be sure to change the drive in the file path.)

If you want to use the Trakpak3 assets in a different source mod (Source SDK 2013 in order to use Propper), you will have to copy the materials and models into the folder you use. Because the folder can be different for every user, I will not detail that here - I trust you already know what you're doing.

### To-Do Lists

[Master To-Do List](https://github.com/MagnumMacKivler/trakpak3/projects/1)

[Wiki To-Do List](https://github.com/MagnumMacKivler/trakpak3/projects/2)

[Bug Tracker](https://github.com/MagnumMacKivler/trakpak3/projects/3)

### Community Contribution

Thanks to all the members of our community who helped (and continue to help) make this project a reality!

* MrLazorz
* GrovestreetGman
* ThaPatMan54
* Titus Studios
* Griggs
* The Southeastern Railway Museum
* Engineer Productions
