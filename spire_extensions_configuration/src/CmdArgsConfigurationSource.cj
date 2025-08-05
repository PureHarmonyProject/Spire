// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_extensions_configuration

import std.process.*
import std.collection.*

class CmdArgsConfigurationProvider <: ConfigurationProvider {
    private let _args: Array<String>
    private let _switchMappings: ?Map<String, String>

    init(args: Array<String>, switchMappings!: ?Map<String, String> = None) {
        _args = args
        if (let Some(switchMappings) <- switchMappings) {
            _switchMappings = getValidatedSwitchMappingsCopy(switchMappings)
        } else {
            _switchMappings = None
        }
    }

    public override func load() {
        let it = _args.iterator()
        while (let Some(next) <- it.next()) {
            var currentArg = next
            var keyStartIndex = 0
            if (currentArg.startsWith('--')) {           
                keyStartIndex = 2
            } else if (currentArg.startsWith('-')) {
                keyStartIndex = 1
            } else if (currentArg.startsWith('/')) {
                keyStartIndex = 2
                currentArg = "--${currentArg[1..]}"
            }

            if (let Some(separator) <- currentArg.indexOf('=')) {
                let keySegment = currentArg[0..separator]
        
                let key = if (let Some(switchMappings) <- _switchMappings && let Some(mappedKeySegment) <- switchMappings.get(keySegment)) {
                    mappedKeySegment
                }  else {
                    if (keyStartIndex == 1) {
                        throw IllegalFormatException("The short switch '${currentArg}' is not defined in the switch mappings.")
                    }
                    currentArg[keyStartIndex..separator]
                }
                
                let value = currentArg[separator + 1..]
                data.add(key, value)
            } else {
                if (keyStartIndex == 0) {
                    continue
                }

                let key = if (let Some(switchMappings) <- _switchMappings && let Some(mappedKey) <- switchMappings.get(currentArg)) {
                    mappedKey
                } else   {
                    if (keyStartIndex == 1) {
                        continue
                    }
                    currentArg[keyStartIndex..]
                }

                if (let Some(next) <- it.next()) {
                    data.add(key, next)
                } else {
                    continue
                }
            }
        }
    }

    private static func getValidatedSwitchMappingsCopy(switchMappings: Map<String, String>) {
        let switchMappingsCopy = IgnoreCaseHashMap<String>()

        for ((key, value) in switchMappings) {
            if (!key.startsWith('-') && !key.startsWith('--')) {
                throw IllegalArgumentException("The switch mappings contain an invalid switch '${key}'.")
            }
            if (switchMappingsCopy.contains(key)) {
                throw IllegalArgumentException(
                    "Keys in switch mappings are case-insensitive. A duplicated key '${key}' was found.")
            }
            switchMappingsCopy.add(key, value)
        }

        return switchMappingsCopy
    }
}

class CmdArgsConfigurationSource <: IConfigurationSource {
    private let _args: Array<String>
    private let _switchMappings: ?Map<String, String>

    init(args: Array<String>, switchMappings!: ?Map<String, String> = None) {
        _args = args
        _switchMappings = switchMappings
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = CmdArgsConfigurationProvider(_args, switchMappings: _switchMappings)
        return provider
    }
}

extend ConfigurationManager {
    public func addCmdArgs(args: Array<String>, switchMappings!: ?Map<String, String> = None): IConfigurationBuilder {
        add(CmdArgsConfigurationSource(args, switchMappings: switchMappings))
        return this
    }
}
