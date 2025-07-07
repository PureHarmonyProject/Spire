// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authorization

import spire_extensions_options.*

public class DefaultAuthorizationPolicyProvider <: IAuthorizationPolicyProvider {
    private let _options : AuthorizationOptions
    private var _cachedDefaultPolicy: ?AuthorizationPolicy = None
    private var _cachedFallbackPolicy: ?AuthorizationPolicy = None

    public init(options: IOptions<AuthorizationOptions>) {
        _options = options.value
    }

    public func getPolicy(policyName: String): ?AuthorizationPolicy {
        _options.getPolicy(policyName)
    }

    
    public func getDefaultPolicy(): ?AuthorizationPolicy {
        if (_cachedDefaultPolicy.isNone() || _cachedDefaultPolicy.flatMap{f => !refEq(f, _options.defaultPolicy)} == Some(true)) {
            _cachedDefaultPolicy =  _options.defaultPolicy
        }
        _cachedDefaultPolicy
    }
    
    public func getFallbackPolicy(): ?AuthorizationPolicy {

        let hasCached = match ((_cachedFallbackPolicy, _options.fallbackPolicy)) {
            case (Some(a), Some(b)) => refEq(a, b)
            case _ => false
        }
       
        if (_cachedFallbackPolicy.isNone() || !hasCached) {
            _cachedFallbackPolicy = _options.fallbackPolicy
        }
        _cachedFallbackPolicy
    }
}