// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens
import std.unicode.UnicodeStringExtension

import stdx.crypto.x509.*
import stdx.encoding.hex.*
import stdx.crypto.digest.*

extend X509Certificate{
    /*
    计算证书指纹
    */
    public func getThumbprint() {
        let hasher = SHA1()
        hasher.write(this.encodeToDer().body)
        let hash = hasher.finish()
        return toHexString(hash).toUpper()
    }

    public func getX5t() {
        let hasher = SHA1()
        hasher.write(this.encodeToDer().body)
        let hash = hasher.finish()
        return Base64UrlEncoder.encode(hash)
    }
}