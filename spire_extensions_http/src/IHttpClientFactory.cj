package spire_extensions_http

import spire_net_http.*

public interface IHttpClientFactory {
    func createClient(name: String): HttpClient
}
