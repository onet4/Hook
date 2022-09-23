#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk
global $oHook := new Hook()

global $v := "foo"

_o := new TestMultipleParameters()

; Callback should fails for an insufficient number of parameters
$oHook.do( "test-multiple-parameters" )
if ( "foo" != $v ) {
    ExitApp A_LineNumber
}
$oHook.do( "test-multiple-parameters", "a", "b" )
if ( "foo" != $v ) {
    ExitApp A_LineNumber
}

; The callback should be called and modify the global variable
$oHook.do( "test-multiple-parameters", "a", "b", "c" )
if ( "foo" == $v ) {
    ExitApp A_LineNumber
}

; Passing an exceeding number of parameter can call the callback normally
$v := "reset"
$oHook.do( "test-multiple-parameters", "a", "b", "c", "d" )
if ( "foo" == $v ) {
    ExitApp A_LineNumber
}

class TestMultipleParameters {

    __New() {
        $oHook.addAction( "test-multiple-parameters", ObjBindMethod( this, "test" ) )
    }

    test( a, b, c ) {
        $v := "modified"
    }

}