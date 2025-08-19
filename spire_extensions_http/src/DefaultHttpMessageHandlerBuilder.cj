package spire_extensions_http

import std.collection.*
import spire_net_http.*
import spire_extensions_injection.*

class DefaultHttpMessageHandlerBuilder <: HttpMessageHandlerBuilder {
    private var _name: ?String = None
    private let _services: IServiceProvider
    private var _primaryHandler: HttpMessageHandler
    private let _additionalHandlers = ArrayList<DelegatingHandler>()

    public init(services: IServiceProvider) {
        _services = services
        _primaryHandler = createPrimaryHandler()
    }

    public mut prop name: ?String {
        get() {
            _name
        }
        set(value) {
            _name = value
        }
    }
    public prop services: IServiceProvider {
        get() {
            _services
        }
    }

    public mut prop primaryHandler: HttpMessageHandler {
        get() {
            _primaryHandler
        }
        set(value) {
            _primaryHandler = value
        }
    }

    public prop additionalHandlers: List<DelegatingHandler> {
        get() {
            _additionalHandlers
        }
    }

    public func build(): HttpMessageHandler {
        return createHandlerPipeline(primaryHandler, additionalHandlers)
    }

    private static func createPrimaryHandler() {
        return HttpClientHandler()
    }
}