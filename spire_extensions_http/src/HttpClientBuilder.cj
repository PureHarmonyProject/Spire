package spire_extensions_http

import std.reflect.*
import std.collection.*
import spire_net_http.*
import spire_extensions_options.*
import spire_extensions_injection.*

public class HttpClientBuilder {
    private let _name: String
    private let _services: ServiceCollection

    init(name: String, services: ServiceCollection) {
        _name = name
        _services = services
    }

    public func configureHttpClient(configureClient: (HttpClient) -> Unit) {
        _services.configure<HttpClientFactoryOptions>(_name) {
            options => options.httpClientActions.add(configureClient)
        }
    }

    public func configureHttpClient(configureClient: (HttpClient, IServiceProvider) -> Unit) {
        _services.configure<HttpClientFactoryOptions>(_name) {
            options, sp => options.httpClientActions.add({client => configureClient(client, sp)})
        }
    }

    public func addHttpMessageHandler(configureHandler: () -> DelegatingHandler) {
        _services.configure<HttpClientFactoryOptions>(_name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(configureHandler())
                })
        }
    }

    public func addHttpMessageHandler(configureHandler: (IServiceProvider) -> DelegatingHandler) {
        _services.configure<HttpClientFactoryOptions>(_name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(configureHandler(b.services))
                })
        }
    }

    public func addHttpMessageHandler<THandler>() where THandler <: DelegatingHandler {
        _services.configure<HttpClientFactoryOptions>(_name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(b.services.getOrThrow<THandler>())
                })
        }
    }

    public func configureHttpMessageHandlerBuilder(configureBuilder: (HttpMessageHandlerBuilder) -> Unit) {
        _services.configure<HttpClientFactoryOptions>(_name) {
            options => options.httpMessageHandlerBuilderActions.add(configureBuilder)
        }
    }

    public func configurePrimaryHttpMessageHandler(configureHandler: () -> HttpMessageHandler) {
        _services.configure<HttpClientFactoryOptions>(_name) {
            options => options.httpMessageHandlerBuilderActions.add({
                b => b.primaryHandler = configureHandler()
            })
        }
    }

    public func configurePrimaryHttpMessageHandler(configureHandler: (IServiceProvider) -> HttpMessageHandler) {
        _services.configure<HttpClientFactoryOptions>(_name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.primaryHandler = configureHandler(b.services)
                })
        }
    }

    public func configurePrimaryHttpMessageHandler<THandler>() where THandler <: HttpMessageHandler {
        _services.configure<HttpClientFactoryOptions>(_name) {
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
        reserveClient(TypeInfo.of<TClient>(), _name, validateSingleType)
        _services.addTransient<TClient, TClient> {
            sp =>
            let httpClientFactory = sp.getOrThrow<IHttpClientFactory>()
            let client = httpClientFactory.createClient(_name)
            return factory(client, sp)
        }
    }

    private func reserveClient(typeInfo: TypeInfo, name: String, validateSingleType: Bool) {
        let registry = _services
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
