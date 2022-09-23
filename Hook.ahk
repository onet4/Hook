/**
 * Provides a hook system
 *
 * @see https://github.com/onet4/Hook
 * @version 1.0.0
 */
class Hook {

    oActionHooks := {}
    oFilterHooks := {}
    oActionCalls := {}  ; stores call counts for actions - checked wither an action hook is already triggered or not
    oFilterCalls := {}  ; stores call counts for filters

    /**
     * @param integer iPriority When omitted, the callback will be appended. Otherwize, it will be queued to the set position. If the same position already exists, the one added later will be called eariler.
     */
    addAction( sHookName, cb, iPriority="" ) {
        this.oActionHooks[ sHookName ] := this.oActionHooks[ sHookName ] && isObject( this.oActionHooks[ sHookName ] )
            ? this.oActionHooks[ sHookName ]
            : []
        this.oActionCalls[ sHookName ] := this.oActionCalls[ sHookName ] && isObject( this.oActionCalls[ sHookName ] )
            ? this.oActionCalls[ sHookName ]
            : 0
        if ( strlen( iPriority ) ) {
            this.oActionHooks[ sHookName ].InsertAt( iPriority, cb )
        } else {
            this.oActionHooks[ sHookName ].Insert( cb )
        }
    }

    addFilter( sHookName, cb, iPriority="" ) {
        this.oFilterHooks[ sHookName ] := this.oFilterHooks[ sHookName ] && isObject( this.oFilterHooks[ sHookName ] )
            ? this.oFilterHooks[ sHookName ]
            : []
        this.oFilterCalls[ sHookName ] := this.oFilterCalls[ sHookName ] && isObject( this.oFilterCalls[ sHookName ] )
            ? this.oFilterCalls[ sHookName ]
            : 0
        if ( strlen( iPriority ) ) {
            this.oFilterHooks[ sHookName ].InsertAt( iPriority, cb )
        } else {
            this.oFilterHooks[ sHookName ].Insert( cb )
        }
    }

    do( sNameHook, aParams* ) {
        this.oActionCalls[ sNameHook ] := this.oActionCalls[ sNameHook ] ? this.oActionCalls[ sNameHook ]++ : 1
        for _i, _fn in this.oActionHooks[ sNameHook ] {
            if strlen( _fn ) {
                Func( _fn ).Call( aParams* )
                continue
            }
            _fn.Call( aParams* )
        }
    }

    get( sNameHook, v, aParams* ) {
        this.oFilterCalls[ sNameHook ] := this.oFilterCalls[ sNameHook ] ? this.oFilterCalls[ sNameHook ]++ : 1
        aParams.InsertAt( 1, v )
        for _i, _fn in this.oFilterHooks[ sNameHook ] {
            if strlen( _fn ) {
                v := Func( _fn ).Call( aParams* )
                continue
            }
            v := _fn.Call( aParams* )
        }
        return v
    }

    didAction( sNameHook ) {
        return this.oActionCalls[ sNameHook ]
    }

    didFilter( sNameHook ) {
        return this.oFilterCalls[ sNameHook ]
    }

}