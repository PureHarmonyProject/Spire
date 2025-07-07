// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_extensions_configuration

import std.process.*
import std.collection.*

class CmdVarsConfigurationProvider <: ConfigurationProvider {
    private let _args: Array<String>
    
    init(args: Array<String>) {
        _args = args
    }
    
    public override func load() {
        for (item in _args) {
            let entry = item.split('=', 2)
            if (entry.size < 2) {
                continue
            }
            let key = camelCase(entry[0], "-")
            let value = entry[1].trimEnd().trimStart()
            data.add(key, value)
        }
    }
}

class CmdVarsConfigurationSource <: IConfigurationSource {
    private let _args: Array<String>
   
    init(args: Array<String>) {
        _args = args
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = CmdVarsConfigurationProvider(_args)
        return provider
    }
}

extend ConfigurationManager {
    public func addCmdVars(args: Array<String>): IConfigurationBuilder {
        add(CmdVarsConfigurationSource(args))
        return this
    }
}
