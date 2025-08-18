package spire_extensions_http

import spire_extensions_injection.*

public interface HttpClientFactoryServiceCollectionExtensions {
    func addHttpClient(): ServiceCollection
    func addHttpClient(name: String): HttpClientBuilder
}

extend ServiceCollection <: HttpClientFactoryServiceCollectionExtensions {
    public func addHttpClient(): ServiceCollection {
        this.addSingleton<HttpClientMappingRegistry>(HttpClientMappingRegistry())
        return this
    }

    public func addHttpClient(name: String): HttpClientBuilder {
        return HttpClientBuilder(name, this)
    }
}
