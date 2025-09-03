package spire_extensions_http

import std.reflect.*
import spire_net_http.*
import spire_extensions_options.*
import spire_extensions_injection.*

public interface HttpClientFactoryServiceCollectionExtensions {
    func addHttpClientCore(): ServiceCollection
    func addHttpClient(name: String): HttpClientBuilder
    func addHttpClient(name: String, configureClient: (HttpClient) -> Unit): HttpClientBuilder
    func addHttpClient(name: String, configureClient: (HttpClient, IServiceProvider) -> Unit): HttpClientBuilder
    func configureHttpClientDefaults(configure: (HttpClientBuilder) -> Unit): ServiceCollection
    func addHttpClient<TClient, TImplementation>(): HttpClientBuilder where TImplementation <: Object
    func addHttpClient<TClient, TImplementation>(configureClient: (HttpClient) -> Unit): HttpClientBuilder where TImplementation <: Object
    func addHttpClient<TClient, TImplementation>(configureClient: (HttpClient, IServiceProvider) -> Unit): HttpClientBuilder where TImplementation <: Object
    func addHttpClient<TClient, TImplementation>(factory: (HttpClient) -> TImplementation): HttpClientBuilder where TImplementation <: Object
    func addHttpClient<TClient, TImplementation>(factory: (HttpClient, IServiceProvider) -> TImplementation): HttpClientBuilder where TImplementation <: Object
}

extend ServiceCollection <: HttpClientFactoryServiceCollectionExtensions {
    public func addHttpClientCore(): ServiceCollection {
        this.addOptions<HttpClientFactoryOptions>()
        this.tryAddSingleton(HttpClientMappingRegistry())
        this.tryAddSingleton<IHttpClientFactory, DefaultHttpClientFactory>()
        this.tryAddTransient<HttpMessageHandlerBuilder, DefaultHttpMessageHandlerBuilder>()
        this.tryAddSingleton<HttpClient, HttpClient> {
            sp => return sp.getOrThrow<IHttpClientFactory>().createClient(String.empty)
        }
        return this
    }

    public func addHttpClient<TClient, TImplementation>(): HttpClientBuilder where TImplementation <: Object {
        addHttpClientCore()
        let name = TypeInfo.of<TClient>().qualifiedName
        return HttpClientBuilder(name, this).addTypedClientCore<TClient, TImplementation>(true)
    }

    public func addHttpClient<TClient, TImplementation>(configureClient: (HttpClient) -> Unit): HttpClientBuilder where TImplementation <: Object {
        addHttpClientCore()
        let name = TypeInfo.of<TClient>().qualifiedName
        return HttpClientBuilder(name, this)
            .configureHttpClient(configureClient)
            .addTypedClientCore<TClient, TImplementation>(true)
    }

    public func addHttpClient<TClient, TImplementation>(configureClient: (HttpClient, IServiceProvider) -> Unit): HttpClientBuilder where TImplementation <: Object {
        addHttpClientCore()
        let name = TypeInfo.of<TClient>().qualifiedName
        return HttpClientBuilder(name, this)
            .configureHttpClient(configureClient)
            .addTypedClientCore<TClient, TImplementation>(true)
    }

    public func addHttpClient<TClient, TImplementation>(factory: (HttpClient) -> TImplementation): HttpClientBuilder where TImplementation <: Object {
        addHttpClientCore()
        let name = TypeInfo.of<TClient>().qualifiedName
        return HttpClientBuilder(name, this).addTypedClient<TClient, TImplementation>(factory)
    }

    public func addHttpClient<TClient, TImplementation>(factory: (HttpClient, IServiceProvider) -> TImplementation): HttpClientBuilder where TImplementation <: Object {
        addHttpClientCore()
        let name = TypeInfo.of<TClient>().qualifiedName
        return HttpClientBuilder(name, this).addTypedClient<TClient, TImplementation>(factory)
    }

    public func addHttpClient(name: String): HttpClientBuilder {
        addHttpClientCore()
        return HttpClientBuilder(name, this)
    }

    public func addHttpClient(name: String, configureClient: (HttpClient) -> Unit): HttpClientBuilder {
        addHttpClientCore()
        return HttpClientBuilder(name, this).configureHttpClient(configureClient)
    }

    public func addHttpClient(name: String, configureClient: (HttpClient, IServiceProvider) -> Unit): HttpClientBuilder {
        addHttpClientCore()
        return HttpClientBuilder(name, this).configureHttpClient(configureClient)
    }

    public func configureHttpClientDefaults(configure: (HttpClientBuilder) -> Unit) {
        addHttpClientCore()
        configure(HttpClientBuilder(Options.defaultName, this))
        return this
    }
}
