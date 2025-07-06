// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.


package aspire_web_cors

import std.collection.*

public class CorsOptions {
    internal let policyMap = HashMap<String, CorsPolicy>()
    private static let _defaultPolicyName = "__DefaultCorsPolicy"

    public prop defaultPolicyName: String {
        get() {
            _defaultPolicyName
        }
    }

    public func addDefaultPolicy(policy: CorsPolicy) {
        addPolicy(defaultPolicyName, policy)
    }

    public func addDefaultPolicy(configurePolicy: (CorsPolicyBuilder)-> Unit) {
        addPolicy(defaultPolicyName, configurePolicy)
    }

    public func addPolicy(name: String, configurePolicy: (CorsPolicyBuilder) -> Unit) {
        let policyBuilder = CorsPolicyBuilder()
        configurePolicy(policyBuilder)
        let policy = policyBuilder.build()
        addPolicy(name, policy)
    }

    public func addPolicy(name: String, policy: CorsPolicy) {
        policyMap[name] = policy
    }

    public func getPolicy(name: String) {
        policyMap.get(name)
    }
}