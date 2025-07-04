// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_options

class ConfigureAfterOptions<TOptions> <: IConfigureAfterOptions<TOptions> where TOptions <: Object {
    private let _name: String
    private let _configure: (TOptions) -> Unit

    init(name: String, configure: (TOptions) -> Unit) {
        _name = name
        _configure = configure
    }

    public func configureAfter(name: String, options: TOptions) {
        if (name == _name) {
            _configure(options)
        }
    }
}