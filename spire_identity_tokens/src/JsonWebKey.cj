// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_identity_tokens

import std.collection.*
import stdx.encoding.json.*
import stdx.serialization.serialization.*

public class JsonWebKey <: SecurityKey {
    public prop keyId: ?String {
        get() {
            kid
        }
    }

    public prop keySize: Int64 {
        get() {
            if (kty == "RSA" && let Some(data) <- n.flatMap {f => Base64UrlEncoder.decode(f)}) {
                return data.size * 8
            }

            if (kty == "EC" && let Some(data) <- x.flatMap {f => Base64UrlEncoder.decode(f)}) {
                return data.size * 8
            }

            if (kty == "oct" && let Some(data) <- k.flatMap {f => Base64UrlEncoder.decode(f)}) {
                return data.size * 8
            }

            return 0
        }
    }

    public JsonWebKey(public var e!: ?String = None, public var k!: ?String = None, public var n!: ?String = None,
        public var d!: ?String = None, public var x!: ?String = None, public var y!: ?String = None,
        public var p!: ?String = None, public var q!: ?String = None, public var qi!: ?String = None,
        public var dp!: ?String = None, public var dq!: ?String = None, public var kid!: ?String = None,
        public var x5c!: ?String = None, public var x5t!: ?String = None, public var x5u!: ?String = None,
        public var crv!: ?String = None, public var kty!: ?String = None, public var use!: ?String = None,
        public var alg!: ?String = None, public var x5tS256!: ?String = None) {
    }

    public static func create(json: String) {
        let jsonWebKey = JsonWebKey()
        JsonWebKeySerializer.read(json, jsonWebKey)
        return jsonWebKey
    }
}
