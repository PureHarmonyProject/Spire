// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_routing

import std.random.Random
import std.collection.*

public class RouteOptions {
    private let _endpointDataSources = HashSet<EndpointDataSource>()

    public prop endpointDataSources: HashSet<EndpointDataSource> {
        get() {
            _endpointDataSources
        }
    }
}
