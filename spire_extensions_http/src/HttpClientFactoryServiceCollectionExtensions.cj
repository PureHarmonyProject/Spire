package spire_extensions_http

import spire_extensions_injection.*

public interface HttpClientFactoryServiceCollectionExtensions {
    func addHttpClient(): ServiceCollection
    func addHttpClient(name: String): HttpClientBuilder
}

extend ServiceCollection <: HttpClientFactoryServiceCollectionExtensions {
    public func addHttpClient(): ServiceCollection {
        this.tryAddSingleton(HttpClientMappingRegistry())
        this.tryAddSingleton<IHttpClientFactory, DefaultHttpClientFactory>()
        this.tryAddSingleton<HttpMessageHandlerBuilder, DefaultHttpMessageHandlerBuilder>()
        return this
    }

    public func addHttpClient(name: String): HttpClientBuilder {
        addHttpClient()
        return HttpClientBuilder(name, this)
    }
}
