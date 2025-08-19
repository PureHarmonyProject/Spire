package spire_extensions_http

import std.reflect.*
import std.collection.*
import spire_net_http.*
import spire_extensions_options.*
import spire_extensions_injection.*

public class HttpClientBuilder {
    private let name: String
    private let services: ServiceCollection

    init(name: String, services: ServiceCollection) {
        this.name = name
        this.services = services
    }

    public func configureHttpClient(configureClient: (HttpClient) -> Unit) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options.httpClientActions.add(configureClient)
        }
    }

    public func configureHttpClient(configureClient: (HttpClient, IServiceProvider) -> Unit) {
        services.configure<HttpClientFactoryOptions>(name) {
            options, sp => options.httpClientActions.add({client => configureClient(client, sp)})
        }
    }

    public func addHttpMessageHandler(configureHandler: () -> DelegatingHandler) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(configureHandler())
                })
        }
    }

    public func addHttpMessageHandler(configureHandler: (IServiceProvider) -> DelegatingHandler) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(configureHandler(b.services))
                })
        }
    }

    public func addHttpMessageHandler<THandler>() where THandler <: DelegatingHandler {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(b.services.getOrThrow<THandler>())
                })
        }
    }

    public func configureHttpMessageHandlerBuilder(configureBuilder: (HttpMessageHandlerBuilder) -> Unit) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options.httpMessageHandlerBuilderActions.add(configureBuilder)
        }
    }

    public func configurePrimaryHttpMessageHandler(configureHandler: () -> HttpMessageHandler) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options.httpMessageHandlerBuilderActions.add({
                b => b.primaryHandler = configureHandler()
            })
        }
    }

    public func configurePrimaryHttpMessageHandler(configureHandler: (IServiceProvider) -> HttpMessageHandler) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.primaryHandler = configureHandler(b.services)
                })
        }
    }

    public func configurePrimaryHttpMessageHandler<THandler>() where THandler <: HttpMessageHandler {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.primaryHandler = b.services.getOrThrow<THandler>()
                })
        }
    }

    public func addTypedClient<TClient>(factory: (HttpClient, IServiceProvider) -> TClient) where TClient <: Object {
        addTypedClientCore<TClient>(false, factory)
    }

    private func addTypedClientCore<TClient>(validateSingleType: Bool, factory: (HttpClient, IServiceProvider) -> TClient) where TClient <: Object {
        reserveClient(TypeInfo.of<TClient>(), name, validateSingleType)
        services.addTransient<TClient, TClient> {
            sp =>
            let httpClientFactory = sp.getOrThrow<IHttpClientFactory>()
            let httpClient = httpClientFactory.createClient(name)
            return factory(httpClient, sp)
        }
    }

    private func reserveClient(typeInfo: TypeInfo, name: String, validateSingleType: Bool) {
        let registry = services
            .iterator()
            .filter {f => f.serviceType == TypeInfo.of<HttpClientMappingRegistry>()}
            .first()
            .flatMap {f => f.implementationInstance as HttpClientMappingRegistry}
            .getOrThrow()
        if (let Some(otherType) <- registry.namedClientRegistrations.get(name) && validateSingleType && typeInfo !=
            otherType) {
            let message = "The HttpClient factory already has a registered client with the name '${name}', bound to the type '${otherType.qualifiedName}'. Client names are computed based on the type name without considering the namespace ('${otherType.name}'). Use an overload of AddHttpClient that accepts a string and provide a unique name to resolve the conflict."
            throw UnsupportedException(message)
        }

        if (validateSingleType) {
            registry.namedClientRegistrations[name] = typeInfo
        }
    }
}
