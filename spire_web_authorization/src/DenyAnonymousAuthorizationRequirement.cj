// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authorization

import std.collection.*

public class DenyAnonymousAuthorizationRequirement 
    <: AuthorizationHandler<DenyAnonymousAuthorizationRequirement> & IAuthorizationRequirement {
    protected func handleRequirement(context: AuthorizationHandlerContext,
        requirement: DenyAnonymousAuthorizationRequirement) {
        var user = context.user
        var isAuthenticated = user.identies |> any {i => i.isAuthenticated}
        if (isAuthenticated) {
            context.succeed(requirement)
        }
    }

    public func toString() {
        "DenyAnonymousAuthorizationRequirement: Requires an authenticated user."
    }
}
