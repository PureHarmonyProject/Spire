// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.sync.*
import std.collection.*

public class CompositeEndpointDataSource <: EndpointDataSource {
    private let _lock = Mutex()
    private var _endpoints: ?ArrayList<Endpoint> = None
    private var _endpointDataSources: Collection<EndpointDataSource>

    init(endpointDataSources: Collection<EndpointDataSource>) {
        _endpointDataSources = endpointDataSources
    }

    public prop endpoints: ReadOnlyList<Endpoint> {
        get() {
            initialize()
            return _endpoints.getOrThrow()
        }
    }

    private func initialize() {
        if (_endpoints.isSome()) {
            return
        } else {
            synchronized(_lock) {
                if (_endpoints.isSome()) {
                    return
                }
                updateEndpoints()
            }
        }
    }

    private func updateEndpoints() {
        let endpoints = ArrayList<Endpoint>()
        for (endpoint in _endpointDataSources |> flatMap {m => m.endpoints}) {
            endpoints.add(endpoint)
        }
        _endpoints = endpoints
    }
}
