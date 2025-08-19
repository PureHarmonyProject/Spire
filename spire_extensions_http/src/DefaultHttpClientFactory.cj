package spire_extensions_http

import spire_net_http.*
import spire_extensions_options.*
import std.collection.concurrent.*
import spire_extensions_injection.*

class DefaultHttpClientFactory <: IHttpClientFactory & IHttpMessageHandlerFactory {
    private let _services: IServiceProvider
    private let _optionsMonitor: IOptionsMonitor<HttpClientFactoryOptions>

    init(services: IServiceProvider, optionsMonitor: IOptionsMonitor<HttpClientFactoryOptions>) {
        _services = services
        _optionsMonitor = optionsMonitor
    }

    public func createClient(name: String): HttpClient {
        let options = _optionsMonitor.get(name)
        let handler = createHandler(name)
        let client = HttpClient(handler)
        for (configure in options.httpClientActions) {
            configure(client)
        }
        return client
    }

    public func createHandler(name: String): HttpMessageHandler {
        let options = _optionsMonitor.get(name)
    }
}
