package spire_web_routing.matching

import std.collection.*
import spire_web_http.*
import spire_web_routing.http.*

public abstract class EndpointSelector {
    public func select(context: HttpContext, candidates: CandidateSet): Unit
}

public class DefaultEndpointSelector <: EndpointSelector {
    public func select(context: HttpContext, candidates: CandidateSet): Unit {
        if (let Some(state) <- apply(candidates)) {
            context.setEndpoint(state.endpoint)
            context.request.routeValues = state.values
        }
    }

    private func apply(candidates: CandidateSet): ?CandidateState {
        if (candidates.candidates.size == 1) {
            return candidates.candidates[0]
        } else if (candidates.candidates.size > 1) {
            return candidates.candidates[0]
        }
        return None
    }
}
