package spire_extensions_http

import spire_net_http.*
import spire_extensions_options.*
import std.collection.concurrent.*
import spire_extensions_injection.*

class DefaultHttpClientFactory <: IHttpClientFactory & IHttpMessageHandlerFactory {
    private let _services: IServiceProvider
    private let _optionsMonitor: IOptionsMonitor<HttpClientFactoryOptions>

    public init(services: IServiceProvider, optionsMonitor: IOptionsMonitor<HttpClientFactoryOptions>) {
        _services = services
        _optionsMonitor = optionsMonitor
    }

    public func createClient(name: String): HttpClient {
        let options = _optionsMonitor.get(name)
        let handler = createHandler(name)
        let client = HttpClient(handler, false)
        for (action in options.httpClientActions) {
            action(client)
        }
        return client
    }

    public func createHandler(name: String): HttpMessageHandler {
        let options = _optionsMonitor.get(name)
        let scope = _services.createScope()
        try {
            //构建名为name的请求管道
            let builder = scope.services.getOrThrow<HttpMessageHandlerBuilder>()
            builder.name = name
            for (action in options.httpMessageHandlerBuilderActions) {
                action(builder)
            }
            return builder.build()
        } catch (ex: Exception) {
            scope.close()
            throw ex
        }
    }
}
