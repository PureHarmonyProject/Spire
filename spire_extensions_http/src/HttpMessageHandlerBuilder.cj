package spire_extensions_http

import std.collection.*
import spire_net_http.*
import spire_extensions_injection.*

public abstract class HttpMessageHandlerBuilder {
    public mut prop name: String
    public prop services: IServiceProvider
    public mut prop primaryHandler: HttpMessageHandler
    public mut prop additionalHandlers: List<DelegatingHandler>
    public func build(): HttpMessageHandler
    protected func CreateHandlerPipeline(primaryHandler: HttpMessageHandler,
        additionalHandlers: Collection<DelegatingHandler>): HttpMessageHandler
}
