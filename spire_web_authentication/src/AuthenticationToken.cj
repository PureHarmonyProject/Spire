// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication

public class AuthenticationToken {
    private let _name: String
    private let _value: String
    
    public init(name: String, value: String) {
        _name = name
        _value = value
    }
    

    public prop name: String {
        get() {
            _name
        }
    }

    public prop value: String {
        get() {
            _value
        }
    }
}
