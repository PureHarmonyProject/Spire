// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_routing

import std.collection.*

public class EndpointRouteBuilder {
    private let _serviceProivder: IServiceProvider
    private let _dataSources = ArrayList<EndpointDataSource>()

    init(serviceProivder: IServiceProvider) {
        _serviceProivder = serviceProivder
    }

    public prop serviceProivder: IServiceProvider {
        get() {
            _serviceProivder
        }
    }

    public prop dataSources: List<EndpointDataSource> {
        get() {
            _dataSources
        }
    }
}
