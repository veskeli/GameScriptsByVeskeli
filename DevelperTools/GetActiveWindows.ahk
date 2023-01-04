#SingleInstance, Force
#KeyHistory, 0
SetBatchLines, -1
ListLines, Off
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , thisscriptname
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
; DetectHiddenWindows, On
; SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
; SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
; SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

Gui 1:Add, ListView, vActiveWindows gActiveWindows AltSubmit checked w900 h400, Application                                                                                        |Location                                                                                                             |WinId
WinGet windows, List
Loop %windows%
{
	id := windows%A_Index%
	WinGetTitle wt, ahk_id %id%
    if(wt != "")
    {
        WinGet, loaction,ProcessPath, ahk_id %id%
        LV_Add("", wt,loaction,A_Index)
    }
}
ActiveCount := LV_GetCount(["S"])
ActiveWindowsCheckboxState := [%ActiveCount%]
loop, %ActiveCount%
{
    ActiveWindowsCheckboxState[A_Index] := False
}
Gui 1:Add, Button, x8 y408 w80 h23 gAddActiveWindowSelect, Add
Gui 1:Add, Button, x96 y408 w80 h23 gCancelActiveWindowSelect, Cancel
Gui 1:Show,,Select applications
return

ActiveWindows:
if (A_GuiEvent == "I")
{
    if InStr(ErrorLevel, "C", true)
    {
        ;MsgBox % "Row "  A_EventInfo " was checked."
        ActiveWindowsCheckboxState[A_EventInfo] := True
    }
    else if InStr(ErrorLevel, "c", true)
    {
        ;MsgBox % "Row "  A_EventInfo " was unchecked."
        ActiveWindowsCheckboxState[A_EventInfo] := False
    }
}
return
AddActiveWindowSelect:
ActiveCount := LV_GetCount(["S"])
r = 
Loop, %ActiveCount%
{
    if(ActiveWindowsCheckboxState[A_Index] == True)
    {
        LV_GetText(t_line, A_Index,1)
        r .= t_line . "`n"
    }
}
MsgBox,,All Windows, %r%
Return
CancelActiveWindowSelect:
Gui 1:Destroy
Return

GuiClose:
ExitApp

;Test
WinGet windows, List
Loop %windows%
{
	id := windows%A_Index%
	WinGetTitle wt, ahk_id %id%
	r .= wt . "`n"
}