#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

_sErrors := ""
Loop, Files, % A_ScriptDir "\*.ahk", R
{
    if ( A_LoopFileLongPath == A_ScriptDir "\" A_ScriptName ) {
        continue
    }
    RunWait, "%A_AhkPath%" /f "%A_LoopFileLongPath%"
    If ErrorLevel {
        SplitPath, % A_LoopFileLongPath, _sNameFile, _sDirName, ext, name_no_ext, drive
        SplitPath, % _sDirName, _sNameDir
        _sErrors .= "[" getNow() "] " _sNameDir "\" _sNameFile " " ErrorLevel "`n"
    }
}
if ( _sErrors ) {
    FileAppend, % _sErrors, % A_ScriptDir "\errors-" getDay() ".log"
    MsgBox, 16, % "Error", % StrSplit( Trim( _sErrors ), "`n" ).Count() " errors."
    ExitApp
}
MsgBox, 64, % "Passed", % "Looks good!"
ExitApp

getDay() {
    return A_YYYY "-" A_MM "-" A_DD
}
getNow() {
    return % getDay() " " A_Hour ":" A_Min ":" A_Sec
}