// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

import std.reflect.*
import std.collection.*

public class OptionsFactory<TOptions> <: IOptionsFactory<TOptions> where TOptions <: Object {
    private let _configures: Collection<IConfigureOptions<TOptions>>
    private let _validations: Collection<IValidateOptions<TOptions>>
    private let _configureAfters: Collection<IConfigureAfterOptions<TOptions>>

    public init(configures: Collection<IConfigureOptions<TOptions>>,
        configureAfters: Collection<IConfigureAfterOptions<TOptions>>, validations: Collection<IValidateOptions<TOptions>>) {
        _configures = configures
        _configureAfters = configureAfters
        _validations = validations
    }

    public func create(name: String) {
        let options = createInstance()
        for (pattern in _configures) {
            if (let configureNamed: IConfigureNamedOptions<TOptions> <- pattern) {
                configureNamed.configure(name, options)
            } else {
                pattern.configure(options)
            }
        }

        for (pattern in _configureAfters) {
            pattern.configureAfter(name, options)
        }

        if (_validations.size > 0) {
            let failures = ArrayList<String>()
            for (validate in _validations) {
                let result = validate.validate(name, options)
                if (result.failed) {
                    failures.add(all: result.failures.getOrThrow() |> collectArray)
                }
            }
            if (failures.size > 0) {
                throw OptionsValidationException(name, TypeInfo.of<TOptions>(), failures |> collectArray)
            }
        }
        return options
    }

    private func createInstance(): TOptions {
        return (ClassTypeInfo.of<TOptions>().construct() as TOptions).getOrThrow()
    }
}
