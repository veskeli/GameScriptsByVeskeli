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
;____________________________________________________________
;//////////////[variables]///////////////
ScriptName = GameScripts
AppFolderName = AHKGameScriptsByVeskeli
AppFolder = %A_AppData%\%AppFolderName%
AppSettingsFolder = %AppFolder%\Settings
AppSettingsIni = %AppSettingsFolder%\Settings.ini
AppGameScriptSettingsIni = %AppSettingsFolder%\GameScriptSettings.ini
AppHotkeysIni = %AppSettingsFolder%\Hotkeys.ini
AppUpdateFile = %AppFolder%\temp\OldFile.ahk
AppGamingScriptsFolder = %AppFolder%\GamingScripts
AppOtherScriptsFolder = %AppFolder%\OtherScripts
AppCustomMacrosFolder = %AppFolder%\CustomMacros
version = 0.365
IsThisExperimental := true
GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
NgrokToolLocation = %AppOtherScriptsFolder%\Ngrok.ahk
BetterDiscordTroubleshooterLocation = %AppOtherScriptsFolder%\BetterDiscordTroubleshooter.ahk
FactorioToolLocation = %AppGamingScriptsFolder%\FactorioTool.ahk
GuiPictureFolder = %AppFolder%\Gui
NumpadMacroDeckSettingsIni = %AppSettingsFolder%\NumpadMacroDeck.ini
;other scipts (Bool)
GHUBTool := false
NgrokTool := false
FactorioTool := false
BetterDiscordTroubleshooter := false
;Numpad Macro Deck
NumpadDeckSelected := ""
CurrentCustomMacro := ""
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
CloseToTray := false
ToggleNumpadMacroDeck := false
IsMacroGuiOpen := false
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
global FactorioToolLocation
global NgrokToolLocation
global NgrokTool
global FactorioTool
global BetterDiscordTroubleshooterLocation
global BetterDiscordTroubleshooter
global GHUBTool
global AppCustomMacrosFolder
;numpadmacrodeck
global GuiPictureFolder
global NumpadDeckSelected
global NumpadMacroDeckSettingsIni
global IsMacroGuiOpen
;global NumpadDeckEnalbedArray
global CurrentCustomMacro
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
;
global CloseToTray
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
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Tab3, x-1 y-1 w840 h521 gUpdateGUIWhenSwitchingTabs vUpdateGUIWhenSwitchingTabsTab3, GameMode|GamingScripts|Settings|Other scripts|Numpad Macro Deck|Windows
;//////////////[GameMode]///////////////
Gui 1:Tab, 1
Gui 1:Font
Gui 1:Font, s11
;//////////////[Mouse Hold]///////////////
Gui 1:Add, GroupBox, x375 y27 w450 h56, Mouse Hold
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x381 y48 w83 h23 +0x200, Mouse button:
Gui 1:Add, DropDownList, x471 y48 w88 gGuiSubmit vMouseHoldList, Left||Middle|Right
Gui 1:Add, Text, x562 y48 w47 h23 +0x200, Hotkey:
Gui 1:Add, Hotkey, x614 y48 w120 h21 gGuiSubmit vMouseHoldHotkey
Gui 1:Add, Button, x737 y37 w80 h23 gSaveMouseHoldSettings, Save Hotkey
Gui 1:Font
Gui 1:Font, s11
Gui 1:Add, CheckBox, x740 y61 w70 h18 gMouseHoldEnabled vMouseHoldCheckbox, Enabled
Gui 1:Font
Gui 1:Font, s11
;//////////////[Mouse Clicker]///////////////
Gui 1:Add, GroupBox, x375 y86 w450 h80, Mouse Clicker
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x381 y104 w83 h23 +0x200 , Mouse button:
Gui 1:Add, DropDownList, x471 y104 w88 gGuiSubmit vMouseClickerList, Left||Middle|Right
Gui 1:Add, Text, x562 y104 w47 h23 +0x200 , Hotkey:
Gui 1:Add, Hotkey, x614 y104 w120 h21 gGuiSubmit vMouseClickerHotkey
Gui 1:Add, Button, x737 y104 w80 h23 gSaveMouseClickerSettings, Save Settings
Gui 1:Add, Text, x383 y134 w62 h23 +0x200 , Timer: (ms)
Gui 1:Add, Edit, x449 y136 w120 h21 +Number gGuiSubmit vMouseClickerDelay, 150
Gui 1:Font
Gui 1:Font, s11
Gui 1:Add, CheckBox, x743 y132 w70 h23 gMouseClickerEnabled vMouseClickerCheckbox, Enabled
Gui 1:Font
Gui 1:Font, s11
;//////////////[Auto Run/Walk]///////////////
Gui 1:Add, GroupBox, x375 y168 w450 h78, Auto Run/Walk (Holds "W" so only 3D games)
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x385 y185 w47 h23 +0x200, Hotkey:
Gui 1:Add, Hotkey, x438 y185 w120 h21 gGuiSubmit vToggleRunHotkey
Gui 1:Add, Button, x737 y185 w80 h23 gSaveToggleRun, Save Hotkey
Gui 1:Add, CheckBox, x385 y212 w93 h23 +Checked gAutoRunUseShiftButton, Run (Use shift)
;Gui 1:Add, CheckBox, x564 y183 w171 h23 gGuiSubmit vTurnOffAutoRunByMovement, Turn off by any movement
Gui 1:Font
Gui 1:Font, s11
Gui 1:Add, CheckBox, x745 y214 w70 h23 gEnableAutoRun vAutoRunCheckbox, Enabled
Gui 1:Font
Gui 1:Font, s11
Gui 1:Add, GroupBox, x375 y257 w450 h143, Capture only in game
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Font
Gui 1:Font, s13
Gui 1:Add, CheckBox, x383 y279 w183 h23 +Disabled, Capture only in game
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x381 y311 w107 h23 +0x200 +Disabled, Game/application:
Gui 1:Add, DropDownList, x492 y311 w292 +Disabled, App||
Gui 1:Add, Text, x380 y339 w98 h23 +0x200 +Disabled, Custom WinTitle:
Gui 1:Add, Edit, x482 y340 w302 h21 +Disabled
Gui 1:Add, Button, x737 y275 w80 h23 +Disabled, Save settings
Gui 1:Add, Text, x380 y364 w43 h23 +0x200 +Disabled, Games:
Gui 1:Add, DropDownList, x428 y364 w356 +Disabled, Game||
Gui 1:Add, Radio, x792 y312 w19 h23 +Checked +Disabled
Gui 1:Add, Radio, x792 y338 w19 h23 +Disabled
Gui 1:Add, Radio, x792 y364 w19 h23 +Disabled
Gui 1:Font
Gui 1:Font, s11
;//////////////[Always on top]///////////////
Gui 1:Add, GroupBox, x2 y27 w367 h55, Toggle any application to Always on top by hotkey
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x9 y50 w47 h23 +0x200, Hotkey:
Gui 1:Add, Hotkey, x59 y50 w120 h21 vAlwaysOnTopHotkey gGuiSubmit
Gui 1:Add, Button, x281 y49 w80 h23 gSaveAlwaysOnTopHotkey, Save Hotkey
Gui 1:Font
Gui 1:Font, s11
Gui 1:Add, CheckBox, x201 y51 w70 h23 gEnableAlwaysOnTop vAlwaysOnTopCheckbox, Enabled
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Font
Gui 1:Font, s9, Segoe UI
;//////////////[Disable buttons]///////////////
Gui 1:Add, GroupBox, x375 y400 w450 h111, Disable buttons
Gui 1:Add, CheckBox, x383 y426 w156 h23 gDisableWindowsButton vDisableWindowsCheckbox, Disable Windows button
Gui 1:Add, CheckBox, x383 y450 w120 h23 gDisableCapsLockButton vDisableCapsLockCheckbox, Disable Caps Lock
Gui 1:Add, CheckBox, x542 y426 w74 h23 gEnableWindowsRebind vRebindWindowsCheckbox, Rebind to:
Gui 1:Add, Hotkey, x622 y427 w120 h21 gGuiSubmit vRebindWindowsButton ;Windows
Gui 1:Add, CheckBox, x542 y450 w77 h23 gEnableCapsLockRebind vRebindCapsLockCheckbox, Rebind to:
Gui 1:Add, Hotkey, x622 y451 w120 h21 gGuiSubmit vRebindCapsLockButton ;capslock
Gui 1:Add, Button, x732 y478 w80 h23 gSaveRebindHotkeys, Save Hotkeys
Gui 1:Add, CheckBox, x385 y479 w120 h23 gDisableAltTabButton vDisableAltTabCheckbox, Disable Alt + Tab
Gui 1:Font
Gui 1:Tab, 2
;____________________________________________________________
;//////////////[Game scripts]///////////////
;Factorio
Gui 1:Add, GroupBox, x3 y30 w830 h54, Factorio
Gui 1:Font, s14
Gui 1:Add, Text, x12 y48 w258 h32 +0x200, Factorio Tool
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Button, x360 y50 w100 h23 gDownloadFactorioTool vDownloadFactorioToolButton, Download
Gui 1:Add, CheckBox, x464 y50 w170 h23 +Disabled, Open/Close automatically
Gui 1:Add, CheckBox, x628 y50 w120 h23 +Disabled, Check for updates
Gui 1:Add, Button, x740 y50 w90 h23 gUninstallFactorioTool vUninstallFactorioToolButton +Disabled, Delete
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Tab, 3
;____________________________________________________________
;//////////////[Settings]///////////////
Gui 1:Add, GroupBox, x633 y433 w199 h78, Check for updates
Gui 1:Add, CheckBox, x646 y451 w172 h23 vCheckUpdatesOnStartup gAutoUpdates, Check for updates on startup
Gui 1:Add, Button, x666 y480 w126 h23 gcheckForupdates, Check updates
Gui 1:Font
Gui 1:Font, s14
Gui 1:Add, Text, x479 y488 w148 h23 +0x200, Version = %version%
Gui 1:Font
Gui 1:Add, Button, x479 y457 w148 h33 gDownloadExperimentalBranch +Hidden vDownloadExperimentalBranchButton , Download experimental branch
Gui 1:Font, s9, Segoe UI
Gui 1:Add, GroupBox, x633 y27 w196 h145, Delete stuff
Gui 1:Add, Button, x643 y70 w107 h23 gDeleteAppSettings, Delete all settings
Gui 1:Add, Button, x642 y43 w180 h23 gDeleteGameModeSettings, Delete all GameMode settings
;Gui 1:Add, Button, x643 y121 w175 h38 gDeleteAllFiles, Uninstall(Delete all including this script)
Gui 1:Add, Button, x643 y121 w175 h38 gDeleteAllFiles, Delete all files
Gui 1:Add, Button, x644 y95 w80 h23 +Disabled, Delete Scripts
Gui 1:Add, GroupBox, x633 y172 w196 h80, Clear
Gui 1:Add, Button, x658 y196 w139 h39 gClearGameModeHotkeys, Clear GameMode Hotkeys
;Gui 1:Add, Button, x723 y360 w103 h23 +Disabled, Show Changelog
Gui 1:Add, GroupBox, x506 y27 w128 h64, Shortcut
Gui 1:Add, Button, x520 y45 w108 h34 gShortcut_to_desktop, Shortcut to Desktop
Gui 1:Add, GroupBox, x0 y364 w317 h155, Exe Runner
Gui 1:Add, Button, x168 y480 w141 h32 vDownloadEXERunnerButton gDownloadEXERunner, Download EXE Runner
Gui 1:Add, Text, x8 y385 w306 h90, EXE Runner is simple Run script compiled to exe.`n(Moves this main script to Appdata and replaces this with an exe file)(You can always revert back)`nNew Features with exe Runner:`n+ You can pin this to taskbar`n+ Cool App Icon
Gui 1:Add, GroupBox, x633 y252 w196 h82, Open Folder
Gui 1:Add, Button, x655 y272 w150 h23 gOpenAppSettingsFolder, Open App Settings Folder
Gui 1:Add, Button, x677 y301 w110 h23 gOpenAppSettingsFile, Open Settings File
Gui 1:Add, GroupBox, x340 y27 w167 h53, Numpad Macro Deck
Gui 1:Add, Button, x348 y46 w100 h23 gNumpadMacroDeckDeleteAllSettings, Delete all Actions
Gui 1:Add, GroupBox, x633 y334 w197 h100, This Script
Gui 1:Add, Button, x647 y370 w145 h30 gRedownloadGuiPictures, Redownload Gui pictures
Gui 1:Add, CheckBox, x648 y401 w175 h27 gOnExitCloseToTray vOnExitCloseToTrayCheckbox, On Exit close to tray `n(Esc Still is ExitApp)
Gui 1:Font, s9, Segoe UI
Gui 1:Add, CheckBox, x648 y349 w147 h20 gKeepThisAlwaysOnTop, Keep this always on top
Gui 1:Font
Gui 1:Add, GroupBox, x145 y24 w196 h68, Backup Close
Gui 1:Add, CheckBox, x153 y43 w176 h39 gBackupClose vBackupCloseCheckbox, Close This Script if Some Games That doesn't like Ahk is running
Gui 1:Add, GroupBox, x4 y24 w142 h80, Admin
Gui 1:Add, Button, x19 y42 w101 h30 gRunAsThisAdmin vRunAsThisAdminButton, Run this as admin
Gui 1:Add, CheckBox, x17 y72 w120 h23 gRunAsThisAdminCheckboxButton vRunAsThisAdminCheckbox, Run as admin on start
Gui 1:Tab, 4
;____________________________________________________________
;//////////////[Other scripts]///////////////
;y + 55
Gui 1:Font
;//////////////[Logitech GHUB Tool]///////////////
Gui 1:Add, GroupBox, x3 y30 w823 h54, Logitech Backup Tool
Gui 1:Font, s14
Gui 1:Add, Text, x12 y48 w258 h32 +0x200, Logitech Backup Profiles Tool
Gui 1:Font
Gui 1:Add, Button, x390 y50 w100 h23 vDowloadGHUBToolButton gDownloadLogitechGHUBTool, Download
Gui 1:Add, Button, x494 y50 w130 h23 +Disabled, Check for updates
Gui 1:Add, Button, x628 y50 w97 h23 gOpenGHUBToolGithub, Open in Github
Gui 1:Add, Button, x730 y50 w80 h23 gUninstallGHUBToolScript vUninstallGHUBToolScritpButton +Disabled, Delete
Gui 1:Font
;//////////////[Ngrok Tool]///////////////
Gui 1:Add, GroupBox, x3 y85 w823 h54, Ngrok tool
Gui 1:Font, s14
Gui 1:Add, Text, x12 y102 w258 h32 +0x200, Ngrok Port fowarding tool
Gui 1:Font
Gui 1:Add, Button, x390 y105 w100 h23 gDownloadNgrokTool vDownloadNgrokToolButton, Download
Gui 1:Add, Button, x494 y105 w130 h23 +Disabled, Check for updates
Gui 1:Add, Button, x628 y105 w97 h23 gOpenNgrokInGithub, Open in Github
Gui 1:Add, Button, x730 y105 w80 h23 gUninstallNgrokTool vUninstallNgrokToolButton +Disabled, Delete
Gui 1:Font
;//////////////[Better Discord Troubleshooter]///////////////
Gui 1:Add, GroupBox, x3 y140 w823 h54, Better Discord Troubleshooter
Gui 1:Font, s14
Gui 1:Add, Text, x12 y157 w258 h32 +0x200, Better Discord Troubleshooter
Gui 1:Font
Gui 1:Add, Button, x390 y160 w100 h23 +Disabled gDownloadBetterDiscordTroubleshooter vDownloadBetterDiscordTroubleshooterButton, Download
Gui 1:Add, Button, x494 y160 w130 h23 +Disabled, Check for updates
Gui 1:Add, Button, x628 y160 w97 h23 gOpenBetterDiscordTroubleshooterGithub, Open in Github
Gui 1:Add, Button, x730 y160 w80 h23 gUninstallBetterDiscordTroubleshooter vUninstallBetterDiscordTroubleshooter +Disabled, Delete
Gui 1:Font
Gui 1:Tab, 5
;____________________________________________________________
;//////////////[Numpad Macro Deck]///////////////
Gui 1:Font, s17
Gui 1:Add, CheckBox, x304 y40 w343 h41 gNumpadMacroDeckEnableHotkeys vNumpadMacroDeckEnableHotkeysCheckbox, Numpad Macro Deck Enabled
Gui 1:Font
;Gui 1:Add, Text, x359 y73 w260 h23 +0x200, Num Lock Toggles between numpad and macro deck
Gui 1:Font, s14
Gui 1:Add, GroupBox, x0 y32 w288 h476, Numpad Deck Beta
;start
Gui 1:Font, s14
;Gui 1:Add, Picture, x24 y104 w60 h60 gDeckNumlock vDeckNumlockControl, %GuiPictureFolder%\NumLock.png
Gui 1:Add, Picture, x24 y104 w60 h60, %GuiPictureFolder%\NumLockBlue.png
Gui 1:Font, s14
Gui 1:Add, Picture, x88 y104 w60 h60 gDeckDivision vDeckDivisionControl, %GuiPictureFolder%\Division.png
Gui 1:Font, s14
Gui 1:Add, Picture, x152 y104 w60 h60 gDeckMultiplication vDeckMultiplicationControl, %GuiPictureFolder%\Multiplication.png
Gui 1:Font, s14
Gui 1:Add, Picture, x216 y104 w60 h60 gDeckSubtraction vDeckSubtractionControl, %GuiPictureFolder%\Subtraction.png
Gui 1:Font, s14
Gui 1:Add, Picture, x24 y168 w60 h60 gDeck7 vDeck7Control, %GuiPictureFolder%\7.png
Gui 1:Font, s14
Gui 1:Add, Picture, x88 y168 w60 h60 gDeck8 vDeck8Control, %GuiPictureFolder%\8.png
Gui 1:Font, s14
Gui 1:Add, Picture, x152 y168 w60 h60 gDeck9 vDeck9Control, %GuiPictureFolder%\9.png
Gui 1:Font, s14
Gui 1:Add, Picture, x216 y168 w60 h124 gDeckAddition vDeckAdditionControl, %GuiPictureFolder%\Addition.png
Gui 1:Font, s14
Gui 1:Add, Picture, x24 y232 w60 h60 gDeck4 vDeck4Control, %GuiPictureFolder%\4.png
Gui 1:Font, s14
Gui 1:Add, Picture, x88 y232 w60 h60 gDeck5 vDeck5Control, %GuiPictureFolder%\5.png
Gui 1:Font, s14
Gui 1:Add, Picture, x152 y232 w60 h60 gDeck6 vDeck6Control, %GuiPictureFolder%\6.png
Gui 1:Font, s14
Gui 1:Add, Picture, x24 y296 w60 h60 gDeck1 vDeck1Control, %GuiPictureFolder%\1.png
Gui 1:Font, s14
Gui 1:Add, Picture, x88 y296 w60 h60 gDeck2 vDeck2Control, %GuiPictureFolder%\2.png
Gui 1:Font, s14
Gui 1:Add, Picture, x152 y296 w60 h60 gDeck3 vDeck3Control, %GuiPictureFolder%\3.png
Gui 1:Font, s14
Gui 1:Add, Picture, x216 y296 w60 h124 gDeckEnter vDeckEnterControl, %GuiPictureFolder%\Enter.png
Gui 1:Font, s14
Gui 1:Add, Picture, x152 y360 w60 h60 gDeckDot vDeckDotControl, %GuiPictureFolder%\Dot.png
Gui 1:Font, s14
Gui 1:Add, Picture, x24 y360 w124 h60 gDeck0 vDeck0Control, %GuiPictureFolder%\0.png
Gui 1:Font
;End
Gui 1:Font, s14
Gui 1:Add, GroupBox, x287 y106 w370 h402, Actions (More changes coming later..)
Gui 1:Font
Gui 1:Add, Text, x296 y136 w329 h28 +0x200 vDeckCurrentlyActive,
;Radio buttons
Gui 1:Add, Radio, x296 y176 w52 h23 +Checked vNumpadMacroDeckTextRadio, Text
Gui 1:Add, Radio, x296 y208 w63 h23 vNumpadMacroDeckHotkeyRadio, Hotkey
Gui 1:Add, Radio, x296 y264 w85 h23 vNumpadCustomMacroRadio +disabled, Macro  Name:
;Text
Gui 1:Add, Edit, x352 y176 w293 h21 vNumpadMacroDeckTextEdit gGuiSubmit
;Hotkey
Gui 1:Add, Edit, x368 y208 w278 h21 vNumpadMacroDeckHotkeyBox gGuiSubmit
Gui 1:Add, Text, x296 y232 w139 h23 +0x200, (Alt = ! Control = ^ Shift = +)
Gui 1:Add, Link, x440 y232 w85 h23, <a href="https://www.autohotkey.com/docs/KeyList.htm">List of Hotkeys</a>
;Macro
Gui 1:Add, DropDownList, +disabled x384 y264 w150 h150 vCustomMacroDropDownList gUpdateCustomMacroDropDownList
Gui 1:Add, Button, +disabled x536 y263 w47 h23 gEditMacro, Edit
Gui 1:Add, Button, +disabled x583 y263 w73 h23 gCreateMacro vCreateOrEditMacroButton, Create macro
Gui 1:Font, s14
Gui 1:Add, Button, x456 y464 w143 h36 vNumpadMacroDeckSaveSettingsButton gNumpadMacroDeckSaveSettings, Save Settings
Gui 1:Add, Button, x304 y464 w143 h36 vNumpadMacroDeckDeleteSettingsButton gNumpadMacroDeckDeleteSettings, Delete Settings
Gui 1:Font
Gui 1:Tab, 6
;____________________________________________________________
;//////////////[Windows settigns/folders]///////////////
Gui 1:Font
Gui 1:Add, GroupBox, x0 y28 w102 h186, Open Folders
Gui 1:Add, Button, x10 y48 w85 h23 gOpenAppdataFolder, Appdata
Gui 1:Add, Button, x10 y74 w85 h23 gOpenStartupFolder, Startup
Gui 1:Add, Button, x10 y100 w85 h23 gOpenWindowsTempFolder, Windows Temp
Gui 1:Add, Button, x10 y126 w85 h23 gOpenMyDocuments, My Documents
Gui 1:Add, Button, x10 y152 w85 h23 gOpenDesktop, Desktop
Gui 1:Add, Button, x10 y179 w85 h23 gOpenStartMenu, StartMenu
Gui 1:Add, GroupBox, x101 y28 w164 h105, Toggle Windows game settings
Gui 1:Add, CheckBox, x109 y48 w115 h23 gToggleXboxOverlay vXboxOverlayCheckbox, Toggle Xbox overlay
Gui 1:Add, CheckBox, x110 y74 w111 h23 gToggleGameMode vToggleGameModeCheckbox, Toggle Game Mode
Gui 1:Add, CheckBox, x110 y100 w111 h23 gToggleGameDVR vToggleGameDVRCheckbox, Toggle Game DVR
Gui 1:Add, GroupBox, x101 y137 w163 h89, Clear stuff
Gui 1:Add, Button, x120 y155 w107 h23 gClearWindowsTempFolder, Clear Windows temp
Gui 1:Add, Button, x112 y184 w125 h33 gClearAllRecentDocumentsInWordpad, Clear all recent documents in wordpad
Gui 1:Add, GroupBox, x384 y32 w147 h119, Toggle windows settings
Gui 1:Add, CheckBox, x392 y54 w131 h23 gToggleClipboardHistory vToggleClipboardHistoryCheckbox, Clipboard history Sync
Gui 1:Add, CheckBox, x392 y81 w128 h28 gAutomaticallyBackupRegistery vAutomaticallyBackupRegisteryCheckbox, Automatically backup registery
Gui 1:Add, CheckBox, x392 y114 w120 h30 gClearVirtualMemoryPageFileAtShutdown vClearVirtualMemoryPageFileAtShutdownCheckbox, Clear Virtual memory page file at shutdown
Gui 1:Add, Button, x536 y48 w124 h23 gDisableMostOfAds, Disable Most of ads
Gui 1:Add, Button, x536 y72 w124 h23 gRestoreMostOfAds, Restore Most of ads
Gui 1:Add, CheckBox, x536 y96 w120 h28 gToggleAdvertisingIDForRelevantAds vToggleAdvertisingIDForRelevantAdsCheckbox, Advertising ID For Relevant ads
Gui 1:Add, CheckBox, x536 y128 w124 h45 gToggleFeaturedAutoInstall vToggleFeaturedAutoInstallCheckbox, Toggle Featured or Suggested Apps from Automatically Installing
Gui 1:Add, GroupBox, x530 y32 w135 h146, Windows 10 Fixes
Gui 1:Add, GroupBox, x264 y28 w121 h81
Gui 1:Add, Button, x275 y42 w97 h23 gOpenCmd, Open Cmd
Gui 1:Add, Button, x275 y68 w97 h23 gRunIpConfig, IPConfig
;____________________________________________________________
;//////////////[System]///////////////
;____________________________________________________________
;//////////////[Check for Settings]///////////////
IfExist, %AppHotkeysIni% 
{
    ;Always on top hotkey
    IniRead, Temp_AlwayOnTopHotkey, %AppHotkeysIni%, GameMode, AlwaysOnTopHotkey
	GuiControl,1:,AlwaysOnTopHotkey,%Temp_AlwayOnTopHotkey%
    ;Auto Run/Walk
    IniRead, Temp_AutoRunHotkey, %AppHotkeysIni%, GameMode, AutoRun
	GuiControl,1:,ToggleRunHotkey,%Temp_AutoRunHotkey%
    ;Rebind Windows button
    IniRead, Temp_RebindWindowsHotkey, %AppHotkeysIni%, GameMode, RebindWindowsButton
	GuiControl,1:,RebindWindowsButton,%Temp_RebindWindowsHotkey%
    ;Rebind Caps lock button
    IniRead, Temp_RebindCapsLockHotkey, %AppHotkeysIni%, GameMode, RebindCapsLockButton
	GuiControl,1:,RebindCapsLockButton,%Temp_RebindCapsLockHotkey%
    ;Mouse Hold
    IniRead, Temp_MouseHoldHotkey, %AppHotkeysIni%, GameMode, MouseHoldHotkey
    ;IniRead, Temp_MouseHoldButton, %AppHotkeysIni%, GameMode, MouseHoldButton
    GuiControl,1:,MouseHoldHotkey,%Temp_MouseHoldHotkey%
    ;GuiControl,1:,MouseHoldList,%Temp_MouseHoldButton%
    ;Mouse Clicker
    IniRead, Temp_MouseClickerHotkey, %AppHotkeysIni%, GameMode, MouseClickerHotkey
    IniRead, Temp_MouseClickerDelay, %AppHotkeysIni%, GameMode, MouseClickerDelay
	GuiControl,1:,MouseClickerHotkey,%Temp_MouseClickerHotkey%
    GuiControl,1:,MouseClickerDelay,%Temp_MouseClickerDelay%
    if (Temp_MouseClickerDelay == "ERROR")
    {
        GuiControl,1:,MouseClickerDelay, 150
    }
}
;Numpad Macro Deck
IfExist, %NumpadMacroDeckSettingsIni%
{
    CheckForEnabledButtons()
}
;Settings tab
IfExist, %AppSettingsIni%
{
    iniread, T_IsRunnerEnabled,%AppSettingsIni%, ExeRunner, UsingExeRunner
    if(%T_IsRunnerEnabled% == true)
    {
        GuiControl,1:Enable,Shortcut_to_taskbarButton
        GuiControl,1:,DownloadEXERunnerButton,Delete EXE Runner
        IsEXERunnerEnabled := true
    }
    else
    {
        IsEXERunnerEnabled := false
    }
    iniread, Temp_CloseToTray,%AppSettingsIni%,Settings,CloseToTray
    if(%Temp_CloseToTray% == true)
    {
        CloseToTray := true
        GuiControl,1:,OnExitCloseToTrayCheckbox,1
    }
    iniread, Temp_BackupClose,%AppSettingsIni%,Settings,BackupClose
    if(%Temp_BackupClose% == true)
    {
        SetTimer,DetectGames,4000
        GuiControl,1:,BackupCloseCheckbox,1
    }
    iniread, Temp_RunAsAdminOnStartup,%AppSettingsIni%,Settings,RunAsAdminOnStart
    if(Temp_RunAsAdminOnStartup == true)
    {
        GuiControl,1:,RunAsThisAdminCheckbox,1
        if(!A_IsAdmin)
        {
            Run *RunAs %A_ScriptFullPath%
            ExitApp
        }
    }
}
if(A_IsAdmin)
{
    GuiControl,1:,RunAsThisAdminButton,Already running as admin
    GuiControl,1:Disable,RunAsThisAdminButton
}
;Read From registery
UpdateSettingsFromRegistery()
;Update Custom macros list
UpdateCustomMacrosList()
;____________________________________________________________
;//////////////[Check for installed scripts]///////////////
IfExist %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
{
    GuiControl,1: , DowloadGHUBToolButton, Run
    GuiControl,1:Enable,UninstallGHUBToolScritpButton
    GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    GHUBTool := true
}
IfExist %AppOtherScriptsFolder%\Ngrok.ahk
{
    GuiControl,1: , DownloadNgrokToolButton, Run
    GuiControl,1:Enable,UninstallNgrokToolButton
    NgrokToolLocation = %AppOtherScriptsFolder%\Ngrok.ahk
    NgrokTool := true
}
IfExist %FactorioToolLocation%
{
    GuiControl,1:, DownloadFactorioToolButton, Run
    GuiControl,1: Enable,UninstallFactorioToolButton
    FactorioTool := true
}
IfExist %BetterDiscordTroubleshooterLocation%
{
    GuiControl,1:, DownloadBetterDiscordTroubleshooterButton, Run
    GuiControl,1: Enable,UninstallBetterDiscordTroubleshooter
    BetterDiscordTroubleshooter := true
}
IfExist, %A_AppData%\LogitechBackupProfilesAhk\Settings\Settings.ini
{
    IniRead, GHUBToolLocation, %A_AppData%\LogitechBackupProfilesAhk\Settings\Settings.ini,Info, ScriptPath
    IfNotExist, %GHUBToolLocation%
    {
        GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    }
    Else
    {
        GuiControl,1: , DowloadGHUBToolButton, Run
        GuiControl,1: Enable,UninstallGHUBToolScritpButton
        GHUBTool := true
    }
} 
;____________________________________________________________
;//////////////[Show Gui 1:After setting all saved settings]///////////////
Random,T_Coice_Num,1,20
If (T_Coice_Num = 1)
{
    Gui 1:Show, w835 h517,Remember to drink your daily dose of coffee.
}
else if (T_Coice_Num = 2)
{
    Gui 1:Show, w835 h517,Humanity runs on coffee.
}
else if (T_Coice_Num = 3)
{
    Gui 1:Show, w835 h517,I put coffee in my coffee
}
else if (T_Coice_Num = 4)
{
    Gui 1:Show, w835 h517,Coffee is always a good idea.
}
else if (T_Coice_Num = 5)
{
    Gui 1:Show, w835 h517,When life gives you lemons trade them for coffee.
}
else if (T_Coice_Num = 6)
{
    Gui 1:Show, w835 h517, I've had so much coffee today I can see noises.
}
else if (T_Coice_Num = 7)
{
    Gui 1:Show, w835 h517,I will start working when my coffee does.
}
else if (T_Coice_Num = 8)
{
    Gui 1:Show, w835 h517,Coffee runs through my veins.
}
else if (T_Coice_Num = 9)
{
    Gui 1:Show, w835 h517,Coffee helps me maintain my "never killed anyone streak"
}
else if (T_Coice_Num = 10)
{
    Gui 1:Show, w835 h517,Coffee is the gasoline of life
}
else if (T_Coice_Num = 11)
{
    Gui 1:Show, w835 h517,A bad day with coffee is better than a good day without it
}
else if (T_Coice_Num = 12)
{
    Gui 1:Show, w835 h517,No one can understand the truth until he drinks of coffee's frothy goodness.
}
else if (T_Coice_Num = 13)
{
    Gui 1:Show, w835 h517,I don't know how people live without coffee. I really don't.
}
else if (T_Coice_Num = 14)
{
    Gui 1:Show, w835 h517,There is no life without water. Because water is needed to make coffee.
}
else if (T_Coice_Num = 15)
{
    Gui 1:Show, w835 h517,Today's good mood is sponsored by coffee.
}
else if (T_Coice_Num = 16)
{
    Gui 1:Show, w835 h517,I like coffee because it gives me the illusion that I might be awake.
}
else if (T_Coice_Num = 17)
{
    Gui 1:Show, w835 h517,The most dangerous drinking game is seeing how long I can go without coffee.
}
else if (T_Coice_Num = 18)
{
    Gui 1:Show, w835 h517,Sometimes I go hours without drinking coffee...it's called sleeping.
}
else if (T_Coice_Num = 19)
{
    Gui 1:Show, w835 h517,Doctors found traces of blood in my coffee stream.
}
else if (T_Coice_Num = 20)
{
    Gui 1:Show, w835 h517,I don't have a problem with caffeine. I have a problem without it.
}
UpdateTrayicon()
;____________________________________________________________
;//////////////[Check for updates]///////////////
IfExist, %AppSettingsIni%
{
    ;Is check for updates enabled
    IniRead, Temp_CheckUpdatesOnStartup, %AppSettingsIni%, Updates, CheckOnStartup
    GuiControl,1:,CheckUpdatesOnStartup,%Temp_CheckUpdatesOnStartup%
    if(Temp_CheckUpdatesOnStartup == 1)
    {
        if(IsThisExperimental)
        {
            MsgBox,,Experimental,This is experimental branch!`nOnly for testing new versions.
            GuiControl,1:show,DownloadExperimentalBranchButton
            GuiControl,1:,DownloadExperimentalBranchButton, Download Stable version
            ;check if there is new stable
            goto CheckForStableVersion
        }
        else
        {
            ;Check for experimental branch
            whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            whr.Open("GET", "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/version.txt", False)
            whr.Send()
            whr.WaitForResponse()
            ExperimentalVersion := whr.ResponseText
            if(ExperimentalVersion != "" and ExperimentalVersion != "404: Not Found")
            {
                ;Found experimental version
                GuiControl,1:show,DownloadExperimentalBranchButton
            }
            goto checkForupdates
        }
    }
    else
    {
        ;if this is experimental but check updates on start is disabled
        if(IsThisExperimental)
        {
            MsgBox,,Experimental,This is experimental branch!`nOnly for testing new versions.
            GuiControl,1:show,DownloadExperimentalBranchButton
            GuiControl,1:,DownloadExperimentalBranchButton, Download Stable version
        }
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
            Gui, 1:Submit, Nohide
            FileCreateDir, %AppFolder%
            FileCreateDir, %AppSettingsFolder%
            IniWrite, 1, %AppSettingsIni%, Updates, CheckOnStartup
            GuiControl,1:,CheckUpdatesOnStartup,1
            IniWrite, 1, %AppSettingsIni%, Intro, SkipIntro
        }
        else
        {
            IniWrite, 1, %AppSettingsIni%, Intro, SkipIntro
        }
    }
}
Return
;____________________________________________________________
;____________________________________________________________
;//////////////[GUI/Tray Actions]///////////////
GuiEscape:
    ExitApp
GuiClose:
if(CloseToTray)
{
    Gui, 1:Hide
}
else
{
    ExitApp
}
Return

EXIT:
	ExitApp
Return
P_OpenGui:
    Gui, 1:Show
return
P_ToggleNumpadMacroDeck:
if(!ToggleNumpadMacroDeck)
{
    NumpadMacroDeckSetHotkeys(true)
    ;Disable buttons (Cant edit macros while active)
    GuiControl,1:Disable,NumpadMacroDeckTextRadio
    GuiControl,1:Disable,NumpadMacroDeckHotkeyRadio
    GuiControl,1:Disable,NumpadMacroDeckTextEdit
    GuiControl,1:Disable,NumpadMacroDeckHotkeyBox
    GuiControl,1:Disable,NumpadMacroDeckSaveSettingsButton
    GuiControl,1:Disable,NumpadMacroDeckDeleteSettingsButton

    hotkey,NumLock,NumpadMacroDeckNumLockAction
    hotkey,NumLock,ON
    GuiControl,1:,NumpadMacroDeckEnableHotkeysCheckbox,1
    UpdateTrayNumpadMacroState(true)
    ToggleNumpadMacroDeck := true
}
else
{
    NumpadMacroDeckSetHotkeys(false)
    GuiControl,1:Enable,NumpadMacroDeckTextRadio
    GuiControl,1:Enable,NumpadMacroDeckHotkeyRadio
    GuiControl,1:Enable,NumpadMacroDeckTextEdit
    GuiControl,1:Enable,NumpadMacroDeckHotkeyBox
    GuiControl,1:Enable,NumpadMacroDeckSaveSettingsButton
    GuiControl,1:Enable,NumpadMacroDeckDeleteSettingsButton
    hotkey,NumLock,OFF
    GuiControl,1:,NumpadMacroDeckEnableHotkeysCheckbox,0
    UpdateTrayNumpadMacroState(false)
    ToggleNumpadMacroDeck := false
}
return
OnExitCloseToTray:
Gui, 1:Submit, Nohide
if(OnExitCloseToTrayCheckbox)
{
    CloseToTray := true
    IniWrite, true,%AppSettingsIni%,Settings,CloseToTray
}
else
{
    CloseToTray := false
    IniWrite, false,%AppSettingsIni%,Settings,CloseToTray
}
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Actions]///////////////
GuiSubmit:
    Gui, 1:Submit, Nohide
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
    GuiControl,1:,CheckUpdatesOnStartup,0
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
    GuiControl,1:,CheckUpdatesOnStartup,0
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
Gui, 1:Submit, Nohide
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
Gui, 1:Submit, Nohide
if (RebindWindowsCheckbox) ;Check if rebind is enabled. Cant rebind and disable same key
{
    MsgBox, 1, Rebind is enabled, Rebind windows button is enabled `nDo you want to Disable it insted.
    IfMsgBox, Cancel
    {
        GuiControl,1:,DisableWindowsCheckbox,0
        return
    }
    else
    {
        GuiControl,1:,RebindWindowsCheckbox,0
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
Gui, 1:Submit, Nohide
if (RebindCapsLockCheckbox) ;Check if rebind is enabled. Cant rebind and disable same key
{
    MsgBox, 1, Rebind is enabled, Rebind CapsLock button is enabled `nDo you want to Disable it insted.
    IfMsgBox, Cancel
    {
        GuiControl,1:,DisableCapsLockCheckbox,0
        return
    }
    else
    {
        GuiControl,1:,RebindCapsLockCheckbox,0
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
Gui, 1:Submit, Nohide
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
Gui, 1:Submit, Nohide
if (DisableWindowsCheckbox) ;Check if disable is also enabled. cant rebind and disable same key
{
    MsgBox, 1, Disable is enabled, Disable windows button is enabled `nDo you want to Rebind it insted.
    IfMsgBox, Cancel
    {
        GuiControl,1:,RebindWindowsCheckbox,0
        return
    }
    else
    {
        GuiControl,1:,DisableWindowsCheckbox,0
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
Gui, 1:Submit, Nohide
send %RebindWindowsButton%
return
EnableCapsLockRebind:
Gui, 1:Submit, Nohide
if (DisableCapsLockCheckbox) ;Check if disable is also enabled. cant rebind and disable same key
{
    MsgBox, 1, Disable is enabled, Disable CapsLock button is enabled `nDo you want to Rebind it insted.
    IfMsgBox, Cancel
    {
        GuiControl,1:,RebindCapsLockCheckbox,0
        return
    }
    else
    {
        GuiControl,1:,DisableCapsLockCheckbox,0
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
Gui, 1:Submit, Nohide
send %RebindCapsLockButton%
return
SaveRebindHotkeys:
Gui, 1:Submit, Nohide
SaveHotkey(RebindWindowsButton,"RebindWindowsButton")
SaveHotkey(RebindCapsLockButton, "RebindCapsLockButton")
return
;____________________________________________________________
;//////////////[Settings]///////////////
ClearGameModeHotkeys:
Gui, 1:Submit, Nohide
;always on top
GuiControl,1:, AlwaysOnTopHotkey, ""
;AutoRun
GuiControl,1:,ToggleRunHotkey, ""
;Mouse Hold
GuiControl,1:,MouseHoldHotkey,""
;Mouse Clicker
GuiControl,1:,MouseClickerHotkey,""
GuiControl,1:,MouseClickerDelay,150
;Rebind buttons
GuiControl,1:,RebindWindowsButton,""
GuiControl,1:,RebindCapsLockButton,""
return
DeleteGameModeSettings:
MsgBox, 1,Are you sure?,All Game Mode Settings will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    Gui, 1:Submit, Nohide
    ;always on top
    GuiControl,1:, AlwaysOnTopHotkey, ""
    SaveHotkey("", "AlwaysOnTopHotkey")
    ;AutoRun
    GuiControl,1:,ToggleRunHotkey, ""
    SaveHotkey("", "AutoRun")
    ;Mouse Hold
    GuiControl,1:,MouseHoldHotkey,""
    SaveHotkey("", "MouseHoldHotkey")
    ;Mouse Clicker
    GuiControl,1:,MouseClickerHotkey,""
    GuiControl,1:,MouseClickerDelay,150
    SaveHotkey("", "MouseClickerHotkey")
    SaveHotkey(150, "MouseClickerDelay")
    ;Rebind buttons
    GuiControl,1:,RebindWindowsButton,""
    GuiControl,1:,RebindCapsLockButton,""
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
    GuiControl,1:, NumpadMacroDeckTextEdit,
    GuiControl,1:, NumpadMacroDeckHotkeyBox,
    GuiControl,1:,NumpadMacroDeckTextRadio,1
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
    GuiControl,1:,DeckDivisionControl,%GuiPictureFolder%\Division.png
    GuiControl,1:,DeckMultiplicationControl,%GuiPictureFolder%\Multiplication.png
    GuiControl,1:,DeckSubtractionControl,%GuiPictureFolder%\Subtraction.png
    GuiControl,1:,Deck0Control,%GuiPictureFolder%\0.png
    GuiControl,1:,Deck1Control,%GuiPictureFolder%\1.png
    GuiControl,1:,Deck2Control,%GuiPictureFolder%\2.png
    GuiControl,1:,Deck3Control,%GuiPictureFolder%\3.png
    GuiControl,1:,Deck4Control,%GuiPictureFolder%\4.png
    GuiControl,1:,Deck5Control,%GuiPictureFolder%\5.png
    GuiControl,1:,Deck6Control,%GuiPictureFolder%\6.png
    GuiControl,1:,Deck7Control,%GuiPictureFolder%\7.png
    GuiControl,1:,Deck8Control,%GuiPictureFolder%\8.png
    GuiControl,1:,Deck9Control,%GuiPictureFolder%\9.png
    GuiControl,1:,DeckAdditionControl,%GuiPictureFolder%\Addition.png
    GuiControl,1:,DeckEnterControl,%GuiPictureFolder%\Enter.png
    GuiControl,1:,DeckDotControl,%GuiPictureFolder%\Dot.png
    GuiControl,1:,DeckCurrentlyActive,
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
    GuiControl,1:,DownloadEXERunnerButton,Download EXE Runner
    IsEXERunnerEnabled := false
}
else
{ 
    ;Download exe runner
    T_FileBeforeMoveLocation = %A_ScriptDir%
    IniWrite,true,%AppSettingsIni%, ExeRunner, UsingExeRunner
    IniWrite,%A_ScriptDir%,%AppSettingsIni%, ExeRunner, OldAhkFileLocation
    FileMove, %A_ScriptFullPath%,%AppFolder%\%ScriptName%.ahk ,1
    GuiControl,1:,DownloadEXERunnerButton,Delete EXE Runner
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/exe/GameScripts.exe , %T_FileBeforeMoveLocation%\GameScripts.exe
    IsEXERunnerEnabled := true
}
return
RunAsThisAdmin:
Run *RunAs %A_ScriptFullPath%
ExitApp
RunAsThisAdminCheckboxButton:
Gui, 1:Submit, Nohide
IniWrite, %RunAsThisAdminCheckbox%,%AppSettingsIni%,Settings,RunAsAdminOnStart
return
KeepThisAlwaysOnTop:
WinSet, AlwaysOnTop,, A
return
;____________________________________________________________
;//////////////[Gui 1:update stuff]///////////////
UpdateGUIWhenSwitchingTabs:
Gui, 1:Submit, Nohide
UpdateTrayicon()
if(UpdateGUIWhenSwitchingTabsTab3 == "Windows")
{
    UpdateSettingsFromRegistery()
}
return
BackupClose:
Gui, 1:Submit, Nohide
if(BackupCloseCheckbox)
{
    SetTimer,DetectGames,4000
    IniWrite,true,%AppSettingsIni%,Settings,BackupClose
}
else
{
    SetTimer,DetectGames,Off
    IniWrite,false,%AppSettingsIni%,Settings,BackupClose
}
return
DetectGames:
IfWinExist, ahk_exe EscapeFromTarkov.exe
    ExitApp
IfWinExist, ahk_exe ModernWarfare.exe
    ExitApp
IfWinExist,​ ahk_exe BlackOpsColdWar.exe
    ExitApp
IfWinExist, ahk_exe VALORANT.exe
    ExitApp
IfWinExist, ahk_exe hunt.exe
    ExitApp
IfWinExist, ahk_exe RainbowSix.exe
    ExitApp
IfWinExist, ahk_exe RainbowSix_Vulkan.exe
    ExitApp
return
;____________________________________________________________
;//////////////[Auto Run/Walk]///////////////
SaveToggleRun:
SaveHotkey(ToggleRunHotkey, "AutoRun")
goto EnableAutoRun
return
EnableAutoRun:
Gui, 1:Submit, Nohide
if (ToggleRunHotkey == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    GuiControl,1:,AutoRunCheckbox,0
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
Gui, 1:Submit, Nohide
if (MouseHoldHotkey == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    GuiControl,1:,MouseHoldCheckbox,0
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
Gui, 1:Submit, Nohide
if (MouseClickerHotkey == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    GuiControl,1:,MouseClickerCheckbox,0
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
    GuiControl,1:, DowloadGHUBToolButton, Run
    GuiControl,1:Enable,UninstallGHUBToolScritpButton
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
;ngrok
OpenNgrokInGithub:
    run, https://github.com/veskeli/NgrokAhk
return
DownloadNgrokTool:
if(!NgrokTool)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppOtherScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/NgrokAhk/master/Ngrok.ahk, %AppOtherScriptsFolder%\Ngrok.ahk
    ;write save/Update Gui
    GuiControl,1:, DownloadNgrokToolButton, Run
    GuiControl,1:Enable,UninstallNgrokToolButton
    NgrokToolLocation = %AppOtherScriptsFolder%\Ngrok.ahk
    NgrokTool := True
}
else
{
    run, %NgrokToolLocation%
}
return
UninstallNgrokTool:
UninstallScript("NgrokTool")
return
;Factorio
UninstallFactorioTool:
UninstallScript("FactorioTool")
return
DownloadFactorioTool:
if(!FactorioTool)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppGamingScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/GamingScripts/FactorioTool.ahk, %FactorioToolLocation%
    ;write save/Update Gui
    GuiControl,1:, DownloadFactorioToolButton, Run
    GuiControl,1:Enable,UninstallFactorioToolButton
    FactorioTool := True
}
else
{
    run, %FactorioToolLocation%
}
return
DownloadBetterDiscordTroubleshooter:
if(!BetterDiscordTroubleshooter)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppGamingScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/BetterDiscordTroubleshooter/main/BetterDiscordTroubleshooter.ahk, %BetterDiscordTroubleshooterLocation%
    ;write save/Update Gui
    GuiControl,1:, DownloadBetterDiscordTroubleshooterButton, Run
    GuiControl,1:Enable,UninstallBetterDiscordTroubleshooter
    BetterDiscordTroubleshooter := True
}
else
{
    run, %BetterDiscordTroubleshooterLocation%
}
return
OpenBetterDiscordTroubleshooterGithub:
    run, https://github.com/veskeli/BetterDiscordTroubleshooter
return
UninstallBetterDiscordTroubleshooter:
UninstallScript("BetterDiscordTroubleshooter")
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Numpad Macro Deck]///////////////
DeckNumlock:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,NumLock
NumpadDeckSelected := "NumLock"
SwitchButtonColor("Numlock","NumLockSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckDivision:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,Division
NumpadDeckSelected := "Division"
SwitchButtonColor("Division","DivisionSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckMultiplication:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,Multiplication
NumpadDeckSelected := "Multiplication"
SwitchButtonColor("Multiplication","MultiplicationSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckSubtraction:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,Subtraction
NumpadDeckSelected := "Subtraction"
SwitchButtonColor("subtraction","subtractionSelected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck0:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,0
NumpadDeckSelected := "0"
SwitchButtonColor("0","0Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck1:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,1
NumpadDeckSelected := "1"
SwitchButtonColor("1","1Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck2:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,2
NumpadDeckSelected := "2"
SwitchButtonColor("2","2Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck3:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,3
NumpadDeckSelected := "3"
SwitchButtonColor("3","3Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck4:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,4
NumpadDeckSelected := "4"
SwitchButtonColor("4","4Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck5:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,5
NumpadDeckSelected := "5"
SwitchButtonColor("5","5Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck6:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,6
NumpadDeckSelected := "6"
SwitchButtonColor("6","6Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck7:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,7
NumpadDeckSelected := "7"
SwitchButtonColor("7","7Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck8:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,8
NumpadDeckSelected := "8"
SwitchButtonColor("8","8Selected")
UpdateNumlockMacroDeckActionBoxes()
return
Deck9:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,9
NumpadDeckSelected := "9"
SwitchButtonColor("9","9Selected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckAddition:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,Addition
NumpadDeckSelected := "Addition"
SwitchButtonColor("Addition","AdditionSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckEnter:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,Enter
NumpadDeckSelected := "Enter"
SwitchButtonColor("Enter","EnterSelected")
UpdateNumlockMacroDeckActionBoxes()
return
DeckDot:
ResetNumpadButtons()
GuiControl,1:,DeckCurrentlyActive,Dot
NumpadDeckSelected := "Dot"
SwitchButtonColor("Dot","DotSelected")
UpdateNumlockMacroDeckActionBoxes()
return
;//////////////[NumpadMacroDeckEnableHotkeys]///////////////
NumpadMacroDeckEnableHotkeys:
Gui, 1:Submit, Nohide
if(NumpadMacroDeckEnableHotkeysCheckbox)
{
    NumpadMacroDeckSetHotkeys(true)
    ;Disable buttons (Cant edit macros while active)
    GuiControl,1:Disable,NumpadMacroDeckTextRadio
    GuiControl,1:Disable,NumpadMacroDeckHotkeyRadio
    GuiControl,1:Disable,NumpadMacroDeckTextEdit
    GuiControl,1:Disable,NumpadMacroDeckHotkeyBox
    GuiControl,1:Disable,NumpadMacroDeckSaveSettingsButton
    GuiControl,1:Disable,NumpadMacroDeckDeleteSettingsButton

    hotkey,NumLock,NumpadMacroDeckNumLockAction
    hotkey,NumLock,ON
    UpdateTrayNumpadMacroState(true)
    ToggleNumpadMacroDeck := true
}
else
{
    NumpadMacroDeckSetHotkeys(false)
    GuiControl,1:Enable,NumpadMacroDeckTextRadio
    GuiControl,1:Enable,NumpadMacroDeckHotkeyRadio
    GuiControl,1:Enable,NumpadMacroDeckTextEdit
    GuiControl,1:Enable,NumpadMacroDeckHotkeyBox
    GuiControl,1:Enable,NumpadMacroDeckSaveSettingsButton
    GuiControl,1:Enable,NumpadMacroDeckDeleteSettingsButton
    hotkey,NumLock,OFF
    UpdateTrayNumpadMacroState(false)
    ToggleNumpadMacroDeck := false
}
return
;//////////////[NumpadMacroDeckSaveSettings]///////////////
NumpadMacroDeckSaveSettings:
Gui,Submit,Nohide
if(%NumpadDeckSelected% == "")
{
    return
}
if (NumpadMacroDeckTextRadio) ;Text
{
    IniWrite, %NumpadMacroDeckTextEdit%, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected% ;Save action
    IniWrite, true, %NumpadMacroDeckSettingsIni%, Enabled, %NumpadDeckSelected% ;Save enabled state
    IniWrite, 1, %NumpadMacroDeckSettingsIni%, RadioButtonStates, %NumpadDeckSelected% ;Save Radio button state
}
else if(NumpadMacroDeckHotkeyRadio) ;Hotkey
{
    IniWrite, %NumpadMacroDeckHotkeyBox%, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected% ;Save action
    IniWrite, true, %NumpadMacroDeckSettingsIni%, Enabled, %NumpadDeckSelected% ;Save enabled state
    IniWrite, 2, %NumpadMacroDeckSettingsIni%, RadioButtonStates, %NumpadDeckSelected% ;Save Radio button state
}
else if(NumpadCustomMacroRadio) ;Macro
{
    IniWrite, %CustomMacroDropDownList%, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected% ;Save action
    IniWrite, true, %NumpadMacroDeckSettingsIni%, Enabled, %NumpadDeckSelected% ;Save enabled state
    IniWrite, 3, %NumpadMacroDeckSettingsIni%, RadioButtonStates, %NumpadDeckSelected% ;Save Radio button state
}
SetNumpadButtonState(NumpadDeckSelected, true) ;Set button color to green
return
CreateMacro:
MacroMakerGui(true)
return
EditMacro:
Gui,1:Submit,Nohide
MacroMakerGui(true)
if(CustomMacroDropDownList != "")
{
    CurrentCustomMacro = %CustomMacroDropDownList%
    LoadMacroMakerMacro(CurrentCustomMacro)
}
return
UpdateCustomMacroDropDownList:

return
;//////////////[NumpadMacroDeckDeleteSettings]///////////////
NumpadMacroDeckDeleteSettings:
if(%NumpadDeckSelected% == "")
{
    return
}
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
;//////////////[Windows]///////////////
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
OpenDesktop:
run, %A_Desktop%
return
OpenStartMenu:
run, %A_StartMenu%
return
ToggleXboxOverlay:
Gui, 1:Submit, Nohide
if(XboxOverlayCheckbox)
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR,AppCaptureEnabled,1
}
else
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR,AppCaptureEnabled,0
}
return
ToggleGameMode:
Gui, 1:Submit, Nohide
if(ToggleGameModeCheckbox)
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AllowAutoGameMode,1
    regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AutoGameModeEnabled,1
}
else
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AllowAutoGameMode,0
    regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AutoGameModeEnabled,0
}
return
ToggleGameDVR:
Gui, 1:Submit, Nohide
if(ToggleGameDVRCheckbox)
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled,1
}
else
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled,0
}
return
ClearWindowsTempFolder:
Progress, b w300, Wait while script is deleting temp files, Deleting Temp Files..., Deleting Temp Files...
dir= %A_Temp%
FileDelete, %dir%\*.*
Loop, %dir%\*.*, 2
{
    Progress, %A_Index%
    FileRemoveDir, %A_LoopFileLongPath%,1
}
Progress, Off
IfExist, %dir%\*.*
{
    MsgBox,,Finished,Some files are being used by other apps.`nBut others were deleted
}
return
ToggleClipboardHistory:
Gui, 1:Submit, Nohide
if(ToggleClipboardHistoryCheckbox)
{
    if(!A_IsAdmin)
        NotAdminError()
    regWrite,REG_DWORD,HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System,AllowClipboardHistory,1
}
else
{
    if(!A_IsAdmin)
        NotAdminError()
    regDelete,HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System,AllowClipboardHistory
}
return
AutomaticallyBackupRegistery:
Gui, 1:Submit, Nohide
if(AutomaticallyBackupRegisteryCheckbox)
{
    if(!A_IsAdmin)
        NotAdminError()
    regWrite,REG_DWORD,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager,EnablePeriodicBackup,1
}
else
{
    if(!A_IsAdmin)
        NotAdminError()
    regDelete,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager,EnablePeriodicBackup
}
return
ClearVirtualMemoryPageFileAtShutdown:
Gui, 1:Submit, Nohide
if(ClearVirtualMemoryPageFileAtShutdownCheckbox)
{
    if(!A_IsAdmin)
        NotAdminError()
    regWrite,REG_DWORD,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management,ClearPageFileAtShutdown,1
}
else
{
    if(!A_IsAdmin)
        NotAdminError()
    regWrite,REG_DWORD,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management,ClearPageFileAtShutdown,0
}
return
OpenCmd:
run, %ComSpec%
return
RunIpConfig:
runwait %ComSpec% /k ipconfig
return
ClearAllRecentDocumentsInWordpad:
regDelete,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List
return
DisableMostOfAds:
regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SilentInstalledAppsEnabled,0
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SystemPaneSuggestionsEnabled,0
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced,ShowSyncProviderNotifications,0
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SoftLandingEnabled,0
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,RotatingLockScreenEnabled,0
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,RotatingLockScreenOverlayEnabled,0
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SubscribedContent-310093Enabled,0
UpdateSettingsFromRegistery()
return
RestoreMostOfAds:
regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SilentInstalledAppsEnabled,1
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SystemPaneSuggestionsEnabled,1
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced,ShowSyncProviderNotifications,1
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SoftLandingEnabled,1
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,RotatingLockScreenEnabled,1
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,RotatingLockScreenOverlayEnabled,1
regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SubscribedContent-310093Enabled,1
UpdateSettingsFromRegistery()
Return
ToggleAdvertisingIDForRelevantAds:
Gui, 1:Submit, Nohide
if(ToggleAdvertisingIDForRelevantAdsCheckbox)
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo,Enabled,1
}
else
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo,Enabled,0
}
return
ToggleFeaturedAutoInstall:
Gui, 1:Submit, Nohide
if(ToggleFeaturedAutoInstallCheckbox)
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SilentInstalledAppsEnabled,1
}
else
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SilentInstalledAppsEnabled,0
}
UpdateSettingsFromRegistery()
return
OpenSounds:
Run, mmsys.cpl
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
            SplashTextOn, 250,50,Downloading...,Downloading new version.`nVersion: %newversion%
            FileCreateDir, %AppFolder%
            FileCreateDir, %AppFolder%\temp
            FileMove, %A_ScriptFullPath%, %AppUpdateFile%, 1
            FileRemoveDir, %GuiPictureFolder%, 1 ;Delete Gui 1:pictures
            sleep 1000
            UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/GameScripts.ahk, %A_ScriptFullPath%
            Sleep 1000
            SplashTextOff
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
Gui, 1:Submit, Nohide
FileCreateDir, %AppFolder%
FileCreateDir, %AppSettingsFolder%
IniWrite, %CheckUpdatesOnStartup%, %AppSettingsIni%, Updates, CheckOnStartup
return
;//////////////[Experimental Download]///////////////
CheckForStableVersion:
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/version.txt", False)
whr.Send()
whr.WaitForResponse()
newversion := whr.ResponseText
if(newversion != "")
{
    if(newversion >= version)
    {
        MsgBox, 1,Update,New Stable version is live`nExperimental version: %version%`nStable versio: %newversion%`nUpdate to stable?
        IfMsgBox, Cancel
        {
            ;temp stuff
        }
        else
        {
            SplashTextOn, 300,50,Downloading...,Downloading new Stable version.`nVersion: %newversion%
            ;Download update
            FileCreateDir, %AppFolder%
            FileCreateDir, %AppFolder%\temp
            FileMove, %A_ScriptFullPath%, %AppUpdateFile%, 1
            FileRemoveDir, %GuiPictureFolder%, 1 ;Delete Gui 1:pictures
            sleep 1000
            UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/GameScripts.ahk, %A_ScriptFullPath%
            Sleep 1000
            SplashTextOff
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
;check if there is new experimental version
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/version.txt", False)
whr.Send()
whr.WaitForResponse()
ExperimentalVersion := whr.ResponseText
if(ExperimentalVersion != "" and ExperimentalVersion != "404: Not Found")
{
    if(ExperimentalVersion > version)
    {
        MsgBox, 1,Update,New Experimental version`nCurrent: %version%`nNew:%ExperimentalVersion%`nUpdate now?
        IfMsgBox, Cancel
        {
            ;temp stuff
        }
        else
        {
            ;Download update
            SplashTextOn, 300,50,Downloading...,Downloading new Experimental version.`nVersion: %ExperimentalVersion%
            FileCreateDir, %AppFolder%
            FileCreateDir, %AppFolder%\temp
            FileMove, %A_ScriptFullPath%, %AppUpdateFile%, 1
            FileRemoveDir, %GuiPictureFolder%, 1 ;Delete Gui 1:pictures
            sleep 1000
            UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/GameScripts.ahk, %A_ScriptFullPath%
            Sleep 1000
            SplashTextOff
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
DownloadExperimentalBranch:
if(IsThisExperimental)
{
    ;Download stable
    SplashTextOn, 240,30,Downloading...,Downloading Stable version.
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppFolder%\temp
    FileMove, %A_ScriptFullPath%, %AppUpdateFile%, 1
    FileRemoveDir, %GuiPictureFolder%, 1 ;Delete Gui 1:pictures
    sleep 1000
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/GameScripts.ahk, %A_ScriptFullPath%
    Sleep 1000
    SplashTextOff
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
else
{
    ;Download Experimental
    SplashTextOn, 240,30,Downloading...,Downloading Experimental version.
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppFolder%\temp
    FileMove, %A_ScriptFullPath%, %AppUpdateFile%, 1
    FileRemoveDir, %GuiPictureFolder%, 1 ;Delete Gui 1:pictures
    sleep 1000
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/GameScripts.ahk, %A_ScriptFullPath%
    Sleep 1000
    SplashTextOff
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
    Progress, b w300, Script will run after all Gui 1:pictures has been downloaded, Downloading Gui 1:Pictures..., Downloading Gui 1:Pictures...
    T_GUIPicProgress = 0
    T_GuiPicAddAmount = 2
    
    ;SplashTextOn, 300,60,Downloading Gui 1:Pictures, Script will run after all Gui 1:pictures has been downloaded
    FileCreateDir,%GuiPictureFolder%
    sleep 100
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/GameScripts.ico , %GuiPictureFolder%/GameScripts.ico ;icon
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/NumLockBlue.png , %GuiPictureFolder%/NumLockBlue.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%

    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Division.png , %GuiPictureFolder%/Division.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/DivisionEnabled.png , %GuiPictureFolder%/DivisionEnabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/DivisionSelected.png , %GuiPictureFolder%/DivisionSelected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Multiplication.png , %GuiPictureFolder%/Multiplication.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/MultiplicationEnabled.png , %GuiPictureFolder%/MultiplicationEnabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/MultiplicationSelected.png , %GuiPictureFolder%/MultiplicationSelected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Subtraction.png , %GuiPictureFolder%/Subtraction.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/SubtractionEnabled.png , %GuiPictureFolder%/SubtractionEnabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/SubtractionSelected.png , %GuiPictureFolder%/SubtractionSelected.png
    ;nums
    
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/0.png , %GuiPictureFolder%/0.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/0Enabled.png , %GuiPictureFolder%/0Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/0Selected.png , %GuiPictureFolder%/0Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/1.png , %GuiPictureFolder%/1.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/1Enabled.png , %GuiPictureFolder%/1Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/1Selected.png , %GuiPictureFolder%/1Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/2.png , %GuiPictureFolder%/2.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/2Enabled.png , %GuiPictureFolder%/2Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/2Selected.png , %GuiPictureFolder%/2Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/3.png , %GuiPictureFolder%/3.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/3Enabled.png , %GuiPictureFolder%/3Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/3Selected.png , %GuiPictureFolder%/3Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/4.png , %GuiPictureFolder%/4.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/4Enabled.png , %GuiPictureFolder%/4Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/4Selected.png , %GuiPictureFolder%/4Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/5.png , %GuiPictureFolder%/5.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/5Enabled.png , %GuiPictureFolder%/5Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/5Selected.png , %GuiPictureFolder%/5Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/6.png , %GuiPictureFolder%/6.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/6Enabled.png , %GuiPictureFolder%/6Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/6Selected.png , %GuiPictureFolder%/6Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/7.png , %GuiPictureFolder%/7.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/7Enabled.png , %GuiPictureFolder%/7Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/7Selected.png , %GuiPictureFolder%/7Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/8.png , %GuiPictureFolder%/8.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/8Enabled.png , %GuiPictureFolder%/8Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/8Selected.png , %GuiPictureFolder%/8Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/9.png , %GuiPictureFolder%/9.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/9Enabled.png , %GuiPictureFolder%/9Enabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/9Selected.png , %GuiPictureFolder%/9Selected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    ;nums end
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Addition.png , %GuiPictureFolder%/Addition.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/AdditionEnabled.png , %GuiPictureFolder%/AdditionEnabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/AdditionSelected.png , %GuiPictureFolder%/AdditionSelected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Enter.png , %GuiPictureFolder%/Enter.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/EnterEnabled.png , %GuiPictureFolder%/EnterEnabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/EnterSelected.png , %GuiPictureFolder%/EnterSelected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/Dot.png , %GuiPictureFolder%/Dot.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/DotEnabled.png , %GuiPictureFolder%/DotEnabled.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/DotSelected.png , %GuiPictureFolder%/DotSelected.png
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    Progress, Off
    ;SplashTextOff
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
    Gui, 1:Submit, Nohide
    IniWrite, %tHotkey%, %AppHotkeysIni%, GameMode, %tKey%
}
UninstallScript(tName)
{
    if (tName == "GHUBTool")
    {
        FileDelete, %GHUBToolLocation%
        if ErrorLevel
        {
            MsgBox,, Error, Error while deleting`nSometimes script cannot delete files`nYou can manually delete if necessary
            return
        }
        GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
        GHUBTool := False
        GuiControl,1:, DowloadGHUBToolButton, Download
        GuiControl,1:Disable ,UninstallGHUBToolScritpButton
    }
    if(tName == "NgrokTool")
    {
        FileDelete, %NgrokToolLocation%
        if ErrorLevel
        {
            MsgBox,, Error, Error while deleting`nSometimes script cannot delete files`nYou can manually delete if necessary
            return
        }
        NgrokToolLocation = %AppOtherScriptsFolder%\Ngrok.ahk
        NgrokTool := False
        GuiControl,1:, DownloadNgrokToolButton, Download
        GuiControl,1:Disable ,UninstallNgrokToolButton
    } 
    if(tName == "FactorioTool")
    {
        FileDelete, %FactorioToolLocation%
        if ErrorLevel
        {
            MsgBox,, Error, Error while deleting`nSometimes script cannot delete files`nYou can manually delete if necessary
            return
        }
        FactorioTool := False
        GuiControl,1:, DownloadFactorioToolButton, Download
        GuiControl,1:Disable ,UninstallFactorioToolButton
    }
    if(tName == "BetterDiscordTroubleshooter")
    {
        FileDelete, %BetterDiscordTroubleshooterLocation%
        if ErrorLevel
        {
            MsgBox,, Error, Error while deleting`nSometimes script cannot delete files`nYou can manually delete if necessary
            return
        }
        BetterDiscordTroubleshooter := False
        GuiControl,1:, DownloadBetterDiscordTroubleshooterButton, Download
        GuiControl,1:Disable ,UninstallBetterDiscordTroubleshooter
    }
}
;/////////////////////////////////////////////////////Numpad macro deck
SwitchButtonColor(T_Button,T_PictureName)
{
    GuiControl,1:,Deck%T_Button%Control,%GuiPictureFolder%\%T_PictureName%.png
}
ResetNumpadButtons()
{
    if(NumpadDeckSelected == "NumLock")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,DeckNumLockControl,%GuiPictureFolder%\NumLock.png
        return
    }
    if(NumpadDeckSelected == "Division")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,DeckDivisionControl,%GuiPictureFolder%\Division.png
        return
    }
    if(NumpadDeckSelected == "Multiplication")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,DeckMultiplicationControl,%GuiPictureFolder%\Multiplication.png
        return
    }
    if(NumpadDeckSelected == "Subtraction")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,DeckSubtractionControl,%GuiPictureFolder%\Subtraction.png
        return
    }
    if(NumpadDeckSelected == "0")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck0Control,%GuiPictureFolder%\0.png
        return
    } 
    if(NumpadDeckSelected == "1")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck1Control,%GuiPictureFolder%\1.png
        return
    } 
    if(NumpadDeckSelected == "2")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck2Control,%GuiPictureFolder%\2.png
        return
    } 
    if(NumpadDeckSelected == "3")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck3Control,%GuiPictureFolder%\3.png
        return
    } 
    if(NumpadDeckSelected == "4")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck4Control,%GuiPictureFolder%\4.png
        return
    } 
    if(NumpadDeckSelected == "5")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck5Control,%GuiPictureFolder%\5.png
        return
    } 
    if(NumpadDeckSelected == "6")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck6Control,%GuiPictureFolder%\6.png
        return
    } 
    if(NumpadDeckSelected == "7")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck7Control,%GuiPictureFolder%\7.png
        return
    } 
    if(NumpadDeckSelected == "8")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck8Control,%GuiPictureFolder%\8.png
        return
    } 
    if(NumpadDeckSelected == "9")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,Deck9Control,%GuiPictureFolder%\9.png
        return
    } 
    if(NumpadDeckSelected == "Addition")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,DeckAdditionControl,%GuiPictureFolder%\Addition.png
        return
    }
    if(NumpadDeckSelected == "Enter")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,DeckEnterControl,%GuiPictureFolder%\Enter.png
        return
    }
    if(NumpadDeckSelected == "Dot")
    {
        if(Deck%NumpadDeckSelected%Enabled == true)
        {
            GuiControl,1:,Deck%NumpadDeckSelected%Control,%GuiPictureFolder%\%NumpadDeckSelected%Enabled.png
            return
        }
        GuiControl,1:,DeckDotControl,%GuiPictureFolder%\Dot.png
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
        GuiControl,1:,DeckDivisionControl,%GuiPictureFolder%\DivisionEnabled.png
    }
    ;Multiplication
    IniRead, T_MultiplicationIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Multiplication
    if(%T_MultiplicationIsEnabled% == true)
    {
        SetNumpadButtonState("Multiplication", true)
        GuiControl,1:,DeckMultiplicationControl,%GuiPictureFolder%\MultiplicationEnabled.png
    }
    ;Subtraction
    IniRead, T_SubtractionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Subtraction
    if(%T_SubtractionIsEnabled% == true)
    {
        SetNumpadButtonState("Subtraction", true)
        GuiControl,1:,DeckSubtractionControl,%GuiPictureFolder%\SubtractionEnabled.png
    }

    ;0
    IniRead, T_0IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 0
    if(%T_0IsEnabled% == true)
    {
        SetNumpadButtonState("0", true)
        GuiControl,1:,Deck0Control,%GuiPictureFolder%\0Enabled.png
    }
    ;1
    IniRead, T_1IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 1
    if(%T_1IsEnabled% == true)
    {
        SetNumpadButtonState("1", true)
        GuiControl,1:,Deck1Control,%GuiPictureFolder%\1Enabled.png
    }
    ;2
    IniRead, T_2IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 2
    if(%T_2IsEnabled% == true)
    {
        SetNumpadButtonState("2", true)
        GuiControl,1:,Deck2Control,%GuiPictureFolder%\2Enabled.png
    }
    ;3
    IniRead, T_3IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 3
    if(%T_3IsEnabled% == true)
    {
        SetNumpadButtonState("3", true)
        GuiControl,1:,Deck3Control,%GuiPictureFolder%\3Enabled.png
    }
    ;4
    IniRead, T_4IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 4
    if(%T_4IsEnabled% == true)
    {
        SetNumpadButtonState("4", true)
        GuiControl,1:,Deck4Control,%GuiPictureFolder%\4Enabled.png
    }
    ;5
    IniRead, T_5IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 5
    if(%T_5IsEnabled% == true)
    {
        SetNumpadButtonState("5", true)
        GuiControl,1:,Deck5Control,%GuiPictureFolder%\5Enabled.png
    }
    ;6
    IniRead, T_6IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 6
    if(%T_6IsEnabled% == true)
    {
        SetNumpadButtonState("6", true)
        GuiControl,1:,Deck6Control,%GuiPictureFolder%\6Enabled.png
    }
    ;7
    IniRead, T_7IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 7
    if(%T_7IsEnabled% == true)
    {
        SetNumpadButtonState("7", true)
        GuiControl,1:,Deck7Control,%GuiPictureFolder%\7Enabled.png
    }
    ;8
    IniRead, T_8IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 8
    if(%T_8IsEnabled% == true)
    {
        SetNumpadButtonState("8", true)
        GuiControl,1:,Deck8Control,%GuiPictureFolder%\8Enabled.png
    }
    ;9
    IniRead, T_9IsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, 9
    if(%T_9IsEnabled% == true)
    {
        SetNumpadButtonState("9", true)
        GuiControl,1:,Deck9Control,%GuiPictureFolder%\9Enabled.png
    }

    ;Addition
    IniRead, T_AdditionIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Addition
    if(%T_AdditionIsEnabled% == true)
    {
        SetNumpadButtonState("Addition", true)
        GuiControl,1:,DeckAdditionControl,%GuiPictureFolder%\AdditionEnabled.png
    }
    ;Enter
    IniRead, T_EnterIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Enter
    if(%T_EnterIsEnabled% == true)
    {
        SetNumpadButtonState("Enter", true)
        GuiControl,1:,DeckEnterControl,%GuiPictureFolder%\EnterEnabled.png
    }
    ;Dot
    IniRead, T_DotIsEnabled,%NumpadMacroDeckSettingsIni%, Enabled, Dot
    if(%T_DotIsEnabled% == true)
    {
        SetNumpadButtonState("Dot", true)
        GuiControl,1:,DeckDotControl,%GuiPictureFolder%\DotEnabled.png
    }
}
UpdateNumlockMacroDeckActionBoxes()
{
    ;//////////////[Read radiobutton state and then change it]///////////////
    IniRead, T_RadioButtonState,%NumpadMacroDeckSettingsIni%,RadioButtonStates,%NumpadDeckSelected%
    if(T_RadioButtonState == 1)
    {
        GuiControl,1:,NumpadMacroDeckTextRadio,1
    }
    else if(T_RadioButtonState == 2)
    {
        GuiControl,1:,NumpadMacroDeckHotkeyRadio,1
    }
    else if(T_RadioButtonState == 3)
    {
        GuiControl,1:,NumpadCustomMacroRadio,1
    }
    else ;if using old version or just backup
    {
        GuiControl,1:,NumpadMacroDeckHotkeyRadio,1
        IniWrite, 2, %NumpadMacroDeckSettingsIni%, RadioButtonStates, %NumpadDeckSelected% ;Save Radio button state
    }
    ;//////////////[Read value]///////////////
    if(T_RadioButtonState)
    {
        IniRead, T_NumpadMacroDeckText, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
        if(T_NumpadMacroDeckText == "ERROR")
        {
            GuiControl,1:, NumpadMacroDeckTextEdit,
            GuiControl,1:, NumpadMacroDeckHotkeyBox,
        }
        else
        {
            GuiControl,1:, NumpadMacroDeckHotkeyBox,
            GuiControl,1:, NumpadMacroDeckTextEdit,%T_NumpadMacroDeckText%
        }
    }
    else
    {
        IniRead, T_NumpadMacroDeckHotkey, %NumpadMacroDeckSettingsIni%, Actions, %NumpadDeckSelected%
        if(T_NumpadMacroDeckText == "ERROR")
        {
            GuiControl,1:, NumpadMacroDeckTextEdit,
            GuiControl,1:, NumpadMacroDeckHotkeyBox,
        }
        else
        {
            GuiControl,1:, NumpadMacroDeckTextEdit,
            GuiControl,1:, NumpadMacroDeckHotkeyBox,%T_NumpadMacroDeckHotkey%
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
;____________________________________________________________
;//////////////[Custom macro]///////////////
MacroMakerGui(t_State)
{
    if(t_State)
    {
        if(!IsMacroGuiOpen)
        {
            global Custom_Macro_Location
            global CustomMacroText
            global Pick_location_button
            global TestCustomMacroButton
            global DeleteCurrentMacroButton
            Gui 2:Add, GroupBox, x0 y0 w706 h80, Settings
            Gui 2:Add, Radio, x8 y16 w120 h23 gChangeMacroStyle vUseCustomlocationMacroRadio, Use custom macro
            Gui 2:Add, Radio, x8 y48 w120 h23 gChangeMacroStyle +Checked vUseCustomMacroRadio, Macro:
            Gui 2:Add, Edit, x192 y16 w343 h21 vCustom_Macro_Location +Disabled
            Gui 2:Add, Text, x136 y16 w53 h24 +0x200, Location:
            Gui 2:Add, Button, x544 y16 w80 h23 gPick_location vPick_location_button +Disabled, Pick file
            Gui 2:Add, GroupBox, x135 y40 w572 h40
            Gui 2:Add, Text, x143 y52 w73 h23 +0x200, Macro Name:
            Gui 2:Add, Edit, x220 y53 w255 h21 vMacroFileName
            Gui 2:Add, Button, x482 y51 w87 h23 gTestCustomMacro vTestCustomMacroButton, Run scirpt/Test
            Gui 2:Font, s14
            Gui 2:Add, Button, x573 y50 w78 h25 gSave_Macro, Save 
            Gui 2:Font
            Gui 2:Add, Button, x652 y45 w53 h35 gDeleteCurrentMacro vDeleteCurrentMacroButton, Delete macro
            Gui 2:Add, Edit, x4 y88 w698 h464 Multi vCustomMacroText

            Gui 2:Show, w706 h555, Macro Maker
            IsMacroGuiOpen := true
        }
    }
    else
    {
        Gui 2:Destroy
        IsMacroGuiOpen := false
    }
}
LoadMacroMakerMacro(t_CurrentCustomMacro)
{
    ;Load Macro type
    IniRead, t_macrotype, %NumpadMacroDeckSettingsIni%, CustomMacroUseLocation, %t_CurrentCustomMacro%
    if(t_macrotype == 1)
    {
        MsgBox, Edit is not implemented yet
    }
}
TestCustomMacro:
Gui, 2:Submit,Nohide
FileCreateDir, %AppCustomMacrosFolder%
IfExist %AppCustomMacrosFolder%\TestMacro.ahk
    FileDelete,%AppCustomMacrosFolder%\TestMacro.ahk
FileAppend, %CustomMacroText%,%AppCustomMacrosFolder%\TestMacro.ahk
runwait,%AppCustomMacrosFolder%\TestMacro.ahk
FileDelete,%AppCustomMacrosFolder%\TestMacro.ahk
return
ChangeMacroStyle:
Gui, 2:Submit, Nohide
if(UseCustomMacroRadio)
{
    GuiControl,2:Disable,Custom_Macro_Location
    GuiControl,2:Disable,Pick_location_button

    GuiControl,2:Enable,CustomMacroText
    GuiControl,2:Enable,TestCustomMacroButton
    GuiControl,2:,DeleteCurrentMacroButton,Delete macro
}
else if(UseCustomlocationMacroRadio)
{
    GuiControl,2:Enable,Custom_Macro_Location
    GuiControl,2:Enable,Pick_location_button

    GuiControl,2:Disable,CustomMacroText
    GuiControl,2:Disable,TestCustomMacroButton
    GuiControl,2:,DeleteCurrentMacroButton,Unlink macro
}
else
{
    GuiControl,2:,UseCustomMacroRadio,1
    goto ChangeMacroStyle
}
return
Pick_location:
FileSelectFile, SelectedFile, , , Open a file, Ahk File (*.ahk)
if (SelectedFile = "")
    MsgBox,,No file Selected,The user didn't select anything., 20
else
{
    GuiControl,2:,Custom_Macro_Location,%SelectedFile%
}
return
Save_Macro:
Gui, 2:Submit, Nohide
if(MacroFileName == "")
{
    MsgBox, 4,Warning No Macro Name, No macro name`nNothing will be saved`nWould you like to continue?
    IfMsgBox No
    {
        return
    }
    else
    {
        MacroMakerGui(false)
        return
    }
}
else if(UseCustomlocationMacroRadio == true and Custom_Macro_Location == "")
{
    MsgBox, 4,Warning No Macro Location, No macro Location`nNothing will be saved`nWould you like to continue?
    IfMsgBox No
    {
        return
    }
    else
    {
        MacroMakerGui(false)
        return
    }
}
if(UseCustomlocationMacroRadio)
{
    t_UseLocation := true
    t_MacroText = %Custom_Macro_Location%
}
else
{
    t_UseLocation := false
    t_MacroText = %CustomMacroText%
}
;Save handle
FileCreateDir, %AppCustomMacrosFolder%  ;Crate Macro Folder
FileAppend, %t_MacroText%`n,%AppCustomMacrosFolder%\%MacroFileName%.txt     ;Save Macro To file
IniWrite, %t_UseLocation%, %NumpadMacroDeckSettingsIni%, CustomMacroUseLocation, %MacroFileName%    ;Save Macro Type
GuiControl,1:,CustomMacroDropDownList,%MacroFileName%
GuiControl,1:ChooseString,CustomMacroDropDownList,%MacroFileName%

MacroMakerGui(false)
return
DeleteCurrentMacro:
if(UseCustomlocationMacroRadio == true)
{
    MsgBox, 4,Warning, This will unlink current macro`nWould you like to continue?
    IfMsgBox No
    {
        return
    }
    else
    {
        DeleteMacro(%CurrentCustomMacro%,txt)
        return
    }
}
else
{
    MsgBox, 4,Warning, This Will Delete current macro`nWould you like to continue?
    IfMsgBox No
    {
        return
    }
    else
    {
        DeleteMacro(%CurrentCustomMacro%,txt)
        return
    }
}
return
DeleteMacro(t_Macro,t_FileType)
{
    FileDelete, %AppCustomMacrosFolder%\%t_Macro%.%t_FileType%
    IniDelete, %NumpadMacroDeckSettingsIni%, CustomMacroUseLocation, %t_Macro%
}
UpdateCustomMacrosList()
{
    loop, Files, % AppCustomMacrosFolder "\*.*"
    {
        SplitPath, A_LoopFileName,,,, FileName
        List1 .= FileName "|"
    }
    List1 := RTrim(List1, "|")
    List1 := StrReplace(List1, "|", "||",, 1) ; make first item default
    GuiControl,1:,CustomMacroDropDownList, |
    GuiControl,1:,CustomMacroDropDownList,% List1
}
2GuiClose: 
MacroMakerGui(false)
return
;//////////////[End of custom macro]///////////////
;____________________________________________________________
UpdateSettingsFromRegistery()
{
    ;Xbox overlay
    regRead,T_XboxOverlayConfig,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR,AppCaptureEnabled
    if(T_XboxOverlayConfig == 1)
    {
        GuiControl,1:,XboxOverlayCheckbox,1
    }
    else
    {
        GuiControl,1:,XboxOverlayCheckbox,0
    }
    ;Game mode
    regRead,T_GameModeConfig,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AllowAutoGameMode
    regRead,T_GameModeConfig2,HKEY_CURRENT_USER\Software\Microsoft\GameBar,AutoGameModeEnabled
    if(T_GameModeConfig == 1 or T_GameModeConfig2 == 1)
    {
        GuiControl,1:,ToggleGameModeCheckbox,1
    }
    else
    {
        GuiControl,1:,ToggleGameModeCheckbox,0
    }
    ;Game DVR
    regRead,T_GameDVRConfig,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled
    if(T_GameDVRConfig == 1)
    {
        GuiControl,1:,ToggleGameDVRCheckbox,1
    }
    else
    {
        GuiControl,1:,ToggleGameDVRCheckbox,0
    }
    ;Clipboard history
    regRead,T_AllowClipboardHistory,HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System,AllowClipboardHistory
    if(T_AllowClipboardHistory == 1)
    {
        GuiControl,1:,ToggleClipboardHistoryCheckbox,1
    }
    else
    {
        GuiControl,1:,ToggleClipboardHistoryCheckbox,0
    }
    ;AutomaticallyBackupRegistery
    regRead,T_AutomaticallyBackupRegistery,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager,EnablePeriodicBackup
    if(T_AutomaticallyBackupRegistery == 1)
    {
        GuiControl,1:,AutomaticallyBackupRegisteryCheckbox,1
    }
    else
    {
        GuiControl,1:,AutomaticallyBackupRegisteryCheckbox,0
    }
    ;ClearVirtualMemoryPageFileAtShutdown
    regRead,T_ClearVirtualMemoryPageFileAtShutdown,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management,ClearPageFileAtShutdown
    if(T_ClearVirtualMemoryPageFileAtShutdown == 1)
    {
        GuiControl,1:,ClearVirtualMemoryPageFileAtShutdownCheckbox,1
    }
    else
    {
        GuiControl,1:,ClearVirtualMemoryPageFileAtShutdownCheckbox,0
    }
    ;ToggleAdvertisingIDForRelevantAds
    regRead,T_ToggleAdvertisingIDForRelevantAds,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo,Enabled
    if(T_ToggleAdvertisingIDForRelevantAds == 1)
    {
        GuiControl,1:,ToggleAdvertisingIDForRelevantAdsCheckbox,1
    }
    else
    {
        GuiControl,1:,ToggleAdvertisingIDForRelevantAdsCheckbox,0
    }
    ;ToggleFeaturedAutoInstall
    regRead,T_ToggleFeaturedAutoInstall,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager,SilentInstalledAppsEnabled
    if(T_ToggleFeaturedAutoInstall == 1)
    {
        GuiControl,1:,ToggleFeaturedAutoInstallCheckbox,1
    }
    else
    {
        GuiControl,1:,ToggleFeaturedAutoInstallCheckbox,0
    }
}
NotAdminError()
{
    MsgBox, 1,Needs admin privileges,This feature needs admin privileges`nPress "Ok" to run this script as admin
    IfMsgBox, ok
    {
        Run *RunAs %A_ScriptFullPath%
        ExitApp
    }
}
UpdateTrayicon()
{
        Menu,Tray,Click,1
        Menu,Tray,DeleteAll
        Menu,Tray,NoStandard
        Menu,Tray,Add,Show GUI,P_OpenGui
        Menu,Tray,Add
        Menu,Tray,Add,Numpad Macro deck,P_ToggleNumpadMacroDeck
        Menu,Tray,Add,Open Appdata Folder,OpenAppdataFolder
        Menu,Tray,Add,Run IpConfig,RunIpConfig
        Menu,Tray,Add,Open Sounds,OpenSounds
        Menu,Tray,Add
        Menu,Tray,Add,E&xit,EXIT
        Menu,Tray,Default,Show GUI
        Menu,Tray,Tip, Game Script Ahk
}
UpdateTrayNumpadMacroState(Temp_state)
{
    if(Temp_state)
    {
        Menu,Tray,Check,Numpad Macro deck
    }
    else
    {
        Menu,Tray,UnCheck,Numpad Macro deck
    }
}