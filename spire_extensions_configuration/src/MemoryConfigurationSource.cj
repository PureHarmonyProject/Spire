// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.process.*
import std.collection.*

class MemoryConfigurationProvider <: ConfigurationProvider {
    private let _values: HashMap<String, String>

    init(values: HashMap<String, String>) {
        _values = values
    }

    public override func load() {
        for ((key, value) in _values) {
            data[key] = value
        }
    }
}

class MemoryConfigurationSource <: IConfigurationSource {
    private let _values: HashMap<String, String>
    
    init(values: HashMap<String, String>) {
        _values = values
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = MemoryConfigurationProvider(_values)
        return provider
    }
}

extend ConfigurationManager {
    public func addMemory(values: Collection<(String, String)>): IConfigurationBuilder {
        add(MemoryConfigurationSource(HashMap<String, String>(values)))
        return this
    }
}
