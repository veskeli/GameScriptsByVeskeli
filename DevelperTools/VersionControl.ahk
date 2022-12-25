#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#NoEnv
SetBatchLines -1
MainFolder = %A_ScriptDir%
StringTrimRight, MainFolder, MainFolder, 14
DownloadManagerFolder = %MainFolder%\DownloadManager

global MainFolder
global DownloadManagerFolder

Gui Font, s9, Segoe UI
Gui Add, Text, x8 y16 w70 h23 +0x200, New version:
Gui Add, Edit, x80 y16 w168 h21 vNewVersionE gNewVersionU
Gui Add, Text, x8 y40 w71 h23 +0x200, Old Version:
Gui Add, Edit, x80 y40 w168 h21 vOldVersionE 
Gui Add, Text, x8 y64 w120 h23 +0x200, Version Git Id:
Gui Add, Edit, x8 y88 w241 h21 vOldVersionGitId
Gui Add, Text, x8 y112 w120 h23 +0x200, Set versions:
Gui Add, Button, x8 y136 w80 h23 gSetMain +Disabled, Main
Gui Add, Button, x88 y136 w80 h23 gSetPreRelease +Disabled, Pre release
Gui Add, Button, x168 y136 w80 h23 gSetExperimental, Experimental

Gui Show, w262 h173, Version Control

VersionFile = %MainFolder%\version.txt
if(FileExist(VersionFile))
{
    FileRead, CurrentVersion, %VersionFile%
    if(CurrentVersion != "" || CurrentVersion != "ERROR" || CurrentVersion != "error")
    {
        T_CreateOldVersion := CurrentVersion
        T_Lenght := StrLen(T_CreateOldVersion) - 1
        T_Multiply := 10
        T_Loop := T_Lenght - 2
        loop %T_Loop%
        {
            T_Multiply := T_Multiply . "0"
        }
        T_CreateOldVersion := T_CreateOldVersion * T_Multiply
        T_CreateOldVersion := T_CreateOldVersion + 1
        T_CreateOldVersion := T_CreateOldVersion / T_Multiply
        T_CreateOldVersion := Round(T_CreateOldVersion,T_Lenght - 1)
        GuiControl,,NewVersionE,%T_CreateOldVersion%
    }
}
Return

GuiEscape:
GuiClose:
    ExitApp

NewVersionU:
Gui,Submit,NoHide
T_CreateOldVersion := NewVersionE
T_Lenght := StrLen(T_CreateOldVersion) - 1
T_Multiply := 10
T_Loop := T_Lenght - 2
loop %T_Loop%
{
    T_Multiply := T_Multiply . "0"
}
T_CreateOldVersion := T_CreateOldVersion * T_Multiply
T_CreateOldVersion := T_CreateOldVersion - 1
T_CreateOldVersion := T_CreateOldVersion / T_Multiply
T_CreateOldVersion := Round(T_CreateOldVersion,T_Lenght - 1)
Guicontrol,,OldVersionE,%T_CreateOldVersion%
Return
;///////////////[Set versions]///////////////
SetMain:
Gui,Submit,NoHide
SetDownloadManagerVersion("main",NewVersionE)
SetVersionsId("main",OldVersionGitId,NewVersionE)
SetVersionFile(NewVersionE)
SetAhkFileVersion(NewVersionE)
MsgBox,1, Done, Done!, 8
Return
SetPreRelease:
Gui,Submit,NoHide
SetDownloadManagerVersion("PreRelease",NewVersionE)
SetVersionsId("PreRelease",OldVersionGitId,NewVersionE)
SetVersionFile(NewVersionE)
SetAhkFileVersion(NewVersionE)
MsgBox,1, Done, Done!, 8
Return
SetExperimental:
Gui,Submit,NoHide
SetDownloadManagerVersion("Experimental",OldVersionE)
SetVersionsId("Experimental",OldVersionGitId,OldVersionE)
SetVersionFile(NewVersionE)
SetAhkFileVersion(NewVersionE)
MsgBox,1, Done, Done!, 8
Return
;///////////////[Functions]///////////////
SetAhkFileVersion(Version)
{
    File = %MainFolder%\GameScripts.ahk
    if(FileExist(File))
    {
        NewVersion := % "version = " . Version
	    ReplaceLine(File,47,NewVersion)
    }
    Else
    {
        MsgBox,,File not Found!,Current version File not Found!,10
        return
    }
}
SetVersionFile(Version)
{
    File = %MainFolder%\version.txt
    if(FileExist(File))
    {
	    FileDelete % File
	    FileAppend % Version, % File    
    }
    Else
    {
        MsgBox,,File not Found!,Current version File not Found!,10
        return
    }
}
SetVersionsId(T_Section,GitId,Version)
{
    File = %DownloadManagerFolder%\VersionIdList.ini
    if(FileExist(File))
    {
        IniWrite, %GitId%, %File%, %T_Section%, %Version%
    }
    Else
    {
        MsgBox,,File not Found!,Version id list File not Found!,10
        return
    }
}
SetDownloadManagerVersion(Branch,Version)
{
    File = %DownloadManagerFolder%\%Branch%
    if(FileExist(File))
    {
        FilePrepend(File,Version)
    }
    Else
    {
        MsgBox,,File not Found!,Version File not Found!,10
        return
    }
}
FilePrepend(filename, atext) {
	FileRead fileContent, % filename
	FileDelete % filename
	FileAppend % atext . "`n" . filecontent, % filename
}
ReplaceLine(filePath, strNum, text) {
   oFile := FileOpen(filePath, "rw")
   start := oFile.Pos
   Loop % strNum {
      line := oFile.ReadLine()
      if (A_Index = strNum - 1)
         start := oFile.Pos
      if (A_Index = strNum) {
         end := oFile.Pos
         rest := oFile.Read()
      }
   } until oFile.AtEOF
   if end {
      oFile.Pos := start
      oFile.Write(text . ( end + 1 > oFile.Length ? "" : RegExReplace(line, "[^`r`n]+") ))
      oFile.Write(rest)
      oFile.Length := oFile.Pos
   }
   oFile.Close()
}