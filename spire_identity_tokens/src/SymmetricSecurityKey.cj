// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens

public class SymmetricSecurityKey <: SecurityKey {
    private let _key: Array<Byte>

    public init(key: Array<Byte>) {
        _key = key
    }

    public prop key: Array<Byte> {
        get() {
            _key
        }
    }

    public prop keyId: ?String {
        get() {
            None
        }
    }

    public prop keySize: Int64 {
        get() {
            _key.size
        }
    }
}
