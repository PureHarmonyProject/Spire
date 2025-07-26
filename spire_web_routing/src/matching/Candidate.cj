package spire_web_routing.matching

import spire_web_http.*
import spire_web_routing.http.*

public class Candidate {
    Candidate(let endpoint: Endpoint, let score: Int64) {
    }

    func debuggerToString(): String {
        if (let routeEndpoint: RouteEndpoint <- endpoint) {
            return routeEndpoint.routePattern.debuggerToString()
        }
        return String.empty
    }
}
