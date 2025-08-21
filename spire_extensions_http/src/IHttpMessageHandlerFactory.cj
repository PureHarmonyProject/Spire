package spire_extensions_http

import spire_net_http.*

public interface IHttpMessageHandlerFactory {
    func createHandler(name: String): HttpMessageHandler
}