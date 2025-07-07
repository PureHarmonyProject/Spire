// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_hosting

import std.reflect.*
import std.collection.*
import spire_web_http.*

class FeatureCollection <: IFeatureCollection {
    private let _items = HashMap<TypeInfo, Any>()

    public func get<T>(): ?T {
        let typeInfo = TypeInfo.of<T>()
        if (_items.contains(typeInfo)) {
            return _items[typeInfo] as T
        }
        return None
    }

    public func set<T>(value: T) {
        let typeInfo = TypeInfo.of<T>()
        _items[typeInfo] = value
    }

    public func iterator() {
        _items.iterator()
    }
}
