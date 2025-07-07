// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_claims

public class Claim {
    private let _name: String
    private let _value: String
    private var _valueType: ?String = None

    public init(name: String, value: String) {
        _name = name
        _value = value
    }

    public init(name: String, value: String, valueType: ?String) {
        _name = name
        _value = value
        _valueType = valueType
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

    public prop valueType: ?String {
        get() {
            _valueType
        }
    }
}
