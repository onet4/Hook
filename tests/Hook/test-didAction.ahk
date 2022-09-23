#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook()

$oHook.do( "something" )
$oHook.do( "something-else" )
$oHook.do( "something-else" )
$oHook.do( "something-else" )

if ( 0 != $oHook.didAction( "foo" ) ) {
    ExitApp A_LineNumber
}
if ( 1 != $oHook.didAction( "something" ) ) {
    ExitApp A_LineNumber
}
if ( 3 != $oHook.didAction( "something-else" ) ) {
    ExitApp A_LineNumber
}
ExitApp

