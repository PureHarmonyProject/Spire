// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authorization

import spire_web_http.*
import spire_web_authentication.*

public class DefaultAuthorizationMiddlewareResultHandler <: IAuthorizationMiddlewareResultHandler {
    public func handle(next: () -> Unit, context: HttpContext, policy: AuthorizationPolicy,
        authorizeResult: PolicyAuthorizationResult): Unit {
        if (authorizeResult.succeeded) {
            next()
            return
        } else if (authorizeResult.challenged) { //401
            if (policy.authenticationSchemes.size > 0) {
                for (pattern in policy.authenticationSchemes) {
                    context.challenge(pattern)
                }
            } else {
                context.challenge()
            }
        } else if (authorizeResult.forbidden) {
            if (policy.authenticationSchemes.size > 0) {
                for (pattern in policy.authenticationSchemes) {
                    context.forbid(pattern)
                }
            } else {
                context.forbid()
            }
        }
    }
}
