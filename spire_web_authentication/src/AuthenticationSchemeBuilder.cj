// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication

import std.reflect.*

public class AuthenticationSchemeBuilder {
    private let _name: String

    public var displyName: ?String = None
    public var handleType: ?TypeInfo = None

    public init(name: String) {
        _name = name
    }

    public prop name: String {
        get() {
            _name
        }
    }

    public func build() {
        AuthenticationScheme(_name, displyName, handleType.getOrThrow())
    }
}
