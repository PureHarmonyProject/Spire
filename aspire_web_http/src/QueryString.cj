// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_http

public struct QueryString <: Equatable<QueryString> & Equatable<String> & ToString{
    private let _value: String

    public init(value: String) {
        _value = value
    }

    public prop value: String {
        get() {
            _value
        }
    }

    public prop hasValue: Bool {
        get() {
            _value.size > 0
        }
    }

    public operator func ==(oth: QueryString) {
        return this.value == oth.value
    }

    public operator func ==(value: String) {
        return this.value == value
    }

    public func toString() {
        _value
    }
}
