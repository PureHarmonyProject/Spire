package spire_web_routing.matching

import spire_web_http.*
import spire_web_routing.http.*

public abstract class EndpointSelector {
    public func select(context: HttpContext, candidates: CandidateSet): Unit
}

public class DefaultEndpointSelector <: EndpointSelector {
    public func select(context: HttpContext, candidates: CandidateSet): Unit {
        if (candidates.candidates.size == 1) {
            context.setEndpoint(candidates.candidates[0].endpoint)
        } else if (candidates.candidates.size > 1) {
            context.setEndpoint(candidates.candidates[0].endpoint)
        }
    }
}
