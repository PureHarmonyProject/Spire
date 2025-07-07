// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.collection.*

public class ConfigurationBuilder <: IConfigurationBuilder {
    private let _properties = HashMap<String, Any>()
    private let _sources = ArrayList<IConfigurationSource>()
    private let _providers = ArrayList<IConfigurationProvider>()

    public prop sources: List<IConfigurationSource> {
        get() {
            _sources
        }
    }
    
    public prop properties: Map<String, Any> {
        get() {
            _properties
        }
    }

    public func add(source: IConfigurationSource): IConfigurationBuilder {
        let provider = source.build(this)
        provider.load()
        _sources.add(source)
        _providers.add(provider)
        return this
    }

    public func build(): IConfigurationRoot {
        return ConfigurationRoot(_providers)
    }
}