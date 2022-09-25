# Hook
Provides a hook system within your AutoHotkey (v1) script.

## Abstract
This is an AutoHotkey v1 class meant to serve as a library that provides a hook system throughout the script execution, by letting subsets of code (let's call them components) interact with each other. In other words, you can design your script to host components serving as middleware and make them easy to be removed from or added to your script like LEGOs.

## Description
There are two types of hooks to be used with this library: _action_ and _filter_. Arbitrary names can be given to those hooks (or you may call them events) and triggered at the desired timing. When they are called, the registered callback functions will be triggered along with passed parameters. Those callbacks serve as middleware to interfere with the upstream of code execution so that custom behaviors can be added on top of the default behavior or default values that particular functions provide can be modified.

To run additional code on top of the upstream code execution, _action_ hooks are used and to modify values given by the upstream, _filter_ hooks are used. You give names to  those hooks (events) and trigger them whenever needed so that associated callbacks will be called.

This allows different parts of code to interact with each other without using extra global variables. This becomes helpful to organize code structure and files, especially for mid-sized or large scripts, and gives sustainability plus scalability to the codebase.

## Usage
### Steps
1. Place `Hook.ahk` in the library `Lib` folder. Then load it with the line, `#Include <Hook>`.
2. Instantiate the `Hook` class like `global $oHook := new Hook()`. It is recommended to make it super global to be accessed from anywhere in the script.
3. Register a callback function or class method using the `addAction()` or `addFilter()` method.
4. Trigger the hook (or you may call it an event) with the `do()` (to run additional code) or `get()`(to modify passed values) method.

### Examples
#### #1 Action Hooks
```autohotkey
#Include <Hook>
global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

; Register callbacks to the 'do-something' action hook (name it whatever you like in your actual script)
$oHook.addAction( "do-something", "DoSomething" ) ; Imagine these addAction() are done in some other components
$oHook.addAction( "do-something", "DoSomethingElse" )

; Trigger the 'do-somthing' action hook
$oHook.do( "do-something", "Hi!" )

DoSomething( v ) {
    msgbox % v
}
DoSomethingElse( v ) {
    ; do something such as creating a log file
}
```
#### #2 Filter Hooks
```autohotkey
#Include <Hook>
global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

; Register callbacks to the 'get-something' filter hook (name it whatever you like in your actual script)
$oHook.addFilter( "get-something", "GetSomething" ) ; Imagine these addFilter() are done in multpile places
$oHook.addFilter( "get-something", "GetSomethingElse" )

; Trigger the 'get-something' filter hook and receive a value customized by callbacks
msgbox % $oHook.get( "get-something", "Hello!" )

GetSomething( v ) {
    return v "`nAdded by " A_ThisFunc
}
GetSomethingElse( v ) {
    return v "`nModified by " A_ThisFunc
}
```
#### #3 Registering class methods
```autohotkey
#Include <Hook>
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
```

#### #4 Passing parameters from callback registerers
```autohotkey
#Include <Hook>
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
```
#### #5 Load components based on settings
```autohotkey
#Include <Hook>
global $oHook := new Hook() ; Reommended to make it super global to be accessed from anywhere

; Assume the settings are loaded from somewhere
oSettings := { "Components": { "Logger": true
                             , "FileConverterJSONToYAML": true
                             , "FileConverterCSVToExcel": true
                             , "FileUploader": false } }

; Load components according to the settings
oComponents := {}
For _sComponentName, _bEnabled in oSettings.Components {
    if _bEnabled {
        oComponents[ _sComponentName ] := new %_sComponentName%()
    }
}

; Assume the main component fetches a file from somewhere and saves it.
SaveFile( "[ ""Downloaded from somewhere!"" ]", A_ScriptDir "\example.json" )
SaveFile( "A,B,C", A_ScriptDir "\example.csv" )
Return

; This function triggers an action after a file is saved so that components know that a file was saved.
SaveFile( sContent, sFilePath ) {
    FileAppend, % sContent, % sFilePath
    SplitPath, sFilePath,,, _sExtension
    $oHook.do( "saved-file", sFilePath )
    $oHook.do( "saved-file-" _sExtension, sFilePath )
}

; Component classes
class Logger {
    __New() {
        $oHook.addAction( "saved-file", ObjBindMethod( this, "log" ) )
    }
    ; Gets called when "saved-file" action is triggered
    log( sFilePath ) {
        FileAppend, % "[" A_YYYY "-" A_MM "-" A_DD " " A_Hour ":" A_Min ":" A_Sec "] File saved: "  sFilePath "`n", % A_ScriptDir "\saved-file.log"
    }
}
class FileConverterBase {
    sSupportedExt := ""
    __New() {
        $oHook.addAction( "saved-file-" this.sSupportedExt, ObjBindMethod( this, "convert" ) )
    }
    convert() {
    }
}
class FileConverterJSONToYAML extends FileConverterBase {
    sSupportedExt := "json"
    ; Only gets called when a json file is saved
    convert( sFilePath ) {
        msgbox,, JOSN to Yaml, % "Let's convert JSON to Yaml."
    }
}
class FileConverterCSVToExcel extends FileConverterBase {
    sSupportedExt := "csv"
    ; Only gets called when a csv file is saved
    convert( sFilePath ) {
        msgbox,, CSV to Excel, % "Let's convert CSV to an Excel file"
    }
}
class FileUploader {
    __New() {
        $oHook.addAction( "saved-file", ObjBindMethod( this, "upload" ) )
    }
    upload( sFilePath ) {
        msgbox,, Uploader, % "Upload the file to somewhere."
    }
}
```

### Remarks

#### Number of parameters
If the registered callback expects a certain number of parameters and if the method (`do()` or `get()`) is called with an insufficient number of parameters, the method call to the callback silently fails. On the other hand, if the method (`do()` or `get()`) is called with an exceeding number of parameters over the callback's parameters, the method call to the callback will be performed. This is by the design of AutoHotkey. To avoid silent failures of callbacks, when a number of passed parameters is uncertain from the callback function, use the variadic function technique such as `myCallback( aParams* )`.
#### Adding identical callbacks
Currently, identical functions can be registered for a particular hook, meaning if the same function is added twice, the function will be called twice, which produce duplicated calls. This behavior can be a subject to change.

## Notes
This is how WordPress hosts so many plugins and themes and lets them customize the program behavior.

## License
MIT