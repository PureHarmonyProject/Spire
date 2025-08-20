package spire_extensions_http

import spire_net_http.*
import spire_extensions_options.*

public interface IHttpClientFactory {
    func createClient(): HttpClient {
        return createClient(Options.defaultName)
    }

    func createClient(name: String): HttpClient
}
