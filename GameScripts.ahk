#SingleInstance, Force
#KeyHistory, 0
SetBatchLines, -1
ListLines, Off
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , GameScripts
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
; DetectHiddenWindows, On
SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag
;____________________________________________________________
;____________________________________________________________
;//////////////[variables]///////////////
ScriptName = GameScripts
AppFolderName = AHKGameScriptsByVeskeli
AppFolder = %A_AppData%\%AppFolderName%
AppSettingsFolder = %AppFolder%\Settings
AppSettingsIni = %AppSettingsFolder%\Settings.ini
AppUpdateFile = %AppFolder%\temp\OldFile.ahk
version = 0.1
;//////////////[Global variables]///////////////
global ScriptName
global AppFolderName
global AppFolder
global AppSettingsFolder
global AppSettingsIni
global AppUpdateFile
;//////////////[Startup checks]///////////////
IfExist %AppUpdateFile% 
{
    FileDelete, %AppUpdateFile% ;delete old file after update
} 
;____________________________________________________________
;____________________________________________________________
;//////////////[Gui]///////////////
Gui Font, s9, Segoe UI
Gui Add, Tab3, x-1 y-1 w840 h521, GameMode|GamingScripts|Settings|Other scripts
;//////////////[GameMode]///////////////
Gui Tab, 1
Gui Font
Gui Font, s11
Gui Add, GroupBox, x375 y27 w450 h56, Mouse Hold
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x381 y48 w83 h23 +0x200 +Disabled, Mouse button:
Gui Add, DropDownList, x471 y48 w88 +Disabled, Left||Middle|Right
Gui Add, Text, x562 y48 w47 h23 +0x200 +Disabled, Hotkey:
Gui Add, Hotkey, x614 y48 w120 h21 +Disabled
Gui Add, Button, x737 y37 w80 h23 +Disabled, Save Settings
Gui Font
Gui Font, s11
Gui Add, GroupBox, x375 y86 w450 h80, Mouse Clicker
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x381 y104 w83 h23 +0x200 +Disabled, Mouse button:
Gui Add, DropDownList, x471 y104 w88 +Disabled, Left||Middle|Right
Gui Add, Text, x562 y104 w47 h23 +0x200 +Disabled, Hotkey:
Gui Add, Hotkey, x614 y104 w120 h21 +Disabled
Gui Add, Button, x737 y104 w80 h23 +Disabled, Save Settings
Gui Add, Text, x383 y134 w62 h23 +0x200 +Disabled, Timer: (ms)
Gui Add, Edit, x449 y136 w120 h21 +Number +Disabled, 50
Gui Font
Gui Font, s11
Gui Add, GroupBox, x375 y168 w450 h78, Auto run/walk
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x385 y185 w47 h23 +0x200, Hotkey:
Gui Add, Hotkey, x438 y185 w120 h21 +Disabled
Gui Add, Button, x737 y185 w80 h23 +Disabled, Save Settings
Gui Add, CheckBox, x385 y212 w93 h23 +Checked +Disabled, Run (Use shift)
Gui Add, CheckBox, x564 y183 w171 h23 +Disabled, Turn off by any movement
Gui Font
Gui Font, s11
Gui Add, GroupBox, x375 y257 w450 h143, Capture only in game
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s13
Gui Add, CheckBox, x383 y279 w183 h23 +Disabled, Capture only in game
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x381 y311 w107 h23 +0x200 +Disabled, Game/application:
Gui Add, DropDownList, x492 y311 w292 +Disabled, App||
Gui Add, Text, x380 y339 w98 h23 +0x200 +Disabled, Custom WinTitle:
Gui Add, Edit, x482 y340 w302 h21 +Disabled
Gui Add, Button, x737 y275 w80 h23 +Disabled, Save settings
Gui Add, Text, x380 y364 w43 h23 +0x200 +Disabled, Games:
Gui Add, DropDownList, x428 y364 w356 +Disabled, Game||
Gui Add, Radio, x792 y312 w19 h23 +Checked +Disabled
Gui Add, Radio, x792 y338 w19 h23 +Disabled
Gui Add, Radio, x792 y364 w19 h23 +Disabled
Gui Font
Gui Font, s11
Gui Add, GroupBox, x2 y27 w367 h55, Toggle any application to Always on top by hotkey
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x9 y50 w47 h23 +0x200 +Disabled, Hotkey:
Gui Add, Hotkey, x59 y50 w120 h21 +Disabled
Gui Add, Button, x281 y49 w80 h23 +Disabled, Save settings
Gui Font
Gui Font, s11
Gui Add, CheckBox, x201 y51 w70 h23 +Disabled, Enabled
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s11
Gui Add, CheckBox, x740 y61 w70 h18 +Disabled, Enabled
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s11
Gui Add, CheckBox, x743 y132 w70 h23 +Disabled, Enabled
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s11
Gui Add, CheckBox, x745 y214 w70 h23 +Disabled, Enabled
Gui Font
Gui Font, s9, Segoe UI
Gui Add, GroupBox, x375 y400 w450 h111, Disable buttons
Gui Add, CheckBox, x383 y426 w156 h23 +Disabled, Disable Windows button
Gui Add, CheckBox, x383 y450 w120 h23 +Disabled, Disable Caps Lock
Gui Add, CheckBox, x542 y426 w74 h23 +Disabled, Rebind to:
Gui Add, Hotkey, x622 y427 w120 h21 +Disabled
Gui Add, CheckBox, x542 y450 w77 h23 +Disabled, Rebind to:
Gui Add, Hotkey, x622 y451 w120 h21 +Disabled
Gui Add, Button, x732 y478 w80 h23 +Disabled, Save settings
Gui Add, CheckBox, x385 y479 w120 h23 +Disabled, Disable Alt + Tab
Gui Tab, 2
;//////////////[Game scripts]///////////////
Gui Font
Gui Font, s20
Gui Add, Text, x276 y156 w450 h185 +0x200, Nothing to show yet
Gui Font
Gui Font, s9, Segoe UI
Gui Tab, 3
;//////////////[Settings]///////////////
Gui Add, GroupBox, x633 y416 w199 h95, Check for updates
Gui Add, CheckBox, x646 y442 w172 h23 vCheckUpdatesOnStartup gAutoUpdates, Check for updates on startup
Gui Add, Button, x666 y473 w126 h23 +Disabled, Check updates
IfExist, %AppSettingsIni%
{
    IniRead, Temp_CheckUpdatesOnStartup, %AppSettingsIni%, Updates, CheckOnStartup
	GuiControl,,CheckUpdatesOnStartup,%Temp_CheckUpdatesOnStartup%
}
Gui Font
Gui Font, s14
Gui Add, Text, x706 y387 w120 h23 +0x200, Version = %version%
Gui Font
Gui Font, s9, Segoe UI
Gui Add, CheckBox, x10 y30 w147 h23 +Disabled, Keep this always on top
Gui Font
Gui Font, s14
Gui Add, Button, x467 y470 w163 h40 +Disabled, Save all settings
Gui Font
Gui Font, s9, Segoe UI
Gui Add, GroupBox, x633 y27 w196 h145, Delete stuff
Gui Add, Button, x643 y70 w107 h23 +Disabled, Delete all settings
Gui Add, Button, x642 y43 w180 h23 +Disabled, Delete all GameMode settings
Gui Add, Button, x643 y121 w175 h38 +Disabled, Uninstall(Delete all including this script)
Gui Add, Button, x644 y95 w80 h23 +Disabled, Delete Scripts
Gui Add, GroupBox, x633 y172 w196 h80, Clear
Gui Add, Button, x658 y196 w139 h39 +Disabled, Clear GameMode Hotkeys
Gui Add, Button, x723 y360 w103 h23 +Disabled, Show Changelog
Gui Add, Button, x720 y255 w108 h34 gShortcut_to_desktop, Shortcut to Desktop
Gui Tab, 4
;//////////////[Other scripts]///////////////
Gui Font
Gui Font, s20
Gui Add, Text, x276 y156 w450 h185 +0x200, Nothing to show yet
Gui Font
Gui Tab

