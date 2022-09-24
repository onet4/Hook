#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

global $v := "FOO"

$oComponentA := new ComponentA   ; Assume this loads the component A
$oHook.do( "do-whatever", "This is the first parameter value.", "This is the second parameter value." )

if ( $v != "This is the first parameter value." "`n" "This is the second parameter value." ) {
    ExitApp, A_LineNumber
}

ExitApp
class ComponentA {
    __New() {
        $oHook.addAction( "do-whatever", ObjBindMethod( this, "doWhatever" ) )
    }
    doWhatever( sFirst, sSecond ) {
        $v := sFirst "`n" sSecond
       ; msgbox % sFirst "`n" sSecond
    }
}