/*
This is installer for GameScripts
https://github.com/veskeli/GameScriptsByVeskeli
*/
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
;Vars
ShortcutState = 1
AppInstallLocation = 
ScriptName = GameScripts
AppFolderName = AHKGameScriptsByVeskeli
AppFolder = %A_AppData%\%AppFolderName%
AppSettingsFolder = %AppFolder%\Settings
GuiPictureFolder = %AppFolder%\Gui
AppSettingsIni = %AppSettingsFolder%\Settings.ini

Menu Tray, Icon, shell32.dll, 163

Gui -MinimizeBox -MaximizeBox
Gui Font, s9, Segoe UI
Gui Add, CheckBox, x8 y168 w123 h23 +Checked vShortCutToDesktop gSaveShortToDesk, Shortcut to desktop
Gui Add, GroupBox, x3 y80 w496 h77, Install as:
Gui Add, Radio, x8 y120 w47 h23 vInstallAsAhk gUpdateInstallAs, .ahk
Gui Add, Radio, x8 y96 w129 h23 +Checked vInstallAsExe gUpdateInstallAs, .exe (Recommended)
Gui Add, Text, x144 y88 w354 h66, If exe (Recommended) is selected the script installs Exe Runner.`nExe Runner is a simple Run script compiled to exe. (You can always revert in settings).`nWith exe, you can pin this app to the taskbar and get the app icon.
Gui Add, Edit, x16 y32 w469 h21 vLocation,% A_ProgramFiles . "\" . AppFolderName
Gui Add, GroupBox, x3 y8 w491 h77, Where should GameScript be installed?
Gui Add, Button, x400 y56 w86 h23 vChangeLocation gChangeFolder, Change
Gui Add, CheckBox, x144 y168 w149 h23 +Disabled, Install Script Repair tool
Gui Add, Text, x8 y56 w302 h23 +0x200, (Main Script and settings are always stored in AppData.)
Gui Add, Button, x320 y208 w90 h23 gInstallScript, Install
Gui Add, Button, x416 y208 w80 h23 gCancelInstall, Cancel
Gui Add, Text, x0 y200 w505 h2 +0x10
Gui Add, CheckBox, x296 y168 w183 h23 +Checked vDeleteThis, Delete this script after install
Gui Add, CheckBox, x311 y56 w87 h23 gToggleOnlyDesktop vOnlyDesktop, Only Desktop

Gui Show, w504 h237, Game Scripts Installer
Return

GuiEscape:
GuiClose:
CancelInstall:
    ExitApp
ChangeFolder:
FileSelectFolder, OutputVar, , 3
if OutputVar =
    GuiControl,,Location,% A_ProgramFiles . "\" . AppFolderName
else
    GuiControl,,Location,% OutputVar . "\" . AppFolderName
return
UpdateInstallAs:
Gui, Submit, Nohide
if(InstallAsExe)
{
    GuiControl,Enable,ShortCutToDesktop
    GuiControl,,ShortCutToDesktop,%ShortcutState%
}
else
{
    GuiControl,Disable,ShortCutToDesktop
    GuiControl,,ShortCutToDesktop,0
}
return
SaveShortToDesk:
Gui, Submit, Nohide
ShortcutState = %ShortCutToDesktop%
return
ToggleOnlyDesktop:
Gui, Submit, Nohide
if(OnlyDesktop)
{
    GuiControl,Disable,Location
    GuiControl,Disable,ChangeLocation
    GuiControl,Disable,ShortCutToDesktop
    GuiControl,,ShortCutToDesktop,0
}
else
{
    GuiControl,Enable,Location
    GuiControl,Enable,ChangeLocation
    GuiControl,Enable,ShortCutToDesktop
    GuiControl,,ShortCutToDesktop,%ShortcutState%
}
Return
InstallScript:
Gui, Submit, Nohide
;Create all folders
FileCreateDir,%AppFolder%
FileCreateDir,%AppSettingsFolder%
;Download main script to Appdata
UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/GameScripts.ahk,% AppFolder . "\" . ScriptName . ".ahk"
if(OnlyDesktop)
{   
    AppInstallLocation = %A_Desktop%
}
else
{
    AppInstallLocation = %Location%
    IfNotExist, %AppInstallLocation%
        FileCreateDir,%AppInstallLocation%
}
;install exe or ahk
if(InstallAsExe)
{
    IniWrite,true,%AppSettingsIni%, ExeRunner, UsingExeRunner
    IniWrite,%AppInstallLocation%,%AppSettingsIni%, ExeRunner, OldAhkFileLocation
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/exe/GameScripts.exe,% AppInstallLocation . "\" . ScriptName . ".exe"
}
else
{
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/exe/GameScripts.ahk,% AppInstallLocation . "\" . ScriptName . ".ahk"
}
IniWrite,%AppInstallLocation%,%AppSettingsIni%, install, InstallFolder
;create shortcut
if(ShortCutToDesktop)
{
    FileCreateShortcut,% Location . "\" . ScriptName . ".exe",% A_Desktop . "\" . ScriptName . ".lnk"
}
;Would you like to open the script?
MsgBox, 4,Install successful, Would you like to open the script?
IfMsgBox Yes
{
    run,% AppFolder . "\" . ScriptName . ".ahk"
    if(DeleteThis)
    {
        FileDelete, %A_ScriptFullPath%
    }
    ExitApp
}
;Delete this script
if(DeleteThis)
{
    FileDelete, %A_ScriptFullPath%
    ExitApp
}
Return