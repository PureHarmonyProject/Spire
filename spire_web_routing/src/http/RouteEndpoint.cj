// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.http

import spire_web_http.*
import spire_web_routing.patterns.*

public class RouteEndpoint <: Endpoint {
    private let _routePattern: RoutePattern

    public init(routePattern: RoutePattern, delegate: RequestDelegate, metadata: EndpointMetadataCollection, displayName: ?String) {
        super(delegate, metadata, displayName)
        _routePattern = routePattern
    }

    public prop routePattern: RoutePattern {
        get() {
            _routePattern
        }
    }

    public override func toString() {
        _routePattern.rawText
    }
}
