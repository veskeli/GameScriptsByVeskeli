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
version = 0.384
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
;____________________________________________________________
;____________________________________________________________
;//////////////[GUI]///////////////
;//////////////[Startup checks]///////////////
IfExist %AppUpdateFile%
{
    FileDelete, %AppUpdateFile% ;delete old file after update
    FileRemoveDir, %AppFolder%\temp ;Delete temp directory
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
Gui 1:Add, Tab3, x0 y0 w898 h640, Home|Settings|Other Scripts|Windows and Voicemeeter|Basic Scripts
;____________________________________________________________
;____________________________________________________________
;//////////////[Home]///////////////
Gui 1:Tab, 1
Gui 1:Add, GroupBox, x432 y32 w386 h126, Quick actions
Gui 1:Add, CheckBox, x440 y56 w120 h23 gToggleXboxOverlay1 vXboxOverlayCheckbox1, Xbox Overlay
Gui 1:Add, CheckBox, x440 y80 w120 h23 gToggleGameDVR1 vToggleGameDVRCheckbox1, Game DVR
Gui 1:Add, Button, x440 y112 w164 h28 gClearWindowsTempFolder, Clear Windows Temp Folder
Gui 1:Add, Button, x568 y56 w80 h23 gRunIpConfig, IPConfig
Gui 1:Add, Button, x568 y80 w80 h23 gOpenAppdataFolder, Appdata
Gui 1:Add, Button, x656 y56 w149 h48 gSetVoicemeeterAsDefaultAudioDevice, Set Voicemeeter as default audio device
Gui 1:Add, Button, x608 y112 w80 h23 gOpenSounds, Open Sounds
;____________________________________________________________
;____________________________________________________________
;//////////////[Settings]///////////////
Gui 1:Tab, 2
Gui 1:Add, GroupBox, x8 y32 w175 h98, Admin
Gui 1:Add, Button, x16 y56 w152 h23 gRunAsThisAdmin vRunAsThisAdminButton, Run This Script as admin
Gui 1:Add, CheckBox, x16 y88 w152 h23 gRunAsThisAdminCheckboxButton vRunAsThisAdminCheckbox, Run as admin on start
Gui 1:Add, GroupBox, x8 y121 w175 h193, This script settings
Gui 1:Add, CheckBox, x16 y144 w143 h23 gKeepThisAlwaysOnTop, Keep this always on top
Gui 1:Add, CheckBox, x16 y168 w140 h23 gOnExitCloseToTray vOnExitCloseToTrayCheckbox, On Exit close to tray
Gui 1:Add, Button, x16 y192 w133 h28 gRedownloadAssets, Redownload assets
Gui 1:Add, CheckBox, x11 y224 w169 h23 vCheckUpdatesOnStartup gAutoUpdates, Check for updates on startup
Gui 1:Add, Button, x16 y248 w128 h23 gcheckForupdates, Check for updates
Gui 1:Add, Button, x16 y324 w138 h36 gDownloadExperimentalBranch +Hidden vDownloadExperimentalBranchButton, Download experimental version
Gui 1:Font
Gui 1:Font, s15
Gui 1:Add, Text, x16 y280 w158 h28 +0x200, Version = %version%
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, GroupBox, x8 y305 w175 h123, Debug
Gui 1:Add, Button, x16 y360 w139 h27 gOpenAppSettingsFolder, Open Settings Folder
Gui 1:Add, Button, x16 y392 w116 h23 gOpenAppSettingsFile, Open settings File
Gui 1:Add, GroupBox, x8 y419 w175 h102, Delete Stuff
Gui 1:Add, Button, x16 y440 w103 h23 gDeleteAppSettings, Delete all settings
Gui 1:Add, Button, x16 y464 w135 h42 gDeleteAllFiles, Delete all files (including this script)
Gui 1:Add, GroupBox, x182 y32 w120 h62, Shortcut
Gui 1:Add, Button, x192 y48 w95 h35 gShortcut_to_desktop, Shortcut to Desktop
Gui 1:Add, Button, x512 y48 w67 h28 vDownloadEXERunnerButton gDownloadEXERunner, Download
Gui 1:Add, GroupBox, x301 y31 w281 h63, exe Shortcut
Gui 1:Add, Text, x305 y48 w208 h40, Changes current ahk file with .exe`n(ahk files cannot be pinned to taskbar)
;____________________________________________________________
;____________________________________________________________
;//////////////[Other Scripts]///////////////
Gui 1:Tab, 3
; Add 70 to Y
;Logitech backup tool
Gui 1:Font, s13
Gui 1:Add, GroupBox, x8 y27 w430 h69, Logitech Backup Tool
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Button, x16 y56 w131 h23 vDowloadGHUBToolButton gDownloadLogitechGHUBTool, Download
Gui 1:Add, Button, x352 y56 w80 h23 gUninstallGHUBToolScript vUninstallGHUBToolScritpButton +Disabled, Delete
Gui 1:Add, Button, x160 y56 w80 h23 +disabled, Settings
Gui 1:Add, Button, x248 y56 w100 h23 gOpenGHUBToolGithub, Open in Github
;Ngrok tool
Gui 1:Font, s13
Gui 1:Add, GroupBox, x8 y97 w430 h69, Ngrok port fowarding Tool
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Button, x16 y126 w131 h23 gDownloadNgrokTool vDownloadNgrokToolButton, Download
Gui 1:Add, Button, x352 y126 w80 h23 gUninstallNgrokTool vUninstallNgrokToolButton +Disabled, Delete
Gui 1:Add, Button, x160 y126 w80 h23 +disabled, Settings
Gui 1:Add, Button, x248 y126 w100 h23 gOpenNgrokInGithub, Open in Github
;Satisfactory Save Manager
Gui 1:Font, s13
Gui 1:Add, GroupBox, x8 y167 w430 h69, Satisfactory Save Manager
Gui 1:Font
Gui 1:Font, s9, Segoe UI
Gui 1:Add, Button, x16 y196 w131 h23 gDownloadSatisfactorySaveManager vDownloadSatisfactorySaveManagerButton, Download
Gui 1:Add, Button, x352 y196 w80 h23 gUninstallSatisfactorySaveManager vUninstallSatisfactorySaveManagerButton +Disabled, Delete
Gui 1:Add, Button, x160 y196 w80 h23 +disabled, Settings
Gui 1:Add, Button, x248 y196 w100 h23 gOpenSatisfactorySaveManagerInGithub, Open in Github
;____________________________________________________________
;____________________________________________________________
;//////////////[Windows and voicemeeter]///////////////
Gui 1:Tab, 4
Gui 1:Add, GroupBox, x8 y32 w332 h256, Windows
Gui 1:Add, GroupBox, x8 y48 w193 h99, Clear Stuff
Gui 1:Add, Button, x16 y72 w171 h30 gClearWindowsTempFolder, Clear Windows temp folder
Gui 1:Add, Button, x16 y104 w171 h34 gClearAllRecentDocumentsInWordpad, Clear all recent documents in wordpad
Gui 1:Add, GroupBox, x200 y48 w140 h99, Open stuff
Gui 1:Add, Button, x208 y64 w80 h23 gOpenCmd, Open CMD
Gui 1:Add, Button, x208 y88 w126 h23 gOpenCmdAsAdmin, Open CMD as admin
Gui 1:Add, Button, x208 y112 w80 h23 gRunIpConfig, IPConfig
Gui 1:Add, GroupBox, x8 y139 w193 h149, Toggle windows game settings
Gui 1:Add, CheckBox, x16 y160 w131 h23 gToggleXboxOverlay vXboxOverlayCheckbox, Xbox Overlay
Gui 1:Add, CheckBox, x16 y184 w120 h23 gToggleGameDVR vToggleGameDVRCheckbox, Game DVR
Gui 1:Add, CheckBox, x16 y208 w120 h23 gToggleGameMode vToggleGameModeCheckbox, Game Mode
Gui 1:Add, GroupBox, x200 y139 w140 h149, Open Folders
Gui 1:Add, Button, x208 y160 w90 h23 gOpenAppdataFolder, Appdata
Gui 1:Add, Button, x208 y184 w90 h23 gOpenStartupFolder, Startup
Gui 1:Add, Button, x208 y208 w91 h23 gOpenWindowsTempFolder, Windows Temp
Gui 1:Add, Button, x208 y232 w89 h23 gOpenMyDocuments, My Documents
Gui 1:Add, Button, x208 y256 w89 h23 gOpenDesktop, Desktop
Gui 1:Add, Button, x656 y56 w149 h48 gSetVoicemeeterAsDefaultAudioDevice, Set Voicemeeter as default audio device
;____________________________________________________________
;____________________________________________________________
;//////////////[Basic scripts]///////////////
Gui 1:Tab, 5
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
;____________________________________________________________
;//////////////[Startup stuff]///////////////
if(A_IsAdmin)
{
    GuiControl,1:,RunAsThisAdminButton,Already running as admin
    GuiControl,1:Disable,RunAsThisAdminButton
}
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
}
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
IfExist %AppOtherScriptsFolder%\SatisfactorySaveManager.ahk
{
    GuiControl,1: , DownloadSatisfactorySaveManagerButton, Run
    GuiControl,1:Enable,UninstallSatisfactorySaveManagerButton
    SatisfactorySaveManagerLocation = %AppOtherScriptsFolder%\Ngrok.ahk
    SatisfactorySaveManager := true
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
Progress, b w300, Wait while script is deleting temp files, Deleting Temp Files..., Deleting Temp Files...
dir= %A_Temp%
FileDelete, %dir%\*.*
Loop, %dir%\*.*, 2
{
    Progress, %A_Index%
    FileRemoveDir, %A_LoopFileLongPath%,1
}
Progress, 100
Progress, Off
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
DownloadSatisfactorySaveManager:
if(!SatisfactorySaveManager)
{
    FileCreateDir, %AppFolder%
    FileCreateDir, %AppOtherScriptsFolder%
    UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/SatisfactorySaveManager/main/SatisfactorySaveManager.ahk, %AppOtherScriptsFolder%\SatisfactorySaveManager.ahk
    ;write save/Update Gui
    GuiControl,1:, DownloadSatisfactorySaveManagerButton, Run
    GuiControl,1:Enable,UninstallSatisfactorySaveManagerButton
    SatisfactorySaveManagerLocation = %AppOtherScriptsFolder%\SatisfactorySaveManager.ahk
    SatisfactorySaveManager := True
}
else
{
    run, %SatisfactorySaveManagerLocation%
}
return
UninstallSatisfactorySaveManager:
UninstallScript("SatisfactorySaveManager")
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
    Progress, b w300, Script will run after all Assets has been downloaded, Downloading Assets..., Downloading Assets...
    T_GUIPicProgress = 0
    T_GuiPicAddAmount = 50
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    ;SplashTextOn, 300,60,Downloading Gui Pictures, Script will run after all Gui pictures has been downloaded
    FileCreateDir,%GuiPictureFolder%
    sleep 100
    UrlDownloadToFile,https://raw.githubusercontent.com/veskeli/GameScriptsByVeskeli/main/Gui/GameScripts.ico , %GuiPictureFolder%/GameScripts.ico ;icon
    T_GUIPicProgress += T_GuiPicAddAmount
    Progress, %T_GUIPicProgress%
    
    Progress, Off
    ;SplashTextOff
}