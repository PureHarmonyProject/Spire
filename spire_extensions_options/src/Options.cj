// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

public abstract class Options {
    public static let defaultName = String.empty

    public static func create<TOptions>(options: TOptions): IOptions<TOptions> where  TOptions <: Object {
        return OptionsWrapper<TOptions>(options)
    }
}
