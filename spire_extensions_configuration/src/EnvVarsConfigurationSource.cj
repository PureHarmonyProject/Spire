// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.env.*
import std.reflect.*
import std.unicode.*
import std.collection.*

class EnvVarsConfigurationProvider <: ConfigurationProvider {
    private let _prefix: String
    private let _normalizedPrefix: String

    init(prefix: String) {
        _prefix = prefix
        _normalizedPrefix = normalize(prefix)
    }

    public func toString() {
        "${ClassTypeInfo.of(this).name} Prefix: '${_prefix}'"
    }

    public override func load() {
        for ((name, value) in getVariables()) {
            addIfNormalizedKeyMatchesPrefix(normalize(name), value)
        }
    }

    private func addIfNormalizedKeyMatchesPrefix(normalizedKey: String, value: String) {
        if (normalizedKey.startsWithIgnoreAsciiCase(_normalizedPrefix)) {
            data.add(normalizedKey[_normalizedPrefix.size..], value)
        }
    }

    private static func normalize(key: String) {
        return key.replace("__", ConfigurationPath.delimiter)
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
    public func addEnvVars(prefix: String) {
        add(EnvVarsConfigurationSource(prefix))
        return this
    }
}

extend ConfigurationBuilder {
    public func addEnvVars(prefix: String) {
        add(EnvVarsConfigurationSource(prefix))
        return this
    }
}
