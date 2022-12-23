#SingleInstance, Force
#KeyHistory, 0
SetBatchLines, -1
ListLines, Off
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , GameScripts
#MaxThreadsPerHotkey, 4 ; no re-entrant hotkey handling
; DetectHiddenWindows, On
SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag
#Persistent
;____________________________________________________________
UpdaterVersion = 0.25
global UpdaterVersion
;____________________________________________________________
;//////////////[Folders]///////////////
ScriptName = GameScripts
AppFolderName = AHKGameScriptsByVeskeli
AppFolder = %A_AppData%\%AppFolderName%
AppSettingsFolder = %AppFolder%\Settings
AppUpdaterFile = %AppFolder%\Updater.ahk
GuiPictureFolder = %AppFolder%\Gui
MainScriptFile = %AppFolder%\%ScriptName%
MainScriptAhkFile = %AppFolder%\%ScriptName%.ahk
AppUpdaterSettingsFile = %AppFolder%\UpdaterInfo.ini
AppVersionSettingsFile = %AppFolder%\VersionInfo.ini
AppScriptTempFile = %A_ScriptDir%\GameSciptTemp.ini
;//////////////[Other Scripts]///////////////
AppGamingScriptsFolder = %AppFolder%\GamingScripts
AppOtherScriptsFolder = %AppFolder%\OtherScripts
;//////////////[ini]///////////////
AppSettingsIni = %AppSettingsFolder%\Settings.ini
AppGameScriptSettingsIni = %AppSettingsFolder%\GameScriptSettings.ini
AppHotkeysIni = %AppSettingsFolder%\Hotkeys.ini
AppVersionIdListIni = %AppFolder%\temp\VersionIdList.ini
AppPreVersionsIni = %AppFolder%\temp\PreVersions.ini
AppOtherScriptsIni = %AppOtherScriptsFolder%\OtherScripts.ini
;//////////////[Update]///////////////
AppUpdateFile = %AppFolder%\temp\OldFile.ahk
;//////////////[Script Dir]///////////////
ScriptFullPath = 
T_SkipShortcut = false
FixUserLocation = false
ShortcutState = 1
AppInstallLocation = 
;____________________________________________________________
;//////////////[Main Script]///////////////
ExecuteAsUpdater := false
ExecuteAsVersionControl := false
if (FileExist(AppUpdaterSettingsFile))
{
    ExecuteAsUpdater := true
}
If (FileExist(AppVersionSettingsFile))
{
    ExecuteAsVersionControl := true
}
If (FileExist(MainScriptFile))
{
    MsgBox, , Test, Found!, 20
}
if (ExecuteAsUpdater)
{
    iniread,version,%AppUpdaterSettingsFile%,Options,Version
    iniread,MainScriptFile,%AppUpdaterSettingsFile%,Options,ScriptFullPath
    iniread,MainScriptBranch,%AppUpdaterSettingsFile%,Options,Branch
    global version
    global MainScriptFile
    global MainScriptBranch
    FileDelete,%AppUpdaterSettingsFile%

    UpdateScript(true,MainScriptBranch)
    CheckForUpdaterUpdates()
    ExitApp
}
if (ExecuteAsVersionControl)
{
    FileDelete, %AppVersionSettingsFile%
    ExitApp
}
;Execute as installer
if (!ExecuteAsVersionControl && !ExecuteAsUpdater)
{
    if(!A_IsAdmin && false == true)
    {
        IniWrite, %A_Appdata%, AppScriptTempFile, AppData, Correct
        IniWrite, %A_UserName%, AppScriptTempFile, AppData, CorrectUser
        IniWrite, %A_Desktop%, AppScriptTempFile, AppData, CorrectDesktop
        try{
            Run *RunAs %A_ScriptFullPath%
        }
        catch{
            FileDelete, AppScriptTempFile
            MsgBox,, Install aborted!, Installer needs to be executed as administrator, 7
            ExitApp
        }
        ExitApp
    }
    if (FileExist(AppScriptTempFile))
    {
        IniRead, CorrectAppDataFolder,AppScriptTempFile, AppData, Correct
        IniRead, CorrectDesktop,AppScriptTempFile, AppData, CorrectDesktop
        IniRead, CorrectUser,AppScriptTempFile, AppData, CorrectUser
        FileDelete, AppScriptTempFile
    }
    if(CorrectAppDataFolder != "Error" and CorrectAppDataFolder != "")
        AppFolder = %CorrectAppDataFolder%\%AppFolderName%
    if(CorrectUser != A_UserName)
    {
        FixUserLocation := true
    }
    Menu Tray, Icon, shell32.dll, 163

    Gui -MinimizeBox -MaximizeBox
    Gui Font, s9, Segoe UI
    Gui Add, CheckBox, x8 y168 w123 h23 +Checked vShortCutToDesktop gSaveShortToDesk, Shortcut to desktop
    Gui Add, GroupBox, x3 y80 w496 h77, Install as:
    Gui Add, Radio, x8 y120 w47 h23 vInstallAsAhk gUpdateInstallAs, .ahk
    Gui Add, Radio, x8 y96 w129 h23 +Checked vInstallAsExe gUpdateInstallAs, .exe (Recommended)
    Gui Add, Text, x144 y88 w354 h66, If exe (Recommended) is selected the script installs Exe Runner.`nExe Runner is a simple Run script compiled to exe. (You can always revert in settings).`nWith exe, you can pin this app to the taskbar and get the app icon.
    Gui Add, Edit, x16 y32 w469 h21 vLocation,% A_AppData . "\" . AppFolderName
    Gui Add, GroupBox, x3 y8 w491 h77, Where should GameScript be installed?
    Gui Add, Button, x400 y56 w86 h23 vChangeLocation gChangeFolder, Change
    Gui Add, CheckBox, x144 y168 w149 h23 +Disabled, Install Script Repair tool
    Gui Add, Text, x8 y56 w302 h23 +0x200, (Main Script and settings are always stored in AppData.)
    Gui Add, Button, x320 y208 w90 h23 vInstallScriptButton gInstallScript, Install
    Gui Add, Button, x416 y208 w80 h23 gCancelInstall, Cancel
    Gui Add, Text, x0 y200 w505 h2 +0x10
    Gui Add, CheckBox, x296 y168 w183 h23 +Checked +disabled vDeleteThis, Delete this script after install
    Gui Add, CheckBox, x311 y56 w87 h23 gToggleOnlyDesktop vOnlyDesktop, Only Desktop

    Gui Show, w504 h237, Game Scripts Installer
    Return
}
;____________________________________________________________
;//////////////[updater]///////////////
UpdateScript(T_CheckForUpdates,T_Branch)
{
    if(T_Branch == "main" or T_Branch == "Experimental" or T_Branch == "PreRelease")  ;Check that branch is correctly typed
    {
        newversion := GetNewVersion(T_Branch)
        if(newversion == "ERROR")
        {
            MsgBox,,Update ERROR!,New Version Error!`nError while getting new version,15
            return
        }
        if(T_CheckForUpdates) ;If normal Check and update
        {
            if(newversion > version)
            {
                if(T_Branch == "main")
                {
                    UpdateText := % "New version is: " . newversion . "`nOld is: " . version .  "`nUpdate now?"
                }
                else if(T_Branch == "PreRelease")
                {
                    UpdateText := % "New Pre-Release is: " . newversion . "`nOld is: " . version .  "`nUpdate now?"
                }
                else if(T_Branch == "Experimental")
                {
                    UpdateText := % "New Experimental version is: " . newversion . "`nOld is: " . version .  "`nUpdate now?"
                }
                MsgBox, 4,Update,%UpdateText%
                IfMsgBox, Yes
                {
                    TForceUpdate(newversion,T_Branch)
                }
                Else
                {
                    return "ERROR"
                }
            }
        }
        else    ;Force update/Download
        {
            msgbox, Force Download Called!?!
            ;TForceUpdate(newversion,T_Branch)
        }
    }
    else
    {
        ExitApp
    }
}
GetNewVersion(T_Branch)
{
    ;Build link
    VersionLink := % "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_Branch . "/version.txt"
    ;Get Version Text
    T_NewVersion := ReadFileFromLink(VersionLink)
    if(T_NewVersion == "ERROR")
    {
        ;msgbox,,No Internet Connection!,No Internet Connection!
        return
    }
    ;Check that not empty or not found
    if(T_NewVersion != "" and T_NewVersion != "404: Not Found" and T_NewVersion != "500: Internal Server Error" and T_NewVersion != "400: Invalid request")
    {
        Return T_NewVersion
    }
    else
    {
        return "ERROR"
    }
}
ReadFileFromLink(Link)
{
    try
    {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", Link, False)
        whr.Send()
        whr.WaitForResponse()
        TResponse := whr.ResponseText
    }
    Catch T_Error
    {
        return "ERROR"
    }
    return TResponse
}
;Activate Download
TForceUpdate(newversion,T_Branch)
{
    msgbox, starting
    ;Check That if script is running
    SetTitleMatchMode, 2
    DetectHiddenWindows, On
    If WinExist("GameScripts.ahk" . " ahk_class AutoHotkey")
    {
        ;Stop Script
        WinClose
    }
    ;Update Script
    ForceUpdate(newversion,T_Branch)
}
ForceUpdate(newversion,T_Branch)
{
    ;Save branch
    IniWrite, %T_Branch%,%AppSettingsIni%,Branch,Instance1
    ;Download update
    SplashTextOn, 250,50,Downloading...,Downloading new version.`nVersion: %newversion%
    FileDelete, %MainScriptFile%
    DownloadLink := % "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_Branch . "/GameScripts.ahk"
    UrlDownloadToFile, %DownloadLink%, %MainScriptFile%
    SplashTextOff
    loop
    {
        if (FileExist(MainScriptAhkFile))
        {
            Run, %MainScriptAhkFile%
            ExitApp
        }
    }
    ExitApp
}
CheckForUpdaterUpdates()
{
    newversion := GetNewUpdaterVersion(MainScriptBranch)
    if(newversion == "ERROR")
    {
        ExitApp
    }
    if(newversion > UpdaterVersion)
    {
        ForceUpdateUpdater(newversion)
    }
}
GetNewUpdaterVersion(T_Branch)
{
    ;Build link
    VersionLink := % "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_Branch . "/UpdaterVersion.txt"
    ;Get Version Text
    T_NewVersion := ReadFileFromLink(VersionLink)
    if(T_NewVersion == "ERROR")
    {
        ExitApp
    }
    ;Check that not empty or not found
    if(T_NewVersion != "" and T_NewVersion != "404: Not Found" and T_NewVersion != "500: Internal Server Error")
    {
        Return T_NewVersion
    }
    else
    {
        ExitApp
    }
}
ForceUpdateUpdater(newversion)
{
    FileCreateDir, %AppFolder%\temp
    FileMove, %A_ScriptFullPath%, %AppUpdateFile%, 1
    DownloadLink := % "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . MainScriptBranch . "/Updater.ahk"
    UrlDownloadToFile, %DownloadLink%, %A_ScriptFullPath%
    ExitApp
}
;____________________________________________________________
;//////////////[Installer]///////////////
GuiEscape:
GuiClose:
CancelInstall:
    ExitApp
ChangeFolder:
FileSelectFolder, OutputVar, , 3
if OutputVar =
    GuiControl,,Location,% A_AppData . "\" . AppFolderName
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
;Disable all Buttons
SetControlState("Disable")
;Check if already installed
if (FileExist(MainScriptAhkFile))
{
    IniRead, InstalledCheck, %AppSettingsIni%, install, installFolder, Default
    if(InstalledCheck != "Error" or InstalledCheck != "")
    {
        MsgBox, 4,Already installed, Already installed!`ncontinue?
        IfMsgBox No
        {
            SetControlState("Enable")
            Return
        }
    }
}
Progress, b w300, Creating folders, Installing script..., Installing script...
;Create all folders
FileCreateDir,%AppFolder%
FileCreateDir,%AppSettingsFolder%
;Download main script to Appdata
Progress, b w300, Downloading main script, Installing script..., Installing script...
Progress, 30
try{
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/GameScripts.ahk,% AppFolder . "\" . ScriptName . ".ahk"
}
Catch
{
    Progress, Off
    if(A_IsAdmin)
    {
        MsgBox,,Error,Script is already running as admin`nTry to download Newer or older installer!
        ExitApp
    }
    MsgBox, 4,Install Error, [Main script] URL Download Error `nInstall Can't continue`nWould you like to restart as admin?
    IfMsgBox Yes
    {
        Run *RunAs %A_ScriptFullPath%
        ExitApp
    }
    Else
    {
        SetControlState("Enable")
        Return
    }
}
Progress, b w300, Creating subfolders, Installing script..., Installing script...
Progress, 50
if(OnlyDesktop)
{   
    AppInstallLocation = %A_Desktop%
}
else
{
    AppInstallLocation = %Location%
    if(!FileExist(AppInstallLocation))
    {
        try{
            FileCreateDir,%AppInstallLocation%
        }
        Catch{
            Progress, Off
            if(!A_IsAdmin && !FileExist(AppInstallLocation))
            {
                MsgBox, 4,Install Error, Can't create folders without administrator privilages. `nfolder: %AppInstallLocation% `nWould you like to run this script as admin?
                IfMsgBox Yes
                {
                    Run *RunAs %A_ScriptFullPath%
                    ExitApp
                }
                Else
                {
                    if (FileExist(AppFolder),"D")
                        FileRemoveDir, %AppFolder%, 1
                    ExitApp
                }
            }
            Else if(A_IsAdmin)
            {
                MsgBox, 4,Install Error, Can't create folders. `nfolder: %AppInstallLocation% `nPossible fix: Change install location`nWould You like to still continue? (Not recomended!)
                IfMsgBox No
                {
                    if (FileExist(AppFolder),"D")
                        FileRemoveDir, %AppFolder%, 1
                    ExitApp
                }
            }
        }
    }
}
Progress, b w300, Settings default settings, Installing script..., Installing script...
Progress, 60
;install exe or ahk
if(InstallAsExe)
{
    Progress, b w300, Downloading files..., Installing script..., Installing script...
    Progress, 80
    IniWrite,true,%AppSettingsIni%, ExeRunner, UsingExeRunner
    IniWrite,%AppInstallLocation%,%AppSettingsIni%, ExeRunner, OldAhkFileLocation
    UrlDownloadToFile, https://github.com/veskeli/GameScriptsByVeskeli/raw/main/exe/GameScripts.exe,% AppInstallLocation . "\GameScripts.exe"
}
else
{
    Progress, b w300, Downloading files..., Installing script..., Installing script...
    Progress, 80
    try{
        UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/exe/GameScripts.ahk,% AppInstallLocation . "\GameScripts.ahk"
    }
    Catch{
        Progress, Off
        MsgBox, 4,Install Error, [Exe Runner] URL Download failed. `nWould you like to continue?`nYou can Download [Exe runner] in settings later
        IfMsgBox No
        {
            if (FileExist(AppFolder),"D")
                FileRemoveDir, %AppFolder%, 1
            if(!OnlyDesktop)
            {
                AppProgramFolder = % A_AppData . "\" . AppFolderName
                if (FileExist(AppProgramFolder))
                    FileRemoveDir, AppProgramFolder, 1
            }
            SetControlState("Enable")
            Return
        }
        Else
        {
            T_SkipShortcut := true
        }
    }
}
IniWrite,%AppInstallLocation%,%AppSettingsIni%, install, InstallFolder
;Use correct appdata
if(FixUserLocation)
{
    IniWrite, %CorrectAppDataFolder%,%AppSettingsIni%,Appdata,Correct
    IniWrite, %CorrectDesktop%,%AppSettingsIni%,Appdata,CorrectDesktop
    IniWrite, true,%AppSettingsIni%,Appdata,UseCorrectFolder
}
;create shortcut
if(ShortCutToDesktop)
{
    if(T_SkipShortcut != "true")
    {
        if(FixUserLocation)
        {
            FileCreateShortcut,% AppInstallLocation . "\" . ScriptName . ".exe",% CorrectDesktop . "\" . ScriptName . ".lnk"
        }
        Else
        {
            FileCreateShortcut,% AppInstallLocation . "\" . ScriptName . ".exe",% A_Desktop . "\" . ScriptName . ".lnk"
        }
    }
}
Progress, Off
;Would you like to open the script?
MsgBox, 4,Install successful, Would you like to open the script?
IfMsgBox Yes
{
    run,% AppFolder . "\" . ScriptName . ".ahk"
    if(DeleteThis)
    {
        FileMove, %A_ScriptFullPath%, %AppUpdaterFile%, 1
    }
    ExitApp
}
;Move this as udpater to script folder
if(DeleteThis)
{
    ;FileDelete, %A_ScriptFullPath%
    FileMove, %A_ScriptFullPath%, %AppUpdaterFile%, 1
    ExitApp
}
SetControlState("Enable")
Return
SetControlState(State)
{
    GuiControl, %State%,ShortCutToDesktop
    GuiControl, %State%,InstallAsAhk
    GuiControl, %State%,InstallAsExe
    GuiControl, %State%,Location
    GuiControl, %State%,ChangeLocation
    GuiControl, %State%,InstallScriptButton
    GuiControl, %State%,DeleteThis
    GuiControl, %State%,OnlyDesktop
    if(State == "Enable")
        UpdateLocks()
}
UpdateLocks()
{
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
        if(ShortcutState == 0)
            GuiControl,,ShortCutToDesktop,%ShortcutState%
        Else
            GuiControl,,ShortCutToDesktop,1
    }
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
}