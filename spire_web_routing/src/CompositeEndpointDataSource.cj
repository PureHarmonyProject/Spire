// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.sync.*
import std.collection.*

public class CompositeEndpointDataSource <: EndpointDataSource {
    private let _lock = Mutex()
    private let _options: RouteOptions
    private var _endpoints: ?ReadOnlyList<Endpoint> = None

    init(options: IOptions<RouteOptions>) {
        _options = options.value
    }

    public prop endpoints: ReadOnlyList<Endpoint> {
        get() {
            initialize()
            _endpoints.getOrThrow()
        }
    }

    private func initialize() {
        if (let Some(_) <- _endpoints) {
            return
        } else {
            synchronized(_lock) {
                if (let Some(_) <- _endpoints) {
                    return
                }
                updateEndpoints()
            }
        }
    }

    private func updateEndpoints() {
        let endpoints = ArrayList<Endpoint>()
        for (endpoint in _options.endpointDataSources |> flatMap{m => m.endpoints}) {
            endpoints.add(endpoint)
        }
        _endpoints = endpoints
    }
}
