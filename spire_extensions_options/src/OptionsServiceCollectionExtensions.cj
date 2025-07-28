// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

import spire_extensions_injection.*

public interface OptionsServiceCollectionExtensions {
    func addOptions<TOptions>(): OptionsBuilder<TOptions> where TOptions <: Object
    func configure<TOptions>(configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object
    func configure<TOptions>(name: String, configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object
    func configureAfter<TOptions>(configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object
    func configureAfter<TOptions>(name: String, configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object
}

extend ServiceCollection <: OptionsServiceCollectionExtensions {
    public func addOptions<TOptions>() where TOptions <: Object {
        tryAddSingleton<IOptions<TOptions>, UnnamedOptionsManager<TOptions>>()
        
        tryAddSingleton<IOptionsMonitor<TOptions>, OptionsMonitor<TOptions>>()

        tryAddSingleton<IOptionsFactory<TOptions>, OptionsFactory<TOptions>>{sp => 
            let configures = sp.getAll<IConfigureOptions<TOptions>>()
            let configureAfters = sp.getAll<IConfigureAfterOptions<TOptions>>()
            return OptionsFactory<TOptions>(configures, configureAfters)
        }

        tryAddSingleton<IOptionsMonitorCache<TOptions>, OptionsCache<TOptions>>()

        return OptionsBuilder<TOptions>()
    }

    public func configure<TOptions>(configureOptions: (TOptions) -> Unit) where TOptions <: Object {
        configure(Options.defaultName, configureOptions)
        return this
    }
     
    public func configureAfter<TOptions>(configureOptions: (TOptions) -> Unit) where TOptions <: Object {
        configureAfter(Options.defaultName, configureOptions)
        return this
    }

    public func configure<TOptions>(name: String, configureOptions: (TOptions) -> Unit) where TOptions <: Object {
        addOptions<TOptions>()
        addSingleton<IConfigureOptions<TOptions>, ConfigureNamedOptions<TOptions>>(ConfigureNamedOptions<TOptions>(name, configureOptions))
        return this
    }

    public func configureAfter<TOptions>(name: String, configureOptions: (TOptions) -> Unit) where TOptions <: Object {
        addOptions<TOptions>()
        this.addSingleton<IConfigureAfterOptions<TOptions>, ConfigureAfterOptions<TOptions>>(ConfigureAfterOptions<TOptions>(name, configureOptions))
        return this
    }
}
