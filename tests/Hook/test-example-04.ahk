#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\..\..\Hook.ahk

global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

; Normally trigger an action hook
global $oTestValue := ""
$oHook.addAction( "do-action-normally", Func( "DemonstrateParameterInjectionByAction" ) )
$oHook.do( "do-action-normally", "Parameter Value 1", "Parameter Value 2" )
sExpected := "1: Parameter Value 1`n2: Parameter Value 2`n"
if ( sExpected != $oTestValue ) {
    ExitApp A_LineNumber
}

; Trigger an action hook by passing parameters from the registerer
$oHook.addAction( "do-action-to-demonstrate-parameter-injection", Func( "DemonstrateParameterInjectionByAction" ).Bind( "Passed by callback registerer (1)", "Passed by callback registerer (2)" ) )
$oHook.do( "do-action-to-demonstrate-parameter-injection", "Normal Parameter Value 1", "Normal Parameter Value 2" )
sExpected2 := "1: Passed by callback registerer (1)`n2: Passed by callback registerer (2)`n3: Normal Parameter Value 1`n4: Normal Parameter Value 2`n"
if ( sExpected2 != $oTestValue ) {
; msgbox % $oTestValue "`n----`n" "1: Passed by callback registerer (1)`n2: Passed by callback registerer (2)`n3: Normal Parameter Value 1`n4: Normal Parameter Value 2`n"
    ExitApp A_LineNumber
}

; Normally trigger a filter hook
$oHook.addFilter( "apply-filter-normally", Func( "DemonstrateParameterInjectionByFilter" ) )
; msgbox,, From Filter, % $oHook.get( "apply-filter-normally", "Parameter Value 1", "Parameter Value 2" )
if ( $oHook.get( "apply-filter-normally", "Parameter Value 1", "Parameter Value 2" ) != sExpected ) {
    ExitApp, A_LineNumber
}

; Trigger a filter hook by passing parameters from the registerer
$oHook.addFilter( "apply-filter-to-demonstrate-parameter-injection", Func( "DemonstrateParameterInjectionByFilter" ).Bind( "Passed by callback registerer (1)", "Passed by callback registerer (2)" ) )
; msgbox,, From Filter, % $oHook.get( "apply-filter-to-demonstrate-parameter-injection", "Parameter Value 1", "Parameter Value 2" )
if ( sExpected2 != $oHook.get( "apply-filter-to-demonstrate-parameter-injection", "Normal Parameter Value 1", "Normal Parameter Value 2" ) ) {
    ExitApp, A_LineNumber
}

DemonstrateParameterInjectionByAction( aParams* ) {
    _sParams := ""
    For _k, _v in aParams {
        _sParams .= _k ": " _v "`n"
    }
    ; msgbox,, From Action, % _sParams
    $oTestValue := _sParams
}
DemonstrateParameterInjectionByFilter( aParams* ) {
    _sParams := ""
    For _k, _v in aParams {
        _sParams .= _k ": " _v "`n"
    }
    return _sParams
}