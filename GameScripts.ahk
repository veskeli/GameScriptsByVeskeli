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
AppHotkeysIni = %AppSettingsFolder%\Hotkeys.ini
AppUpdateFile = %AppFolder%\temp\OldFile.ahk
version = 0.21
;//////////////[Action variables]///////////////
AutoRunToggle = 0
AutoRunUseShift = 1
WindowsButtonRebindEnabled = 0
CapsLockButtonRebindEnabled = 0
;//////////////[Global variables]///////////////
global ScriptName
global AppFolderName
global AppFolder
global AppSettingsFolder
global AppSettingsIni
global AppHotkeysIni
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
;//////////////[Auto Run/Walk]///////////////
Gui Add, GroupBox, x375 y168 w450 h78, Auto Run/Walk
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x385 y185 w47 h23 +0x200, Hotkey:
Gui Add, Hotkey, x438 y185 w120 h21 gGuiSubmit vToggleRunHotkey
Gui Add, Button, x737 y185 w80 h23 gSaveToggleRun, Save Hotkey
Gui Add, CheckBox, x385 y212 w93 h23 +Checked gAutoRunUseShiftButton, Run (Use shift)
;Gui Add, CheckBox, x564 y183 w171 h23 gGuiSubmit vTurnOffAutoRunByMovement, Turn off by any movement
Gui Font
Gui Font, s11
Gui Add, CheckBox, x745 y214 w70 h23 gEnableAutoRun vAutoRunCheckbox, Enabled
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
;//////////////[Always on top]///////////////
Gui Add, GroupBox, x2 y27 w367 h55, Toggle any application to Always on top by hotkey
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x9 y50 w47 h23 +0x200, Hotkey:
Gui Add, Hotkey, x59 y50 w120 h21 vAlwaysOnTopHotkey gGuiSubmit
Gui Add, Button, x281 y49 w80 h23 gSaveAlwaysOnTopHotkey, Save Hotkey
Gui Font
Gui Font, s11
Gui Add, CheckBox, x201 y51 w70 h23 gEnableAlwaysOnTop vAlwaysOnTopCheckbox, Enabled
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
Gui Font, s9, Segoe UI
;//////////////[Disable buttons]///////////////
Gui Add, GroupBox, x375 y400 w450 h111, Disable buttons
Gui Add, CheckBox, x383 y426 w156 h23 gDisableWindowsButton vDisableWindowsCheckbox, Disable Windows button
Gui Add, CheckBox, x383 y450 w120 h23 gDisableCapsLockButton vDisableCapsLockCheckbox, Disable Caps Lock
Gui Add, CheckBox, x542 y426 w74 h23 gEnableWindowsRebind vRebindWindowsCheckbox, Rebind to:
Gui Add, Hotkey, x622 y427 w120 h21 gGuiSubmit vRebindWindowsButton ;Windows
Gui Add, CheckBox, x542 y450 w77 h23 gEnableCapsLockRebind vRebindCapsLockCheckbox, Rebind to:
Gui Add, Hotkey, x622 y451 w120 h21 gGuiSubmit vRebindCapsLockButton ;capslock
Gui Add, Button, x732 y478 w80 h23 gSaveRebindHotkeys, Save Hotkeys
Gui Add, CheckBox, x385 y479 w120 h23 gDisableAltTabButton vDisableAltTabCheckbox, Disable Alt + Tab
Gui Tab, 2
;____________________________________________________________
;//////////////[Game scripts]///////////////
Gui Font
Gui Font, s20
Gui Add, Text, x276 y156 w450 h185 +0x200, Nothing to show yet
Gui Font
Gui Font, s9, Segoe UI
Gui Tab, 3
;____________________________________________________________
;//////////////[Settings]///////////////
Gui Add, GroupBox, x633 y416 w199 h95, Check for updates
Gui Add, CheckBox, x646 y442 w172 h23 vCheckUpdatesOnStartup gAutoUpdates, Check for updates on startup
Gui Add, Button, x666 y473 w126 h23 +Disabled, Check updates
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
Gui Add, Button, x643 y70 w107 h23 gDeleteAppSettings, Delete all settings
Gui Add, Button, x642 y43 w180 h23 +Disabled, Delete all GameMode settings
;Gui Add, Button, x643 y121 w175 h38 gDeleteAllFiles, Uninstall(Delete all including this script)
Gui Add, Button, x643 y121 w175 h38 gDeleteAllFiles, Delete all files
Gui Add, Button, x644 y95 w80 h23 +Disabled, Delete Scripts
Gui Add, GroupBox, x633 y172 w196 h80, Clear
Gui Add, Button, x658 y196 w139 h39 gClearGameModeHotkeys, Clear GameMode Hotkeys
;Gui Add, Button, x723 y360 w103 h23 +Disabled, Show Changelog
Gui Add, Button, x720 y255 w108 h34 gShortcut_to_desktop, Shortcut to Desktop
Gui Tab, 4
;____________________________________________________________
;//////////////[Other scripts]///////////////
Gui Font
Gui Font, s20
Gui Add, Text, x276 y156 w450 h185 +0x200, Nothing to show yet
Gui Font
Gui Tab
;____________________________________________________________
;//////////////[Check for Settings]///////////////
IfExist, %AppSettingsIni% ;Check for updates checkbox
{
    IniRead, Temp_CheckUpdatesOnStartup, %AppSettingsIni%, Updates, CheckOnStartup
	GuiControl,,CheckUpdatesOnStartup,%Temp_CheckUpdatesOnStartup%
}
IfExist, %AppHotkeysIni% ;Always on top hotkey
{
    IniRead, Temp_AlwayOnTopHotkey, %AppHotkeysIni%, GameMode, AlwaysOnTopHotkey
	GuiControl,,AlwaysOnTopHotkey,%Temp_AlwayOnTopHotkey%
}
IfExist, %AppHotkeysIni% ;Auto Run/Walk
{
    IniRead, Temp_AutoRunHotkey, %AppHotkeysIni%, GameMode, AutoRun
	GuiControl,,ToggleRunHotkey,%Temp_AutoRunHotkey%
}
IfExist, %AppHotkeysIni% ;Rebind Windows button
{
    IniRead, Temp_RebindWindowsHotkey, %AppHotkeysIni%, GameMode, RebindWindowsButton
	GuiControl,,RebindWindowsButton,%Temp_RebindWindowsHotkey%
}
IfExist, %AppHotkeysIni% ;Rebind Caps lock button
{
    IniRead, Temp_RebindCapsLockHotkey, %AppHotkeysIni%, GameMode, RebindCapsLockButton
	GuiControl,,RebindCapsLockButton,%Temp_RebindCapsLockHotkey%
}
;____________________________________________________________
;//////////////[Show Gui After setting all saved settings]///////////////
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
;//////////////[Actions]///////////////
GuiSubmit:
    Gui, Submit, Nohide
