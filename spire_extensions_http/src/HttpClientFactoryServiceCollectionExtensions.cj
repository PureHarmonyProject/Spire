package spire_extensions_http
import spire_extensions_options.OptionsServiceCollectionExtensions

import spire_net_http.*
import spire_extensions_options.*
import spire_extensions_injection.*

public interface HttpClientFactoryServiceCollectionExtensions {
    func addHttpClient(): ServiceCollection
    func addHttpClient(name: String): HttpClientBuilder
    func configureHttpClientDefaults(configure: (HttpClientBuilder)-> Unit): ServiceCollection 
}

extend ServiceCollection <: HttpClientFactoryServiceCollectionExtensions {
    public func addHttpClient(): ServiceCollection {

        this.addOptions<HttpClientFactoryOptions>()

        this.tryAddSingleton(HttpClientMappingRegistry())
        
        this.tryAddSingleton<IHttpClientFactory, DefaultHttpClientFactory>()
        
        this.tryAddTransient<HttpMessageHandlerBuilder, DefaultHttpMessageHandlerBuilder>()

        this.tryAddSingleton<HttpClient, HttpClient>{ sp =>
            return sp.getOrThrow<IHttpClientFactory>().createClient(String.empty)
        }
        return this
    }

    public func configureHttpClientDefaults(configure: (HttpClientBuilder)-> Unit) {
        addHttpClient()
        configure(HttpClientBuilder(Options.defaultName, this))
        return this
    }

    public func addHttpClient(name: String): HttpClientBuilder {
        addHttpClient()
        return HttpClientBuilder(name, this)
    }
}
