// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_identity_tokens

import stdx.crypto.keys.*

public struct ECParameters {
    public ECParameters(public let q: ECPoint) {
    }
}

public struct ECPoint {
    public ECPoint(
        public let x: Array<Byte>,
        public let y: Array<Byte>) {
    }
}
