// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.collection.*

public abstract class ConfigurationProvider <: IConfigurationProvider {
    private let _data = IgnoreCaseHashMap<?String>()

    protected prop data: Map<String, ?String> {
        get() {
            _data
        }
    }

    public open func get(key: String): ?String {
        if (_data.contains(key)) {
            return _data[key]
        }
        return None
    }

    public open func set(key: String, value: ?String): Unit {
        _data[key] = value
    }

    public open func getChildKeys(earlierKeys: Iterable<String>, parentPath: ?String): Iterable<String> {
        let results = HashSet<String>()
        if (let Some(parentPath) <- parentPath) {
            for (pattern in data.keys()) {
                if (pattern.size > parentPath.size && pattern.startsWith(parentPath) &&
                    pattern[parentPath.size..parentPath.size + 1] == ConfigurationPath.delimiter) {
                    results.add(segment(pattern, parentPath.size + 1))
                }
            }
        } else {
            for (pattern in data.keys()) {
                results.add(segment(pattern, 0))
            }
        }
        results.add(all: earlierKeys |> collectArray)
        return results
    }

    private static func segment(key: String, prefixLength: Int64): String {
        if (let Some(index) <- key.indexOf(ConfigurationPath.delimiter, prefixLength)) {
            return key[prefixLength..index]
        }
        return key[prefixLength..]
    }

    public open func load(): Unit {
    }
}
