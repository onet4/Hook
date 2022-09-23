#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook()

global $iNumber := 1

; Check if the callback is called
$oHook.addAction( "test-action", "TestFunc" )
$oHook.do( "test-action", 3 )
if ( 4 != $iNumber ) {
    ExitApp A_LineNumber
}

; Check if a class method is properly called
_o := new TestActionHook()
$oHook.do( "test-action", 2 )
if ( 8 != $iNumber ) {
    ExitApp A_LineNumber
}

; Check if adding a filter hook messes the added action
$oHook.addFilter( "test-action", "TestDummy" )
$oHook.do( "test-action", 2 )
if ( 12 != $iNumber ) {
    ExitApp A_LineNumber
}


ExitApp

TestFunc( i ) {
    $iNumber := $iNumber + i
}

TestDummy( i ) {
    return i + 1
}

class TestActionHook {

    __New() {
        $oHook.addAction( "test-action", ObjBindMethod( this, "do" ) )
    }

    do( i ) {
        $iNumber := $iNumber + i
    }

}