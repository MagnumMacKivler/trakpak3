REM --John Henry Automatic File Copier/Renamer V1.0 by Magnum--
REM Copy this Batch file into every folder you want to synchronize to Hammer

REM Set this to your johnhenry_out folder (located in Garry's Mod\data\e2files)
SET jhfolder=D:\Program Files (x86)\Steam\SteamApps\common\GarrysMod\garrysmod\data\e2files\johnhenry_out_vmf

REM Set this to your bin folder (from which Hammer will load VMF files)
SET binfolder=D:\Program Files (x86)\Steam\steamapps\common\Source SDK Base 2013 Multiplayer\bin\propper_vmfs

REM --End of Config--

REM Get folder structure...
SET originaldir=%cd%
SET currentdir="%cd%"
SET blankstr=
CALL SET foldertomake=%%currentdir:%jhfolder%\=%blankstr%%%

REM Create Temp Folder and copy TXTs into it
MKDIR temp
COPY "*.txt" "temp"

REM Make destination folders...
CD "%binfolder%"
MKDIR "%foldertomake%"

REM Rename TXTs to VMFs and Copy VMFs over...
CD "%originaldir%\temp"
REN "*.txt" "*.vmf"
COPY /Y "*.vmf" "%binfolder%\%foldertomake%"

REM Delete Temp Folder
CD "%originaldir%"
RD /S /Q temp

pause