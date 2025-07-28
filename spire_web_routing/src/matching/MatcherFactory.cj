package spire_web_routing.matching

import spire_web_routing.http.*

public abstract class MatcherFactory {
    public func createMatcher(dataSource: EndpointDataSource): Matcher
}