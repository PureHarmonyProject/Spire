// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

import spire_extensions_injection.*

private let DefaultValidationFailureMessage = "A validation error has occurred."

public class OptionsBuilder<TOptions> where TOptions <: Object {
    OptionsBuilder(let name: String, let services: ServiceCollection) {
    }

    public func configure(configureOptions: (TOptions) -> Unit) {
        configure {
            options, _ => configureOptions(options)
        }
        return this
    }

    public func configure(configureOptions: (TOptions, IServiceProvider) -> Unit) {
        services.configure(name, configureOptions)
        return this
    }

    public func configureAfter(configureOptions: (TOptions) -> Unit) {
        configureAfter {
            options, _ => configureOptions(options)
        }
        return this
    }

    public func configureAfter(configureOptions: (TOptions, IServiceProvider) -> Unit) {
        services.configureAfter(name, configureOptions)
        return this
    }

    public func validate(validation: (TOptions) -> Bool) {
        validate {
            options, _ => validation(options)
        }
        return this
    }

    public func validate(validation: (TOptions, IServiceProvider) -> Bool) {
        services.addSingleton<IValidateOptions<TOptions>, ValidateOptions<TOptions>> {
            sp => ValidateOptions<TOptions>(name, sp, validation, DefaultValidationFailureMessage)
        }
        return this
    }
}
