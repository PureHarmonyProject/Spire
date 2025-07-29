// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

import spire_extensions_injection.*

public class ConfigureAfterOptions<TOptions> <: IConfigureAfterOptions<TOptions> where TOptions <: Object {
    public ConfigureAfterOptions(public let name: ?String, public let services: IServiceProvider,
        public let action: (TOptions, IServiceProvider) -> Unit) {
    }

    public func configureAfter(name: ?String, options: TOptions) {
        if (this.name.isNone() || this.name == name) {
            action(options, services)
        }
    }
}
