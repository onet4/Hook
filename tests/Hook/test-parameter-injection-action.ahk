#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk
global $oHook := new Hook()

global $v := "foo"

_o := new TestParameterInjection()
$oHook.do( "test-parameter-injection" )
if ( "one two three" != $v ) {
    ExitApp A_LineNumber
}

$oHook.addAction( "test-parameter-injection-2", Func( "FuncTestPareterInjection" ).Bind( "four", "five", "six" ) )
$oHook.do( "test-parameter-injection-2" )
if ( "four five six" != $v ) {
    ExitApp A_LineNumber
}

$oHook.addAction( "test-parameter-injection-3", Func( "FuncTestPareterInjection2" ).Bind( "seven" ) )
$oHook.do( "test-parameter-injection-3", "eight" )
if ( "seven eight" != $v ) {
    ExitApp A_LineNumber
}



ExitApp

FuncTestPareterInjection2( a, b ) {
    $v := a " " b
}
FuncTestPareterInjection( a, b, c ) {
    $v := a " " b " " c
}

class TestParameterInjection {

    __New() {
        $oHook.addAction( "test-parameter-injection", ObjBindMethod( this, "testMethod", "one", "two", "three" ) )
    }

    testMethod( a, b, c ) {
        $v := a " " b " " c
    }

}