// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authorization

public class DefaultAuthorizationEvaluator <: IAuthorizationEvaluator {
    public func evaluate(context: AuthorizationHandlerContext) {
        if (context.hasSucceeded) {
            return AuthorizationResult.success()
        } else {
            let failure = if (context.hasFailed) {
                AuthorizationFailure.failed(context.failedReasons)
            } else {
                AuthorizationFailure.failed(context.pendingRequirements)
            }
            return AuthorizationResult.failed(failure)
        }
    }
}
