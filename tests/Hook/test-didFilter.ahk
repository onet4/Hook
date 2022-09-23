#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook()

_s := $oHook.get( "something", "aa" )
_s2 := $oHook.get( "something-else", _s )
_s2 := $oHook.get( "something-else", _s2 )
_s2 := $oHook.get( "something-else", _s2 )
_s2 := $oHook.get( "something-else", _s2 )

if ( 0 != $oHook.didFilter( "foo" ) ) {
    ExitApp A_LineNumber
}
if ( 1 != $oHook.didFilter( "something" ) ) {
    ExitApp A_LineNumber
}
if ( 4 != $oHook.didFilter( "something-else" ) ) {
    ExitApp A_LineNumber
}
ExitApp
