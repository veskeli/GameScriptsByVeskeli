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
;//////////////[Folders]///////////////
ScriptName = GameScripts
AppFolderName = AHKGameScriptsByVeskeli
AppFolder = %A_AppData%\%AppFolderName%
AppSettingsFolder = %AppFolder%\Settings
GuiPictureFolder = %AppFolder%\Gui
;//////////////[ini]///////////////
AppSettingsIni = %AppSettingsFolder%\Settings.ini
AppGameScriptSettingsIni = %AppSettingsFolder%\GameScriptSettings.ini
AppHotkeysIni = %AppSettingsFolder%\Hotkeys.ini
;//////////////[Update]///////////////
AppUpdateFile = %AppFolder%\temp\OldFile.ahk
;//////////////[Other Scripts]///////////////
AppGamingScriptsFolder = %AppFolder%\GamingScripts
AppOtherScriptsFolder = %AppFolder%\OtherScripts
;____________________________________________________________
;//////////////[Version]///////////////
version = 0.3896
;//////////////[Experimental]///////////////
IsThisExperimental := true
;//////////////[Action variables]///////////////
AutoRunToggle = 0
AutoRunUseShift = 1
WindowsButtonRebindEnabled = 0
CapsLockButtonRebindEnabled = 0
MouseHoldToggle = 0
MouseClickerToggle = 0
;____________________________________________________________
;//////////////[variables]///////////////
CloseToTray := false
PinSlot := [5]
ShowChangelog := false
;//////////////[Gui Pictures]///////////////
PinPic = %GuiPictureFolder%\pin.png
RemovePinPic = %GuiPictureFolder%\removepin.png
;____________________________________________________________
;//////////////[Global variables]///////////////
global ScriptName
global AppFolderName
global AppFolder
global AppSettingsFolder
global AppSettingsIni
global AppHotkeysIni
global AppUpdateFile
global CloseToTray
global GuiPictureFolder
global AppOtherScriptsFolder
global GHUBToolLocation
global NgrokToolLocation
global GHUBTool
global NgrokTool
global SatisfactorySaveManager
global SatisfactorySaveManagerLocation
global PinSlot
;____________________________________________________________
;____________________________________________________________
;//////////////[GUI]///////////////
;//////////////[Startup checks]///////////////
IfExist %AppUpdateFile%
{
    FileDelete, %AppUpdateFile% ;delete old file after update
    FileRemoveDir, %AppFolder%\temp ;Delete temp directory
    ShowChangelog := true
}
IfNotExist %GuiPictureFolder%
{
    DownloadAssets()
}
IfExist, %GuiPictureFolder%\GameScripts.ico
{
    Menu Tray, Icon, %GuiPictureFolder%\GameScripts.ico,1
}
else
{
    MsgBox,,Asset download error,Assets needs to be Redownloaded `n You can re download assets from settings tab
}
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Tab3, x0 y0 w898 h640, Home|Settings|Other Scripts|Windows|Basic Scripts
;____________________________________________________________
;____________________________________________________________
;//////////////[Home]///////////////
Gui 1:Tab, Home
Gui 1:Add, GroupBox, x432 y32 w386 h126, Quick actions
Gui 1:Add, CheckBox, x440 y56 w120 h23 gToggleXboxOverlay1 vXboxOverlayCheckbox1, Xbox Overlay
Gui 1:Add, CheckBox, x440 y80 w120 h23 gToggleGameDVR1 vToggleGameDVRCheckbox1, Game DVR
Gui 1:Add, Button, x440 y112 w164 h28 gClearWindowsTempFolder, Clear Windows Temp Folder
Gui 1:Add, Button, x568 y56 w80 h23 gRunIpConfig, IPConfig
Gui 1:Add, Button, x568 y80 w80 h23 gOpenAppdataFolder, Appdata
;Gui 1:Add, Button, x656 y56 w149 h48 gSetVoicemeeterAsDefaultAudioDevice, Set Voicemeeter as default audio device
Gui 1:Add, Button, x608 y112 w80 h23 gOpenSounds, Open Sounds
Gui 1:Add, Picture, x48 y112 w349 h294 vpintextIMG, %GuiPictureFolder%/pintext.png
Gui 1:Font, s17
Gui 1:Add, Text, x272 y440 w353 h50 +0x200, All of this might change.
Gui 1:Font
Gui 1:Font, s16
Gui 1:Add, GroupBox, x16 y40 w385 h80 +Hidden vPin1GroubBox, Pin1
Gui 1:Add, GroupBox, x16 y128 w385 h80 +Hidden vPin2GroubBox, Pin2
Gui 1:Add, GroupBox, x16 y216 w385 h80 +Hidden vPin3GroubBox, Pin3
Gui 1:Add, GroupBox, x16 y304 w385 h80 +Hidden vPin4GroubBox, Pin4
Gui 1:Add, GroupBox, x16 y392 w385 h80 +Hidden vPin5GroubBox, Pin5
Gui 1:Font, s20
Gui 1:Add, Button, x128 y68 w137 h45 +Hidden gPin1RunButton vPin1RunButton, % Chr(0x25B6) . " Open"
Gui 1:Add, Button, x128 y148 w137 h45 +Hidden gPin2RunButton vPin2RunButton, % Chr(0x25B6) . " Open"
Gui 1:Add, Button, x128 y236 w137 h45 +Hidden gPin3RunButton vPin3RunButton, % Chr(0x25B6) . " Open"
Gui 1:Font, s9, Segoe UI
Gui 1:Add, GroupBox, x432 y160 w386 h62, Toggle any application to Always on top by hotkey
Gui 1:Font
Gui 1:Font, s12
Gui 1:Add, Text, x440 y184 w61 h23 +0x200, Hotkey:
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Hotkey, x504 y184 w120 h21 vAlwaysOnTopHotkey_Menu gSaveAlwaysOnTopHotkey_Menu
Gui 1:Add, Picture, x632 y182 w50 h25 gAlwaysOnTopHotkey_Menu vAlwaysOnTopHotkey_MenuButton, %GuiPictureFolder%/off.png
Gui 1:Font
;____________________________________________________________
;____________________________________________________________
;//////////////[Settings]///////////////
Gui 1:Tab, Settings
Gui 1:Add, GroupBox, x8 y32 w175 h88, Admin
Gui 1:Add, Button, x16 y56 w152 h23 gRunAsThisAdmin vRunAsThisAdminButton, Run This Script as admin
Gui 1:Add, CheckBox, x16 y88 w152 h23 gRunAsThisAdminCheckboxButton vRunAsThisAdminCheckbox, Run as admin on start
Gui 1:Add, GroupBox, x8 y122 w175 h130, Settings for this script.
Gui 1:Add, CheckBox, x16 y144 w143 h23 gKeepThisAlwaysOnTop, Keep this always on top
Gui 1:Add, CheckBox, x16 y168 w140 h23 gOnExitCloseToTray vOnExitCloseToTrayCheckbox, On Exit close to tray
Gui 1:Add, Button, x16 y192 w133 h28 gRedownloadAssets, Redownload assets
Gui 1:Add, Button, x16 y224 w133 h23 gShowChangelogButton, Show Changelog
Gui 1:Add, GroupBox, x499 y442 w150 h67 +Hidden vDownloadExperimentalBranchGroupbox, Experimental
Gui 1:Add, Button, x504 y464 w138 h36 gDownloadExperimentalBranch +Hidden vDownloadExperimentalBranchButton, Download experimental version
Gui 1:Font
Gui 1:Add, GroupBox, x648 y392 w179 h117, Updates
Gui 1:Font, s15
Gui 1:Add, Text, x664 y472 w158 h28 +0x200, Version = %version%
Gui 1:Font
Gui 1:Add, CheckBox, x656 y416 w169 h23 vCheckUpdatesOnStartup gAutoUpdates, Check for updates on startup
Gui 1:Add, Button, x672 y440 w128 h23 gcheckForupdates, Check for updates
Gui 1:Font, s9, Segoe UI
Gui 1:Add, GroupBox, x8 y339 w175 h80, Debug
Gui 1:Add, Button, x16 y360 w139 h27 gOpenAppSettingsFolder, Open Settings Folder
Gui 1:Add, Button, x16 y392 w116 h23 gOpenAppSettingsFile, Open settings File
Gui 1:Add, GroupBox, x8 y419 w175 h94, Delete Stuff
Gui 1:Add, Button, x16 y440 w103 h23 gDeleteAppSettings, Delete all settings
Gui 1:Add, Button, x16 y464 w135 h42 gDeleteAllFiles, Delete all files (including this script)
Gui 1:Add, GroupBox, x182 y31 w120 h63, Shortcut
Gui 1:Add, Button, x192 y48 w95 h35 gShortcut_to_desktop, Shortcut to Desktop
Gui 1:Add, GroupBox, x182 y364 w318 h155, Exe Runner
Gui 1:Add, Button, x350 y480 w142 h32 vDownloadEXERunnerButton gDownloadEXERunner, Download EXE Runner
Gui 1:Add, Text, x190 y385 w306 h90, EXE Runner is a simple Run script compiled to exe.`n(Moves this main script to Appdata and replaces this with an exe file[You can always revert back])`nNew Features with exe Runner:`n+ You can pin this to taskbar`n+ Cool App Icon
;____________________________________________________________
;____________________________________________________________
;//////////////[Other Scripts]///////////////
Gui 1:Tab, Other Scripts
; Add 70 to Y
;Logitech backup tool
Gui 1:Font, s13
Gui 1:Add, GroupBox, x8 y27 w430 h69, Logitech Backup Tool
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Button, x16 y56 w131 h23 vDowloadGHUBToolButton gDownloadGHUBTool, Download
Gui 1:Add, Button, x352 y56 w80 h23 gUninstallGHUBToolScript vUninstallGHUBToolScritpButton +Disabled, Delete
Gui 1:Add, Button, x160 y56 w80 h23 +disabled, Settings
Gui 1:Add, Button, x248 y56 w100 h23 gOpenGHUBToolGithub, Open in Github
Gui 1:Add, Picture, x413 y39 w18 h18 gPinGHUBTool vPinGHUBToolIMG +Hidden, %PinPic%
;Ngrok tool
Gui 1:Font, s13
Gui 1:Add, GroupBox, x8 y97 w430 h69, Ngrok port fowarding Tool
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Button, x16 y126 w131 h23 gDownloadNgrokTool vDownloadNgrokToolButton, Download
Gui 1:Add, Button, x352 y126 w80 h23 gUninstallNgrokTool vUninstallNgrokToolButton +Disabled, Delete
Gui 1:Add, Button, x160 y126 w80 h23 +disabled, Settings
Gui 1:Add, Button, x248 y126 w100 h23 gOpenNgrokInGithub, Open in Github
Gui 1:Add, Picture, x413 y109 w18 h18 gPinNgrokTool vPinNgrokToolIMG +Hidden, %PinPic%
;Satisfactory Save Manager
Gui 1:Font, s13
Gui 1:Add, GroupBox, x8 y167 w430 h69, Satisfactory Save Manager
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Button, x16 y196 w131 h23 gDownloadSatisfactorySaveManager vDownloadSatisfactorySaveManagerButton, Download
Gui 1:Add, Button, x352 y196 w80 h23 gUninstallSatisfactorySaveManager vUninstallSatisfactorySaveManagerButton +Disabled, Delete
Gui 1:Add, Button, x160 y196 w80 h23 +disabled, Settings
Gui 1:Add, Button, x248 y196 w100 h23 gOpenSatisfactorySaveManagerInGithub, Open in Github
Gui 1:Add, Picture, x413 y179 w18 h18 gPinSatisfactorySaveManager vPinSatisfactorySaveManagerIMG +Hidden, %PinPic%
;____________________________________________________________
;____________________________________________________________
;//////////////[Windows]///////////////
Gui 1:Tab, Windows
Gui 1:Add, GroupBox, x8 y388 w317 h124, Free Space on your device.
Gui 1:Add, Text, x24 y408 w278 h23 +0x200,Deletes Windows temporary files that are not in use.
Gui 1:Font, s11
Gui 1:Add, Button, x16 y440 w264 h30 gClearWindowsTempFolder, Clear Windows temporary folder
Gui 1:Font
Gui 1:Add, Button, x16 y478 w265 h28 gClearAllRecentDocumentsInWordpad, Clear all recent documents in wordpad
Gui 1:Add, GroupBox, x8 y32 w140 h99,Open command prompt
Gui 1:Add, Button, x16 y48 w80 h23 gOpenCmd, Open CMD
Gui 1:Add, Button, x16 y72 w126 h23 gOpenCmdAsAdmin, Open CMD as admin
Gui 1:Add, Button, x16 y96 w80 h23 gRunIpConfig, IPConfig
Gui 1:Add, GroupBox, x152 y32 w164 h99, Toggle windows game settings
Gui 1:Add, CheckBox, x160 y48 w131 h23 gToggleXboxOverlay vXboxOverlayCheckbox, Xbox Overlay
Gui 1:Add, CheckBox, x160 y72 w120 h23 gToggleGameDVR vToggleGameDVRCheckbox, Game DVR
Gui 1:Add, CheckBox, x160 y96 w120 h23 gToggleGameMode vToggleGameModeCheckbox, Game Mode
Gui 1:Add, GroupBox, x8 y136 w140 h149, Open Folders
Gui 1:Add, Button, x16 y152 w90 h23 gOpenAppdataFolder, Appdata
Gui 1:Add, Button, x16 y176 w90 h23 gOpenStartupFolder, Startup
Gui 1:Add, Button, x16 y200 w91 h23 gOpenWindowsTempFolder, Windows Temp
Gui 1:Add, Button, x16 y224 w89 h23 gOpenMyDocuments, My Documents
Gui 1:Add, Button, x16 y248 w89 h23 gOpenDesktop, Desktop
Gui 1:Add, GroupBox, x456 y32 w372 h200, Advanced Features
Gui 1:Add, CheckBox, x682 y28 w124 h23 gToggleadvancedWindowsFeatures vToggleadvancedWindowsFeaturesCheckbox,I know what I'm doing.
Gui 1:Add, CheckBox, x464 y64 w143 h23 +Disabled gToggleClipboardHistory vToggleClipboardHistoryCheckbox, Clipboard histroy Sync
Gui 1:Add, CheckBox, x464 y88 w180 h23 +Disabled gAutomaticallyBackupRegistery vAutomaticallyBackupRegisteryCheckbox, Automatically backup registery
Gui 1:Add, CheckBox, x464 y112 w177 h30 +Disabled gClearVirtualMemoryPageFileAtShutdown vClearVirtualMemoryPageFileAtShutdownCheckbox, Clear virtual memorypage file during shutdown
Gui 1:Add, CheckBox, x464 y144 w230 h48 +Disabled vToggleFeaturedAutoInstallCheckbox, Toggle Windows 10 Featured or Suggested Apps from Automatically Installing
Gui 1:Add, Button, x464 y200 w171 h23 +Disabled gDisableMostOfAds vDisableMostOfAdsButton, Disable Most windows 10 ads
Gui 1:Add, Button, x648 y200 w169 h23 +Disabled gRestoreMostOfAds vRestoreMostOfAdsButton, Restore Most windows 10 ads
;____________________________________________________________
;____________________________________________________________
;//////////////[Voicemeeter]///////////////
/*
Gui 1:Tab, Voicemeeter
Gui 1:Add, Button, x656 y56 w149 h48 gSetVoicemeeterAsDefaultAudioDevice, Set Voicemeeter as default audio device
*/
;____________________________________________________________
;____________________________________________________________
;//////////////[Basic scripts]///////////////
Gui 1:Tab, Basic Scripts
Gui 1:Add, GroupBox, x376 y26 w450 h288, Game Scripts
Gui 1:Font, s12
Gui 1:Add, Text, x384 y42 w436 h84, These scripts aren't made for exploitation or cheating. `nThey are simple scripts to use in single/coop games. `nSome anti-cheat software can ban you if you use them to cheat/exploit. Please play fair.
Gui 1:Font
;//////////////[Mouse Hold]///////////////
Gui 1:Add, GroupBox, x376 y128 w450 h56, Mouse Hold
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x384 y152 w83 h23 +0x200, Mouse button:
Gui 1:Add, DropDownList, x472 y152 w94 gGuiSubmit vMouseHoldList, Left||Middle|Right
Gui 1:Add, Text, x576 y152 w47 h23 +0x200, Hotkey:
Gui 1:Add, Hotkey, x632 y152 w120 h21 gSaveMouseHoldSettings vMouseHoldHotkey
Gui 1:Font
Gui 1:Add, Picture, x760 y144 w54 h29 vMouseHoldCheckbox gMouseHoldEnabled, %GuiPictureFolder%/off.png
Gui 1:Font, s11
;//////////////[Mouse Clicker]///////////////
Gui 1:Add, GroupBox, x376 y184 w450 h80, Mouse Clicker
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x384 y200 w83 h23 +0x200 , Mouse button:
Gui 1:Font
Gui 1:Add, DropDownList, x464 y200 w104 gGuiSubmit vMouseClickerList, Left||Middle|Right
Gui 1:Add, Text, x576 y200 w47 h23 +0x200 , Hotkey:
Gui 1:Add, Hotkey, x624 y200 w120 h21 gSaveMouseClickerSettings vMouseClickerHotkey
Gui 1:Add, Text, x384 y232 w62 h23 +0x200 , Timer: (ms)
Gui 1:Add, Edit, x448 y232 w120 h21 +Number gGuiSubmit vMouseClickerDelay, 150
Gui 1:Add, Picture, x760 y194 w54 h29 gMouseClickerEnabled vMouseClickerCheckbox, %GuiPictureFolder%/off.png
Gui 1:Font, s11
;//////////////[Auto Run/Walk]///////////////
Gui 1:Add, GroupBox, x376 y264 w450 h50, Auto Run/Walk (Hold "W" [3D games only])
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x384 y280 w47 h23 +0x200, Hotkey:
Gui 1:Add, Hotkey, x440 y280 w120 h21 gSaveToggleRun vToggleRunHotkey
Gui 1:Add, CheckBox, x576 y280 w93 h23 +Checked gAutoRunUseShiftButton vAutoRunUseShiftButtonVar, Run (Use shift)
Gui 1:Add, Picture, x762 y274 w54 h29 gEnableAutoRun vAutoRunCheckbox, %GuiPictureFolder%/off.png
;//////////////[Always on top]///////////////
Gui 1:Font, s11
Gui 1:Add, GroupBox, x2 y27 w367 h55, Toggle any application to Always on top by hotkey
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Text, x9 y50 w47 h23 +0x200, Hotkey:
Gui 1:Add, Hotkey, x59 y50 w120 h21 vAlwaysOnTopHotkey gSaveAlwaysOnTopHotkey
Gui 1:Add, Picture, x201 y48 w50 h25 gEnableAlwaysOnTop vAlwaysOnTopCheckbox, %GuiPictureFolder%/off.png
;//////////////[Disable buttons]///////////////
Gui 1:Font, s9, Segoe UI
Gui 1:Add, GroupBox, x3 y99 w366 h111, Disable or Rebind buttons
Gui 1:Add, CheckBox, x16 y120 w156 h23 gDisableWindowsButton vDisableWindowsCheckbox, Disable Windows button
Gui 1:Add, CheckBox, x16 y144 w120 h23 gDisableCapsLockButton vDisableCapsLockCheckbox, Disable Caps Lock
Gui 1:Add, CheckBox, x176 y120 w74 h23 gEnableWindowsRebind vRebindWindowsCheckbox, Rebind to:
Gui 1:Add, Hotkey, x256 y120 w110 h21 gGuiSubmit vRebindWindowsButton ;Windows
Gui 1:Add, CheckBox, x176 y144 w77 h23 gEnableCapsLockRebind vRebindCapsLockCheckbox, Rebind to:
Gui 1:Add, Hotkey, x256 y144 w110 h21 gGuiSubmit vRebindCapsLockButton ;capslock
Gui 1:Add, CheckBox, x16 y168 w120 h23 gDisableAltTabButton vDisableAltTabCheckbox, Disable Alt + Tab
Gui 1:Font
;____________________________________________________________
;//////////////[Startup stuff]///////////////
if(A_IsAdmin)
{
    GuiControl,1:,RunAsThisAdminButton,Already running as admin
    GuiControl,1:Disable,RunAsThisAdminButton
}
IfExist, %AppHotkeysIni% 
{
    ;//////////////[Menu Tab]///////////////
    IniRead, Temp_AlwayOnTopHotkey_Menu, %AppHotkeysIni%, GameMode, AlwaysOnTopHotkey_Menu
	GuiControl,1:,AlwaysOnTopHotkey_Menu,%Temp_AlwayOnTopHotkey_Menu%
    ;//////////////[Basic Scripts]///////////////
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
;Settings tab
IfExist, %AppSettingsIni%
{
    iniread, T_IsRunnerEnabled,%AppSettingsIni%, ExeRunner, UsingExeRunner
    if(%T_IsRunnerEnabled% == true)
    {
        GuiControl,1:Enable,Shortcut_to_taskbarButton
        GuiControl,1:,DownloadEXERunnerButton,Revert
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
    IniRead, Temp_GHUBToolPin,%AppSettingsIni%,Pinned,% "GHUBTool" . "IsPinned"
    if(Temp_GHUBToolPin == "true")
    {
        GuiControl,1:,% "Pin" . "GHUBTool" . "IMG",%GuiPictureFolder%\removepin.png
    }
    IniRead, Temp_NgrokToolPin,%AppSettingsIni%,Pinned,% "NgrokTool" . "IsPinned"
    if(Temp_NgrokToolPin == "true")
    {
        GuiControl,1:,% "Pin" . "NgrokTool" . "IMG",%GuiPictureFolder%\removepin.png
    }
    IniRead, Temp_SatisfactorySaveManagerPin,%AppSettingsIni%,Pinned,% "SatisfactorySaveManager" . "IsPinned"
    if(Temp_SatisfactorySaveManagerPin == "true")
    {
        GuiControl,1:,% "Pin" . "SatisfactorySaveManager" . "IMG",%GuiPictureFolder%\removepin.png
    }
    UpdateHomeScreen()
    UpdateAllCustomCheckboxes()
}
IfExist %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
{
    GuiControl,1: , DowloadGHUBToolButton, % Chr(0x25B6) . " Open"
    GuiControl,1:Enable,UninstallGHUBToolScritpButton
    GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    GHUBTool := true
    GuiControl,1:Show ,PinGHUBToolIMG
}
IfExist %AppOtherScriptsFolder%\Ngrok.ahk
{
    GuiControl,1: , DownloadNgrokToolButton, % Chr(0x25B6) . " Open"
    GuiControl,1:Enable,UninstallNgrokToolButton
    NgrokToolLocation = %AppOtherScriptsFolder%\Ngrok.ahk
    NgrokTool := true
    GuiControl,1:Show ,PinNgrokToolIMG
}
IfExist %AppOtherScriptsFolder%\SatisfactorySaveManager.ahk
{
    GuiControl,1: , DownloadSatisfactorySaveManagerButton, % Chr(0x25B6) . " Open"
    GuiControl,1:Enable,UninstallSatisfactorySaveManagerButton
    SatisfactorySaveManagerLocation = %AppOtherScriptsFolder%\SatisfactorySaveManager.ahk
    SatisfactorySaveManager := true
    GuiControl,1:Show ,PinSatisfactorySaveManagerIMG
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
        GuiControl,1: , DowloadGHUBToolButton, % Chr(0x25B6) . " Open"
        GuiControl,1: Enable,UninstallGHUBToolScritpButton
        GHUBTool := true
        GuiControl,1:Show ,PinGHUBToolIMG
    }
}
;Read From registery
UpdateSettingsFromRegistery()
;____________________________________________________________
;//////////////[Audio Switching code]///////////////
Devices := {}
IMMDeviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")
; IMMDeviceEnumerator::EnumAudioEndpoints
; eRender = 0, eCapture, eAll
; 0x1 = DEVICE_STATE_ACTIVE
DllCall(NumGet(NumGet(IMMDeviceEnumerator+0)+3*A_PtrSize), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 0x1, "UPtrP", IMMDeviceCollection, "UInt")
ObjRelease(IMMDeviceEnumerator)

; IMMDeviceCollection::GetCount
DllCall(NumGet(NumGet(IMMDeviceCollection+0)+3*A_PtrSize), "UPtr", IMMDeviceCollection, "UIntP", Count, "UInt")
Loop % (Count)
{
    ; IMMDeviceCollection::Item
    DllCall(NumGet(NumGet(IMMDeviceCollection+0)+4*A_PtrSize), "UPtr", IMMDeviceCollection, "UInt", A_Index-1, "UPtrP", IMMDevice, "UInt")

    ; IMMDevice::GetId
    DllCall(NumGet(NumGet(IMMDevice+0)+5*A_PtrSize), "UPtr", IMMDevice, "UPtrP", pBuffer, "UInt")
    DeviceID := StrGet(pBuffer, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "UPtr", pBuffer)

    ; IMMDevice::OpenPropertyStore
    ; 0x0 = STGM_READ
    DllCall(NumGet(NumGet(IMMDevice+0)+4*A_PtrSize), "UPtr", IMMDevice, "UInt", 0x0, "UPtrP", IPropertyStore, "UInt")
    ObjRelease(IMMDevice)

    ; IPropertyStore::GetValue
    VarSetCapacity(PROPVARIANT, A_PtrSize == 4 ? 16 : 24)
    VarSetCapacity(PROPERTYKEY, 20)
    DllCall("Ole32.dll\CLSIDFromString", "Str", "{A45C254E-DF1C-4EFD-8020-67D146A850E0}", "UPtr", &PROPERTYKEY)
    NumPut(14, &PROPERTYKEY + 16, "UInt")
    DllCall(NumGet(NumGet(IPropertyStore+0)+5*A_PtrSize), "UPtr", IPropertyStore, "UPtr", &PROPERTYKEY, "UPtr", &PROPVARIANT, "UInt")
    DeviceName := StrGet(NumGet(&PROPVARIANT + 8), "UTF-16")    ; LPWSTR PROPVARIANT.pwszVal
    DllCall("Ole32.dll\CoTaskMemFree", "UPtr", NumGet(&PROPVARIANT + 8))    ; LPWSTR PROPVARIANT.pwszVal
    ObjRelease(IPropertyStore)

    ObjRawSet(Devices, DeviceName, DeviceID)
}
;____________________________________________________________
;//////////////[Show Gui After setting all saved settings]///////////////
if(IsThisExperimental)
{
    Gui 1:Show, w835 h517,This is experimental branch! Only for testing new versions.
}
else
{
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
            GuiControl,1:Show,DownloadExperimentalBranchGroupbox
            GuiControl,1:,DownloadExperimentalBranchButton, Download Stable version
            ;check if there is new stable
            GoSub CheckForStableVersion
        }
        else
        {
            ;Check for experimental branch
            whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            whr.Open("GET", "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/version.txt", False)
            whr.Send()
            whr.WaitForResponse()
            ExperimentalVersion := whr.ResponseText
            if(ExperimentalVersion != "" and ExperimentalVersion != "404: Not Found" and ExperimentalVersion != "500: Internal Server Error")
            {
                ;Found experimental version
                GuiControl,1:show,DownloadExperimentalBranchButton
                GuiControl,1:Show,DownloadExperimentalBranchGroupbox
            }
            GoSub checkForupdates
        }
    }
    else
    {
        ;if this is experimental but check updates on start is disabled
        if(IsThisExperimental)
        {
            MsgBox,,Experimental,This is experimental branch!`nOnly for testing new versions.
            GuiControl,1:show,DownloadExperimentalBranchButton
            GuiControl,1:Show,DownloadExperimentalBranchGroupbox
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
;Last thing is to show changelog
if(ShowChangelog)
{
    UrlDownloadToFile,% "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/Changelog/" . version,%AppFolder%/Changelog.txt
    FileRead, ChangelogText,%AppFolder%/Changelog.txt
    if(ChangelogText != "" and ChangelogText != "404: Not Found" and ChangelogText != "500: Internal Server Error")
    {
        MsgBox,,Changelog %version%, %ChangelogText%
    }
    else
    {
        FileDelete, %AppFolder%/Changelog.txt
    }
}
return
;____________________________________________________________
;//////////////[Changelog]///////////////
ShowChangelogButton:
UrlDownloadToFile,% "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/Changelog/" . version,%AppFolder%/Changelog.txt
FileRead, ChangelogText,%AppFolder%/Changelog.txt
if(ChangelogText != "" and ChangelogText != "404: Not Found" and ChangelogText != "500: Internal Server Error")
{
    MsgBox,,Changelog %version%, %ChangelogText%
}
else
{
    MsgBox,,No Changelog!,The current version doesn't have a changelog.,10
    FileDelete, %AppFolder%/Changelog.txt
}
return
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
OpenMainGui:
    Gui, 1:Show
return
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
ToggleXboxOverlay1:
Gui, 1:Submit, Nohide
GuiControl,1:,XboxOverlayCheckbox,%XboxOverlayCheckbox1%
goto ToggleXboxOverlay
return
ToggleXboxOverlay:
Gui, 1:Submit, Nohide
GuiControl,1:,XboxOverlayCheckbox1,%XboxOverlayCheckbox%
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
ToggleGameDVR1:
Gui, 1:Submit, Nohide
GuiControl,1:,ToggleGameDVRCheckbox,%ToggleGameDVRCheckbox1%
Goto ToggleGameDVR
return
ToggleGameDVR:
Gui, 1:Submit, Nohide
GuiControl,1:,ToggleGameDVRCheckbox1,%ToggleGameDVRCheckbox%
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
Progress, b w300, Wait while the script is deleting temporary files., Deleting Temporary Files..., Deleting Temporary Files...
dir= %A_Temp%
FileDelete, %dir%\*.*
Loop, %dir%\*.*, 2
{
    Progress, %A_Index%
    FileRemoveDir, %A_LoopFileLongPath%,1
}
Progress, 100
Progress, Off
MsgBox,,All Done!,Unused temporary files deleted.,5
return
OpenCmd:
run, %ComSpec%
return
OpenCmdAsAdmin:
Run *RunAs %ComSpec%
return
RunIpConfig:
runwait %ComSpec% /k ipconfig
return
ClearAllRecentDocumentsInWordpad:
regDelete,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List
return
OpenSounds:
Run, mmsys.cpl
return
ToggleadvancedWindowsFeatures:
Gui, 1:Submit, Nohide
if(ToggleadvancedWindowsFeaturesCheckbox)
{
    GuiControl,1:Enable,ToggleClipboardHistoryCheckbox
    GuiControl,1:Enable,AutomaticallyBackupRegisteryCheckbox
    GuiControl,1:Enable,ClearVirtualMemoryPageFileAtShutdownCheckbox
    GuiControl,1:Enable,ToggleFeaturedAutoInstallCheckbox
    GuiControl,1:Enable,DisableMostOfAdsButton
    GuiControl,1:Enable,RestoreMostOfAdsButton
}
else
{
    GuiControl,1:Disable,ToggleClipboardHistoryCheckbox
    GuiControl,1:Disable,AutomaticallyBackupRegisteryCheckbox
    GuiControl,1:Disable,ClearVirtualMemoryPageFileAtShutdownCheckbox
    GuiControl,1:Disable,ToggleFeaturedAutoInstallCheckbox
    GuiControl,1:Disable,DisableMostOfAdsButton
    GuiControl,1:Disable,RestoreMostOfAdsButton
}
return
ToggleClipboardHistory:
Gui, 1:Submit, Nohide
if(ToggleClipboardHistoryCheckbox)
{
    if(!A_IsAdmin)
    {
        NotAdminError()
        GuiControl,1:,ToggleClipboardHistoryCheckbox,0
        return
    } 
    regWrite,REG_DWORD,HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System,AllowClipboardHistory,1
}
else
{
    if(!A_IsAdmin)
    {
        NotAdminError()
        GuiControl,1:,ToggleClipboardHistoryCheckbox,1
        return
    }
    regDelete,HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System,AllowClipboardHistory
}
AutomaticallyBackupRegistery:
Gui, 1:Submit, Nohide
if(AutomaticallyBackupRegisteryCheckbox)
{
    if(!A_IsAdmin)
    {
        NotAdminError()
        GuiControl,1:,AutomaticallyBackupRegisteryCheckbox,0
        return
    }
    regWrite,REG_DWORD,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager,EnablePeriodicBackup,1
}
else
{
    if(!A_IsAdmin)
    {
        NotAdminError()
        GuiControl,1:,AutomaticallyBackupRegisteryCheckbox,1
        return
    }
    regDelete,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager,EnablePeriodicBackup
}
return
ClearVirtualMemoryPageFileAtShutdown:
Gui, 1:Submit, Nohide
if(ClearVirtualMemoryPageFileAtShutdownCheckbox)
{
    if(!A_IsAdmin)
    {
        NotAdminError()
        GuiControl,1:,ClearVirtualMemoryPageFileAtShutdownCheckbox,0
        return
    }
    regWrite,REG_DWORD,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management,ClearPageFileAtShutdown,1
}
else
{
    if(!A_IsAdmin)
    {
        NotAdminError()
        GuiControl,1:,ClearVirtualMemoryPageFileAtShutdownCheckbox,1
        return
    }
    regWrite,REG_DWORD,HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management,ClearPageFileAtShutdown,0
}
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
;____________________________________________________________
;____________________________________________________________
;//////////////[Voicemeeter]///////////////
SetVoicemeeterAsDefaultAudioDevice:
SetDefaultEndpoint(GetDeviceID(Devices, "VoiceMeeter Aux Input"))
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Settings]///////////////
RedownloadAssets:
FileRemoveDir, %GuiPictureFolder%, 1
Run, %A_ScriptFullPath%
ExitApp
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
OpenAppSettingsFolder:
run, %AppFolder%
return
OpenAppSettingsFile:
run, %AppSettingsIni%
return
AutoUpdates:
Gui, 1:Submit, Nohide
FileCreateDir, %AppFolder%
FileCreateDir, %AppSettingsFolder%
IniWrite, %CheckUpdatesOnStartup%, %AppSettingsIni%, Updates, CheckOnStartup
return
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
            MsgBox, Error while deleting file`nYou need to delete exe file manually`nBut Revert is still successful.
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
;____________________________________________________________
;//////////////[checkForupdates]///////////////
checkForupdates:
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/version.txt", False)
whr.Send()
whr.WaitForResponse()
newversion := whr.ResponseText
if(newversion != "" and newversion != "404: Not Found" and newversion != "500: Internal Server Error")
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
;//////////////[Experimental Download]///////////////
CheckForStableVersion:
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/version.txt", False)
whr.Send()
whr.WaitForResponse()
newversion := whr.ResponseText
if(newversion != "" and newversion != "404: Not Found" and newversion != "500: Internal Server Error")
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
if(ExperimentalVersion != "" and ExperimentalVersion != "404: Not Found" and ExperimentalVersion != "500: Internal Server Error")
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
;____________________________________________________________
;//////////////[Other Scripts]///////////////
DownloadGHUBTool:
if (!GHUBTool)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppOtherScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/LogitechBackupProfilesAhk/master/LogitechBackupProfiles.ahk, %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    ;write save/Update Gui
    GuiControl,1:, DowloadGHUBToolButton, % Chr(0x25B6) . " Open"
    GuiControl,1:Enable,UninstallGHUBToolScritpButton
    GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    GHUBTool := True
    GuiControl,1:Show ,PinGHUBToolIMG
}
Else ;app is already istalled/downloaded
{
    run, %GHUBToolLocation%
}
Return
UninstallGHUBToolScript:
UninstallScript("GHUBTool")
Return
PinGHUBTool:
PinAppOrAction("GHUBTool")
return
OpenGHUBToolGithub:
run, https://github.com/veskeli/LogitechBackupProfilesAhk
Return
;ngrok
OpenNgrokInGithub:
    run, https://github.com/veskeli/NgrokAhk
