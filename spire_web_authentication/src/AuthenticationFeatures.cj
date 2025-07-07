// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication

import spire_identity_claims.*

public class AuthenticationFeatures <: IAuthenticateResultFeature & IHttpAuthenticationFeature {
    private var _result: AuthenticateResult

    public init(result: AuthenticateResult) {
        _result = result
    }

    public mut prop result: AuthenticateResult {
        get() {
            _result
        }
        set(value) {
            _result = value
        }
    }

    public prop user: ?ClaimsPrincipal {
        get() {
            _result.principal
        }
    }
}
