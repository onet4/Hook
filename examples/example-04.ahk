#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\Hook.ahk
global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

; Normally trigger an action hook
$oHook.addAction( "do-action-normally", Func( "DemonstrateParameterInjectionByAction" ) )
$oHook.do( "do-action-normally", "Parameter Value 1", "Parameter Value 2" )

; Trigger an action hook by passing parameters from the registerer
$oHook.addAction( "do-action-to-demonstrate-parameter-injection", Func( "DemonstrateParameterInjectionByAction" ).Bind( "Passed by callback registerer (1)", "Passed by callback registerer (2)" ) )
$oHook.do( "do-action-to-demonstrate-parameter-injection", "Normal Parameter Value 1", "Normal Parameter Value 2" )

; Normally trigger a filter hook
$oHook.addFilter( "apply-filter-normally", Func( "DemonstrateParameterInjectionByFilter" ) )
msgbox,, From Filter, % $oHook.get( "apply-filter-normally", "Parameter Value 1", "Parameter Value 2" )

; Trigger a filter hook by passing parameters from the registerer
$oHook.addFilter( "apply-filter-to-demonstrate-parameter-injection", Func( "DemonstrateParameterInjectionByFilter" ).Bind( "Passed by callback registerer (1)", "Passed by callback registerer (2)" ) )
msgbox,, From Filter, % $oHook.get( "apply-filter-to-demonstrate-parameter-injection", "Parameter Value 1", "Parameter Value 2" )

DemonstrateParameterInjectionByAction( aParams* ) {
    _sParams := ""
    For _k, _v in aParams {
        _sParams .= _k ": " _v "`n"
    }
    msgbox,, From Action, % _sParams
}
DemonstrateParameterInjectionByFilter( aParams* ) {
    _sParams := ""
    For _k, _v in aParams {
        _sParams .= _k ": " _v "`n"
    }
    return _sParams
}