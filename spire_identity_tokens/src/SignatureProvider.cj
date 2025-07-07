// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens

import std.reflect.*
import stdx.encoding.hex.*
import stdx.crypto.digest.*

public abstract class SignatureProvider {
    private let _key: SecurityKey
    private let _algorithm: String

    protected init(key: SecurityKey, algorithm: String) {
        _key = key
        _algorithm = algorithm
    }

    public prop key: SecurityKey {
        get() {
            _key
        }
    }

    public prop algorithm: String {
        get() {
            _algorithm
        }
    }

    public func sign(input: Array<Byte>): Array<Byte>

    public func verify(input: Array<Byte>, signature: Array<Byte>): Bool
}


