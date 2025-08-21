package spire_extensions_http

import std.ref.*
import spire_net_http.*
import spire_extensions_injection.*

class ExpiredHandlerTrackingEntry {
    private let _name: String
    private let _scope: IServiceScope
    private let _innerHandler: ?HttpMessageHandler
    private let _livenessTracker: WeakRef<LifetimeTrackingHttpMessageHandler>

    init(other: ActiveHandlerTrackingEntry) {
        _name = other.name
        _scope = other.scope
        _livenessTracker = WeakRef<LifetimeTrackingHttpMessageHandler>(other.handler, CleanupPolicy.EAGER)
        _innerHandler = other.handler.innerHandler
    }

    public prop name: String {
        get() {
            _name
        }
    }

    public prop scope: IServiceScope {
        get() {
            _scope
        }
    }

    public prop innerHandler: ?HttpMessageHandler {
        get() {
            _innerHandler
        }
    }

    public prop canDispose: Bool {
        get() {
            _livenessTracker.value.isNone()
        }
    }
}
