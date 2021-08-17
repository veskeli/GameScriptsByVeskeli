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
AppOtherScriptsFolder = %AppFolder%\OtherScripts
version = 0.33
GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
GuiPictureFolder = %AppFolder%\Gui
NumpadMacroDeckSettingsIni = %AppSettingsFolder%\NumpadMacroDeck.ini
;other scipts (Bool)
GHUBTool := false
;Numpad Macro Deck
NumpadDeckSelected := ""
;NumpadDeckEnalbedArray := []
DeckNumlockEnabled := false
DeckDivisionEnabled := false
DeckMultiplicationEnabled := false
DeckSubstractionEnabled := false
Deck0Enabled := false
Deck1Enabled := false
Deck2Enabled := false
Deck3Enabled := false
Deck4Enabled := false
Deck5Enabled := false
Deck6Enabled := false
Deck7Enabled := false
Deck8Enabled := false
Deck9Enabled := false
DeckAdditionEnabled := false
DeckEnterEnabled := false
DeckDotEnabled := false
NumpadMacroDeckToggleBetweenNumpad := true
IsEXERunnerEnabled := false
;//////////////[Action variables]///////////////
AutoRunToggle = 0
AutoRunUseShift = 1
WindowsButtonRebindEnabled = 0
CapsLockButtonRebindEnabled = 0
MouseHoldToggle = 0
MouseClickerToggle = 0
;//////////////[Global variables]///////////////
global ScriptName
global AppFolderName
global AppFolder
global AppSettingsFolder
global AppSettingsIni
global AppHotkeysIni
global AppUpdateFile
global AppOtherScriptsFolder
global GHUBToolLocation
global GHUBTool
;numpadmacrodeck
global GuiPictureFolder
global NumpadDeckSelected
global NumpadMacroDeckSettingsIni
;global NumpadDeckEnalbedArray
global DeckNumlockEnabled
global DeckDivisionEnabled
global DeckMultiplicationEnabled
global DeckSubtractionEnabled
global Deck0Enabled
global Deck1Enabled
global Deck2Enabled
global Deck3Enabled
global Deck4Enabled
global Deck5Enabled
global Deck6Enabled
global Deck7Enabled
global Deck8Enabled
global Deck9Enabled
global DeckAdditionEnabled
global DeckEnterEnabled
global DeckDotEnabled
;//////////////[Startup checks]///////////////
IfExist %AppUpdateFile% 
{
    FileDelete, %AppUpdateFile% ;delete old file after update
    FileRemoveDir, %AppFolder%\temp ;Delete temp directory
}
IfNotExist %GuiPictureFolder%
{
    DownloadGuiPictures()
}
;____________________________________________________________
;____________________________________________________________
;//////////////[Gui]///////////////
Menu Tray, Icon, %GuiPictureFolder%\GameScripts.ico,1
Gui Font, s9, Segoe UI
Gui Add, Tab3, x-1 y-1 w840 h521, GameMode|GamingScripts|Settings|Other scripts|Numpad Macro Deck
;//////////////[GameMode]///////////////
Gui Tab, 1
Gui Font
Gui Font, s11
;//////////////[Mouse Hold]///////////////
Gui Add, GroupBox, x375 y27 w450 h56, Mouse Hold
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x381 y48 w83 h23 +0x200, Mouse button:
Gui Add, DropDownList, x471 y48 w88 gGuiSubmit vMouseHoldList, Left||Middle|Right
Gui Add, Text, x562 y48 w47 h23 +0x200, Hotkey:
Gui Add, Hotkey, x614 y48 w120 h21 gGuiSubmit vMouseHoldHotkey
Gui Add, Button, x737 y37 w80 h23 gSaveMouseHoldSettings, Save Hotkey
Gui Font
Gui Font, s11
Gui Add, CheckBox, x740 y61 w70 h18 gMouseHoldEnabled vMouseHoldCheckbox, Enabled
Gui Font
Gui Font, s11
;//////////////[Mouse Clicker]///////////////
Gui Add, GroupBox, x375 y86 w450 h80, Mouse Clicker
Gui Font
Gui Font, s9, Segoe UI
Gui Add, Text, x381 y104 w83 h23 +0x200 , Mouse button:
Gui Add, DropDownList, x471 y104 w88 gGuiSubmit vMouseClickerList, Left||Middle|Right
Gui Add, Text, x562 y104 w47 h23 +0x200 , Hotkey:
Gui Add, Hotkey, x614 y104 w120 h21 gGuiSubmit vMouseClickerHotkey
Gui Add, Button, x737 y104 w80 h23 gSaveMouseClickerSettings, Save Settings
Gui Add, Text, x383 y134 w62 h23 +0x200 , Timer: (ms)
Gui Add, Edit, x449 y136 w120 h21 +Number gGuiSubmit vMouseClickerDelay, 150
Gui Font
Gui Font, s11
Gui Add, CheckBox, x743 y132 w70 h23 gMouseClickerEnabled vMouseClickerCheckbox, Enabled
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
Gui Font, s9, Segoe UI
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
Gui Add, Button, x666 y473 w126 h23 gcheckForupdates, Check updates
Gui Font
Gui Font, s14
Gui Add, Text, x505 y488 w120 h23 +0x200, Version = %version%
Gui Font
Gui Font, s9, Segoe UI
Gui Add, GroupBox, x633 y27 w196 h145, Delete stuff
Gui Add, Button, x643 y70 w107 h23 gDeleteAppSettings, Delete all settings
Gui Add, Button, x642 y43 w180 h23 gDeleteGameModeSettings, Delete all GameMode settings
;Gui Add, Button, x643 y121 w175 h38 gDeleteAllFiles, Uninstall(Delete all including this script)
Gui Add, Button, x643 y121 w175 h38 gDeleteAllFiles, Delete all files
Gui Add, Button, x644 y95 w80 h23 +Disabled, Delete Scripts
Gui Add, GroupBox, x633 y172 w196 h80, Clear
Gui Add, Button, x658 y196 w139 h39 gClearGameModeHotkeys, Clear GameMode Hotkeys
;Gui Add, Button, x723 y360 w103 h23 +Disabled, Show Changelog
Gui Add, GroupBox, x506 y27 w128 h64, Shortcut
Gui Add, Button, x520 y45 w108 h34 gShortcut_to_desktop, Shortcut to Desktop
Gui Add, GroupBox, x0 y364 w317 h155, Exe Runner
Gui Add, Button, x168 y480 w141 h32 vDownloadEXERunnerButton gDownloadEXERunner, Download EXE Runner
Gui Add, Text, x8 y385 w306 h90, EXE Runner is simple Run script compiled to exe.`n(Moves this main script to Appdata and replaces this with an exe file)(You can alway revert back)`nNew Features with exe Runner:`n+ You can pin this to taskbar`n+ Cool App Icon
Gui Add, GroupBox, x633 y252 w196 h82, Open Folder
Gui Add, Button, x655 y272 w150 h23 gOpenAppSettingsFolder, Open App Settings Folder
Gui Add, Button, x677 y301 w110 h23 gOpenAppSettingsFile, Open Settings File
Gui Add, GroupBox, x340 y27 w167 h53, Numpad Macro Deck
Gui Add, Button, x348 y46 w100 h23 gNumpadMacroDeckDeleteAllSettings, Delete all Actions
Gui Add, GroupBox, x632 y336 w197 h80, This Script
Gui Add, Button, x647 y378 w145 h30 gRedownloadGuiPictures, Redownload Gui pictures
Gui Font, s9, Segoe UI
Gui Add, CheckBox, x648 y352 w147 h23 +Disabled, Keep this always on top
Gui Font
;Windows settigns/folders
Gui Font
Gui Add, GroupBox, x0 y28 w102 h130, Open Folders
Gui Add, Button, x10 y48 w85 h23 gOpenAppdataFolder, Appdata
Gui Add, Button, x10 y74 w85 h23 gOpenStartupFolder, Startup
Gui Add, Button, x10 y100 w85 h23 gOpenWindowsTempFolder, Windows Temp
Gui Add, Button, x10 y126 w85 h23 gOpenMyDocuments, My Documents
Gui Add, GroupBox, x101 y28 w164 h130, Toggle windows settings
Gui Add, Button, x109 y48 w112 h23 gXboxOverlayOn, Xbox overlay On
Gui Add, Button, x225 y48 w35 h23 gXboxOverlayOff, Off
Gui Add, Button, x110 y74 w111 h23 gGameModeOn, Game Mode On
Gui Add, Button, x225 y74 w35 h23 gGameModeOff, Off
Gui Add, Button, x110 y100 w111 h23 gToggleGameDVRON, Game DVR On
Gui Add, Button, x225 y100 w35 h23 gToggleGameDVROFF, Off
Gui Tab, 4
;____________________________________________________________
;//////////////[Other scripts]///////////////
Gui Font
;//////////////[Logitech GHUB Tool]///////////////
Gui Add, GroupBox, x3 y30 w823 h54, Logitech Backup Tool
Gui Font, s14
Gui Add, Text, x12 y48 w258 h32 +0x200, Logitech Backup Profiles Tool
Gui Font
Gui Add, Button, x390 y50 w100 h23 vDowloadGHUBToolButton gDownloadLogitechGHUBTool, Download
Gui Add, Button, x494 y50 w130 h23 +Disabled, Check for updates
Gui Add, Button, x628 y50 w97 h23 gOpenGHUBToolGithub, Open in Github
Gui Add, Button, x730 y50 w80 h23 gUninstallGHUBToolScript vUninstallGHUBToolScritpButton +Disabled, Delete
Gui Font
Gui Tab, 5
;____________________________________________________________
;//////////////[Numpad Macro Deck]///////////////
Gui Font, s12
Gui Add, CheckBox, x360 y40 w238 h23 gNumpadMacroDeckEnableHotkeys vNumpadMacroDeckEnableHotkeysCheckbox, Numpad Macro Deck Enabled
Gui Font
Gui Add, Text, x359 y73 w260 h23 +0x200, Num Lock Toggles between numpad and macro deck
Gui Font, s14
Gui Add, GroupBox, x0 y32 w339 h476, Numpad Deck
;start
Gui Font, s14
;Gui Add, Picture, x24 y104 w60 h60 gDeckNumlock vDeckNumlockControl, %GuiPictureFolder%\NumLock.png
Gui Add, Picture, x24 y104 w60 h60, %GuiPictureFolder%\NumLockBlue.png
Gui Font, s14
Gui Add, Picture, x88 y104 w60 h60 gDeckDivision vDeckDivisionControl, %GuiPictureFolder%\Division.png
Gui Font, s14
Gui Add, Picture, x152 y104 w60 h60 gDeckMultiplication vDeckMultiplicationControl, %GuiPictureFolder%\Multiplication.png
Gui Font, s14
Gui Add, Picture, x216 y104 w60 h60 gDeckSubtraction vDeckSubtractionControl, %GuiPictureFolder%\Subtraction.png
Gui Font, s14
Gui Add, Picture, x24 y168 w60 h60 gDeck7 vDeck7Control, %GuiPictureFolder%\7.png
Gui Font, s14
Gui Add, Picture, x88 y168 w60 h60 gDeck8 vDeck8Control, %GuiPictureFolder%\8.png
Gui Font, s14
Gui Add, Picture, x152 y168 w60 h60 gDeck9 vDeck9Control, %GuiPictureFolder%\9.png
Gui Font, s14
Gui Add, Picture, x216 y168 w60 h124 gDeckAddition vDeckAdditionControl, %GuiPictureFolder%\Addition.png
Gui Font, s14
Gui Add, Picture, x24 y232 w60 h60 gDeck4 vDeck4Control, %GuiPictureFolder%\4.png
Gui Font, s14
Gui Add, Picture, x88 y232 w60 h60 gDeck5 vDeck5Control, %GuiPictureFolder%\5.png
Gui Font, s14
Gui Add, Picture, x152 y232 w60 h60 gDeck6 vDeck6Control, %GuiPictureFolder%\6.png
Gui Font, s14
Gui Add, Picture, x24 y296 w60 h60 gDeck1 vDeck1Control, %GuiPictureFolder%\1.png
Gui Font, s14
Gui Add, Picture, x88 y296 w60 h60 gDeck2 vDeck2Control, %GuiPictureFolder%\2.png
Gui Font, s14
Gui Add, Picture, x152 y296 w60 h60 gDeck3 vDeck3Control, %GuiPictureFolder%\3.png
Gui Font, s14
Gui Add, Picture, x216 y296 w60 h124 gDeckEnter vDeckEnterControl, %GuiPictureFolder%\Enter.png
Gui Font, s14
Gui Add, Picture, x152 y360 w60 h60 gDeckDot vDeckDotControl, %GuiPictureFolder%\Dot.png
Gui Font, s14
Gui Add, Picture, x24 y360 w124 h60 gDeck0 vDeck0Control, %GuiPictureFolder%\0.png
Gui Font
;End
Gui Add, GroupBox, x338 y116 w379 h392, Actions (More actions coming soon)
Gui Add, Text, x360 y149 w329 h28 +0x200 vDeckCurrentlyActive, 
Gui Add, Radio, x348 y197 w52 h23 +Checked vNumpadMacroDeckTextRadio, Text
Gui Add, Radio, x348 y238 w63 h23 vNumpadMacroDeckHotkeyRadio, Hotkey
Gui Add, Edit, x406 y198 w293 h21 vNumpadMacroDeckTextEdit gGuiSubmit
Gui Add, Edit, x417 y240 w215 h21 vNumpadMacroDeckHotkeyBox gGuiSubmit
Gui Add, Link, x648 y240 w50 h23, <a href="https://www.autohotkey.com/docs/KeyList.htm">Hotkeys</a>
Gui Font, s14
Gui Add, Button, x568 y462 w143 h36 vNumpadMacroDeckSaveSettingsButton gNumpadMacroDeckSaveSettings, Save Settings
Gui Add, Button, x421 y462 w143 h36 vNumpadMacroDeckDeleteSettingsButton gNumpadMacroDeckDeleteSettings, Delete Settings
Gui Font
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
IfExist, %AppHotkeysIni% ;Mouse Hold
{
    IniRead, Temp_MouseHoldHotkey, %AppHotkeysIni%, GameMode, MouseHoldHotkey
    ;IniRead, Temp_MouseHoldButton, %AppHotkeysIni%, GameMode, MouseHoldButton
    GuiControl,,MouseHoldHotkey,%Temp_MouseHoldHotkey%
    ;GuiControl,,MouseHoldList,%Temp_MouseHoldButton%
}
IfExist, %AppHotkeysIni% ;Mouse Clicker
{
    IniRead, Temp_MouseClickerHotkey, %AppHotkeysIni%, GameMode, MouseClickerHotkey
    IniRead, Temp_MouseClickerDelay, %AppHotkeysIni%, GameMode, MouseClickerDelay
	GuiControl,,MouseClickerHotkey,%Temp_MouseClickerHotkey%
    GuiControl,,MouseClickerDelay,%Temp_MouseClickerDelay%
    if (Temp_MouseClickerDelay == "ERROR")
    {
        GuiControl,,MouseClickerDelay, 150
    }
}
;Numpad Macro Deck
IfExist, %NumpadMacroDeckSettingsIni%
{
    CheckForEnabledButtons()
}
;EXERunner
IfExist, %AppSettingsIni%
{
    iniread, T_IsRunnerEnabled,%AppSettingsIni%, ExeRunner, UsingExeRunner
    if(%T_IsRunnerEnabled%)
    {
        GuiControl,Enable,Shortcut_to_taskbarButton
        GuiControl,,DownloadEXERunnerButton,Delete EXE Runner
        IsEXERunnerEnabled := true
    }
    else
    {
        IsEXERunnerEnabled := false
    }
}
;____________________________________________________________
;//////////////[Check for installed scripts]///////////////
IfExist %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
{
    GuiControl, , DowloadGHUBToolButton, Run
    GuiControl, Enable,UninstallGHUBToolScritpButton
    GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    GHUBTool := true
}
else IfExist, %A_AppData%\LogitechBackupProfilesAhk\Settings\Settings.ini
{
    IniRead, GHUBToolLocation, %A_AppData%\LogitechBackupProfilesAhk\Settings\Settings.ini,Info, ScriptPath
    IfNotExist, %GHUBToolLocation%
    {
        GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    }
    Else
    {
        GuiControl, , DowloadGHUBToolButton, Run
        GuiControl, Enable,UninstallGHUBToolScritpButton
        GHUBTool := true
    }
} 
;____________________________________________________________
;//////////////[Show Gui After setting all saved settings]///////////////
;Gui Show, w835 h517, Remember to drink your daily dose of coffee.
Random,T_Coice_Num,1,8
If (T_Coice_Num = 1)
{
    Gui Show, w835 h517,Remember to drink your daily dose of coffee.
}
else if (T_Coice_Num = 2)
{
    Gui Show, w835 h517,Humanity runs on coffee.
}
else if (T_Coice_Num = 3)
{
    Gui Show, w835 h517,I put coffee in my coffee
}
else if (T_Coice_Num = 4)
{
    Gui Show, w835 h517,Coffee is always a good idea.
}
else if (T_Coice_Num = 5)
{
    Gui Show, w835 h517,When life gives you lemons trade them for coffee.
}
else if (T_Coice_Num = 6)
{
    Gui Show, w835 h517, I've had so much coffee today I can see noises.
}
else if (T_Coice_Num = 7)
{
    Gui Show, w835 h517,I will start working when my coffee does.
}
else if (T_Coice_Num = 8)
{
    Gui Show, w835 h517,Coffee runs through my veins.
}
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
;//////////////[Settings]///////////////
ClearGameModeHotkeys:
Gui, Submit, Nohide
;always on top
GuiControl,, AlwaysOnTopHotkey, ""
;AutoRun
GuiControl,,ToggleRunHotkey, ""
;Mouse Hold
GuiControl,,MouseHoldHotkey,""
;Mouse Clicker
GuiControl,,MouseClickerHotkey,""
GuiControl,,MouseClickerDelay,150
;Rebind buttons
GuiControl,,RebindWindowsButton,""
GuiControl,,RebindCapsLockButton,""
return
DeleteGameModeSettings:
MsgBox, 1,Are you sure?,All Game Mode Settings will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    Gui, Submit, Nohide
    ;always on top
    GuiControl,, AlwaysOnTopHotkey, ""
    SaveHotkey("", "AlwaysOnTopHotkey")
    ;AutoRun
    GuiControl,,ToggleRunHotkey, ""
    SaveHotkey("", "AutoRun")
    ;Mouse Hold
    GuiControl,,MouseHoldHotkey,""
    SaveHotkey("", "MouseHoldHotkey")
    ;Mouse Clicker
    GuiControl,,MouseClickerHotkey,""
    GuiControl,,MouseClickerDelay,150
    SaveHotkey("", "MouseClickerHotkey")
    SaveHotkey(150, "MouseClickerDelay")
    ;Rebind buttons
    GuiControl,,RebindWindowsButton,""
    GuiControl,,RebindCapsLockButton,""
    SaveHotkey("","RebindWindowsButton")
    SaveHotkey("", "RebindCapsLockButton")
}
return
OpenAppSettingsFolder:
run, %AppFolder%
return
OpenAppSettingsFile:
run, %AppSettingsIni%
return
NumpadMacroDeckDeleteAllSettings:
MsgBox, 1,Are you sure?,All Numpad Macro Deck Settings will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    GuiControl,, NumpadMacroDeckTextEdit,
    GuiControl,, NumpadMacroDeckHotkeyBox,
    GuiControl,,NumpadMacroDeckTextRadio,1
    FileDelete,%NumpadMacroDeckSettingsIni%
    DeckNumlockEnabled := false
    DeckDivisionEnabled := false
    DeckMultiplicationEnabled := false
    DeckSubstractionEnabled := false
    Deck0Enabled := false
    Deck1Enabled := false
    Deck2Enabled := false
    Deck3Enabled := false
    Deck4Enabled := false
    Deck5Enabled := false
    Deck6Enabled := false
    Deck7Enabled := false
    Deck8Enabled := false
    Deck9Enabled := false
    DeckAdditionEnabled := false
    DeckEnterEnabled := false
    DeckDotEnabled := false
    GuiControl,,DeckDivisionControl,%GuiPictureFolder%\Division.png
    GuiControl,,DeckMultiplicationControl,%GuiPictureFolder%\Multiplication.png
    GuiControl,,DeckSubtractionControl,%GuiPictureFolder%\Subtraction.png
    GuiControl,,Deck0Control,%GuiPictureFolder%\0.png
    GuiControl,,Deck1Control,%GuiPictureFolder%\1.png
    GuiControl,,Deck2Control,%GuiPictureFolder%\2.png
    GuiControl,,Deck3Control,%GuiPictureFolder%\3.png
    GuiControl,,Deck4Control,%GuiPictureFolder%\4.png
    GuiControl,,Deck5Control,%GuiPictureFolder%\5.png
    GuiControl,,Deck6Control,%GuiPictureFolder%\6.png
    GuiControl,,Deck7Control,%GuiPictureFolder%\7.png
    GuiControl,,Deck8Control,%GuiPictureFolder%\8.png
    GuiControl,,Deck9Control,%GuiPictureFolder%\9.png
    GuiControl,,DeckAdditionControl,%GuiPictureFolder%\Addition.png
    GuiControl,,DeckEnterControl,%GuiPictureFolder%\Enter.png
    GuiControl,,DeckDotControl,%GuiPictureFolder%\Dot.png
    GuiControl,,DeckCurrentlyActive,
    NumpadDeckSelected =
}
return
RedownloadGuiPictures:
FileRemoveDir, %GuiPictureFolder%, 1
Run, %A_ScriptFullPath%
ExitApp
return ;Just in case
DownloadEXERunner:
if(IsEXERunnerEnabled)
{
    ;Delete exe runner
    IniRead, T_RevertLocation,%AppSettingsIni%, ExeRunner, ExeFileLocation
    if(T_RevertLocation = "ERROR")
    {
        iniread,T_RevertLocation,%AppSettingsIni%, ExeRunner, OldAhkFileLocation
    }
    FileMove, %AppFolder%\%ScriptName%.ahk,%T_RevertLocation%\%ScriptName%.ahk ,1
    if ErrorLevel
    {
        MsgBox, Error while moving files
        return
    }    
    FileDelete, %T_RevertLocation%\%ScriptName%.exe
    if ErrorLevel
    {
        FileRecycle, %T_RevertLocation%\%ScriptName%.exe
        if ErrorLevel
        {
            MsgBox, Error while deleting file`nYou need to delete exe file manually
        }
    }
    IniWrite,false,%AppSettingsIni%, ExeRunner, UsingExeRunner
    GuiControl,,DownloadEXERunnerButton,Download EXE Runner
    IsEXERunnerEnabled := false
}
else
{ 
    ;Download exe runner
    T_FileBeforeMoveLocation = %A_ScriptDir%
    IniWrite,true,%AppSettingsIni%, ExeRunner, UsingExeRunner
    IniWrite,%A_ScriptDir%,%AppSettingsIni%, ExeRunner, OldAhkFileLocation
    FileMove, %A_ScriptFullPath%,%AppFolder%\%ScriptName%.ahk ,1
    GuiControl,,DownloadEXERunnerButton,Delete EXE Runner
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/exe/GameScripts.exe , %T_FileBeforeMoveLocation%\GameScripts.exe
    IsEXERunnerEnabled := true
}
return
OpenAppdataFolder:
run, %A_AppData%
return
OpenStartupFolder:
run, %A_Startup%
return
OpenWindowsTempFolder:
run, %A_Temp%
return
OpenMyDocuments:
run, %A_MyDocuments%
return
ToggleGameDVRON:
regWrite,REG_DWORD,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled,1
return
ToggleGameDVROFF:
regWrite,REG_DWORD,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled,0
return
XboxOverlayOn:
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR,AppCaptureEnabled,1
regWrite,REG_DWORD,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled,1
return
XboxOverlayOff:
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR,AppCaptureEnabled,0
regWrite,REG_DWORD,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled,0
return
GameModeOn:
regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AllowAutoGameMode,1
regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AutoGameModeEnabled,1
return
GameModeOff:
regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AllowAutoGameMode,0
regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AutoGameModeEnabled,0
return
;____________________________________________________________
;//////////////[Auto Run/Walk]///////////////
SaveToggleRun:
SaveHotkey(ToggleRunHotkey, "AutoRun")
goto EnableAutoRun
return
EnableAutoRun:
Gui, Submit, Nohide
if (ToggleRunHotkey == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    GuiControl,,AutoRunCheckbox,0
    return
}
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
;//////////////[Mouse hold]///////////////
MouseHoldEnabled:
Gui, Submit, Nohide
if (MouseHoldHotkey == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    GuiControl,,MouseHoldCheckbox,0
    return
}
if (MouseHoldCheckbox)
{
    Hotkey, %MouseHoldHotkey%,MouseHoldAction, ON
}
else
{
    Hotkey, %MouseHoldHotkey%,MouseHoldAction, Off
}
return
MouseHoldAction:
MouseHoldToggle := !MouseHoldToggle
if (MouseHoldToggle)
{
    if (MouseHoldList == "Left")
    {
        send {lbutton down}
    }
    else if (MouseHoldList == "Middle")
    {
        send {mbutton down}
    }
    else if (MouseHoldList == "Right")
    {
        send {rbutton down}
    }
}
else
{
    if (MouseHoldList == "Left")
    {
        send {lbutton up}
    }
    else if (MouseHoldList == "Middle")
    {
        send {mbutton up}
    }
    else if (MouseHoldList == "Right")
    {
        send {rbutton up}
    }
}
return
SaveMouseHoldSettings:
SaveHotkey(MouseHoldHotkey, "MouseHoldHotkey")
;SaveHotkey(MouseHoldList,"MouseHoldButton") ;Save to gamemode. Same as hotkey
return
;____________________________________________________________
;//////////////[Mouse Clicker]///////////////
MouseClickerEnabled:
Gui, Submit, Nohide
if (MouseClickerHotkey == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    GuiControl,,MouseClickerCheckbox,0
    return
}
if (MouseClickerCheckbox)
{
    Hotkey, %MouseClickerHotkey%,MouseClickerAction, ON
}
else
{
    Hotkey, %MouseClickerHotkey%,MouseClickerAction, Off
}
return
MouseClickerAction:
MouseClickerToggle := !MouseClickerToggle
While (MouseClickerToggle)
{
    MouseClick, %MouseClickerList%
    sleep %MouseClickerDelay%
}
return
SaveMouseClickerSettings:
SaveHotkey(MouseClickerHotkey, "MouseClickerHotkey")
SaveHotkey(MouseClickerDelay, "MouseClickerDelay")
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Other Scripts]///////////////
DownloadLogitechGHUBTool:
if (!GHUBTool)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppOtherScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/LogitechBackupProfilesAhk/master/LogitechBackupProfiles.ahk, %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    ;write save/Update Gui
    GuiControl, , DowloadGHUBToolButton, Run
    GuiControl, Enable,UninstallGHUBToolScritpButton
    GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    GHUBTool := True
}
Else ;app is already istalled/downloaded
{
    run, %GHUBToolLocation%
}
Return
UninstallGHUBToolScript:
UninstallScript("GHUBTool")
Return
;____________________________________________________________
;____________________________________________________________
;//////////////[Numpad Macro Deck]///////////////
DeckNumlock:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,NumLock
NumpadDeckSelected := "NumLock"
SwitchButtonColor("Numlock","NumLockSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckDivision:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,Division
NumpadDeckSelected := "Division"
SwitchButtonColor("Division","DivisionSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckMultiplication:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,Multiplication
NumpadDeckSelected := "Multiplication"
SwitchButtonColor("Multiplication","MultiplicationSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckSubtraction:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,Subtraction
NumpadDeckSelected := "Subtraction"
SwitchButtonColor("subtraction","subtractionSelected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck0:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,0
NumpadDeckSelected := "0"
SwitchButtonColor("0","0Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck1:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,1
NumpadDeckSelected := "1"
SwitchButtonColor("1","1Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck2:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,2
NumpadDeckSelected := "2"
SwitchButtonColor("2","2Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck3:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,3
NumpadDeckSelected := "3"
SwitchButtonColor("3","3Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck4:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,4
NumpadDeckSelected := "4"
SwitchButtonColor("4","4Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck5:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,5
NumpadDeckSelected := "5"
SwitchButtonColor("5","5Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck6:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,6
NumpadDeckSelected := "6"
SwitchButtonColor("6","6Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck7:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,7
NumpadDeckSelected := "7"
SwitchButtonColor("7","7Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck8:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,8
NumpadDeckSelected := "8"
SwitchButtonColor("8","8Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck9:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,9
NumpadDeckSelected := "9"
SwitchButtonColor("9","9Selected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckAddition:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,Addition
NumpadDeckSelected := "Addition"
SwitchButtonColor("Addition","AdditionSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckEnter:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,Enter
NumpadDeckSelected := "Enter"
SwitchButtonColor("Enter","EnterSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckDot:
ResetNumpadButtons()
GuiControl,,DeckCurrentlyActive,Dot
NumpadDeckSelected := "Dot"
SwitchButtonColor("Dot","DotSelected")
UpdateNumlockMacroDeckActionBoxes()
return
;//////////////[NumpadMacroDeckEnableHotkeys]///////////////
NumpadMacroDeckEnableHotkeys:
Gui, Submit, Nohide
if(NumpadMacroDeckEnableHotkeysCheckbox)
{
    NumpadMacroDeckSetHotkeys(true)
    ;Disable buttons (Cant edit macros while active)
    GuiControl,Disable,NumpadMacroDeckTextRadio
    GuiControl,Disable,NumpadMacroDeckHotkeyRadio
    GuiControl,Disable,NumpadMacroDeckTextEdit
    GuiControl,Disable,NumpadMacroDeckHotkeyBox
    GuiControl,Disable,NumpadMacroDeckSaveSettingsButton
    GuiControl,Disable,NumpadMacroDeckDeleteSettingsButton

    hotkey,NumLock,NumpadMacroDeckNumLockAction
    hotkey,NumLock,ON
}
else
{
    NumpadMacroDeckSetHotkeys(false)
    GuiControl,Enable,NumpadMacroDeckTextRadio
    GuiControl,Enable,NumpadMacroDeckHotkeyRadio
    GuiControl,Enable,NumpadMacroDeckTextEdit
    GuiControl,Enable,NumpadMacroDeckHotkeyBox
    GuiControl,Enable,NumpadMacroDeckSaveSettingsButton
    GuiControl,Enable,NumpadMacroDeckDeleteSettingsButton
    hotkey,NumLock,OFF
}
return
;//////////////[NumpadMacroDeckSaveSettings]///////////////
NumpadMacroDeckSaveSettings:
if (NumpadMacroDeckTextRadio)
{
    IniWrite, %NumpadMacroDeckTextEdit%, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected% ;Save action
    IniWrite, true, %NumpadMacroDeckSettingsIni%, Enabled, %NumpadDeckSelected% ;Save enabled state
    IniWrite, %NumpadMacroDeckTextRadio%, %NumpadMacroDeckSettingsIni%, RadioButtonStates, %NumpadDeckSelected% ;Save Radio button state
}
else
{
    IniWrite, %NumpadMacroDeckHotkeyBox%, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected% ;Save action
    IniWrite, true, %NumpadMacroDeckSettingsIni%, Enabled, %NumpadDeckSelected% ;Save enabled state
    IniWrite, %NumpadMacroDeckTextRadio%, %NumpadMacroDeckSettingsIni%, RadioButtonStates, %NumpadDeckSelected% ;Save Radio button state
}
SetNumpadButtonState(NumpadDeckSelected, true) ;Set button color to green
return
;//////////////[NumpadMacroDeckDeleteSettings]///////////////
NumpadMacroDeckDeleteSettings:
IniDelete,%NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
IniDelete,%NumpadMacroDeckSettingsIni%, Enabled, %NumpadDeckSelected%
IniDelete,%NumpadMacroDeckSettingsIni%, RadioButtonStates, %NumpadDeckSelected%
SetNumpadButtonState(NumpadDeckSelected, false) ;Set button color to Red
return
;//////////////[NumpadMacroDeckHotkeys]///////////////
NumpadMacroDeckNumLockAction:
if(NumpadMacroDeckToggleBetweenNumpad)
{
    NumpadMacroDeckSetHotkeys(false)
    NumpadMacroDeckToggleBetweenNumpad := false
}
else
{
    NumpadMacroDeckSetHotkeys(true)
    NumpadMacroDeckToggleBetweenNumpad := true
}
return
NumpadMacroDeckDivisionAction:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,Division
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Division
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Division
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeckMultiplicationAction:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,Multiplication
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Multiplication
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Multiplication
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeckSubtractionAction:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,Subtraction
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Subtraction
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Subtraction
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck0Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,0
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 0
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 0
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck1Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 1
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 1
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck2Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 2
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 2
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck3Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 3
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 3
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck4Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 4
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 4
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck5Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 5
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 5
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck6Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 6
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 6
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck7Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 7
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 7
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck8Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 8
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 8
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeck9Action:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 9
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, 9
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeckAdditionAction:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Addition
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Addition
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeckEnterAction:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Enter
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Enter
    send, %T_NumpadMacroDeckText%
}
return
NumpadMacroDeckDotAction:
IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
if(T_RadioButtonState)
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Dot
    sendraw, %T_NumpadMacroDeckText%
}
else
{
    IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, Dot
    send, %T_NumpadMacroDeckText%
}
return
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
            FileRemoveDir, %GuiPictureFolder%, 1 ;Delete gui pictures
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
if(IsEXERunnerEnabled)
{
    IniRead, T_RevertLocation,%AppSettingsIni%, ExeRunner, ExeFileLocation
    if(T_RevertLocation = "ERROR")
    {
        iniread,T_RevertLocation,%AppSettingsIni%, ExeRunner, OldAhkFileLocation
    }
    FileCreateShortcut,"T_RevertLocation\%ScriptName%.exe", %A_Desktop%\%ScriptName%.lnk
}
else
{
    FileCreateShortcut,"%A_ScriptFullPath%", %A_Desktop%\%ScriptName%.lnk
}
return
DownloadGuiPictures()
{
    SplashTextOn, 300,60,Downloading GUI Pictures, Script will run after all GUI pictures has been downloaded
    FileCreateDir,%GuiPictureFolder%
    sleep 100
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/GameScripts.ico , %GuiPictureFolder%/GameScripts.ico ;icon
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/NumLockBlue.png , %GuiPictureFolder%/NumLockBlue.png

    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Division.png , %GuiPictureFolder%/Division.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/DivisionEnabled.png , %GuiPictureFolder%/DivisionEnabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/DivisionSelected.png , %GuiPictureFolder%/DivisionSelected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Multiplication.png , %GuiPictureFolder%/Multiplication.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/MultiplicationEnabled.png , %GuiPictureFolder%/MultiplicationEnabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/MultiplicationSelected.png , %GuiPictureFolder%/MultiplicationSelected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Subtraction.png , %GuiPictureFolder%/Subtraction.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/SubtractionEnabled.png , %GuiPictureFolder%/SubtractionEnabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/SubtractionSelected.png , %GuiPictureFolder%/SubtractionSelected.png
    ;nums
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/0.png , %GuiPictureFolder%/0.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/0Enabled.png , %GuiPictureFolder%/0Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/0Selected.png , %GuiPictureFolder%/0Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/1.png , %GuiPictureFolder%/1.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/1Enabled.png , %GuiPictureFolder%/1Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/1Selected.png , %GuiPictureFolder%/1Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/2.png , %GuiPictureFolder%/2.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/2Enabled.png , %GuiPictureFolder%/2Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/2Selected.png , %GuiPictureFolder%/2Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/3.png , %GuiPictureFolder%/3.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/3Enabled.png , %GuiPictureFolder%/3Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/3Selected.png , %GuiPictureFolder%/3Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/4.png , %GuiPictureFolder%/4.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/4Enabled.png , %GuiPictureFolder%/4Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/4Selected.png , %GuiPictureFolder%/4Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/5.png , %GuiPictureFolder%/5.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/5Enabled.png , %GuiPictureFolder%/5Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/5Selected.png , %GuiPictureFolder%/5Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/6.png , %GuiPictureFolder%/6.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/6Enabled.png , %GuiPictureFolder%/6Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/6Selected.png , %GuiPictureFolder%/6Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/7.png , %GuiPictureFolder%/7.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/7Enabled.png , %GuiPictureFolder%/7Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/7Selected.png , %GuiPictureFolder%/7Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/8.png , %GuiPictureFolder%/8.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/8Enabled.png , %GuiPictureFolder%/8Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/8Selected.png , %GuiPictureFolder%/8Selected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/9.png , %GuiPictureFolder%/9.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/9Enabled.png , %GuiPictureFolder%/9Enabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/9Selected.png , %GuiPictureFolder%/9Selected.png
    ;nums end
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Addition.png , %GuiPictureFolder%/Addition.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/AdditionEnabled.png , %GuiPictureFolder%/AdditionEnabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/AdditionSelected.png , %GuiPictureFolder%/AdditionSelected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Enter.png , %GuiPictureFolder%/Enter.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/EnterEnabled.png , %GuiPictureFolder%/EnterEnabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/EnterSelected.png , %GuiPictureFolder%/EnterSelected.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Dot.png , %GuiPictureFolder%/Dot.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/DotEnabled.png , %GuiPictureFolder%/DotEnabled.png
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/DotSelected.png , %GuiPictureFolder%/DotSelected.png
    SplashTextOff
}
;____________________________________________________________
;//////////////[Links]///////////////
OpenGHUBToolGithub:
run, https://github.com/veskeli/LogitechBackupProfilesAhk
Return
;____________________________________________________________
;____________________________________________________________
;//////////////[Functions]///////////////
SaveHotkey(tHotkey, tKey)
{
    Gui, Submit, Nohide
    IniWrite, %tHotkey%, %AppHotkeysIni%, GameMode, %tKey%
}
UninstallScript(tName)
{
    if (tName == "GHUBTool")
    {
        FileDelete, %GHUBToolLocation%
        GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
        GHUBTool := False
        GuiControl, , DowloadGHUBToolButton, Download
        GuiControl, Disable ,UninstallGHUBToolScritpButton
    } 
}
SwitchButtonColor(T_Button,T_PictureName)
{
    GuiControl,,Deck%T_Button%Control,%GuiPictureFolder%\%T_PictureName%.png
}
ResetNumpadButtons()
{
    ;MsgBox, % NumpadDeckEnalbedArray[%NumpadDeckSelected%] NumpadDeckSelected
    
    if(NumpadDeckSelected == "NumLock")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,DeckNumLockControl,%GuiPictureFolder%\NumLock.png
        return
    }
    if(NumpadDeckSelected == "Division")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,DeckDivisionControl,%GuiPictureFolder%\Division.png
        return
    }
    if(NumpadDeckSelected == "Multiplication")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,DeckMultiplicationControl,%GuiPictureFolder%\Multiplication.png
        return
    }
    if(NumpadDeckSelected == "Subtraction")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,DeckSubtractionControl,%GuiPictureFolder%\Subtraction.png
        return
    }
    if(NumpadDeckSelected == "0")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck0Control,%GuiPictureFolder%\0.png
        return
    } 
    if(NumpadDeckSelected == "1")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck1Control,%GuiPictureFolder%\1.png
        return
    } 
    if(NumpadDeckSelected == "2")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck2Control,%GuiPictureFolder%\2.png
        return
    } 
    if(NumpadDeckSelected == "3")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck3Control,%GuiPictureFolder%\3.png
        return
    } 
    if(NumpadDeckSelected == "4")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck4Control,%GuiPictureFolder%\4.png
        return
    } 
    if(NumpadDeckSelected == "5")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck5Control,%GuiPictureFolder%\5.png
        return
    } 
    if(NumpadDeckSelected == "6")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck6Control,%GuiPictureFolder%\6.png
        return
    } 
    if(NumpadDeckSelected == "7")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck7Control,%GuiPictureFolder%\7.png
        return
    } 
    if(NumpadDeckSelected == "8")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck8Control,%GuiPictureFolder%\8.png
        return
    } 
    if(NumpadDeckSelected == "9")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,Deck9Control,%GuiPictureFolder%\9.png
        return
    } 
    if(NumpadDeckSelected == "Addition")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,DeckAdditionControl,%GuiPictureFolder%\Addition.png
        return
    }
    if(NumpadDeckSelected == "Enter")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,DeckEnterControl,%GuiPictureFolder%\Enter.png
        return
    }
    if(NumpadDeckSelected == "Dot")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,,DeckDotControl,%GuiPictureFolder%\Dot.png
        return
    }
}
SetNumpadButtonState(T_SelectedName,T_State)
{
    if(T_SelectedName == "NumLock")
    {
        DeckNumlockEnabled := T_State
    }
    if(T_SelectedName == "Division")
    {
        DeckDivisionEnabled := T_State
    }
    if(T_SelectedName == "Multiplication")
    {
        DeckMultiplicationEnabled := T_State
    }
    if(T_SelectedName == "Subtraction")
    {
        DeckSubtractionEnabled := T_State
    }
    ;num
    if(T_SelectedName == "0")
    {
        Deck0Enabled := T_State
    }
    if(T_SelectedName == "1")
    {
        Deck1Enabled := T_State
    }
    if(T_SelectedName == "2")
    {
        Deck2Enabled := T_State
    }
    if(T_SelectedName == "3")
    {
        Deck3Enabled := T_State
    }
    if(T_SelectedName == "4")
    {
        Deck4Enabled := T_State
    }
    if(T_SelectedName == "5")
    {
        Deck5Enabled := T_State
    }
    if(T_SelectedName == "6")
    {
        Deck6Enabled := T_State
    }
    if(T_SelectedName == "7")
    {
        Deck7Enabled := T_State
    }
    if(T_SelectedName == "8")
    {
        Deck8Enabled := T_State
    }
    if(T_SelectedName == "9")
    {
        Deck9Enabled := T_State
    }
    ;num end
    if(T_SelectedName == "Addition")
    {
        DeckAdditionEnabled := T_State
    }
    if(T_SelectedName == "Enter")
    {
        DeckEnterEnabled := T_State
    }
    if(T_SelectedName == "Dot")
    {
        DeckDotEnabled := T_State
    }
}
CheckForEnabledButtons()
{
    ;Division
    IniRead, T_DivisionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Division
    if(%T_DivisionIsEnabled% == true)
    {
        SetNumpadButtonState("Division", true)
        GuiControl,,DeckDivisionControl,%GuiPictureFolder%\DivisionEnabled.png
    }
    ;Multiplication
    IniRead, T_MultiplicationIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Multiplication
    if(%T_MultiplicationIsEnabled% == true)
    {
        SetNumpadButtonState("Multiplication", true)
        GuiControl,,DeckMultiplicationControl,%GuiPictureFolder%\MultiplicationEnabled.png
    }
    ;Subtraction
    IniRead, T_SubtractionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Subtraction
    if(%T_SubtractionIsEnabled% == true)
    {
        SetNumpadButtonState("Subtraction", true)
        GuiControl,,DeckSubtractionControl,%GuiPictureFolder%\SubtractionEnabled.png
    }

    ;0
    IniRead, T_0IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 0
    if(%T_0IsEnabled% == true)
    {
        SetNumpadButtonState("0", true)
        GuiControl,,Deck0Control,%GuiPictureFolder%\0Enabled.png
    }
    ;1
    IniRead, T_1IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 1
    if(%T_1IsEnabled% == true)
    {
        SetNumpadButtonState("1", true)
        GuiControl,,Deck1Control,%GuiPictureFolder%\1Enabled.png
    }
    ;2
    IniRead, T_2IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 2
    if(%T_2IsEnabled% == true)
    {
        SetNumpadButtonState("2", true)
        GuiControl,,Deck2Control,%GuiPictureFolder%\2Enabled.png
    }
    ;3
    IniRead, T_3IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 3
    if(%T_3IsEnabled% == true)
    {
        SetNumpadButtonState("3", true)
        GuiControl,,Deck3Control,%GuiPictureFolder%\3Enabled.png
    }
    ;4
    IniRead, T_4IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 4
    if(%T_4IsEnabled% == true)
    {
        SetNumpadButtonState("4", true)
        GuiControl,,Deck4Control,%GuiPictureFolder%\4Enabled.png
    }
    ;5
    IniRead, T_5IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 5
    if(%T_5IsEnabled% == true)
    {
        SetNumpadButtonState("5", true)
        GuiControl,,Deck5Control,%GuiPictureFolder%\5Enabled.png
    }
    ;6
    IniRead, T_6IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 6
    if(%T_6IsEnabled% == true)
    {
        SetNumpadButtonState("6", true)
        GuiControl,,Deck6Control,%GuiPictureFolder%\6Enabled.png
    }
    ;7
    IniRead, T_7IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 7
    if(%T_7IsEnabled% == true)
    {
        SetNumpadButtonState("7", true)
        GuiControl,,Deck7Control,%GuiPictureFolder%\7Enabled.png
    }
    ;8
    IniRead, T_8IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 8
    if(%T_8IsEnabled% == true)
    {
        SetNumpadButtonState("8", true)
        GuiControl,,Deck8Control,%GuiPictureFolder%\8Enabled.png
    }
    ;9
    IniRead, T_9IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 9
    if(%T_9IsEnabled% == true)
    {
        SetNumpadButtonState("9", true)
        GuiControl,,Deck9Control,%GuiPictureFolder%\9Enabled.png
    }

    ;Addition
    IniRead, T_AdditionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Addition
    if(%T_AdditionIsEnabled% == true)
    {
        SetNumpadButtonState("Addition", true)
        GuiControl,,DeckAdditionControl,%GuiPictureFolder%\AdditionEnabled.png
    }
    ;Enter
    IniRead, T_EnterIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Enter
    if(%T_EnterIsEnabled% == true)
    {
        SetNumpadButtonState("Enter", true)
        GuiControl,,DeckEnterControl,%GuiPictureFolder%\EnterEnabled.png
    }
    ;Dot
    IniRead, T_DotIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Dot
    if(%T_DotIsEnabled% == true)
    {
        SetNumpadButtonState("Dot", true)
        GuiControl,,DeckDotControl,%GuiPictureFolder%\DotEnabled.png
    }
}
UpdateNumlockMacroDeckActionBoxes()
{
    ;//////////////[Read radiobutton state and then change it]///////////////
    IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
    if(T_RadioButtonState)
    {
        GuiControl,,NumpadMacroDeckTextRadio,1
    }
    else
    {
        GuiControl,,NumpadMacroDeckHotkeyRadio,1
    }
    ;//////////////[Read value]///////////////
    if(NumpadDeckSelected == "NumLock")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "Division")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "Multiplication")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "Subtraction")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    ;num
    if(NumpadDeckSelected == "0")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "1")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "2")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "3")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "4")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "5")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "6")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "7")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "8")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "9")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    ;num end
    if(NumpadDeckSelected == "Addition")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "Enter")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
    if(NumpadDeckSelected == "Dot")
    {
        if(T_RadioButtonState)
        {
            IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckHotkeyBox,
                GuiControl,, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
            }
        }
        else
        {
            IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
            if(T_NumpadMacroDeckText == "ERROR")
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,
            }
            else
            {
                GuiControl,, NumpadMacroDeckTextEdit,
                GuiControl,, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
            }
        }
    }
}
NumpadMacroDeckSetHotkeys(T_HotkeysState)
{
    if(T_HotkeysState)
    {
        ;Division
        IniRead, T_DivisionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Division
        if(%T_DivisionIsEnabled% == true)
        {
            hotkey,NumpadDiv,NumpadMacroDeckDivisionAction
            hotkey,NumpadDiv,ON
        }
        ;Multiplication
        IniRead, T_MultiplicationIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Multiplication
        if(%T_MultiplicationIsEnabled% == true)
        {
            hotkey,NumpadMult,NumpadMacroDeckMultiplicationAction
            hotkey,NumpadMult,ON
        }
        ;Subtraction
        IniRead, T_SubtractionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Subtraction
        if(%T_SubtractionIsEnabled% == true)
        {
            hotkey,NumpadSub,NumpadMacroDeckSubtractionAction
            hotkey,NumpadSub,ON
        }

        ;0
        IniRead, T_0IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 0
        if(%T_0IsEnabled% == true)
        {
            hotkey,Numpad0,NumpadMacroDeck0Action
            hotkey,Numpad0,ON
        }
        ;1
        IniRead, T_1IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 1
        if(%T_1IsEnabled% == true)
        {
            hotkey,Numpad1,NumpadMacroDeck1Action
            hotkey,Numpad1,ON
        }
        ;2
        IniRead, T_2IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 2
        if(%T_2IsEnabled% == true)
        {
            hotkey,Numpad2,NumpadMacroDeck2Action
            hotkey,Numpad2,ON
        }
        ;3
        IniRead, T_3IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 3
        if(%T_3IsEnabled% == true)
        {
            hotkey,Numpad3,NumpadMacroDeck3Action
            hotkey,Numpad3,ON
        }
        ;4
        IniRead, T_4IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 4
        if(%T_4IsEnabled% == true)
        {
            hotkey,Numpad4,NumpadMacroDeck4Action
            hotkey,Numpad4,ON
        }
        ;5
        IniRead, T_5IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 5
        if(%T_5IsEnabled% == true)
        {
            hotkey,Numpad5,NumpadMacroDeck5Action
            hotkey,Numpad5,ON
        }
        ;6
        IniRead, T_6IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 6
        if(%T_6IsEnabled% == true)
        {
            hotkey,Numpad6,NumpadMacroDeck6Action
            hotkey,Numpad6,ON
        }
        ;7
        IniRead, T_7IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 7
        if(%T_7IsEnabled% == true)
        {
            hotkey,Numpad7,NumpadMacroDeck7Action
            hotkey,Numpad7,ON
        }
        ;8
        IniRead, T_8IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 8
        if(%T_8IsEnabled% == true)
        {
            hotkey,Numpad8,NumpadMacroDeck8Action
            hotkey,Numpad8,ON
        }
        ;9
        IniRead, T_9IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 9
        if(%T_9IsEnabled% == true)
        {
            hotkey,Numpad9,NumpadMacroDeck9Action
            hotkey,Numpad9,ON
        }

        ;Addition
        IniRead, T_AdditionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Addition
        if(%T_AdditionIsEnabled% == true)
        {
            hotkey,NumpadAdd,NumpadMacroDeckAdditionAction
            hotkey,NumpadAdd,ON
        }
        ;Enter
        IniRead, T_EnterIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Enter
        if(%T_EnterIsEnabled% == true)
        {
            hotkey,NumpadEnter,NumpadMacroDeckEnterAction
            hotkey,NumpadEnter,ON
        }
        ;Dot
        IniRead, T_DotIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Dot
        if(%T_DotIsEnabled% == true)
        {
            hotkey,NumpadDot,NumpadMacroDeckDotAction
            hotkey,NumpadDot,ON
        }
    }
    else
    {
        ;Division
        IniRead, T_DivisionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Division
        if(%T_DivisionIsEnabled% == true)
        {
            hotkey,NumpadDiv,OFF,UseErrorLevel
        }
        ;Multiplication
        IniRead, T_MultiplicationIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Multiplication
        if(%T_MultiplicationIsEnabled% == true)
        {
            hotkey,NumpadMult,OFF,UseErrorLevel
        }
        ;Subtraction
        IniRead, T_SubtractionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Subtraction
        if(%T_SubtractionIsEnabled% == true)
        {
            hotkey,NumpadSub,OFF,UseErrorLevel
        }

        ;0
        IniRead, T_0IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 0
        if(%T_0IsEnabled% == true)
        {
            hotkey,Numpad0,OFF,UseErrorLevel
        }
        ;1
        IniRead, T_1IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 1
        if(%T_1IsEnabled% == true)
        {
            hotkey,Numpad1,OFF,UseErrorLevel
        }
        ;2
        IniRead, T_2IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 2
        if(%T_2IsEnabled% == true)
        {
            hotkey,Numpad2,OFF,UseErrorLevel
        }
        ;3
        IniRead, T_3IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 3
        if(%T_3IsEnabled% == true)
        {
            hotkey,Numpad3,OFF,UseErrorLevel
        }
        ;4
        IniRead, T_4IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 4
        if(%T_4IsEnabled% == true)
        {
            hotkey,Numpad4,OFF,UseErrorLevel
        }
        ;5
        IniRead, T_5IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 5
        if(%T_5IsEnabled% == true)
        {
            hotkey,Numpad5,OFF,UseErrorLevel
        }
        ;6
        IniRead, T_6IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 6
        if(%T_6IsEnabled% == true)
        {
            hotkey,Numpad6,OFF,UseErrorLevel
        }
        ;7
        IniRead, T_7IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 7
        if(%T_7IsEnabled% == true)
        {
            hotkey,Numpad7,OFF,UseErrorLevel
        }
        ;8
        IniRead, T_8IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 8
        if(%T_8IsEnabled% == true)
        {
            hotkey,Numpad8,OFF,UseErrorLevel
        }
        ;9
        IniRead, T_9IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 9
        if(%T_9IsEnabled% == true)
        {
            hotkey,Numpad9,OFF,UseErrorLevel
        }

        ;Addition
        IniRead, T_AdditionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Addition
        if(%T_AdditionIsEnabled% == true)
        {
            hotkey,NumpadAdd,OFF,UseErrorLevel
        }
        ;Enter
        IniRead, T_EnterIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Enter
        if(%T_EnterIsEnabled% == true)
        {
            hotkey,NumpadEnter,OFF,UseErrorLevel
        }
        ;Dot
        IniRead, T_DotIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Dot
        if(%T_DotIsEnabled% == true)
        {
            hotkey,NumpadDot,OFF,UseErrorLevel
        }
    }
}