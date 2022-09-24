#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

; Register callbacks to the 'get-something' filter hook (name it whatever you like in your actual script)
$oHook.addFilter( "get-something", "GetSomething" ) ; Imagine these addFilter() are done in multpile places
$oHook.addFilter( "get-something", "GetSomethingElse" )

; Trigger the 'get-something' filter hook and receive a value customized by callbacks
sValueRaw := "FOO"
sValue    := $oHook.get( "get-something", sValueRaw )
sExpected := GetSomethingElse( GetSomething( sValueRaw ) )
if ( sValue != sExpected ) {
    ExitApp A_LineNumber
}

ExitApp

GetSomething( v ) {
    return v "`nAdded by " A_ThisFunc
}
GetSomethingElse( v ) {
    return v "`nModified by " A_ThisFunc
}