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
        if (context.getEndpoint().isSome()) {
            next()
        } else {
            initializationCore()
            let matcher = _matcher.getOrThrow()
            matcher.invoke(context)
        }
    }

    private func initializationCore() {
        if (let Some(matcher) <- _matcher) {
            return matcher
        }

        synchronized(_lock) {
            if (let Some(matcher) <- _matcher) {
                return matcher
            }
            _matcher = _matcherFactory.get()
        }
    }
}
