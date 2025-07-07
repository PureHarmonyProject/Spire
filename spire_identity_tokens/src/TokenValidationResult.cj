// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens

import spire_identity_claims.*

public class TokenValidationResult {
    private TokenValidationResult(
        public let identity!: ClaimsIdentity,
        public let securityToken!: ?SecurityToken = None,
        public let exception!: ?Exception = None) {
    }

    public static func success(identity: ClaimsIdentity, securityToken: SecurityToken) {
        TokenValidationResult(identity: identity, securityToken: securityToken)
    }

    public static func failed(exception: Exception) {
        TokenValidationResult(identity: ClaimsIdentity(), exception: exception)
    }

    public prop isValid: Bool {
        get() {
            exception.isNone()
        }
    }
}
