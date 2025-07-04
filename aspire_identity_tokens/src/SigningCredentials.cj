// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_identity_tokens

import stdx.crypto.x509.*
import stdx.crypto.keys.*

public class SigningCredentials {
    private let _key: SecurityKey
    private let _algorithm: String

    public init(key: SecurityKey, algorithm: String) {
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
}
