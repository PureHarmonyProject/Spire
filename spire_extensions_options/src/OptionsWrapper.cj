// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

public class OptionsWrapper<TOptions> <: IOptions<TOptions> where TOptions <: Object {
    private let _value: TOptions
    
    public init(options: TOptions) {
        _value = options
    }

    public prop value: TOptions {
        get() {
            _value
        }
    }
}