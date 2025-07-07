// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authorization

import spire_identity_claims.*

public interface IAuthorizationService {
    func authorize(user: ClaimsPrincipal, resource: ?Object, policyName: String): AuthorizationResult
   
    func authorize(user: ClaimsPrincipal, resource: ?Object, requirements: Collection<IAuthorizationRequirement>): AuthorizationResult

    func authorize(user: ClaimsPrincipal, resource: ?Object, policy: AuthorizationPolicy): AuthorizationResult {
        this.authorize(user, resource, policy.requirements)
    }

    func authorize(user: ClaimsPrincipal, policy: AuthorizationPolicy): AuthorizationResult {
        this.authorize(user, None, policy)
    }

    func authorize(user: ClaimsPrincipal, policyName: String): AuthorizationResult {
        this.authorize(user, None, policyName)
    }
}
