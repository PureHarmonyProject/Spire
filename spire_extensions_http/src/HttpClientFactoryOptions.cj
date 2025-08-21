package spire_extensions_http

import spire_net_http.*
import std.collection.*

public class HttpClientFactoryOptions {

    private var _handlerLifetime = Duration.minute * 2
    
    internal static let MinimumHandlerLifetime = Duration.second * 1

    public mut prop handlerLifetime: Duration {
        get() {
            _handlerLifetime
        }
        set(value) {
            _handlerLifetime = value
        }
    }

    public let httpClientActions: List<(HttpClient) -> Unit> = ArrayList<(HttpClient) -> Unit>()

    public let httpMessageHandlerBuilderActions: List<(HttpMessageHandlerBuilder) -> Unit> = ArrayList<(HttpMessageHandlerBuilder) -> Unit>()
}