return
;____________________________________________________________
;//////////////[Delete files]///////////////
DeleteAllFiles: ;uninstall
MsgBox, 1,Are you sure?,All files will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    FileRemoveDir, %AppFolder%,1
    ;Reset all settings when settings files are removed
    GuiControl,,CheckUpdatesOnStartup,0
}
return
DeleteAppSettings:
MsgBox, 1,Are you sure?,All Settings will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    FileRemoveDir, %AppSettingsFolder%,1
    ;Reset all settings when settings files are removed
    GuiControl,,CheckUpdatesOnStartup,0
}
return
;____________________________________________________________
;//////////////[SaveAlwaysOnTopHotkey]///////////////
SaveAlwaysOnTopHotkey:
    SaveHotkey(AlwaysOnTopHotkey, "AlwaysOnTopHotkey")
    goto EnableAlwaysOnTop
return
AlwaysOnTopHotkeyPress:
    Winset, Alwaysontop, , A
return
EnableAlwaysOnTop:
Gui, Submit, Nohide
if (AlwaysOnTopCheckbox)
{
    Hotkey, %AlwaysOnTopHotkey%,AlwaysOnTopHotkeyPress, ON
} 
else
{
    Hotkey, %AlwaysOnTopHotkey%,AlwaysOnTopHotkeyPress, OFF
}
return
;____________________________________________________________
;//////////////[Disable buttons]///////////////
DisableWindowsButton:
Gui, Submit, Nohide
if (RebindWindowsCheckbox) ;Check if rebind is enabled. Cant rebind and disable same key
{
    MsgBox, 1, Rebind is enabled, Rebind windows button is enabled `nDo you want to Disable it insted.
    IfMsgBox, Cancel
    {
        GuiControl,,DisableWindowsCheckbox,0
        return
    }
    else
    {
        GuiControl,,RebindWindowsCheckbox,0
        Hotkey, LWin, WindowsButtonRebinded, Off
    }
}
if (DisableWindowsCheckbox)
{
    Hotkey, LWin,DisableHotkeyLabel, ON
} 
else
{
    Hotkey, LWin,DisableHotkeyLabel, OFF
}
DisableCapsLockButton:
Gui, Submit, Nohide
if (RebindCapsLockCheckbox) ;Check if rebind is enabled. Cant rebind and disable same key
{
    MsgBox, 1, Rebind is enabled, Rebind CapsLock button is enabled `nDo you want to Disable it insted.
    IfMsgBox, Cancel
    {
        GuiControl,,DisableCapsLockCheckbox,0
        return
    }
    else
    {
        GuiControl,,RebindCapsLockCheckbox,0
        Hotkey, CapsLock, CapsLockButtonRebinded, Off
    }
}
if (DisableCapsLockCheckbox)
{
    Hotkey, CapsLock,DisableHotkeyLabel, ON
} 
else
{
    Hotkey, CapsLock,DisableHotkeyLabel, OFF
}
return
DisableAltTabButton:
Gui, Submit, Nohide
if (DisableAltTabCheckbox)
{
    Hotkey, !Tab,DisableHotkeyLabel, ON
} 
else
{
    Hotkey, !Tab,DisableHotkeyLabel, OFF
}
return
DisableHotkeyLabel: ;Disable button
return
EnableWindowsRebind:
Gui, Submit, Nohide
if (DisableWindowsCheckbox) ;Check if disable is also enabled. cant rebind and disable same key
{
    MsgBox, 1, Disable is enabled, Disable windows button is enabled `nDo you want to Rebind it insted.
    IfMsgBox, Cancel
    {
        GuiControl,,RebindWindowsCheckbox,0
        return
    }
    else
    {
        GuiControl,,DisableWindowsCheckbox,0
        Hotkey, LWin,DisableHotkeyLabel, OFF
    }
}
WindowsButtonRebindEnabled := !WindowsButtonRebindEnabled
if (WindowsButtonRebindEnabled)
{
    Hotkey, LWin, WindowsButtonRebinded, On
}
else
{
    Hotkey, LWin, WindowsButtonRebinded, Off
}
return
WindowsButtonRebinded:
Gui, Submit, Nohide
send %RebindWindowsButton%
return
EnableCapsLockRebind:
Gui, Submit, Nohide
if (DisableCapsLockCheckbox) ;Check if disable is also enabled. cant rebind and disable same key
{
    MsgBox, 1, Disable is enabled, Disable CapsLock button is enabled `nDo you want to Rebind it insted.
    IfMsgBox, Cancel
    {
        GuiControl,,RebindCapsLockCheckbox,0
        return
    }
    else
    {
        GuiControl,,DisableCapsLockCheckbox,0
        Hotkey, CapsLock,DisableHotkeyLabel, OFF
    }
}
CapsLockButtonRebindEnabled := !CapsLockButtonRebindEnabled
if (CapsLockButtonRebindEnabled)
{
    Hotkey, CapsLock, CapsLockButtonRebinded, On
}
else
{
    Hotkey, CapsLock, CapsLockButtonRebinded, Off
}
return
CapsLockButtonRebinded:
Gui, Submit, Nohide
send %RebindCapsLockButton%
return
SaveRebindHotkeys:
Gui, Submit, Nohide
SaveHotkey(RebindWindowsButton,"RebindWindowsButton")
SaveHotkey(RebindCapsLockButton, "RebindCapsLockButton")
return
;____________________________________________________________
;//////////////[Clear hotkeys]///////////////
ClearGameModeHotkeys:
Gui, Submit, Nohide
;always on top
GuiControl,, AlwaysOnTopHotkey, ""
SaveHotkey("", "AlwaysOnTopHotkey")
return
;____________________________________________________________
;//////////////[Auto Run/Walk]///////////////
SaveToggleRun:
SaveHotkey(ToggleRunHotkey, "AutoRun")
goto EnableAutoRun
return
EnableAutoRun:
Gui, Submit, Nohide
if (AutoRunCheckbox)
{
    Hotkey, %ToggleRunHotkey%,ToggleAutoRun, ON
    Hotkey, *%ToggleRunHotkey%,ToggleAutoRun, ON
} 
else
{
    Hotkey, %ToggleRunHotkey%,ToggleAutoRun, OFF
}
return
ToggleAutoRun:
AutoRunToggle := !AutoRunToggle
if (AutoRunToggle)
{
    if (AutoRunUseShift)
    {
        Send, {lshift Down}
        Send, {Blind}{w Down}
    }
    else
    {
        Send, {w Down}
    }
}
else
{
    if (AutoRunUseShift)
    {
        Send, {lshift Up}
        Send, {Blind}{w Up}
    }
    else
    {
        Send, {w Up}
    }
}
return
AutoRunUseShiftButton:
AutoRunUseShift := !AutoRunUseShift
Return
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
                    ExitApp
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
;____________________________________________________________
;____________________________________________________________
;//////////////[Functions]///////////////
SaveHotkey(tHotkey, tKey)
{
    Gui, Submit, Nohide
    IniWrite, %tHotkey%, %AppHotkeysIni%, GameMode, %tKey%
}