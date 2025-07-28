// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_hosting

import std.collection.*

public interface IHostBuilder {
    prop logging: LoggingBuilder
    prop services: ServiceCollection
    prop environment: IHostEnvironment
    prop properties: HashMap<String, Any>
    prop configuration: ConfigurationManager
}