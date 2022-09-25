#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\Hook.ahk
global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

$oComponentA := new ComponentA   ; Assume this loads the component A
$oHook.do( "do-whatever", "This is the first parameter value.", "This is the second parameter value." )
class ComponentA {
    __New() {
        $oHook.addAction( "do-whatever", ObjBindMethod( this, "doWhatever" ) )
    }
    doWhatever( sFirst, sSecond ) {
        msgbox % sFirst "`n" sSecond
    }
}