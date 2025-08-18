package spire_extensions_http

import spire_net_http.*
import std.collection.concurrent.*

class DefaultHttpClientFactory <: IHttpClientFactory {
    public func createClient(name: String): HttpClient {
        throw UnsupportedException()
    }
}
