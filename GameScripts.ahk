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
AppUpdaterFile = %AppFolder%\Updater.ahk
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
;//////////////[Tabs]///////////////
HomeTAB := true
SettingsTAB := true
OtherScriptsTAB := true
WindowsTAB := true
BasicScriptsTAB := true
VoicemeeterTAB := true
DiscordMusicBotTAB := true
;____________________________________________________________
;//////////////[Version]///////////////
version = 0.3967
;//////////////[Experimental and Pre Release]///////////////
IsThisExperimental := false
IsThisPreRelease := false
TestingGround := true
PreVersion = 0.397Pre2
CurrentScriptBranch = Main
;//////////////[Action variables]///////////////
AutoRunToggle = 0
AutoRunUseShift = 1
WindowsButtonRebindEnabled = 0
CapsLockButtonRebindEnabled = 0
MouseHoldToggle = 0
MouseClickerToggle = 0
IsOffline := false
;//////////////[Other Scripts]///////////////
OSName := [10]
OSID := [10]
OSDownloadLink := [10]
OSGithub := [10]
;____________________________________________________________
;//////////////[variables]///////////////
CloseToTray := false
PinSlotsCount := 8
PinSlot := [%PinSlotsCount%]
PinnedGroupYCoordSpace := 55 ;84
ShowChangelog := false
;//////////////[Gui Pictures]///////////////
PinPic = %GuiPictureFolder%\pin.png
RemovePinPic = %GuiPictureFolder%\removepin.png
;____________________________________________________________
;//////////////[Global variables]///////////////
global version
global ScriptName
global AppFolderName
global AppFolder
global AppSettingsFolder
global AppSettingsIni
global AppHotkeysIni
global AppVersionIdListIni
global AppPreVersionsIni
global AppOtherScriptsIni
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
global MinecraftServerManager
global MinecraftServerManagerLocation
global PinSlot
global HomeTAB
global SettingsTAB
global OtherScriptsTAB
global windowsTAB
global BasicScriptsTAB
global VoicemeeterTAB
global OSName
global OSID
global OSDownloadLink
global OSGithub
global IsOffline
global CurrentScriptBranch
global AppUpdaterFile
global AppUpdaterSettingsFile
global PinnedGroupYCoordSpace
global PinSlotsCount
;//////////////[Set Current Branch]///////////////
if(!TestingGround)
{
    IniRead, CurrentBranch,%AppSettingsIni%,Branch,Instance1
    if(CurrentBranch == "Experimental")
    {
        IsThisExperimental := true
        IsThisPreRelease := false
        CurrentScriptBranch = Experimental
    }
    else if(CurrentBranch == "PreRelease")
    {
        IsThisExperimental := false
        IsThisPreRelease := true
        CurrentScriptBranch = PreRelease
    }
}
else
{
    IsThisExperimental := true
    IsThisPreRelease := false
    CurrentScriptBranch = Experimental
}
;____________________________________________________________
;//////////////[Tab Control]///////////////
IniRead, T_HomeTab, %AppSettingsIni%,Tabs,Home
IniRead, T_SettingsTab, %AppSettingsIni%,Tabs,Settings
IniRead, T_OtherScriptsTab, %AppSettingsIni%,Tabs,OtherScripts
IniRead, T_WindowsTab, %AppSettingsIni%,Tabs,Windows
IniRead, T_BasicScriptsTab, %AppSettingsIni%,Tabs,BasicScripts
IniRead, T_VoicemeeterTab, %AppSettingsIni%,Tabs,Voicemeeter
IniRead, T_DiscordMusicBotTab, %AppSettingsIni%,Tabs,DiscordMusicBot
if(T_HomeTab == "0")
    HomeTAB := false
if(T_SettingsTab == "0")
    SettingsTAB := false
if(T_OtherScriptsTab == "0")
    OtherScriptsTAB := false
if(T_WindowsTab == "0")
    WindowsTAB := false
if(T_BasicScriptsTab == "0")
    BasicScriptsTAB := false
if(!IsThisExperimental)
    T_VoicemeeterTab := 0
if(T_VoicemeeterTab == "0")
    VoicemeeterTAB := false
if(!IsThisExperimental)
    T_DiscordMusicBotTab := 0
if(T_DiscordMusicBotTab == "0")
    DiscordMusicBotTAB := false
