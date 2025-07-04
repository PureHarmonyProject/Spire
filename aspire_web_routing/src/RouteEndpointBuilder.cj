// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_routing

import std.collection.*

public class RouteEndpointBuilder <: EndpointBuilder {
    private let _routePattern: RoutePattern
    private let _metadata = ArrayList<Any>()
    private let _delegate: RequestDelegate
    private let _services: IServiceProvider
    private let _displayName: ?String = None

    public init(routePattern: RoutePattern, delegate: RequestDelegate, services: IServiceProvider) {
        _routePattern = routePattern
        _delegate = delegate
        _services = services
    }

    public prop routePattern: RoutePattern {
        get() {
            _routePattern
        }
    }

    public prop metadata: List<Any> {
        get() {
            _metadata
        }
    }

    public prop delegate: RequestDelegate {
        get() {
            _delegate
        }
    }

    public prop services: IServiceProvider {
        get() {
            _services
        }
    }

    public prop displayName: ?String {
        get() {
            _displayName
        }
    }

    public func build(): Endpoint {
        let metadata = EndpointMetadataCollection(_metadata)
        return RouteEndpoint(_routePattern, _delegate, metadata, _displayName)
    }
}
