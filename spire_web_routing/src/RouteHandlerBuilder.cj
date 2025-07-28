// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.collection.*

class RouteHandlerBuilder <: EndpointConventionBuilder {
    private let _conventions: ArrayList<(EndpointBuilder) -> Unit>

    init(conventions: ArrayList<(EndpointBuilder) -> Unit>) {
        _conventions = conventions
    }

    public func add(builder: (EndpointBuilder) -> Unit) {
        _conventions.add(builder)
    }
}
