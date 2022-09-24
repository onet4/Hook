/**
 * Provides a hook system
 *
 * @see https://github.com/onet4/Hook
 * @version 1.2.0
 */
class Hook {

    oAction := {}
    oFilter := {}

    __New() {
        this.oAction := new Hook.Action()
        this.oFilter := new Hook.Filter()
    }

    /**
     * @param integer iPriority When omitted, the callback will be appended. Otherwize, it will be queued to the set position. If the same position already exists, the one added later will be called eariler.
     */
    addAction( sNameHook, cb, iPriority:="" ) {
        this.oAction.add( sNameHook, cb, iPriority )
    }

    addFilter( sNameHook, cb, iPriority:="" ) {
        this.oFilter.add( sNameHook, cb, iPriority )
    }

    do( sNameHook, aParams* ) {
        this.oAction.do( sNameHook, aParams* )
    }

    get( sNameHook, v, aParams* ) {
        return this.oFilter.get( sNameHook, v, aParams* )
    }

    didAction( sNameHook ) {
        return this.oAction.did( sNameHook )
    }

    didFilter( sNameHook ) {
        return this.oFilter.did( sNameHook )
    }

    class Common {

        oHooks := {}
        oCalls := {}

        add( sHookName, cb, iPriority:="" ) {
            this.oHooks[ sHookName ] := IsObject( this.oHooks[ sHookName ] ) ? this.oHooks[ sHookName ] : []
            this.oCalls[ sHookName ] := IsObject( this.oCalls[ sHookName ] ) ? this.oCalls[ sHookName ] : 0
            if ( StrLen( iPriority ) ) {
                this.oHooks[ sHookName ].InsertAt( iPriority, cb )
            } else {
                this.oHooks[ sHookName ].Insert( cb )
            }
        }

        did( sNameHook ) {
            return this.oCalls[ sNameHook ] ? this.oCalls[ sNameHook ] : 0
        }

    }

    class Action extends Hook.Common {

        do( sNameHook, aParams* ) {
            this.oCalls[ sNameHook ] := this.oCalls[ sNameHook ] ? ++this.oCalls[ sNameHook ] : 1
            for _i, _fn in this.oHooks[ sNameHook ] {
                if StrLen( _fn ) {
                    Func( _fn ).Call( aParams* )
                    continue
                }
                _fn.Call( aParams* )
            }
        }

    }

    class Filter extends Hook.Common {

        get( sNameHook, v, aParams* ) {
            this.oCalls[ sNameHook ] := this.oCalls[ sNameHook ] ? ++this.oCalls[ sNameHook ] : 1
            aParams.InsertAt( 1, v )
            for _i, _fn in this.oHooks[ sNameHook ] {
                if strlen( _fn ) {
                    aParams.1 := Func( _fn ).Call( aParams* )
                    continue
                }
                aParams.1 := _fn.Call( aParams* )
            }
            return aParams.1
        }

    }

}