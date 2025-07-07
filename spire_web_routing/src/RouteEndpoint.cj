// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.collection.*

public class RouteEndpoint <: Endpoint {
    private let _routePattern: RoutePattern

    init(routePattern: RoutePattern, delegate: RequestDelegate, metadata: EndpointMetadataCollection, displayName: ?String) {
        super(delegate, metadata, displayName)
        _routePattern = routePattern
    }

    public prop routePattern: RoutePattern {
        get() {
            _routePattern
        }
    }
}
