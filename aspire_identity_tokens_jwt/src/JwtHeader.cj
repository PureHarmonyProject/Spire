// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_identity_tokens_jwt

import std.collection.*
import stdx.encoding.json.*
import aspire_identity_tokens.*

public class JwtHeader <: JwtContent {
    private let _signingCredentials: SigningCredentials

    public init(signingCredentials: SigningCredentials, outboundAlgorithmMap: Collection<(String, Any)>) {
        _signingCredentials = signingCredentials
        add(all: outboundAlgorithmMap)
        addFirstPriorityClaims()
    }

    public init(signingCredentials: SigningCredentials) {
        this(signingCredentials, [])
    }

    public prop typ: String {
        get() {
            "JWT"
        }
    }

    public prop alg: String {
        get() {
            _signingCredentials.algorithm
        }
    }

    public prop kid: ?String {
        get() {
            _signingCredentials.key.keyId
        }
    }

    private func addFirstPriorityClaims() {
        this["alg"] = alg
        this["typ"] = typ
        if (let Some(kid) <- signingCredentials.key.keyId) {
            this["kid"] = kid
        }
    }

    public prop signingCredentials: SigningCredentials {
        get() {
            _signingCredentials
        }
    }
}
