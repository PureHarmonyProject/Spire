package spire_extensions_http

import spire_net_http.*
import std.collection.*

public class HttpClientFactoryOptions {
    public let httpClientActions: List<(HttpClient) -> Unit> = ArrayList<(HttpClient) -> Unit>()
    public let httpMessageHandlerBuilderActions: List<(HttpMessageHandlerBuilder) -> Unit> = ArrayList<(HttpMessageHandlerBuilder) -> Unit>()
}
