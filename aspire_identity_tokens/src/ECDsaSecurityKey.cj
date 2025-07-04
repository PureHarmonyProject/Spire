// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_identity_tokens

import std.convert.*
import std.collection.*
import stdx.crypto.keys.*
import stdx.encoding.base64.*

public class ECDsaSecurityKey <: AsymmetricSecurityKey {
    private let _publicKey: ?ECDSAPublicKey
    private let _privateKey: ?ECDSAPrivateKey

    public init(publicKey!: ?ECDSAPublicKey = None, privateKey!: ?ECDSAPrivateKey = None) {
        _publicKey = publicKey
        _privateKey = privateKey
    }

    public prop publicKey: ?ECDSAPublicKey {
        get() {
            _publicKey
        }
    }

    public prop privateKey: ?ECDSAPrivateKey {
        get() {
            _privateKey
        }
    }

    public prop keySize: Int64 {
        get() {
            0
        }
    }

    public prop keyId: ?String {
        get() {
            None
        }
    }

    public func exportParameters(): ?ECParameters {
        if (let Some(key) <- _publicKey) {
            let body = key.encodeToDer().body
            let parameters = AsnParser.parse(body).toHashMap()
            let bitStringData = parameters["00:03:1"]
            let coordinateSize = (bitStringData.size - 2) / 2
            let x = bitStringData[2..coordinateSize + 2]
            let y = bitStringData[coordinateSize + 2..bitStringData.size]
            return ECParameters(ECPoint(x, y))
        }

        return None
    }
}
