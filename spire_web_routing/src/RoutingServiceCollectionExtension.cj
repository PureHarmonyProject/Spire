// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import spire_web_routing.matching.*

public interface RoutingServiceCollectionExtension {
    func addRouting(): Unit

    func addRouting(configureOptions: (RouteOptions) -> Unit): Unit
}

extend ServiceCollection <: RoutingServiceCollectionExtension {
    public func addRouting(): Unit {
        addRouting({_ => })
    }

    public func addRouting(configureOptions: (RouteOptions) -> Unit): Unit {
        this.configure(configureOptions)

        this.tryAddSingleton(RoutingMarkerService())
       
        this.tryAddSingleton<EndpointSelector, DefaultEndpointSelector>()
        this.tryAddEnumerable(ServiceDescriptor.singleton<INodeBuilderPolicy, HttpMethodMatcherPolicy>())
       
        this.tryAddSingleton<MatcherFactory, DfaMatcherFactory>()

        this.tryAddSingleton<EndpointDataSource, CompositeEndpointDataSource> {
            sp => CompositeEndpointDataSource(sp.getOrThrow<IOptions<RouteOptions>>().value.endpointDataSources)
        }
    }
}