return
OpenSatisfactorySaveManagerInGithub:
    run, https://github.com/veskeli/SatisfactorySaveManager
return
DownloadNgrokTool:
if(!NgrokTool)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppOtherScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/NgrokAhk/master/Ngrok.ahk, %AppOtherScriptsFolder%\Ngrok.ahk
    ;write save/Update Gui
    GuiControl,1:, DownloadNgrokToolButton, % Chr(0x25B6) . " Open"
    GuiControl,1:Enable,UninstallNgrokToolButton
    NgrokToolLocation = %AppOtherScriptsFolder%\Ngrok.ahk
    NgrokTool := True
    GuiControl,1:Show ,PinNgrokToolIMG
}
else
{
    run, %NgrokToolLocation%
}
return
UninstallNgrokTool:
UninstallScript("NgrokTool")
return
PinNgrokTool:
PinAppOrAction("NgrokTool")
return
DownloadSatisfactorySaveManager:
if(!SatisfactorySaveManager)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppOtherScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/SatisfactorySaveManager/main/SatisfactorySaveManager.ahk, %AppOtherScriptsFolder%\SatisfactorySaveManager.ahk
    ;write save/Update Gui
    GuiControl,1:, DownloadSatisfactorySaveManagerButton, % Chr(0x25B6) . " Open"
    GuiControl,1:Enable,UninstallSatisfactorySaveManagerButton
    SatisfactorySaveManagerLocation = %AppOtherScriptsFolder%\SatisfactorySaveManager.ahk
    SatisfactorySaveManager := True
    GuiControl,1:Show ,PinSatisfactorySaveManagerIMG
}
else
{
    run, %SatisfactorySaveManagerLocation%
}
return
UninstallSatisfactorySaveManager:
UninstallScript("SatisfactorySaveManager")
return
PinSatisfactorySaveManager:
PinAppOrAction("SatisfactorySaveManager")
return
Pin1RunButton:
RunPinnedApp(1)
return
Pin2RunButton:
RunPinnedApp(2)
return
Pin3RunButton:
RunPinnedApp(3)
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Basic scripts]///////////////
GuiSubmit:
    Gui, 1:Submit, Nohide
