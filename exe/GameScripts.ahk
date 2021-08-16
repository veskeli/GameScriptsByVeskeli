/*
This is Exe runner
Simple script compiled to run the main script
*/
IniWrite, %A_ScriptDir%,%A_AppData%\AHKGameScriptsByVeskeli\Settings\Settings.ini, ExeRunner, ExeFileLocation ;Save this exe file folder
run, %A_AppData%\AHKGameScriptsByVeskeli\GameScripts.ahk
ExitApp