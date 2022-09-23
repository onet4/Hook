#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk
global $oHook := new Hook()

_o := new TestParameterInjection()

if ( "one two three" != $oHook.get( "test-parameter-injection", "foo" ) ) {
    ExitApp A_LineNumber
}

$oHook.addFilter( "test-parameter-injection-2", Func( "FuncTestPareterInjection" ).Bind( "four", "five", "six" ) )
if ( "four five six" != $oHook.get( "test-parameter-injection-2", "dismissed" ) ) {
    ExitApp A_LineNumber
}

$oHook.addFilter( "test-parameter-injection-3", Func( "FuncTestPareterInjection2" ).Bind( "seven" ) )
if ( "seven eight" != $oHook.get( "test-parameter-injection-3", "eight" ) ) {
    ExitApp A_LineNumber
}

ExitApp

FuncTestPareterInjection2( a, b ) {
    return a " " b
}
FuncTestPareterInjection( a, b, c ) {
    return a " " b " " c
}

class TestParameterInjection {

    __New() {
        $oHook.addFilter( "test-parameter-injection", ObjBindMethod( this, "getValue", "one", "two", "three" ) )
    }

    getValue( a, b, c ) {
        return a " " b " " c
    }

}