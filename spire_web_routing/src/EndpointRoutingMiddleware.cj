// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.sync.*
import spire_web_routing.matching.*

public class EndpointRoutingMiddleware <: IMiddleware {
    private let _lock = Mutex()
    private var _matcher: ?Matcher = None
    private let _matcherFactory: MatcherFactory
    private var _endpointDataSource: EndpointDataSource

    public init(builder: EndpointRouteBuilder, matcherFactory: MatcherFactory) {
        _matcherFactory = matcherFactory
        _endpointDataSource = CompositeEndpointDataSource(builder.dataSources)
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        initializationCore()
        if (context.getEndpoint().isNone()) {
            let matcher = _matcher.getOrThrow()
            matcher.invoke(context)
        }
        next()
    }

    /*
    应用启动阶段阻塞完成状态机构建
     */
    private func initializationCore(): Unit {
        if (_matcher.isSome()) {
            return
        }
        synchronized(_lock) {
            if (_matcher.isSome()) {
                return
            }
            _matcher = _matcherFactory.createMatcher(_endpointDataSource)
        }
    }
}
