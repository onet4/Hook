#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook()

$oHook.addAction( "test-action", "TestFunc" )

_sPath := A_ScriptDIr "\test-action.log"
FileDelete, % _sPath
_sText := A_Now
$oHook.do( "test-action", _sText, _sPath )

If ! FileExist( _sPath ) {
    MsgBox, 16, Error, % "Failed " A_LineFile " " A_LineNumber
    FileDelete, % _sPath
    exitapp 1
}
FileRead, _sLog, % _sPath
If ( _sText != _sLog ) {
    MsgBox, 16, Error, % "Failed " A_LineFile " " A_LineNumber "`n"
        . "Expected: " _sText "`n"
        . "Actual: " _sLog
    FileDelete, % _sPath
    exitapp 1
}

FileDelete, % _sPath
ExitApp

TestFunc( sText, sPath ) {
    FileAppend, % sText, % sPath
}