package spire_web_routing.matching

import std.collection.*
import spire_web_http.*
import spire_web_routing.http.*

public abstract class EndpointSelector {
    public func select(context: HttpContext, candidates: CandidateSet): Unit
}
