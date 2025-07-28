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
        let endpointSelector = _services.getOrThrow<EndpointSelector>()
        
        //创建dfa构建器
        let builder = DfaMatcherBuilder(endpointSelector, policies)

        //添加终结点
        for (endpoint in dataSource.endpoints |> filterMap {f => f as RouteEndpoint}) {
            builder.addEndpoint(endpoint)
        }
        return builder.build()
    }
}