;____________________________________________________________
UpdateTrayicon()
;____________________________________________________________
;//////////////[GUI]///////////////
;//////////////[Startup checks]///////////////
if(FileExist(AppUpdateFile))
{
    ;Show Changelog
    FileDelete, %AppUpdateFile% ;delete old file after update
    FileRemoveDir, %AppFolder%\temp ;Delete temp directory
    ShowChangelog := true
}
if(!FileExist(GuiPictureFolder))
{
    DownloadAssets()
}
CheckAssets()
T_GameScriptIcon = %GuiPictureFolder%\GameScripts.ico
if(FileExist(T_GameScriptIcon))
{
    Menu Tray, Icon, %GuiPictureFolder%\GameScripts.ico,1
}
else
{
    MsgBox,,Asset download error,Assets needs to be Redownloaded `n You can re download assets from settings tab
}
Gui 1:Font, s9, Segoe UI
TabHandle = 
if(HomeTAB)
    TabHandle = % TabHandle . "|" . "Home"
if(SettingsTAB)
    TabHandle = % TabHandle . "|" . "Settings"
if(OtherScriptsTAB)
    TabHandle = % TabHandle . "|" . "Other Scripts"
if(WindowsTAB)
    TabHandle = % TabHandle . "|" . "Windows"
if(BasicScriptsTAB)
    TabHandle = % TabHandle . "|" . "Basic Scripts"
if(VoicemeeterTAB)
    TabHandle = % TabHandle . "|" . "Voicemeeter[Alpha]"
if(DiscordMusicBotTAB)
    TabHandle = % TabHandle . "|" . "Discord Music[Pre Alpha]"
StringTrimLeft, TabHandle, TabHandle, 1
Gui 1:Add, Tab3, x0 y0 w898 h640, %TabHandle% ;Home|Settings|Other Scripts|Windows|Basic Scripts
;____________________________________________________________
;____________________________________________________________
;//////////////[Home]///////////////
if(HomeTAB)
{
Gui 1:Tab, Home
Gui 1:Add, GroupBox, x432 y32 w386 h126, Quick actions
Gui 1:Add, CheckBox, x440 y56 w120 h23 gToggleXboxOverlay1 vXboxOverlayCheckbox1, Xbox Overlay
Gui 1:Add, CheckBox, x440 y80 w120 h23 gToggleGameDVR1 vToggleGameDVRCheckbox1, Game DVR
Gui 1:Add, Button, x440 y112 w164 h28 gClearWindowsTempFolder, Clear Windows Temp Folder
Gui 1:Add, Button, x568 y56 w80 h23 gRunIpConfig, IPConfig
Gui 1:Add, Button, x568 y80 w80 h23 gOpenAppdataFolder, Appdata
if(VoicemeeterTAB)
    Gui 1:Add, Button, x656 y56 w149 h48 gSetVoicemeeterAsDefaultAudioDevice, Set Voicemeeter as default audio device
Gui 1:Add, Button, x608 y112 w80 h23 gOpenSounds, Open Sounds
Gui 1:Add, Picture, x48 y112 w349 h294 vpintextIMG, %GuiPictureFolder%/pintext.png
Gui 1:Font, s10
PinnedGroupYLocation := 40
loop %PinSlotsCount%
{
    Gui 1:Add, GroupBox, x10 y%PinnedGroupYLocation%  w165 h55 +Hidden vPin%A_Index%GroubBox, Pin%A_Index%    
    PinnedGroupYLocation += PinnedGroupYCoordSpace
}
;Gui 1:Add, GroupBox, x10 y40  w165 h55 +Hidden vPin1GroubBox, Pin1
;Gui 1:Add, GroupBox, x10 y124 w165 h55 +Hidden vPin2GroubBox, Pin2
;Gui 1:Add, GroupBox, x10 y208 w165 h55 +Hidden vPin3GroubBox, Pin3
;Gui 1:Add, GroupBox, x10 y292 w165 h55 +Hidden vPin4GroubBox, Pin4
;Gui 1:Add, GroupBox, x10 y376 w165 h55 +Hidden vPin5GroubBox, Pin5
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
}
;____________________________________________________________
;____________________________________________________________
;//////////////[Settings]///////////////
if(SettingsTAB)
{
Gui 1:Tab, Settings
Gui 1:Add, GroupBox, x8 y32 w175 h88, Admin
Gui 1:Add, Button, x16 y56 w152 h23 gRunAsThisAdmin vRunAsThisAdminButton, Run This Script as admin
Gui 1:Add, CheckBox, x16 y88 w152 h23 gRunAsThisAdminCheckboxButton vRunAsThisAdminCheckbox, Run as admin on script start
Gui 1:Add, GroupBox, x8 y122 w175 h160, Settings for this script.
Gui 1:Add, CheckBox, x16 y144 w143 h23 gKeepThisAlwaysOnTop, Keep this always on top
Gui 1:Add, CheckBox, x16 y168 w140 h23 gOnExitCloseToTray vOnExitCloseToTrayCheckbox, On Exit close to tray
Gui 1:Add, Button, x16 y192 w133 h28 gRedownloadAssets, Redownload assets
Gui 1:Add, Button, x16 y224 w133 h23 gShowChangelogButton, Show Changelog
Gui 1:Add, Button, x16 y252 w133 h23 gCustomizeTabs, Customize Tabs
Gui 1:Add, GroupBox, x499 y442 w150 h67,Download Manager
Gui 1:Add, Button, x504 y464 w138 h36 gShowDownloadManager vShowDownloadManager, Download Manager
Gui 1:Font
Gui 1:Add, GroupBox, x648 y392 w179 h117, Updates
Gui 1:Font, s15
if(!IsThisPreRelease)
{
    Gui 1:Add, Text, x664 y472 w158 h28 +0x200, Version = %version%
}
else
{  
    Gui 1:Font, s13
    Gui 1:Add, Text, x664 y472 w158 h28 +0x200, Version = %PreVersion%
}
Gui 1:Font
Gui 1:Add, CheckBox, x656 y416 w169 h23 vCheckUpdatesOnStartup gAutoUpdates, Check for updates on startup
Gui 1:Add, Button, x672 y440 w128 h23 gcheckForupdates, Check for updates
Gui 1:Font, s9, Segoe UI
Gui 1:Add, GroupBox, x8 y295 w170 h123, Debug
Gui 1:Add, Button, x16 y312 w110 h23 gOpenScriptFolder, Open Script Folder
Gui 1:Add, Button, x16 y336 w100 h23 gOpenThisInGithub, Open in github
Gui 1:Add, Button, x16 y360 w139 h27 gOpenAppSettingsFolder, Open Settings Folder
Gui 1:Add, Button, x16 y392 w116 h23 gOpenAppSettingsFile, Open settings File
Gui 1:Add, GroupBox, x8 y419 w170 h80, Delete Stuff
Gui 1:Add, Button, x16 y440 w103 h23 gDeleteAppSettings, Delete all settings
Gui 1:Add, Button, x16 y464 w103 h23 gDeleteAllFiles, Uninstall
Gui 1:Add, GroupBox, x182 y31 w120 h63, Shortcut
Gui 1:Add, Button, x192 y48 w95 h35 gShortcut_to_desktop, Shortcut to Desktop
Gui 1:Add, GroupBox, x182 y364 w318 h155, Exe Runner
Gui 1:Add, Button, x350 y480 w142 h32 vDownloadEXERunnerButton gDownloadEXERunner, Download EXE Runner
Gui 1:Add, Text, x190 y385 w306 h90, EXE Runner is a simple Run script compiled to exe.`n(Moves this main script to Appdata and replaces this with an exe file[You can always revert back])`nNew Features with exe Runner:`n+ You can pin this to taskbar`n+ Cool App Icon
Gui 1:Font, s14
Gui 1:Add, Button, x624 y32 w206 h35 gReportAnIssueOrBug, Report an issue or bug
if(IsThisExperimental)
{
    T_Experimentalchanges=
    (
    Current Experimental changes:
    + Uninstaller rewrite
    + Updated pinned apps
    )
    Gui 1:Font, s11
    Gui 1:Add, Text, x509 y70 w314 h321, %T_Experimentalchanges%
}
Gui 1:Font
}
;____________________________________________________________
;____________________________________________________________
;//////////////[Other Sctipts]///////////////
if(OtherScriptsTAB)
{
OtherScriptsNames = 
(
LogitechBackupTool
NgrokPortForwardingTool
SatisfactorySaveManager
MinecraftSimpleServerManager
)
OSName[1] := "Logitech Backup Tool"
OSID[1] := "LogitechBackupTool"
OSDownloadLink[1] := "https://raw.githubusercontent.com/veskeli/LogitechBackupProfilesAhk/master/LogitechBackupProfiles.ahk"
OSGithub[1] := "https://github.com/veskeli/LogitechBackupProfilesAhk"
OSName[2] := "Ngrok port Forwarding Tool"
OSID[2] := "NgrokPortForwardingTool"
OSDownloadLink[2] := "https://raw.githubusercontent.com/veskeli/NgrokAhk/master/Ngrok.ahk"
OSGithub[2] := "https://github.com/veskeli/NgrokAhk"
OSName[3] := "Satisfactory Save Manager"
OSID[3] := "SatisfactorySaveManager"
OSDownloadLink[3] := "https://raw.githubusercontent.com/veskeli/SatisfactorySaveManager/main/SatisfactorySaveManager.ahk"
OSGithub[3] := "https://github.com/veskeli/SatisfactorySaveManager"
OSName[4] := "Minecraft Simple Server Manager[Early Access]"
OSID[4] := "MinecraftSimpleServerManager"
OSDownloadLink[4] := "https://raw.githubusercontent.com/veskeli/SimpleMinecraftServerManager/main/SimpleMinecraftServerManager.ahk"
OSGithub[4] := "https://github.com/veskeli/SimpleMinecraftServerManager"
Gosub, BuildOtherScripts
}
;____________________________________________________________
;____________________________________________________________
;//////////////[Windows]///////////////
if(WindowsTAB)
{
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
}
;____________________________________________________________
;____________________________________________________________
;//////////////[Voicemeeter]///////////////
if(VoicemeeterTAB)
{
Gui 1:Tab, Voicemeeter
Gui 1:Add, Button, x656 y56 w149 h48 gSetVoicemeeterAsDefaultAudioDevice, Set Voicemeeter as default audio device
}
;____________________________________________________________
;____________________________________________________________
;//////////////[Discord music bot]///////////////
if(DiscordMusicBotTAB)
{
Gui 1:Tab, Discord Music
Gui 1:Font, s14
Gui 1:Add, Text, x8 y24 w162 h23 +0x200, Not working yet ;Discord music Bot
Gui 1:Font
Gui 1:Add, Button, x232 y28 w80 h23 +Disabled, Play all    
Gui 1:Add, Button, x320 y28 w80 h23 +Disabled, Stop    
Gui 1:Add, DropDownList, x472 y28 w120 +Disabled, Chip||
Gui 1:Font, s12
Gui 1:Add, Text, x435 y28 w36 h23 +0x200, Bot:
Gui 1:Add, Text, x624 y28 w53 h23 +0x200, Prefix:
Gui 1:Font, s9, Segoe UI
Gui 1:Add, ComboBox, x680 y28 w120 +Disabled, ch!||
Gui 1:Add, Text, x0 y56 w837 h2 +0x10

DLYO = 64 ;Discord link Y Offset
DLYOAdd = 30 ;Discord link Y offset add
DLHMR = 15 ;Discord link How Many Rows 
Loop %DLHMR%
{
    Gui 1:Add, Text, x8 y%DLYO% w32 h23 +0x200, Link:
    Gui 1:Add, Edit, x40 y%DLYO% w480 h21   
    Gui 1:Add, Button, x528 y%DLYO% w80 h23 +Disabled, Add to queue
    DLYO += DLYOAdd
}
DLYO = 64 ;Discord link Y Offset
Loop %DLHMR%
{
    Gui 1:Add, Radio, x616 y%DLYO% w42 h23 v%A_Index%LinkRadio, %A_Index%.
    DLYO += DLYOAdd
}
GuiControl, 1:, 1LinkRadio,1 ;Check first radio button
}
;____________________________________________________________
;____________________________________________________________
;//////////////[Basic scripts]///////////////
if(BasicScriptsTAB)
{
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
}
;____________________________________________________________
;//////////////[Startup stuff]///////////////
if(A_IsAdmin)
{
    GuiControl,1:,RunAsThisAdminButton,Already running as admin
    GuiControl,1:Disable,RunAsThisAdminButton
}
if(FileExist(AppHotkeysIni))
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
if(FileExist(AppSettingsIni))
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
    UpdateHomeScreen()
    UpdateAllCustomCheckboxes()
}
;Use correct appdata if Admin
if(A_IsAdmin)
{
    IniRead, UseCorrectFolder,%AppSettingsIni%,Appdata,UseCorrectFolder
    if(UseCorrectFolder == "true")
    {
        IniRead, CorrectAppdataFolder,%AppSettingsIni%,Appdata,Correct
        AppFolder = %CorrectAppdataFolder%\%AppFolderName%
    }
}
;Read From registery
UpdateSettingsFromRegistery()
;____________________________________________________________
;//////////////[Audio Switching code]///////////////
if(VoicemeeterTAB)
{
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

;____________________________________________________________
;//////////////[Intro]///////////////
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
;____________________________________________________________
;Last thing is to show changelog
if(ShowChangelog)
{
    UrlDownloadToFile,% "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Changelog/" . version,%AppFolder%/Changelog.txt
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
;____________________________________________________________
;//////////////[Check for updates]///////////////
;Is check for updates enabled
IniRead, Temp_CheckUpdatesOnStartup, %AppSettingsIni%, Updates, CheckOnStartup
if(Temp_CheckUpdatesOnStartup != "ERROR")
    GuiControl,1:,CheckUpdatesOnStartup,%Temp_CheckUpdatesOnStartup%
if(Temp_CheckUpdatesOnStartup == 1)
{
    if(!FileExist(AppUpdaterFile))
    {
        ;Updater File Missing!!
    }
    else
    {
        IniWrite, %version%,%AppUpdaterSettingsFile%,Options,Version
        IniWrite, %A_ScriptFullPath%,%AppUpdaterSettingsFile%,Options,ScriptFullPath
        IniWrite, %CurrentScriptBranch%,%AppUpdaterSettingsFile%,Options,Branch

        run, %AppUpdaterFile%
    }
}
return ;//////////////[GUI LAST RETURN]///////////////
;____________________________________________________________
;//////////////[Changelog]///////////////
ShowChangelogButton:
UrlDownloadToFile,% "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Changelog/" . version,%AppFolder%/Changelog.txt
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
ToggleXboxOverlay1: ; Home screen
Gui, 1:Submit, Nohide
GuiControl,1:,XboxOverlayCheckbox,%XboxOverlayCheckbox1%
goto ToggleXboxOverlay
return
ToggleXboxOverlay2: ;tray
Gui, 1:Submit, Nohide
if(XboxOverlayCheckbox == 1)
{
    GuiControl,1:,XboxOverlayCheckbox,0
}
else
{
    GuiControl,1:,XboxOverlayCheckbox,1
}
goto ToggleXboxOverlay
return
ToggleXboxOverlay:
Gui, 1:Submit, Nohide
GuiControl,1:,XboxOverlayCheckbox1,%XboxOverlayCheckbox%
if(XboxOverlayCheckbox)
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR,AppCaptureEnabled,1
    Menu,QuickActions,Check,Xbox Overlay
}
else
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR,AppCaptureEnabled,0
    Menu,QuickActions,UnCheck,Xbox Overlay
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
ToggleGameDVR2:
Gui, 1:Submit, Nohide
if(ToggleGameDVRCheckbox == 1)
{
    GuiControl,1:,ToggleGameDVRCheckbox,0
}
else
{
    GuiControl,1:,ToggleGameDVRCheckbox,1
}
Goto ToggleGameDVR
return
ToggleGameDVR:
Gui, 1:Submit, Nohide
GuiControl,1:,ToggleGameDVRCheckbox1,%ToggleGameDVRCheckbox%
if(ToggleGameDVRCheckbox)
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled,1
    Menu,QuickActions,Check,Game DVR
}
else
{
    regWrite,REG_DWORD,HKEY_CURRENT_USER\System\GameConfigStore,GameDVR_Enabled,0
    Menu,QuickActions,UnCheck,Game DVR
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
ReportAnIssueOrBug:
run, https://github.com/veskeli/GameScriptsByVeskeli/issues
return
OpenThisInGithub:
run, https://github.com/veskeli/GameScriptsByVeskeli
return
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
OpenScriptFolder:
run, %A_ScriptDir%
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
        MsgBox, Error while deleting file`nYou need to delete exe file manually`nBut Revert is still successful.
    }
    IniWrite,false,%AppSettingsIni%, ExeRunner, UsingExeRunner
    GuiControl,1:,DownloadEXERunnerButton,Download EXE Runner
    IsEXERunnerEnabled := false
    IniDelete,%AppSettingsIni%, ExeRunner
}
else
{
    T_FileBeforeMoveLocation = %A_ScriptDir%
    ;Download exe runner
    IniWrite,true,%AppSettingsIni%, ExeRunner, UsingExeRunner
    IniWrite,%A_ScriptDir%,%AppSettingsIni%, ExeRunner, OldAhkFileLocation
    FileMove, %A_ScriptFullPath%,%AppFolder%\%ScriptName%.ahk ,1
    GuiControl,1:,DownloadEXERunnerButton,Revert
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/exe/GameScripts.exe, %T_FileBeforeMoveLocation%\GameScripts.exe
    IsEXERunnerEnabled := true
}
Return
;____________________________________________________________
;//////////////[checkForupdates]///////////////
checkForupdates:
if(IsThisExperimental)
{
    T_UserCancel := UpdateScript(true,"Experimental")
}
else if(IsThisPreRelease)
{
    T_UserCancel := UpdateScript(true,"PreRelease")
}
else
{
    T_UserCancel := UpdateScript(true,"main")
}
if(T_UserCancel == "ERROR")
    return
msgbox,,Already Newest version,You are already running the latest version
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
    IniRead, UseCorrectFolder,%AppSettingsIni%,Appdata,UseCorrectFolder
    if(UseCorrectFolder == "true")
    {
        IniRead, CorrectDesktop,%AppSettingsIni%,Appdata,CorrectDesktop
        FileCreateShortcut,% T_RevertLocation . "\" . ScriptName . ".exe", %CorrectDesktop%\%ScriptName%.lnk
    }
    Else
    {
        FileCreateShortcut,% T_RevertLocation . "\" . ScriptName . ".exe", %A_Desktop%\%ScriptName%.lnk
    }
}
else
{
    FileCreateShortcut,"%A_ScriptFullPath%", %A_Desktop%\%ScriptName%.lnk
}
return
;//////////////[Delete files]///////////////
DeleteAllFiles: ;uninstall
if(!A_IsAdmin)
{
    ;NotAdminError()
    ;Return
}
MsgBox, 1,Are you sure?,All files will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    Progress, b w300,  Uninstalling script...,  Uninstalling script..., Uninstalling script...
    IniRead,T_AppInstallLocation,%AppSettingsIni%, install, InstallFolder
    if(T_AppInstallLocation != "Error" && T_AppInstallLocation != "")
    {
        try{
            FileRemoveDir, %T_AppInstallLocation%,1
        }
        catch{
            Progress, Off
            T_adminuninstall = % "Some files needs admin privilages to delete!"
            NotAdminError(T_adminuninstall)
        }
    }
    Progress, 25
    DesktopShortcutLocation = % A_Desktop . "\" . ScriptName . ".lnk"
    if (FileExist(DesktopShortcutLocation))
    {
        try{
            FileDelete, %DesktopShortcutLocation%
        }
        catch{
            Progress, Off
            T_adminuninstall = % "Some files needs admin privilages to delete!"
            NotAdminError(T_adminuninstall)
        }
    }
    Progress, 50
    if(FileExist(AppFolder),"D")
    {
        try{
            FileRemoveDir, %AppFolder% ,1
        }
        catch{
            Progress, Off
            T_adminuninstall = % "Some files needs admin privilages to delete!"
            NotAdminError(T_adminuninstall)
        }
    }
    Progress, 75
    if(FileExist(A_ScriptFullPath))
    {
        try{
            FileDelete, %A_ScriptFullPath%
        }
        catch{
            Progress, Off
            T_adminuninstall = % "Some files needs admin privilages to delete!"
            NotAdminError(T_adminuninstall)
        }
    }
    Progress, 100
}
Progress, Off
ExitApp
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
CustomizeTabs:
Gui 2:Destroy ;Destroy if already existing
Gui 2:Add, GroupBox, x8 y4 w594 h100, Show tabs
Gui 2:Add, CheckBox, +Checked +Disabled x16 y24 w60 h23 vHomeTabC, Home
Gui 2:Add, CheckBox, +Checked +Disabled x80 y24 w67 h23 vSettingsTabC, Settings

Gui 2:Add, CheckBox, x152 y24 w95 h23 vOtherScriptsTabC, Other Scripts
IniRead, OtherScriptsTabOld, %AppSettingsIni%, Tabs, OtherScripts
if (OtherScriptsTabOld = 1)
    GuiControl,2:, OtherScriptsTabC,1

Gui 2:Add, CheckBox, x256 y24 w73 h23 vWindowsTabC, Windows
IniRead, WindowsTabOld, %AppSettingsIni%, Tabs, OtherScripts
if (WindowsTabOld = 1)
    GuiControl,2:, WindowsTabC,1

Gui 2:Add, CheckBox, x336 y24 w88 h23 vBasicScriptsTabC, Basic Scripts
IniRead, BasicScriptsTabOld, %AppSettingsIni%, Tabs, BasicScripts
if (BasicScriptsTabOld = 1)
    GuiControl,2:, BasicScriptsTabC,1

Gui 2:Add, CheckBox, x432 y24 w162 h23 vVoicemeeterTabC, Voicemeeter[Alpha]
IniRead, VoicemeeterTabOld, %AppSettingsIni%, Tabs, Voicemeeter
if (VoicemeeterTabOld = 1 && IsThisExperimental)
    GuiControl,2:, VoicemeeterTabC,1

Gui 2:Add, CheckBox, x16 y44 w160 h23 vDiscordMusicBotTabC, Discord Music Bot[Pre Alpha]
IniRead, DiscordMusicBotTabOld, %AppSettingsIni%, Tabs, DiscordMusicBot
if (DiscordMusicBotTabOld = 1 && IsThisExperimental)
    GuiControl,2:, DiscordMusicBotTabC,1

Gui 2:Add, Button, x432 y64 w80 h23 gHandleTabSave, Save
Gui 2:Add, Button, x520 y64 w80 h23 gCancelCustomize, Cancel
Gui 2:Show, w609 h96, Customize Tabs
if(!IsThisExperimental)
{
    GuiControl, 2:Disable, VoicemeeterTabC
    GuiControl, 2:, VoicemeeterTabC,0
    GuiControl, 2:Disable, DiscordMusicBotTabC
    GuiControl, 2:, DiscordMusicBotTabC,0
}
Return
CancelCustomize:
2GuiClose:
2GuiGuiExit:
    Gui 2:Destroy
Return
HandleTabSave:
Gui, 2:Submit,NoHide
RestartNeeded := false
IniRead, HomeTabOld, %AppSettingsIni%, Tabs, Home
if(HometabOld != HomeTabC)
{
    IniWrite, %HomeTabC%, %AppSettingsIni%,Tabs,Home
    RestartNeeded := true
}
IniRead, SettingsTabOld, %AppSettingsIni%, Tabs, Settings
if(SettingsTabOld != SettingsTabC)
{
    IniWrite, %SettingsTabC%, %AppSettingsIni%,Tabs,Settings
    RestartNeeded := true
}
IniRead, OtherScriptsTabOld, %AppSettingsIni%, Tabs, OtherScripts
if(OtherScriptsTabOld != OtherScriptsTabC)
{
    IniWrite, %OtherScriptsTabC%, %AppSettingsIni%,Tabs,OtherScripts
    RestartNeeded := true
}
IniRead, WindowsTabOld, %AppSettingsIni%, Tabs, Windows
if(WindowsTabOld != WindowsTabC)
{
    IniWrite, %WindowsTabC%, %AppSettingsIni%,Tabs,Windows
    RestartNeeded := true
}
IniRead, BasicScriptsTabOld, %AppSettingsIni%, Tabs, BasicScripts
if(BasicScriptsTabOld != BasicScriptsTabC)
{
    IniWrite, %BasicScriptsTabC%, %AppSettingsIni%,Tabs,BasicScripts
    RestartNeeded := true
}
IniRead, VoicemeeterTabOld, %AppSettingsIni%, Tabs, Voicemeeter
if(VoicemeeterTabOld != VoicemeeterTabC)
{
    IniWrite, %VoicemeeterTabC%, %AppSettingsIni%,Tabs,Voicemeeter
    RestartNeeded := true
}
IniRead, DiscordMusicBotTabOld, %AppSettingsIni%, Tabs, DiscordMusicBot
if(DiscordMusicBotTabOld != DiscordMusicBotTabC)
{
    IniWrite, %DiscordMusicBotTabC%, %AppSettingsIni%,Tabs,DiscordMusicBot
    RestartNeeded := true
}
if(RestartNeeded)
{
    MsgBox, 4,Restart needed,Restart is needed to settings take effect`nRestart now?
    IfMsgBox Yes
    {
        Run, %A_ScriptFullPath%
        ExitApp
    }
    Else
    {
        Gui 2:Destroy
    }
}
Else
{
    Gui 2:Destroy
}
Return
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
    GuiControl,1:Enable,UninstallGHUBToolScriptButton
    GHUBToolLocation = %AppOtherScriptsFolder%\LogitechBackupProfiles.ahk
    GHUBTool := True
    GuiControl,1:Show ,PinGHUBToolIMG
}
Else ;app is already istalled/downloaded
{
    run, %GHUBToolLocation%
}
Return
OpenGHUBToolGithub:
run, https://github.com/veskeli/LogitechBackupProfilesAhk
Return
;ngrok
OpenNgrokInGithub:
    run, https://github.com/veskeli/NgrokAhk
