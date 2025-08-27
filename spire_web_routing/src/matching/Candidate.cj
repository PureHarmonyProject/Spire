// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.matching

import spire_web_http.*
import spire_web_routing.http.*

public struct Candidate {
    Candidate(let endpoint: Endpoint, let score: Int64,
        let captures: Array<ParameterCaptureInfo>, let catchAll: ?ParameterCaptureInfo) {
    }

    func debuggerToString(): String {
        if (let routeEndpoint: RouteEndpoint <- endpoint) {
            return routeEndpoint.routePattern.debuggerToString()
        }
        return endpoint.toString()
    }
}
