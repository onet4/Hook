#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%\..\Hook.ahk
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
        FileAppend, % "[" A_YYYY "-" A_MM "-" A_DD " " A_Hour ":" A_Min ":" A_Sec "] File saved: "  sFilePath "`n", % A_ScriptDir "\example-saved-file.log"
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