Gui Show, w835 h517, GamingScriptsByVeskeli
;____________________________________________________________
;//////////////[Check for updates]///////////////
IfExist, %AppSettingsIni%
{
    if(Temp_CheckUpdatesOnStartup == 1)
    {
        goto checkForupdates
    }
}
;____________________________________________________________
;//////////////[Intro]///////////////
IfNotExist, %AppSettingsIni%
{
    IniRead, Temp_IntroCheck, %AppSettingsIni%, Intro, SkipIntro
    if (Temp_IntroCheck != 1)
    {
        MsgBox, 4,Check updates on start?, Would you like to enable auto updates.
        IfMsgBox Yes
        {
            Gui, Submit, Nohide
            FileCreateDir, %AppFolder%
            FileCreateDir, %AppSettingsFolder%
            IniWrite, 1, %AppSettingsIni%, Updates, CheckOnStartup
            GuiControl,,CheckUpdatesOnStartup,1
            IniWrite, 1, %AppSettingsIni%, Intro, SkipIntro
        }
        else
        {
            IniWrite, 1, %AppSettingsIni%, Intro, SkipIntro
        }
    }
}
Return

GuiEscape:
GuiClose:
    ExitApp

;____________________________________________________________
;____________________________________________________________
;//////////////[checkForupdates]///////////////
checkForupdates:
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/version.txt", False)
whr.Send()
whr.WaitForResponse()
newversion := whr.ResponseText
if(newversion != "")
{
    if(newversion > version)
    {
        MsgBox, 1,Update,New version is  %newversion% `nOld is %version% `nUpdate now?
        IfMsgBox, Cancel
        {
            ;temp stuff
        }
        else
        {
            ;Download update
            FileCreateDir, %AppFolder%
            FileCreateDir, %AppFolder%\temp
            FileMove, %A_ScriptFullPath%, %AppUpdateFile%, 1
            sleep 1000
            UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/GameScripts.ahk, %A_ScriptFullPath%
            Sleep 1000
            loop
            {
                IfExist %A_ScriptFullPath%
                {
                    Run, %A_ScriptFullPath%
                }
            }
			ExitApp
        }
    }
}
return
;Check updates on start
AutoUpdates:
Gui, Submit, Nohide
FileCreateDir, %AppFolder%
FileCreateDir, %AppSettingsFolder%
IniWrite, %CheckUpdatesOnStartup%, %AppSettingsIni%, Updates, CheckOnStartup
return
;Shortcut
Shortcut_to_desktop:
FileCreateShortcut,"%A_ScriptFullPath%", %A_Desktop%\%ScriptName%.lnk
return