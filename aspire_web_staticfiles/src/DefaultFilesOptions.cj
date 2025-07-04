// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_web_staticfiles

import std.collection.*

public class DefaultFilesOptions <: SharedOptionsBase {
    public let _defaultFileNames: List<String>

    public init() {
        _defaultFileNames = ArrayList<String>(["index.html", "default.html", "default.htm",  "index.htm"])
    }

    public prop defaultFileNames: List<String> {
        get() {
            _defaultFileNames
        }
    }
}
