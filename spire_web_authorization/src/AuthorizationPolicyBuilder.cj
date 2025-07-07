// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authorization

import std.collection.*
import spire_identity_claims.*

public class AuthorizationPolicyBuilder {
    private let _authenticationSchemes = ArrayList<String>()
    private let _requirements = ArrayList<IAuthorizationRequirement>()
    private static let _denyAnonymousAuthorizationRequirement = DenyAnonymousAuthorizationRequirement()

    public init(authenticationSchemes: Array<String>) {
        addAuthenticationSchemes(authenticationSchemes)
    }

    public init(policy: AuthorizationPolicy) {
        combine(policy)
    }

    public prop requirements: List<IAuthorizationRequirement> {
        get() {
            _requirements
        }
    }

    public prop authenticationSchemes: List<String> {
        get() {
            _authenticationSchemes
        }
    }

    public func combine(policy: AuthorizationPolicy) {
        addAuthenticationSchemesCore(policy.authenticationSchemes)
        addRequirementsCore(policy.requirements)
        return this
    }

    public func requireClaim(claimName: String, allowedValues: Array<String>) {
        requirements.add(ClaimsAuthorizationRequirement(claimName, allowedValues))
        return this
    }

    public func requireClaim(claimName: String) {
        requirements.add(ClaimsAuthorizationRequirement(claimName))
        return this
    }

    public func requireRole(roles: Array<String>) {
        requirements.add(ClaimsAuthorizationRequirement(ClaimNames.Role, roles))
        return this
    }

    public func requireName(roles: Array<String>) {
        requirements.add(ClaimsAuthorizationRequirement(ClaimNames.Name, roles))
        return this
    }

    public func requireAuthenticatedUser() {
        requirements.add(_denyAnonymousAuthorizationRequirement)
        return this
    }

    public func addRequirements(requirements: Array<IAuthorizationRequirement>) {
        return addRequirementsCore(requirements)
    }

    public func addAuthenticationSchemes(schemes: Array<String>) {
        return addAuthenticationSchemesCore(schemes)
    }

    public func build() {
        return AuthorizationPolicy(_requirements, _authenticationSchemes)
    }

    private func addRequirementsCore(requirements: Collection<IAuthorizationRequirement>) {
        for (pattern in requirements) {
            _requirements.add(pattern)
        }
        return this
    }

    private func addAuthenticationSchemesCore(schemes: Collection<String>) {
        for (pattern in schemes) {
            _authenticationSchemes.add(pattern)
        }
        return this
    }
}
