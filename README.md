# Hook
Provides a hook system within your AutoHotkey (v1) script.

## Abstract
This is an AutoHotkey v1 class meant to serve as a library that provides a hook system throughout the script execution, by letting subsets of code (let's call them components) interact with each other. In other words, you can design your script to host components serving as middleware and make them easy to be removed from or added to your script like LEGOs.

## Description
There are two types of hooks to be used with this library: _action_ and _filter_. Arbitrary names can be given to those hooks (or you may call them events) and triggered at the desired timing. When they are called, the registered callback functions will be triggered along. Those callbacks serve as middleware to interfere with the upstream of code execution so that custom behaviors can be added on top of the default behavior or default values that particular functions provide can be modified.

To run additional code on top of the upstream code execution, _action_ hooks are used and to modify values given by the upstream, _filter_ hooks are used. You give names to  those hooks (events) and trigger them whenever needed so that associated callbacks will be called.

This allows different parts of code to interact with each other without using extra global variables. This becomes helpful to organize code structure and files with components that become easy to remove or add groups of code, especially for mid-sized or large scripts.

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

### Remarks

#### Number of parameters
If the registered callback expects a certain number of parameters and if the method (`do()` or `get()`) is called with an insufficient number of parameters, the method call to the callback silently fails. On the other hand, if the method (`do()` or `get()`) is called with an exceeding number of parameters over the callback's parameters, the method call to the callback will be performed. This is by the design of AutoHotkey. To avoid silent failures of callbacks, when a number of passed parameters is uncertain from the callback function, use the variadic function technique such as `myCallback( aParams* )`.
#### Adding identical callbacks
Currently, identical functions can be registered for a particular hook, meaning if the same function is added twice, the function will be called twice, which produce duplicated calls. This behavior can be a subject to change.

## Notes
This is how WordPress hosts so many plugins and themes and lets them customize the program behavior.

## License
MIT