#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\..\..\Hook.ahk
global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

global $v := "raw value"

; Register callbacks to the 'do-something' action hook (name it whatever you like in your actual script)
$oHook.addAction( "do-something", "DoSomething" ) ; Imagine these addAction() are done in some other components
$oHook.addAction( "do-something", "DoSomethingElse" )

; Trigger the 'do-somthing' action hook
$oHook.do( "do-something", "Hello" )
if ( "raw value" == $v ) {
    ExitApp A_LineNumber
}

DoSomething( v ) {
    $v := v
    ; msgbox % v
}
DoSomethingElse( v ) {
    ; do something such as creating a log file
}