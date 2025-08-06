// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.collection.*

public abstract class ConfigurationProvider <: IConfigurationProvider {
    private let _data = CaseInsensitiveHashMap<?String>()

    protected prop data: CaseInsensitiveHashMap<?String> {
        get() {
            _data
        }
    }

    public open func get(key: String): ?String {
        if (let Some(optionValue) <- _data.get(key)) {
            return optionValue
        }
        return None
    }

    public open func set(key: String, value: ?String): Unit {
        _data[key] = value
    }

    public open func getChildKeys(earlierKeys: Iterable<String>, parentPath: ?String): Iterable<String> {
        return data.getChildKeys(earlierKeys, parentPath)
    }

    public open func load(): Unit {

    }
}