return
;____________________________________________________________
;//////////////[Auto Run/Walk]///////////////
SaveToggleRun:
SaveHotkey(ToggleRunHotkey, "AutoRun")
;goto EnableAutoRun
return
EnableAutoRun:
Gui, 1:Submit, Nohide
if (ToggleRunHotkey == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    GuiControl,1:,AutoRunCheckbox,0
    return
}
T_AutoRunCheckboxState := CheckboxToggle("AutoRunCheckbox")
if (T_AutoRunCheckboxState)
{
    Hotkey, %ToggleRunHotkey%,ToggleAutoRun, ON
    Hotkey, *%ToggleRunHotkey%,ToggleAutoRun, ON
    GuiControl,Disable,ToggleRunHotkey
    GuiControl,Disable,AutoRunUseShiftButtonVar
} 
else
{
    Hotkey, %ToggleRunHotkey%,ToggleAutoRun, OFF
    Hotkey, *%ToggleRunHotkey%,ToggleAutoRun, OFF
    GuiControl,Enable,ToggleRunHotkey
    GuiControl,Enable,AutoRunUseShiftButtonVar
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
T_MouseHoldCheckboxState := CheckboxToggle("MouseHoldCheckbox")
if (T_MouseHoldCheckboxState)
{
    Hotkey, %MouseHoldHotkey%,MouseHoldAction, ON
    GuiControl,1:Disable,MouseHoldHotkey
    GuiControl,1:Disable,MouseHoldList
}
else
{
    Hotkey, %MouseHoldHotkey%,MouseHoldAction, Off
    GuiControl,1:Enable,MouseHoldHotkey
    GuiControl,1:Enable,MouseHoldList
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
T_MouseClickerCheckboxState := CheckboxToggle("MouseClickerCheckbox")
if (T_MouseClickerCheckboxState)
{
    Hotkey, %MouseClickerHotkey%,MouseClickerAction, ON
    GuiControl,1:Disable,MouseClickerList
    GuiControl,1:Disable,MouseClickerHotkey
    GuiControl,1:Disable,MouseClickerDelay
}
else
{
    Hotkey, %MouseClickerHotkey%,MouseClickerAction, Off
    GuiControl,1:Enable,MouseClickerList
    GuiControl,1:Enable,MouseClickerHotkey
    GuiControl,1:Enable,MouseClickerDelay
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
;SaveHotkey(MouseClickerDelay, "MouseClickerDelay")
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
    GuiControl,1:Disable,RebindWindowsButton
}
else
{
    Hotkey, LWin, WindowsButtonRebinded, Off
    GuiControl,1:Enable,RebindWindowsButton
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
    GuiControl,1:Disable,RebindCapsLockButton
}
else
{
    Hotkey, CapsLock, CapsLockButtonRebinded, Off
    GuiControl,1:Enable,RebindCapsLockButton
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
;//////////////[SaveAlwaysOnTopHotkey]///////////////
SaveAlwaysOnTopHotkey:
SaveHotkey(AlwaysOnTopHotkey, "AlwaysOnTopHotkey")
return
AlwaysOnTopHotkeyPress:
    Winset, Alwaysontop, , A
return
EnableAlwaysOnTop:
T_GetCheckboxStateAlwaysOnTop := CheckboxToggle("AlwaysOnTopCheckbox")
if (T_GetCheckboxStateAlwaysOnTop)
{
    Hotkey, %AlwaysOnTopHotkey%,AlwaysOnTopHotkeyPress, ON
    GuiControl,1:Disable,AlwaysOnTopHotkey
    ;Disable duplicate
    GuiControl,1:Disable,AlwaysOnTopHotkey_Menu
    GuiControl,1:Disable,AlwaysOnTopHotkey_MenuButton
} 
else
{
    Hotkey, %AlwaysOnTopHotkey%,AlwaysOnTopHotkeyPress, OFF
    GuiControl,1:Enable,AlwaysOnTopHotkey
    ;Enable duplicate
    GuiControl,1:Enable,AlwaysOnTopHotkey_Menu
    GuiControl,1:Enable,AlwaysOnTopHotkey_MenuButton
}
return
SaveAlwaysOnTopHotkey_Menu:
SaveHotkey(AlwaysOnTopHotkey_Menu, "AlwaysOnTopHotkey_Menu")
return
AlwaysOnTopHotkey_Menu:
T_GetCheckboxStateAlwaysOnTop_Menu := CheckboxToggle("AlwaysOnTopHotkey_MenuButton")
if (T_GetCheckboxStateAlwaysOnTop_Menu)
{
    Hotkey, %AlwaysOnTopHotkey_Menu%,AlwaysOnTopHotkeyPress, ON
    GuiControl,1:Disable,AlwaysOnTopHotkey_Menu
    ;Disable duplicate
    GuiControl,1:Disable,AlwaysOnTopHotkey
    GuiControl,1:Disable,AlwaysOnTopCheckbox
} 
else
{
    Hotkey, %AlwaysOnTopHotkey_Menu%,AlwaysOnTopHotkeyPress, OFF
    GuiControl,1:Enable,AlwaysOnTopHotkey_Menu
    ;Enable duplicate
    GuiControl,1:Enable,AlwaysOnTopHotkey
    GuiControl,1:Enable,AlwaysOnTopCheckbox
}
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Functions]///////////////
UpdateTrayicon()
{
        Menu,Tray,Click,1
        Menu,Tray,DeleteAll
        Menu,Tray,NoStandard
        Menu,Tray,Add,Show GUI,OpenMainGui
        Menu,Tray,Add
        Menu,Tray,Add,Open Appdata Folder,OpenAppdataFolder
        Menu,Tray,Add,Run IpConfig,RunIpConfig
        Menu,Tray,Add,Open Sounds,OpenSounds
        Menu,Tray,Add
        Menu,Tray,Add,E&xit,EXIT
        Menu,Tray,Default,Show GUI
        Menu,Tray,Tip, Game Script Ahk
}
SaveHotkey(tHotkey, tKey)
{
    Gui, 1:Submit, Nohide
    IniWrite, %tHotkey%, %AppHotkeysIni%, GameMode, %tKey%
}
UpdateSettingsFromRegistery()
{
    ;Xbox overlay
    regRead,T_XboxOverlayConfig,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR,AppCaptureEnabled
    if(T_XboxOverlayConfig == 1)
    {
        GuiControl,1:,XboxOverlayCheckbox,1
        GuiControl,1:,XboxOverlayCheckbox1,1
    }
    else
    {
        GuiControl,1:,XboxOverlayCheckbox,0
        GuiControl,1:,XboxOverlayCheckbox1,0
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
        GuiControl,1:,ToggleGameDVRCheckbox1,1
    }
    else
    {
        GuiControl,1:,ToggleGameDVRCheckbox,0
        GuiControl,1:,ToggleGameDVRCheckbox1,0
    }
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
        GuiControl,1:Hide ,PinGHUBToolIMG
        PinAppOrAction(tName)
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
        GuiControl,1:Hide ,PinNgrokToolIMG
        PinAppOrAction(tName)
    }
    if(tName == "SatisfactorySaveManager")
    {
        FileDelete, %SatisfactorySaveManagerLocation%
        if ErrorLevel
        {
            MsgBox,, Error, Error while deleting`nSometimes script cannot delete files`nYou can manually delete if necessary
            return
        }
        SatisfactorySaveManagerLocation = %AppOtherScriptsFolder%\SatisfactorySaveManager.ahk
        SatisfactorySaveManager := False
        GuiControl,1:, DownloadSatisfactorySaveManagerButton, Download
        GuiControl,1:Disable ,UninstallSatisfactorySaveManagerButton
        GuiControl,1:Hide ,PinSatisfactorySaveManagerIMG
        PinAppOrAction(tName)
    }
}
;Example SetDefaultEndpoint(GetDeviceID(Devices, "Speakers"))
;This code found in
;https://www.autohotkey.com/boards/viewtopic.php?t=49980
SetDefaultEndpoint(DeviceID)
{
    IPolicyConfig := ComObjCreate("{870af99c-171d-4f9e-af0d-e63df40c2bc9}", "{F8679F50-850A-41CF-9C72-430F290290C8}")
    DllCall(NumGet(NumGet(IPolicyConfig+0)+13*A_PtrSize), "UPtr", IPolicyConfig, "UPtr", &DeviceID, "UInt", 0, "UInt")
    ObjRelease(IPolicyConfig)
}
GetDeviceID(Devices, Name)
{
    For DeviceName, DeviceID in Devices
        If (InStr(DeviceName, Name))
            Return DeviceID
}
DownloadAssets()
{
    Progress, b w300, Script will run after all the Assets have been downloaded, Downloading Assets..., Downloading Assets...
    T_GUIPicProgress = 0
    T_GuiPicAddAmount = 17
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    ;SplashTextOn, 300,60,Downloading Gui Pictures, Script will run after all Gui pictures has been downloaded
    FileCreateDir,%GuiPictureFolder%
    sleep 100
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/GameScripts.ico , %GuiPictureFolder%/GameScripts.ico ;icon
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/Gui/pintext.png , %GuiPictureFolder%/pintext.png ;PinText
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/Gui/pin.png , %GuiPictureFolder%/pin.png ;PinText
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/Gui/removepin.png , %GuiPictureFolder%/removepin.png ;PinText
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/Gui/on.png , %GuiPictureFolder%/on.png ;on button
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/Experimental/Gui/off.png , %GuiPictureFolder%/off.png ;off button
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%

    Progress, Off
    ;SplashTextOff
}
PinAppOrAction(AppOrAction)
{
    IniRead, T_IsPinned,%AppSettingsIni%,Pinned,% AppOrAction . "IsPinned"
    if(T_IsPinned == "ERROR")
    {
        T_IsPinned := false
    }
    if(T_IsPinned == "true")
    {
        GuiControl,1:,% "Pin" . AppOrAction . "IMG",%GuiPictureFolder%\pin.png
        IniRead, T_PinSlotNum,%AppSettingsIni%,Pinned,%AppOrAction%
        if(T_PinSlotNum == "ERROR")
        {
            return
        }
        RemovePinSlot(T_PinSlotNum,AppOrAction)
    }
    else
    {
        GuiControl,1:,% "Pin" . AppOrAction . "IMG",%GuiPictureFolder%\removepin.png
        T_PinSlotNum := GetPinSlot()
        if(T_PinSlotNum == "-1")
        {
            MsgBox, All slots are full
        }
        SavePinToSlot(T_PinSlotNum,AppOrAction)
    }
}
GetPinSlot()
{
    UpdateAllPinSlots()
    ;Get next free spot
    loop, 5
    {
        if(PinSlot[A_Index] == false)
        {
            return A_Index
        }
    }
    return -1
}
UpdateAllPinSlots()
{
    ;Get all Spots
    loop, 5
    {
        IniRead, T_ReadPin,%AppSettingsIni%,Pinned, % "PinSlot" . A_Index
        if(T_ReadPin == "" or T_ReadPin == "false" or T_ReadPin == "ERROR")
        {
            PinSlot[A_Index] := false
        }
        else
        {
            PinSlot[A_Index] := true
        }
    }
}
SavePinToSlot(Slot, Name)
{
    IniWrite, true,%AppSettingsIni%,Pinned, % "PinSlot" . Slot
    IniWrite, %Name%,%AppSettingsIni%,Pinned, % "PinSlot" . Slot . "Name"
    IniWrite, %Slot%,%AppSettingsIni%,Pinned,%Name%
    IniWrite, true,%AppSettingsIni%,Pinned, % Name . "IsPinned"
    UpdateHomeScreen()
}
RemovePinSlot(Slot, Name)
{
    IniWrite, false,%AppSettingsIni%,Pinned, % "PinSlot" . Slot
    IniDelete,%AppSettingsIni%,Pinned, % "PinSlot" . Slot . "Name"
    IniDelete,%AppSettingsIni%,Pinned,%Name%
    IniWrite, false,%AppSettingsIni%,Pinned, % Name . "IsPinned"
    UpdateAllPinSlots()
    ;Reorder slots
    loop, 4
    {
        if(Slot == A_Index)
        {
            if(PinSlot[A_Index + 1] == true)
            {
                IniRead, T_Name,%AppSettingsIni%,Pinned, % "PinSlot" . A_Index + 1 . "Name"
                RemovePinSlot(A_Index + 1, T_Name)
                SavePinToSlot(A_Index, T_Name)
            }
        }
    }
    UpdateHomeScreen()
}
UpdateHomeScreen()
{
    UpdateAllPinSlots()
    ;Reset all first
    GuiControl,1:Show,pintextIMG
    loop, 5
    {
        GuiControl,1:Hide,% "Pin" . A_Index . "GroubBox"
        GuiControl,1:,% "Pin" . A_Index . "GroubBox",% "Pin" . A_Index
        GuiControl,1:Hide,% "Pin" . A_Index . "RunButton"
    }
    ;Hide picture if something is pinned
    if(PinSlot[1] == true)
    {
        GuiControl,1:Hide,pintextIMG
    }
    ;Handle pinned apps
    loop, 5
    {
        if(PinSlot[A_Index] == true)
        {
            IniRead,T_Name,%AppSettingsIni%,Pinned, % "PinSlot" . A_Index . "Name"
            GuiControl,1:show,% "Pin" . A_Index . "GroubBox"
            GuiControl,1:,% "Pin" . A_Index . "GroubBox",%T_Name%
            GuiControl,1:show,% "Pin" . A_Index . "RunButton"
        }
    }
}
RunPinnedApp(Slot)
{
    IniRead,T_Name,%AppSettingsIni%,Pinned, % "PinSlot" . Slot . "Name"
    GoSub, % "Download" . T_Name
}
CheckboxToggle(T_Image)
{
    T_state := false
    iniread, T_ImageState,%AppSettingsIni%,CustomCheckbox,%T_Image%
    if(T_ImageState == "" or T_ImageState == "ERROR")
    {
        T_state := true
        ;Save state
        IniWrite, true,%AppSettingsIni%,CustomCheckbox,%T_Image%
    }
    else if(T_ImageState == "false")
    {
        T_state := true
        IniWrite, true,%AppSettingsIni%,CustomCheckbox,%T_Image%
    }
    else
    {
        T_state := false
        IniWrite, false,%AppSettingsIni%,CustomCheckbox,%T_Image%
    }
    if(T_state)
    {
        GuiControl,1:,% T_Image,%GuiPictureFolder%/on.png
        return true
    }
    else
    {
        GuiControl,1:,% T_Image,%GuiPictureFolder%/off.png
        return false
    }
}
UpdateAllCustomCheckboxes()
{
    IniDelete,%AppSettingsIni%,CustomCheckbox
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