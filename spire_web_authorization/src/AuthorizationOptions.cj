// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authorization

import std.collection.*

public class AuthorizationOptions {
    private var _defaultPolicy: AuthorizationPolicy
    private let _policyMap = HashMap<String, AuthorizationPolicy>()

    public init() {
        _defaultPolicy = AuthorizationPolicyBuilder()
            .requireAuthenticatedUser()
            .build()
    }

    public var invokeHandlersAfterFailure = false

    public var fallbackPolicy: ?AuthorizationPolicy = None

    public var suppressUseHttpContextAsAuthorizationResource = false

    public prop policyMap: HashMap<String, AuthorizationPolicy> {
        get() {
            _policyMap
        }
    }

    public mut prop defaultPolicy: AuthorizationPolicy {
        get() {
            _defaultPolicy
        }
        set(value) {
            _defaultPolicy = value
        }
    }

    public func addPolicy(name: String, policy: AuthorizationPolicy) {
        _policyMap.add(name, policy)
    }

    public func addPolicy(name: String, configurePolicy: (AuthorizationPolicyBuilder) -> Unit) {
        let builder = AuthorizationPolicyBuilder()
        configurePolicy(builder)
        _policyMap[name] = builder.build()
    }

    public func getPolicy(name: String): ?AuthorizationPolicy {
        _policyMap.get(name)
    }
}
