# Trakpak 3 Developer Resources

Trakpak 3.0 "Beta", Copyright 2019-2020 by Magnum MacKivler

(I'm only calling it Beta because there was technically an Alpha like, a year ago, to test out standard gauge physics.)

Trakpak3 is currently in development. This will be the master list for materials, models, brushwork, and other things needed to develop for trakpak. I'm changing my plan for Trakpak3's release schedule. Instead of releasing everything at once (which will take a great deal of time), I plan to release an initial set of resources, enough to get people (including myself) started on mapping, and the rest will be filled in as time goes by.

**The files uploaded here are incomplete and unfinished. Downloading trakpak3 at the current stage of development is NOT recommended!**

But since you're going to do it anyway, I might as well tell you how.

1. Download the Source Code zip file and navigate into the `trakpak3-master` folder.
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
