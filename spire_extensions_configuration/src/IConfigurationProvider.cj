// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.reflect.*

/*
配置源
 */
public interface IConfigurationProvider <: ToString{
    func load(): Unit
    func get(key: String): ?String
    func set(key: String, value: ?String): Unit
    func getChildKeys(earlierKeys: Iterable<String>, parentPath: ?String): Iterable<String>
    func toString() {
        "${TypeInfo.of(this).name}"
    }
}
