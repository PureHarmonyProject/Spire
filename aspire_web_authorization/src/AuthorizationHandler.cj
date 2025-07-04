// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authorization

import std.collection.*

public abstract class AuthorizationHandler<TRequirement> <: IAuthorizationHandler where TRequirement <: IAuthorizationRequirement {
    public func handle(context: AuthorizationHandlerContext): Unit {
        for (pattern in context.requirements |> filterMap {f => f as TRequirement}) {
            handleRequirement(context, pattern)
        }
    }

    protected func handleRequirement(context: AuthorizationHandlerContext, requirement: TRequirement): Unit
}

public abstract class AuthorizationResourceHandler<TRequirement, TResource> <: IAuthorizationHandler where TRequirement <: IAuthorizationRequirement {
    public func handle(context: AuthorizationHandlerContext): Unit {
        if (let resource: TResource <- context.resource) {
            for (pattern in context.requirements |> filterMap {f => f as TRequirement}) {
                handleRequirement(context, pattern, resource)
            }
        }
    }

    protected func handleRequirement(context: AuthorizationHandlerContext, requirement: TRequirement,
        resource: TResource): Unit
}
