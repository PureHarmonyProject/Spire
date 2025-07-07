// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_cors

import spire_web_http.*
import spire_extensions_options.*

class CorsPolicyProvider <: ICorsPolicyProvider {
    private let _options: CorsOptions

    public init(options: IOptions<CorsOptions>) {
        _options = options.value
    }

    public func getPolicy(_: HttpContext, policyName: ?String): ?CorsPolicy {
        let name = policyName ?? _options.defaultPolicyName

        if (let Some(policy) <- _options.policyMap.get(name)) {
            return policy
        }

        return None
    }
}
