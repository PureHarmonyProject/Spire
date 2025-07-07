// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.env.*
import std.unicode.*
import std.collection.*

class EnvVarsConfigurationProvider <: ConfigurationProvider {
    private let _prefix: String

    init(prefix: String) {
        _prefix = prefix
    }

    public override func load() {
        let prefix = "${_prefix.toLower()}_"
        for ((key, value) in getVariables()) {
            var name = key.toLower()
            if (!name.startsWith(prefix)) {
                continue
            }
            name = name.removePrefix(prefix)
            name = camelCase(name, '_')
            data.add(name, value)
        }
    }
}

class EnvVarsConfigurationSource <: IConfigurationSource {
    private let _prefix: String

    init(prefix: String) {
        _prefix = prefix
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = EnvVarsConfigurationProvider(_prefix)
        return provider
    }
}

extend ConfigurationManager {
    public func addEnvVars(prefix: String): IConfigurationBuilder {
        add(EnvVarsConfigurationSource(prefix))
        return this
    }
}
