// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_extensions_configuration

import std.process.*
import std.collection.*

// 将kebab-case转换为camelCase
func toCamelCase(input: String, delimiter: String): String {
    let parts = input.split(delimiter)
    if (parts.size == 0) {
        return ""
    }
    
    if (parts.size == 1) {
        return parts[0]
    }
    
    var result = parts[0]
    for (i in 1..parts.size) {
        let part = parts[i]
        if (part.size > 0) {
            let firstChar = if (part.size > 0) { part[0..1].toAsciiUpper() } else { "" }
            let restChars = if (part.size > 1) { part[1..] } else { "" }
            let capitalized = firstChar + restChars
            result = result + capitalized
        }
    }
    
    return result
}

class CmdArgsConfigurationProvider <: ConfigurationProvider {
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
            let key = toCamelCase(entry[0], "-")
            let value = entry[1].trimEnd().trimStart()
            data[key] = value
        }
    }
}

class CmdArgsConfigurationSource <: IConfigurationSource {
    private let _args: Array<String>
   
    init(args: Array<String>) {
        _args = args
    }

    public func build(_: IConfigurationBuilder): IConfigurationProvider {
        let provider = CmdArgsConfigurationProvider(_args)
        return provider
    }
}

extend ConfigurationManager {
    public func addCmdArgs(args: Array<String>): IConfigurationBuilder {
        add(CmdArgsConfigurationSource(args))
        return this
    }
}
