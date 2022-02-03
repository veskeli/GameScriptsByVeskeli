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
UpdaterVersion = 0.21
global UpdaterVersion
;____________________________________________________________
;//////////////[Folders]///////////////
ScriptName = GameScripts
AppFolderName = AHKGameScriptsByVeskeli
AppFolder = %A_AppData%\%AppFolderName%
AppSettingsFolder = %AppFolder%\Settings
GuiPictureFolder = %AppFolder%\Gui
MainScriptFile = %AppFolder%\%ScriptName%
AppUpdaterSettingsFile = %AppFolder%\UpdaterInfo.ini
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
;____________________________________________________________
;//////////////[Main Script]///////////////
IfNotExist %AppUpdaterSettingsFile%
{
    ;No Updater Settings
    ExitApp
}
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
        IfExist %MainScriptFile%
        {
            Run, %MainScriptFile%
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
    DownloadLink := % "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_Branch . "/Updater.ahk"
    UrlDownloadToFile, %DownloadLink%, %A_ScriptFullPath%
    ExitApp
}