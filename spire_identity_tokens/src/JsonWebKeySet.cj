// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens

import std.collection.*
import stdx.serialization.serialization.*

public class JsonWebKeySet {
    private let _keys: ArrayList<JsonWebKey>

    public init() {
        this(ArrayList<JsonWebKey>())
    }

    public init(keys: Collection<JsonWebKey>) {
        _keys = ArrayList<JsonWebKey>(keys)
    }

    public prop keys: List<JsonWebKey> {
        get() {
            _keys
        }
    }

    public static func create(json: String) {
        let set = JsonWebKeySet()
        JsonWebKeySetSerializer.read(json, set)
        return set
    }
}
