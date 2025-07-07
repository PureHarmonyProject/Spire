// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens

import std.reflect.*
import stdx.encoding.hex.*
import stdx.crypto.digest.*

public class SymmetricSignatureProvider <: SignatureProvider {
    public init(key: SecurityKey, algorithm: String) {
        super(key, algorithm)
    }

    public func sign(input: Array<Byte>): Array<Byte> {
        let hmac = createHmacInstance()
        hmac.write(input)
        return hmac.finish()
    }

    public func verify(input: Array<Byte>, signature: Array<Byte>): Bool {
        return sign(input) == signature
    }

    private func createHmacInstance() {
        if (let symmetricSecurityKey: SymmetricSecurityKey <- this.key) {
            if (algorithm == SecurityAlgorithms.HmacSha256) {
                return HMAC(symmetricSecurityKey.key, HashType.SHA256)
            }
            if (algorithm == SecurityAlgorithms.HmacSha384) {
                return HMAC(symmetricSecurityKey.key, HashType.SHA384)
            }
            if (algorithm == SecurityAlgorithms.HmacSha512) {
                return HMAC(symmetricSecurityKey.key, HashType.SHA512)
            }
        }
        throw UnsupportedException()
    }
}
