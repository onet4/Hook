#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook()

$oHook.addFilter( "get-something", "getSomething" )
_o := new TestFilterHook()

if ( "a[ADDED]" != $oHook.get( "get-something", "a" ) ) {
    ExitApp A_LineNumber
}
if ( "[PREPENDED]b" != $oHook.get( "string-modified-with-class-method", "b" ) ) {
    ExitApp A_LineNumber
}

ExitApp

getSomething( s ) {
    return s "[ADDED]"
}


class TestFilterHook {
    __New() {
        $oHook.addFilter( "string-modified-with-class-method", ObjBindMethod( this, "get" ) )
    }
    get( s ) {
        return "[PREPENDED]" s
    }
}