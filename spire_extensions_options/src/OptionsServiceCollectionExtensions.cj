// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

import spire_extensions_injection.*

public interface OptionsServiceCollectionExtensions {
    func addOptions<TOptions>(): OptionsBuilder<TOptions> where TOptions <: Object {
        addOptions<TOptions>(Options.defaultName)
    }

    func addOptions<TOptions>(name: String): OptionsBuilder<TOptions> where TOptions <: Object
    func configure<TOptions>(configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object {
        configure(Options.defaultName, configureOptions)
    }

    func configure<TOptions>(name: String, configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object {
        configure<TOptions>(name) {
            options, _ => configureOptions(options)
        }
    }

    func configureAfter<TOptions>(configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object {
        configureAfter<TOptions>(Options.defaultName, configureOptions)
    }

    func configureAfter<TOptions>(name: String, configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object {
        configureAfter<TOptions>(name) {
            options, _ => configureOptions(options)
        }
    }

    func configure<TOptions>(configureOptions: (TOptions, IServiceProvider) -> Unit): ServiceCollection where TOptions <: Object
    func configure<TOptions>(name: String, configureOptions: (TOptions, IServiceProvider) -> Unit): ServiceCollection where TOptions <: Object
    func configureAfter<TOptions>(configureOptions: (TOptions, IServiceProvider) -> Unit): ServiceCollection where TOptions <: Object
    func configureAfter<TOptions>(name: String, configureOptions: (TOptions, IServiceProvider) -> Unit): ServiceCollection where TOptions <: Object
    func configureAll<TOptions>(configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object {
        configureAll<TOptions> {
            options, _ => configureOptions(options)
        }
    }

    func configureAll<TOptions>(configureOptions: (TOptions, IServiceProvider) -> Unit): ServiceCollection where TOptions <: Object
    func configureAfterAll<TOptions>(configureOptions: (TOptions) -> Unit): ServiceCollection where TOptions <: Object {
        configureAfterAll<TOptions> {
            options, _ => configureOptions(options)
        }
    }

    func configureAfterAll<TOptions>(configureOptions: (TOptions, IServiceProvider) -> Unit): ServiceCollection where TOptions <: Object
}

extend ServiceCollection <: OptionsServiceCollectionExtensions {
    public func addOptions<TOptions>(name: String) where TOptions <: Object {
        tryAddSingleton<IOptions<TOptions>, UnnamedOptionsManager<TOptions>>()

        tryAddSingleton<IOptionsMonitor<TOptions>, OptionsMonitor<TOptions>>()

        tryAddSingleton<IOptionsFactory<TOptions>, OptionsFactory<TOptions>> {
            sp =>
            let configures = sp.getAll<IConfigureOptions<TOptions>>()
            let configureAfters = sp.getAll<IConfigureAfterOptions<TOptions>>()
            let validations = sp.getAll<IValidateOptions<TOptions>>()
            return OptionsFactory<TOptions>(configures, configureAfters, validations)
        }

        tryAddSingleton<IOptionsMonitorCache<TOptions>, OptionsCache<TOptions>>()

        return OptionsBuilder<TOptions>(name, this)
    }

    public func configure<TOptions>(configureOptions: (TOptions, IServiceProvider) -> Unit) where TOptions <: Object {
        configure(Options.defaultName, configureOptions)
        return this
    }

    public func configureAfter<TOptions>(configureOptions: (TOptions, IServiceProvider) -> Unit) where TOptions <: Object {
        configureAfter(Options.defaultName, configureOptions)
        return this
    }

    public func configure<TOptions>(name: String, configureOptions: (TOptions, IServiceProvider) -> Unit) where TOptions <: Object {
        addOptions<TOptions>()
        addSingleton<IConfigureOptions<TOptions>, ConfigureNamedOptions<TOptions>> {
            services => ConfigureNamedOptions<TOptions>(name, services, configureOptions)
        }
        return this
    }

    public func configureAfter<TOptions>(name: String, configureOptions: (TOptions, IServiceProvider) -> Unit) where TOptions <: Object {
        addOptions<TOptions>()
        this.addSingleton<IConfigureAfterOptions<TOptions>, ConfigureAfterOptions<TOptions>> {
            services => ConfigureAfterOptions<TOptions>(name, services, configureOptions)
        }
        return this
    }

    public func configureAll<TOptions>(configureOptions: (TOptions, IServiceProvider) -> Unit) where TOptions <: Object {
        addOptions<TOptions>()
        this.addSingleton<IConfigureAfterOptions<TOptions>, ConfigureAfterOptions<TOptions>> {
            services => ConfigureAfterOptions<TOptions>(None, services, configureOptions)
        }
        return this
    }

    public func configureAfterAll<TOptions>(configureOptions: (TOptions, IServiceProvider) -> Unit) where TOptions <: Object {
        addOptions<TOptions>()
        this.addSingleton<IConfigureAfterOptions<TOptions>, ConfigureAfterOptions<TOptions>> {
            services => ConfigureAfterOptions<TOptions>(None, services, configureOptions)
        }
        return this
    }
}
