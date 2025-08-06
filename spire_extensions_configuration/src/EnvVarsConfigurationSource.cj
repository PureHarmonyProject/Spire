// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.env.*
import std.unicode.*
import std.collection.*

/// 专门用于环境变量的配置提供者，支持不区分大小写的键访问
class EnvVarsConfigurationProvider <: IConfigurationProvider {
    private let _prefix: String
    private let _data = CaseInsensitiveHashMap<String>()

    init(prefix: String) {
        _prefix = prefix
    }

    public func load(): Unit {
        let prefix = "${_prefix.toAsciiLower()}_"
        for ((key, value) in getVariables()) {
            var name = key.toAsciiLower()
            if (!name.startsWith(prefix)) {
                continue
            }
            // 保持原始格式，只移除前缀，不进行驼峰转换
            name = name.removePrefix(prefix)
            // 将下划线替换为冒号，保持config:port格式
            name = name.replace("_", ":")
            _data.set(name, value)
        }
    }

    public func get(key: String): ?String {
        return _data.get(key)
    }

    public func set(key: String, value: ?String): Unit {
        if (let Some(v) <- value) {
            _data.set(key, v)
        }
    }

    public func getChildKeys(earlierKeys: Iterable<String>, parentPath: ?String): Iterable<String> {
        return _data.getChildKeys(earlierKeys, parentPath)
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
