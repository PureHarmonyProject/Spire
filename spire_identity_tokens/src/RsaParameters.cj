// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens

import stdx.crypto.keys.*

public struct RsaParameters {

    public RsaParameters(
        public let d!: ?Array<Byte> = None,
        public let dp!: ?Array<Byte> = None,
        public let dq!: ?Array<Byte> = None,
        public let exponent!: ?Array<Byte> = None,
        public let inverseQ!: ?Array<Byte> = None,
        public let modulus!: ?Array<Byte> = None,
        public let p!: ?Array<Byte> = None,
        public let q!: ?Array<Byte> = None) {
    }    
}
