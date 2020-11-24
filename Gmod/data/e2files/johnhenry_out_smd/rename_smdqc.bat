REM --John Henry Automatic File Copier/Renamer V1.1 by Magnum, SMD/QC Edition--
REM Copy this Batch file into every folder you want to synchronize to propsource

REM Set this to your johnhenry_out_smd folder (located in Garry's Mod\data\e2files)
SET jhfolder=D:\Program Files (x86)\Steam\SteamApps\common\GarrysMod\garrysmod\data\e2files\johnhenry_out_smd

REM Set this to your propsource folder (from which studioMDL will load the SMD/QC files)
SET binfolder=D:\propsource

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
CD /D "%binfolder%"
MKDIR "%foldertomake%"

REM Rename TXTs to SMD and QC and Copy files over...
CD /D "%originaldir%\temp"
REN "*_ref.txt" "*.smd"
REN "*_throw.txt" "*.smd"
REN "*_phys.txt" "*.smd"
REN "*_qc.txt" "*.qc"
COPY /Y "*.smd" "%binfolder%\%foldertomake%"
COPY /Y "*.qc" "%binfolder%\%foldertomake%"

REM Delete Temp Folder
CD /D "%originaldir%"
RD /S /Q temp

pause