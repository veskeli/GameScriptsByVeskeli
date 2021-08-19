#SingleInstance, Force
#KeyHistory, 0
SetBatchLines, -1
ListLines, Off
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , FactorioTool
#MaxThreadsPerHotkey, 4 ; no re-entrant hotkey handling
; DetectHiddenWindows, On
SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag
#Persistent
version = 0.1
;vars from Gamescripts.ahk
AppFolderName = AHKGameScriptsByVeskeli
AppFolder = %A_AppData%\%AppFolderName%
AppSettingsFolder = %AppFolder%\Settings
AppGameScriptSettingsIni = %AppSettingsFolder%\GameScriptSettings.ini
;Handle updating from gamescripts.ahk
IniWrite,%version%,%AppGameScriptSettingsIni%,Factorio,Version
Menu,Tray,Click,1
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,Show Help Text,P_OpenGui
Menu,Tray,Add
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,Show Help Text
return
P_OpenGui:
MsgBox,,Factorio,Press Delete to exit script`nAlt + Scroll down to fast craft
return

!WheelDown::
Send {Click Left}
return

Delete::
Exit:
ExitApp