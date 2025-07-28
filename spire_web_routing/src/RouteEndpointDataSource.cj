// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.collection.*
import spire_web_routing.patterns.*

class RouteEndpointDataSource <: EndpointDataSource {
    private let _services: IServiceProvider
    private var _endpoints: ?ArrayList<Endpoint> = None
    private let _routeEntries = ArrayList<RouteEntry>()

    init(services: IServiceProvider) {
        _services = services
    }

    public prop endpoints: ReadOnlyList<Endpoint> {
        get() {
            if (let Some(endpoints) <- _endpoints) {
                return endpoints
            } else {
                let endpoints = ArrayList<Endpoint>()
                for (pattern in _routeEntries) {
                    let builder = createRouteEndpointBuilder(pattern)
                    endpoints.add(builder.build())
                }
                _endpoints = endpoints
                return endpoints
            }
        }
    }

    public func addRequestDelegate(routePattern: String, delegate: RequestDelegate, httpMethods: Collection<String>) {
        let conventions = ArrayList<(EndpointBuilder) -> Unit>()
        _routeEntries.add(RouteEntry(routePattern, delegate, httpMethods, conventions))
        return RouteHandlerBuilder(conventions)
    }

    private func createRouteEndpointBuilder(entry: RouteEntry) {
        let routePattern = RoutePattern.parse(entry.routePattern)
        let builder = RouteEndpointBuilder(routePattern, entry.delegate, _services)
        builder.metadata.add(HttpMethodMetadata(entry.httpMethods))
        for (pattern in entry.conventions) {
            pattern(builder)
        }
        return builder
    }
}

struct RouteEntry {
    RouteEntry(
        let routePattern: String, 
        let delegate: RequestDelegate,
        let httpMethods: Collection<String>,
        let conventions: ArrayList<(EndpointBuilder) -> Unit>) {
    }
}
