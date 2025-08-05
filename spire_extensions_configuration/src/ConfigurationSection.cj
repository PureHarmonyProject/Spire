// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.collection.*

class ConfigurationSection <: IConfigurationSection {
    private let _path: String
    private let _key: String
    private let _value: ?String
    private let _root: IConfigurationRoot

    init(path: String, key: String, value: ?String, root: IConfigurationRoot) {
        _path = path
        _key = key
        _value = value
        _root = root
    }

    public prop key: String {
        get() {
            _key
        }
    }

    public prop value: ?String {
        get() {
            _value
        }
    }

    public prop path: String {
        get() {
            _path
        }
    }

    public operator func [](key: String) {
        return _root[ConfigurationPath.combine(_path, key)]
    }

    public operator func [](key: String, value!: ?String) {
        _root[ConfigurationPath.combine(_path, key)] = value
    }

    public func getSection(key: String): IConfigurationSection {
        return ConfigurationSection(ConfigurationPath.combine(_path, key), key, this[key], _root)
    }

    public func getChildren(): Collection<IConfigurationSection> {
        let items = ArrayList<IConfigurationSection>()
        for (key in getChildKeys(_root, _path)) {
            let section = getSection(key)
            items.add(section)
        }
        return items |> collectArray
    }
}
