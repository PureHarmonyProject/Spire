// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_configuration

import std.io.{IOStream}
import std.collection.*

/*
配置构建接口
 */
public interface IConfigurationBuilder {
    prop sources: List<IConfigurationSource>
    prop properties: Map<String, Any>
    func add(source: IConfigurationSource): IConfigurationBuilder
    func build(): IConfigurationRoot
}
