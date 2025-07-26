package spire_web_routing.matching

import std.collection.*
import spire_web_routing.http.*
import spire_extensions_injection.*

public class DfaMatcherFactory <: MatcherFactory {
    private let _services: IServiceProvider

    public init(services: IServiceProvider) {
        _services = services
    }

    public func createMatcher(dataSource: EndpointDataSource): Matcher {
        let policies = _services.getAll<INodeBuilderPolicy>() |> collectArrayList
        let builder = DfaMatcherBuilder(policies)
        for (endpoint in dataSource.endpoints |> filterMap {f => f as RouteEndpoint}) {
            builder.addEndpoint(endpoint)
        }
        return DfaMatcherBuilder(policies).build()
    }
}
