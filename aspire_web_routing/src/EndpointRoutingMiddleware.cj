// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_routing

import std.collection.*

public class EndpointRoutingMiddleware <: IMiddleware {
    private let _matcher: IRouter

    init(matcher: IRouter) {
        _matcher = matcher
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        var flag = RouteFlags.Notfound
        if (context.getEndpoint().isNone()) {
            flag = _matcher.apply(context)
        } else {
            flag = RouteFlags.Ok
        }
        match (flag) {
            case MethodNotAllowed => context.response.status(StatusCodes.MethodNotAllowed)
            case _ => next()
        }
    }
}
