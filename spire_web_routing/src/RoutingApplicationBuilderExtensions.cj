// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import spire_web_http.*
import spire_extensions_injection.*
import spire_web_routing.matching.*

public interface RoutingApplicationBuilderExtensions {
    /*注册路由中间件*/
    func useRouting(): Unit
    /*注册终结点及终结点中间件，如果未注册路由中间件那么自动注册*/
    func useEndpoints(endpoints: (EndpointRouteBuilder) -> Unit): Unit
}

extend ApplicationBuilder <: RoutingApplicationBuilderExtensions {
    public func useEndpoints(endpoints: (EndpointRouteBuilder) -> Unit): Unit {
        checkRequiredServices()
        let builder = getOrCreateEndpointRouteBuilder()
        endpoints(builder)
        //adding endpointSources
        let routeOptions = this.applicationServices.getOrThrow<IOptions<RouteOptions>>()
        for (pattern in builder.dataSources) {
            if (!routeOptions.value.endpointDataSources.contains(pattern)) {
                routeOptions.value.endpointDataSources.add(pattern)
            }
        }
        this.useRouting()
        use(EndpointMiddleware())
    }

    public func useRouting(): Unit {
        let endpointRoutingMiddlewareKey = "__EndpointRoutingMiddleware"
        if (this.properties.contains(endpointRoutingMiddlewareKey)) {
            return
        }
        let matcherFactory = spawn {
            let dataSource = this.applicationServices.getOrThrow<EndpointDataSource>()
            let matcherFactory = this.applicationServices.getOrThrow<MatcherFactory>()
            return matcherFactory.createMatcher(dataSource)
        }
        use(EndpointRoutingMiddleware(matcherFactory))
        this.properties[endpointRoutingMiddlewareKey] = true
    }

    private func getOrCreateEndpointRouteBuilder() {
        let endpointRouteBuilderKey = "__EndpointRouteBuilder"
        if (this.properties.contains(endpointRouteBuilderKey)) {
            (this.properties[endpointRouteBuilderKey] as EndpointRouteBuilder).getOrThrow()
        } else {
            let builder = EndpointRouteBuilder(this.applicationServices)
            this.properties[endpointRouteBuilderKey] = builder
            return builder
        }
    }

    //项目启动过程检测是否注册路由所需的服务
    private func checkRequiredServices() {
       try(scope = this.applicationServices.createScope()) {
            if (scope.services.getOrDefault<RoutingMarkerService>().isNone()) {
                throw Exception("Unable to find the required services. Please add all the required services by calling 'IServiceCollection.addRouting' in the application startup code.")
            }
       }
    }
}
