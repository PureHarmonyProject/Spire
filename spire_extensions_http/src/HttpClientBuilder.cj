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

    public prop name: String {
        get() {
            _name
        }
    }

    public prop services: ServiceCollection {
        get() {
            _services
        }
    }
}

extend HttpClientBuilder {

    public func setHandlerLifetime(handlerLifetime: Duration) {
        if (handlerLifetime != Duration.Zero && handlerLifetime < HttpClientFactoryOptions.MinimumHandlerLifetime) {
            throw IllegalArgumentException("The handler lifetime must be at least ${HttpClientFactoryOptions.MinimumHandlerLifetime.toSeconds()} second.")
        }
       
        services.configure<HttpClientFactoryOptions>(name) {
            options => options.handlerLifetime = handlerLifetime
        }
        return this
    }

    public func configureHttpClient(configureClient: (HttpClient) -> Unit) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options.httpClientActions.add(configureClient)
        }
        return this
    }

    public func configureHttpClient(configureClient: (HttpClient, IServiceProvider) -> Unit) {
        services.configure<HttpClientFactoryOptions>(name) {
            options, sp => options.httpClientActions.add({client => configureClient(client, sp)})
        }
        return this
    }

    public func addHttpMessageHandler(configureHandler: () -> DelegatingHandler) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(configureHandler())
                })
        }
        return this
    }

    public func addHttpMessageHandler(configureHandler: (IServiceProvider) -> DelegatingHandler) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(configureHandler(b.services))
                })
        }
        return this
    }

    public func addHttpMessageHandler<THandler>() where THandler <: DelegatingHandler {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.additionalHandlers.add(b.services.getOrThrow<THandler>())
                })
        }
        return this
    }

    public func configureHttpMessageHandlerBuilder(configureBuilder: (HttpMessageHandlerBuilder) -> Unit) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options.httpMessageHandlerBuilderActions.add(configureBuilder)
        }
        return this
    }

    public func configurePrimaryHttpMessageHandler(configureHandler: () -> HttpMessageHandler) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options.httpMessageHandlerBuilderActions.add({
                b => b.primaryHandler = configureHandler()
            })
        }
        return this
    }

    public func configurePrimaryHttpMessageHandler(configureHandler: (IServiceProvider) -> HttpMessageHandler) {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.primaryHandler = configureHandler(b.services)
                })
        }
        return this
    }

    public func configurePrimaryHttpMessageHandler<THandler>() where THandler <: HttpMessageHandler {
        services.configure<HttpClientFactoryOptions>(name) {
            options => options
                .httpMessageHandlerBuilderActions
                .add({
                    b => b.primaryHandler = b.services.getOrThrow<THandler>()
                })
        }
        return this
    }

    public func addTypedClient<TClient>(factory: (HttpClient, IServiceProvider) -> TClient) where TClient <: Object {
        addTypedClientCore<TClient>(false, factory)
        return this
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
        let registry = getHttpClientMappingRegistry()
        // 验证和注册命名 HttpClient 客户端，防止命名冲突和类型混淆。
        if (let Some(otherType) <- registry.namedClientRegistrations.get(name) && validateSingleType && typeInfo !=
            otherType) {
            let message = "The HttpClient factory already has a registered client with the name '${name}', bound to the type '${otherType.qualifiedName}'. Client names are computed based on the type name without considering the namespace ('${otherType.name}'). Use an overload of AddHttpClient that accepts a string and provide a unique name to resolve the conflict."
            throw UnsupportedException(message)
        }

        if (validateSingleType) {
            registry.namedClientRegistrations[name] = typeInfo
        }
    }

    private func getHttpClientMappingRegistry() {
        let descriptor = services |> filter {f => f.serviceType == TypeInfo.of<HttpClientMappingRegistry>()} |> first
        return descriptor.flatMap {f => f.implementationInstance as HttpClientMappingRegistry}.getOrThrow()
    }
}
