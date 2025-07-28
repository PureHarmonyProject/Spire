package spire_web_routing.matching

import spire_web_http.*

public struct CandidateState {
    CandidateState(let endpoint: Endpoint, let score: Int64, let values: ?RouteValues) {
    }
}
