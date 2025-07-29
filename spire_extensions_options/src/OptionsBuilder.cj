// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

import spire_extensions_injection.*

public class OptionsBuilder<TOptions> where TOptions <: Object {
    OptionsBuilder(let services: ServiceCollection) {
    }

    public func configure(configureOptions: (TOptions) -> Unit) {
        services.configure(configureOptions)
    }

    public func configure(name: String, configureOptions: (TOptions) -> Unit) {
        services.configure(name, configureOptions)
    }

    public func configureAfter(configureOptions: (TOptions) -> Unit) {
        services.configureAfter(configureOptions)
    }

    public func configureAfter(name: String, configureOptions: (TOptions) -> Unit) {
        services.configureAfter(name, configureOptions)
    }

    public func validate(validation: (TOptions) -> Bool) {
        services.addSingleton<IValidateOptions<TOptions>, ValidateOptions<TOptions>>()
    }
}