return
DownloadMinecraftServerManager:
if (!MinecraftServerManager)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppOtherScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/SimpleMinecraftServerManager/main/SimpleMinecraftServerManager.ahk, %AppOtherScriptsFolder%\SimpleMinecraftServerManager.ahk
    ;write save/Update Gui
    GuiControl,1:, DowloadMinecraftServerManagerButton, % Chr(0x25B6) . " Open"
    GuiControl,1:Enable,UninstallMinecraftServerManagerButton
    MinecraftServerManagerLocation = %AppOtherScriptsFolder%\SimpleMinecraftServerManager.ahk
    MinecraftServerManager := True
    GuiControl,1:Show ,PinMinecraftServerManagerIMG
}
Else ;app is already istalled/downloaded
{
    run, %MinecraftServerManagerLocation%
}
Return
;Minecraft server manager
OpenMinecraftServerManagerInGithub:
    run, https://github.com/veskeli/SimpleMinecraftServerManager
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
UninstallScriptButton:
StringTrimLeft, AppToUninstall, A_GuiControl, 9
StringTrimRight, AppToUninstall, AppToUninstall, 6
UninstallScript(AppToUninstall)
return
PinAppToHomeScreen:
StringTrimLeft, AppToPin, A_GuiControl, 3
StringTrimRight, AppToPin, AppToPin, 3
PinAppOrAction(AppToPin)
return
PinRunButton:
T_RunButtonIndex := RegExReplace(A_GuiControl, "\D")
RunPinnedApp(T_RunButtonIndex)
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
Gui,Submit,Nohide
if(AlwaysOnTopHotkey == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    return
}
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
if(AlwaysOnTopHotkey_Menu == "")
{
    MsgBox,,Hotkey Empty, Hotkey Is Empty,15
    return
}
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
        Menu,QuickActions,Add,Xbox Overlay,ToggleXboxOverlay2
        Menu,QuickActions,Add,Game DVR,ToggleGameDVR2
        Menu,QuickActions,Add,Clear Windows Temp Folder,ClearWindowsTempFolder
        Menu,Tray,Add, Quick Actions, :QuickActions
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
        Menu,QuickActions,Check,Xbox Overlay
    }
    else
    {
        GuiControl,1:,XboxOverlayCheckbox,0
        GuiControl,1:,XboxOverlayCheckbox1,0
        Menu,QuickActions,UnCheck,Xbox Overlay
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
        Menu,QuickActions,Check,Game DVR
    }
    else
    {
        GuiControl,1:,ToggleGameDVRCheckbox,0
        GuiControl,1:,ToggleGameDVRCheckbox1,0
        Menu,QuickActions,UnCheck,Game DVR
    }
}
UninstallScript(tName)
{
    if(tName == "GHUBToolScript")
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
        GuiControl,1:Disable ,UninstallGHUBToolScriptButton
        GuiControl,1:Hide ,PinGHUBToolIMG
        StringTrimRight, tName, tName, 6
        RemovePinAppOrAction(tName)
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
        RemovePinAppOrAction(tName)
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
        RemovePinAppOrAction(tName)
    }
    if(tName == "MinecraftServerManager")
    {
        FileDelete, %MinecraftServerManagerLocation%
        if ErrorLevel
        {
            MsgBox,, Error, Error while deleting`nSometimes script cannot delete files`nYou can manually delete if necessary
            return
        }
        MinecraftServerManager := False
        GuiControl,1:, DowloadMinecraftServerManagerButton, Download
        GuiControl,1:Disable ,UninstallMinecraftServerManagerButton
        GuiControl,1:Hide ,PinMinecraftServerManagerIMG
        RemovePinAppOrAction(tName)
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
    LinkCount = 7
    T_GuiPicAddAmount := 100/LinkCount
    StartUrl = https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/
    Progress, %T_GUIPicProgress%
    FileCreateDir,%GuiPictureFolder%
    if(!FileExist(GuiPictureFolder . "/GameScripts.ico"))
        UrlDownloadToFile,% StartUrl . CurrentScriptBranch . "/Gui/GameScripts.ico", %GuiPictureFolder%/GameScripts.ico ;icon
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    if(!FileExist(GuiPictureFolder . "/pintext.png"))
        UrlDownloadToFile,% StartUrl . CurrentScriptBranch . "/Gui/pintext.png" , %GuiPictureFolder%/pintext.png ;PinText
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    if(!FileExist(GuiPictureFolder . "/pin.png"))
        UrlDownloadToFile,% StartUrl . CurrentScriptBranch . "/Gui/pin.png" , %GuiPictureFolder%/pin.png ;PinText
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    if(!FileExist(GuiPictureFolder . "/removepin.png"))
        UrlDownloadToFile,% StartUrl . CurrentScriptBranch . "/Gui/removepin.png" , %GuiPictureFolder%/removepin.png ;PinText
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    if(!FileExist(GuiPictureFolder . "/on.png"))
        UrlDownloadToFile,% StartUrl . CurrentScriptBranch . "/Gui/on.png" , %GuiPictureFolder%/on.png ;on button
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    if(!FileExist(GuiPictureFolder . "/off.png"))
        UrlDownloadToFile,% StartUrl . CurrentScriptBranch . "/Gui/off.png" , %GuiPictureFolder%/off.png ;off button
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    ;Updater
    if(!FileExist(AppUpdaterFile))
        UrlDownloadToFile,% StartUrl . CurrentScriptBranch . "/Updater.ahk" , %AppUpdaterFile% ;Updater File
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%

    Progress, Off
}
CheckAssets()
{
    DownloadAssets()
    Return
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
RemovePinAppOrAction(AppOrAction)
{
    IniRead, T_IsPinned,%AppSettingsIni%,Pinned,% AppOrAction . "IsPinned"
    if(T_IsPinned == "ERROR")
    {
        T_IsPinned := false
    }
    GuiControl,1:,% "Pin" . AppOrAction . "IMG",%GuiPictureFolder%\pin.png
    IniRead, T_PinSlotNum,%AppSettingsIni%,Pinned,%AppOrAction%
    if(T_PinSlotNum == "ERROR")
    {
        return
    }
    RemovePinSlot(T_PinSlotNum,AppOrAction)
}
GetPinSlot()
{
    UpdateAllPinSlots()
    ;Get next free spot
    loop, %PinSlotsCount%
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
    loop, %PinSlotsCount%
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
    loop, %PinSlotsCount% - 1
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
    loop, %PinSlotsCount%
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
    PinYStartLocation := 60 ;68
    loop, %PinSlotsCount%
    {
        if(PinSlot[A_Index] == true)
        {
            IniRead,T_Name,%AppSettingsIni%,Pinned, % "PinSlot" . A_Index . "Name"
            GuiControl,1:show,% "Pin" . A_Index . "GroubBox"
            GuiControl,1:,% "Pin" . A_Index . "GroubBox",%T_Name%
            ;GuiControl,1:show,% "Pin" . A_Index . "RunButton"
            GuiControlGet,IsButtonCreated,,% "Pin" . A_Index . "RunButton"
            if(ErrorLevel)
            {
                ;If button not found create one
                DeclareGlobal("Pin" A_Index "RunButton")
                Gui 1:Tab, Home
                Gui 1:Font, s13
                Gui 1:Add, Button, x15 y%PinYStartLocation% w80 h30 gPinRunButton vPin%A_Index%RunButton, % Chr(0x25B6) . " Open"
            }
            Else
            {
                GuiControl,1:show,% "Pin" . A_Index . "RunButton"
            }
            PinYStartLocation += PinnedGroupYCoordSpace
        }
    }
}
RunPinnedApp(Slot)
{
    IniRead,T_Name,%AppSettingsIni%,Pinned, % "PinSlot" . Slot . "Name"
    run, %AppOtherScriptsFolder%\%T_Name%.ahk
}
DeclareGlobal(globalvar) ;For loop global vars 
{
   global
   (%globalvar%)
   return 
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
NotAdminError(T_CustomMessage = "")
{
    if(T_CustomMessage != "")
    {
        if(!A_IsAdmin)
        {
            MsgBox, 1,Needs admin privileges,%T_CustomMessage%`nPress "Ok" to run this script as admin
            IfMsgBox, ok
            {
                Run *RunAs %A_ScriptFullPath%
                ExitApp
            }
        }
    }
    Else
    {
        if(!A_IsAdmin)
        {
            MsgBox, 1,Needs admin privileges,This feature needs admin privileges`nPress "Ok" to run this script as admin
            IfMsgBox, ok
            {
                Run *RunAs %A_ScriptFullPath%
                ExitApp
            }
        }
    }
}
;____________________________________________________________
;//////////////[updater]///////////////
ReadFileFromLink(Link)
{
    if(IsOffline)
        return "ERROR"
    If ConnectedToInternet()
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
    else
    {
        return "ERROR"
    }
}
ConnectedToInternet(flag=0x40) { ;If connected to internet. (Not checking internet connection [only if plugged in/Connected to wifi])
Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0) 
}
CheckUpdatesOnStart:
if(FileExist(AppSettingsIni))
{
    ;Is check for updates enabled
    IniRead, Temp_CheckUpdatesOnStartup, %AppSettingsIni%, Updates, CheckOnStartup
    if(Temp_CheckUpdatesOnStartup != "ERROR")
        GuiControl,1:,CheckUpdatesOnStartup,%Temp_CheckUpdatesOnStartup%
    if(Temp_CheckUpdatesOnStartup == 1)
    {
        if(IsThisExperimental) ;Check for Experimental updates
        {
            UpdateScript(true,"Experimental")
        }
        else if(IsThisPreRelease) ;Check for pre release updates
        {
            UpdateScript(true,"PreRelease")
        }
        else ;Check for updates
        {
            UpdateScript(true,"main")
        }
    }
}
return
GetNewVersion(T_Branch)
{
    if(T_Branch == "main" or T_Branch == "Experimental" or T_Branch == "PreRelease") ;Check that branch is correctly typed
    {
        ;Build link
        VersionLink := % "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_Branch . "/version.txt"
        ;Get Version Text
        T_NewVersion := ReadFileFromLink(VersionLink)
        if(T_NewVersion == "ERROR")
        {
            msgbox,,No Internet Connection!,No Internet Connection!`nSwitched script to offline mode.`nRestart to reset offline mode
            IsOffline := true
            return
        }
        ;Check that not empty or not found
        if(T_NewVersion != "" and T_NewVersion != "404: Not Found" and T_NewVersion != "500: Internal Server Error")
        {
            Return T_NewVersion
        }
        else if (T_NewVersion == "404: Not Found")
        {
            ;MsgBox, 404: Not Found `nBranch is not live yet!
            return "ERROR"
        }
        else
        {
            return "ERROR"
        }
    }
}
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
                MsgBox, 1,Update,%UpdateText%
                IfMsgBox, Yes
                {
                    ForceUpdate(newversion,T_Branch,T_Branch)
                }
                Else
                {
                    return "ERROR"
                }
            }
        }
        else    ;Force update/Download
        {
            ForceUpdate(newversion,T_Branch,T_Branch)
        }
    }
}
ForceUpdate(newversion,T_Id,T_Branch)
{
    ;Save branch
    IniWrite, %T_Branch%,%AppSettingsIni%,Branch,Instance1
    ;Download update
    SplashTextOn, 250,50,Downloading...,Downloading new version.`nVersion: %newversion%
    FileCreateDir, %AppFolder%\temp
    FileMove, %A_ScriptFullPath%, %AppUpdateFile%, 1
    DownloadLink := % "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_Id . "/GameScripts.ahk"
    UrlDownloadToFile, %DownloadLink%, %A_ScriptFullPath%
    SplashTextOff
    loop
    {
        if(FileExist(A_ScriptFullPath))
        {
            Run, %A_ScriptFullPath%
            ExitApp
        }
    }
    ExitApp
}
;____________________________________________________________
;//////////////[ShowDownloadManager]///////////////
ShowDownloadManager:
if(IsOffline)
{
    msgbox,,You are in offline mode!,You are in offline mode!`nRestart to disable offline mode.
    return
}
GuiControl,1:Disable,ShowDownloadManager
GuiControl,1:,ShowDownloadManager,Preparing versions...
Gui 2:Destroy ;Destroy if already existing
Gui 2:Add, Tab3, x0 y0 w516 h234, Instance1||
Gui 2:Tab, 1
DMYOAdd = 32 ;Dowload Manager Y Offsets Add
DMYON = 48 ;Dowload Manager Y Offsets Normal
loop 3
{
    if(A_Index == 1)
    {
        T_DMBranchName := "main"
        T_DMBranchNameCustom := "Main"
    }
    else if(A_Index == 2)
    {
        T_DMBranchName := "PreRelease"
        T_DMBranchNameCustom := "Pre Release"
    }
    else if(A_Index == 3)
    {
        T_DMBranchName := "Experimental"
        T_DMBranchNameCustom := "Experimental"
    }
    Gui 2:Add, Text, x8 y%DMYON% w77 h23 +0x200, %T_DMBranchNameCustom%:
    Gui 2:Add, DropDownList, x88 y%DMYON% w120 vDMDropDown%T_DMBranchName% +Disabled, ||
    Gui 2:Add, Button, x216 y%DMYON% w80 h23 vDMDownload%T_DMBranchName% gDMForceDownload +Disabled, Download
    Gui 2:Add, Button, x304 y%DMYON% w101 h23 vDMLatest%T_DMBranchName%Button gDownloadLatestBranch, Download Latest
    Gui 2:Add, Text, x408 y%DMYON% w120 h23 +0x200 vDMLatest%T_DMBranchName%, Latest:
    DMYON += DMYOAdd
}
Gui 2:Add, GroupBox, x16 y144 w472 h58, Current Script:
Gui 2:Font, s12
Gui 2:Add, Text, x24 y168 w120 h23 +0x200, Version: %Version%
Gui 2:Add, Text, x152 y168 w203 h23 +0x200 vDMBranch, Branch: Main
Gui 2:Add, Text, x376 y168 w94 h23 +0x200, Instance: 1
Gui 2:Font
Gui 2:Add, Button, x0 y24 w80 h20 +Disabled, New Instance
;Check current Branch
if(IsThisExperimental)
{
    GuiControl,2:,DMBranch,Branch: Experimental
    T_IsThisVersion := GetNewVersion("Experimental")
    if(Version == T_IsThisVersion)
    {
        GuiControl,2:,DMLatestExperimentalButton,Currently Installed
        GuiControl,2:Disable,DMLatestExperimentalButton
    }
}
else if(IsThisPreRelease)
{
    GuiControl,2:,DMBranch,Branch: Pre Release
    T_IsThisVersion := GetNewVersion("PreRelease")
    if(Version == T_IsThisVersion)
    {
        GuiControl,2:,DMLatestPreReleaseButton,Currently Installed
        GuiControl,2:Disable,DMLatestPreReleaseButton
    }
}
else
{
    GuiControl,2:,DMBranch,Branch: Main
    T_IsThisVersion := GetNewVersion("main")
    if(Version == T_IsThisVersion)
    {
        GuiControl,2:,DMLatestmainButton,Currently Installed
        GuiControl,2:Disable,DMLatestmainButton
    }
}
;Check latest versions:
loop 3
{
    T_DMBranchName := BranchName(A_Index)
    T_DMLatest := GetNewVersion(T_DMBranchName)
    if(T_DMLatest == "ERROR")
    {
        GuiControl,2:,DMLatest%T_DMBranchName%,Network Error
        GuiControl,2:Disable,DMLatest%T_DMBranchName%Button
    }
    else
    {
        GuiControl,2:,DMLatest%T_DMBranchName%,% "Latest: " . T_DMLatest
    }
}
;Check all versions
loop 3
{
    T_DMDropDownlistText := 
    T_DMBranchName := BranchName(A_Index)
    T_Link := % "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_DMBranchName . "/DownloadManager/" . T_DMBranchName
    AllVersions := ReadFileFromLink(T_Link)
    if(AllVersions == "ERROR")
    {
        Gui 2:Destroy
        msgbox,,No Internet Connection!,No Internet Connection!
        return
    }
    if(AllVersions == "" or AllVersions == "ERROR" or AllVersions == "404: Not Found")
    {
        Continue
    }
    if(A_Index == 2) ;Get pre versions
    {
        FileCreateDir, %AppFolder%\temp
        UrlDownloadToFile,% "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_DMBranchName . "/DownloadManager/PreVersions.ini",%AppPreVersionsIni%
    }
    if(A_Index == 2) ;set pre versions
    {
        Loop, parse, AllVersions, `n, `r
        {
            if(T_DMDropDownlistText == "") ;if empty
            {
                T_PreVersion := 
                IniRead,T_PreVersion,%AppPreVersionsIni%,PreVersions,%A_LoopField%
                if(T_PreVersion == "ERROR")
                {
                    MsgBox,,Pre version Missing1!,Pre version missing for version: %A_LoopField%
                }   
                T_DMDropDownlistText = % A_LoopField . " (" . T_PreVersion . ")|"
            }
            else
            {
                T_PreVersion :=
                IniRead,T_PreVersion,%AppPreVersionsIni%,PreVersions,%A_LoopField%
                if(T_PreVersion == "ERROR")
                {
                    MsgBox,,Pre version Missing2!,Pre version missing for version: %A_LoopField%
                }
                T_DMDropDownlistText = % T_DMDropDownlistText . "|" . A_LoopField . " (" . T_PreVersion . ")"
            }
        }
    }
    else
    {
        Loop, parse, AllVersions, `n, `r
        {
            if(T_DMDropDownlistText == "") ;if empty
            {
                T_DMDropDownlistText = % A_LoopField . "|"
            }
            else
            {
                T_DMDropDownlistText = % T_DMDropDownlistText . "|" . A_LoopField
            }
        }
    }
    GuiControl,2:,DMDropDown%T_DMBranchName%,|
    GuiControl,2:,DMDropDown%T_DMBranchName%,%T_DMDropDownlistText%
    GuiControl,2:Enable,DMDropDown%T_DMBranchName%
    GuiControl,2:Enable,DMDownload%T_DMBranchName%
}
GuiControl,1:Enable,ShowDownloadManager
GuiControl,1:,ShowDownloadManager,Download Manager
Gui 2:Show, w515 h211, Download Manager
return
BranchName(T_Index)
{
    if(T_Index == 1)
    {
        T_DMBranchName := "main"
    }
    else if(T_Index == 2)
    {
        T_DMBranchName := "PreRelease"
    }
    else if(T_Index == 3)
    {
        T_DMBranchName := "Experimental"
    }
    return T_DMBranchName
}
DownloadLatestBranch:
StringTrimLeft, ScriptToDownload, A_GuiControl, 8
StringTrimRight, ScriptToDownload, ScriptToDownload,6
UpdateScript(false,ScriptToDownload)
return
DMForceDownload:
Gui,Submit,NoHide
StringTrimLeft, T_DMBranchName, A_GuiControl, 10
T_DMDropDown2 := DMDropDown%T_DMBranchName%
if(T_DMDropDown2 == version) ;if current
{
    MsgBox,,Current version!,This is %version%!
    return
}
T_LatestVersion2234422 := GetNewVersion(T_DMBranchName)
if(T_DMDropDown2 == T_LatestVersion2234422) ;if latest
{
    UpdateScript(false,T_DMBranchName)
    return
}
FileCreateDir, %AppFolder%\temp
UrlDownloadToFile,% "https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/" . T_DMBranchName . "/DownloadManager/VersionIdList.ini",%AppVersionIdListIni%
if(ErrorLevel)
{
    MsgBox,,Id Missing!,Id missing for version: %T_DMDropDown2%
    return
}
IniRead,T_Id,%AppVersionIdListIni%,%T_DMBranchName%,%T_DMDropDown2%
if(T_Id == "ERROR")
{
    MsgBox,,Id Missing!,Id missing for version: %T_DMDropDown2%
    return
}
ForceUpdate(T_DMDropDown2,T_Id,T_DMBranchName)
return
;____________________________________________________________
;//////////////[OtherScripts]///////////////
GetInstalledOtherScripts(OtherScriptsNames)
{
    Loop, parse, OtherScriptsNames, `n, `r
    {
        IniRead,T_ID,%AppOtherScriptsIni%,%A_LoopField%,ID
        T_OtherScript = %AppOtherScriptsFolder%\%T_ID%.ahk
        if(FileExist(T_OtherScript))
        {
            GuiControl,1:, %T_ID%Download, % Chr(0x25B6) . " Open"
            GuiControl,1:Enable,%T_ID%Delete
            GuiControl,1:Show,Pin%T_ID%IMG
            IniRead,T_PinState,%AppSettingsIni%,Pinned,% T_ID . "IsPinned"
            if(T_PinState == "true")
            {
                GuiControl,1:,% "Pin" . T_ID . "IMG",%GuiPictureFolder%\removepin.png
            }
        }
    }
}
DownloadOtherScript:
StringTrimRight,T_DownloadLinkIndex,A_GuiControl,8
T_DownloadLinkControl := OSID[T_DownloadLinkIndex]
T_OtherScriptFile = %AppOtherScriptsFolder%\%T_DownloadLinkControl%.ahk
if(!FileExist(T_OtherScriptFile))
{
    FileCreateDir, %AppOtherScriptsFolder%
    T_OtherScriptDownloadLink := OSDownloadLink[T_DownloadLinkIndex]
    UrlDownloadToFile, %T_OtherScriptDownloadLink%,%T_OtherScriptFile%
    GuiControl,1:, %A_GuiControl%, % Chr(0x25B6) . " Open"
    GuiControl,1:Enable,%T_DownloadLinkControl%Delete
    GuiControl,1:Show,Pin%T_DownloadLinkControl%IMG
}
else
{
    run, %T_OtherScriptFile%
}
return
OpenOtherScriptGithub:
StringTrimRight,T_GithubControl,A_GuiControl,6
T_GithubLink := OSGithub[T_GithubControl]
run, %T_GithubLink%
return
DeleteOtherScript:
StringTrimRight,T_OTherScriptControl,A_GuiControl,6
T_Otherfolder =  %AppOtherScriptsFolder%\%T_OTherScriptControl%.ahk
if(FileExist(T_Otherfolder))
    FileDelete, T_Otherfolder
GuiControl,1:, %T_OTherScriptControl%Download,Download
GuiControl,1:Disable,%T_OTherScriptControl%Delete
GuiControl,1:Hide,Pin%T_OTherScriptControl%IMG
RemovePinAppOrAction(T_OTherScriptControl)
return
PinOtherScript:
StringTrimRight,T_OTherScriptControl,A_GuiControl, 3
StringTrimLeft, T_OTherScriptControl, T_OTherScriptControl, 3
PinAppOrAction(T_OTherScriptControl)
return
BuildOtherScripts:
; Add 70 to Y
;Logitech backup tool
OSYOffsetB = 56 ;Other Scripts Y Offset Button
OSYOffsetP = 39 ;Other Scripts Y Offset Picture
OSYOffsetG = 27 ;Other Scripts Y Offset GroupBox
OSAddY = 70 ;How far down next goes
OSXOffset = 2
Gui 1:Tab, Other Scripts
Loop, parse, OtherScriptsNames, `n, `r
{
    if(A_Index == 8)
    {
        OSYOffsetB := OSYOffsetB - (OSAddY * 7)
        OSYOffsetP := OSYOffsetP - (OSAddY * 7)
        OSYOffsetG := OSYOffsetG - (OSAddY * 7)
    }
    if(A_Index >= 8)
    {
        OSXOffset = 418
    }
    else
    {
        OSXOffset = 2
    }
    T_OSGroubBoxName := OSName[A_Index]
    T_OSID := OSID[A_Index]
    Gui 1:Font, s13
    Gui 1:Add, GroupBox, x%OSXOffset% y%OSYOffsetG% w412 h69, %T_OSGroubBoxName%
    Gui 1:Font
    OSXOffset += 8
    Gui 1:Font, s9, Segoe UI
    Gui 1:Add, Button, x%OSXOffset% y%OSYOffsetB% w131 h23 gDownloadOtherScript v%A_Index%Download, Download
    OSXOffset += 134
    Gui 1:Add, Button, x%OSXOffset% y%OSYOffsetB% w80 h23 +disabled, Settings
    OSXOffset += 86
    Gui 1:Add, Button, x%OSXOffset% y%OSYOffsetB% w100 h23 gOpenOtherScriptGithub v%A_Index%Github, Open in Github
    OSXOffset += 100
    Gui 1:Add, Button, x%OSXOffset% y%OSYOffsetB% w80 h23  +Disabled gDeleteOtherScript v%T_OSID%Delete, Delete
    OSXOffset += 61
    Gui 1:Add, Picture, x%OSXOffset% y%OSYOffsetP% w18 h18 +Hidden vPin%T_OSID%IMG gPinOtherScript, %PinPic%

    OSYOffsetB += OSAddY
    OSYOffsetP += OSAddY
    OSYOffsetG += OSAddY
}
GetInstalledOtherScripts(OtherScriptsNames)
return