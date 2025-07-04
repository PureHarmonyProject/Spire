// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_options

class OptionsMonitor<TOptions> <: IOptionsMonitor<TOptions> where TOptions <: Object {
    private let _optionsFactory: IOptionsFactory<TOptions>

    public init(optionsFactory: IOptionsFactory<TOptions>) {
        _optionsFactory = optionsFactory
    }

    public func get(name: String): TOptions {
        _optionsFactory.create(name)
    }

    public prop currentValue: TOptions {
        get() {
            get(Options.defaultName)
        }
    }
}
