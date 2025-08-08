// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing

import std.sync.*
import std.collection.*
import spire_web_routing.matching.Matcher

public class EndpointRoutingMiddleware <: IMiddleware {
    private let _lock = Mutex()
    private var _matcher: ?Matcher = None
    private let _matcherFactory: Future<Matcher>

    init(matcherFactory: Future<Matcher>) {
        _matcherFactory = matcherFactory
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
        if (let Some(matcher) <- _matcher) {
            return
        }

        synchronized(_lock) {
            if (let Some(matcher) <- _matcher) {
                return
            }
            let matcher = _matcherFactory.get()
            _matcher = matcher
        }
    }
}
