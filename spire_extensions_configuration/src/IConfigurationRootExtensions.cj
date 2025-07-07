// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.collection.*

func getChildKeys(configuratin: IConfigurationRoot, parentPath: ?String): Iterable<String> {
    let results = HashSet<String>()
    let providers = configuratin.providers |> collectArray
    var index = providers.size - 1
    while (index >= 0) {
        let provider = providers[index]
        let keys = provider.getChildKeys(results |> collectArray, parentPath)
        for (pattern in keys) {
            if (!results.contains(pattern)) {
                results.add(pattern)
            }
        }
        index--
    }
    return results |> collectArray
}


func camelCase(name: String, splitter: String) {
    let sb = StringBuilder()
    for ((index, pattern) in name.toAsciiLower().split(splitter, removeEmpty: true) |> enumerate) {
        let bytes = pattern.toArray()
        if (index == 0) {
            sb.append(pattern)
        }else {
            bytes[0] = bytes[0].toAsciiUpperCase()
            sb.append(String.fromUtf8(bytes))
        }
    }
    return sb.toString().trimStart().trimEnd()
}
