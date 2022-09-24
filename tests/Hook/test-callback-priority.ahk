#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook()

global $sCalledFuncs := ""

$oHook.addAction( "test-callback-priority", "Test1", 10 )
$oHook.addAction( "test-callback-priority", "Test2", 1 )
$oHook.addAction( "test-callback-priority", "Test3" )
$oHook.addAction( "test-callback-priority", "Test4", 1 )

$oHook.do( "test-callback-priority" )
_sActual := $sCalledFuncs

$sCalledFuncs := ""
Test4()
Test2()
Test1()
Test3()
if ( _sActual != $sCalledFuncs ) {
    ExitApp A_LineNumber
}

ExitApp

Test1() {
    $sCalledFuncs .= A_ThisFunc "`n"
}
Test2() {
    $sCalledFuncs .= A_ThisFunc "`n"
}
Test3() {
    $sCalledFuncs .= A_ThisFunc "`n"
}
Test4() {
    $sCalledFuncs .= A_ThisFunc "`n"
}