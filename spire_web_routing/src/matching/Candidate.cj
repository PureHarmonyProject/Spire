package spire_web_routing.matching

import std.collection.*
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
