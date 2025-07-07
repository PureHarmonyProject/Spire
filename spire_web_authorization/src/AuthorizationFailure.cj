// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authorization

import std.collection.*

public class AuthorizationFailure {
    private var _failCalled = false
    private let _failureReasons = ArrayList<AuthorizationFailureReason>()
    private let _failedRequirements = ArrayList<IAuthorizationRequirement>()

    private static let _explicitFailure: AuthorizationFailure

    static init() {
        _explicitFailure = AuthorizationFailure()
        _explicitFailure._failCalled = true
    }

    public prop failCalled: Bool {
        get() {
            _failCalled
        }
    }

    public prop failureReasons: Collection<AuthorizationFailureReason> {
        get() {
            _failureReasons
        }
    }

    public prop failedRequirements: Collection<IAuthorizationRequirement> {
        get() {
            _failedRequirements
        }
    }

    public static func explicitFail() {
        _explicitFailure
    }

    public static func failed(reasons: Collection<AuthorizationFailureReason>) {
        let result = AuthorizationFailure()
        result._failCalled = true
        result._failureReasons.add(all: reasons)
        return result
    }

    public static func failed(failed: Collection<IAuthorizationRequirement>) {
        let result = AuthorizationFailure()
        result._failCalled = true
        result._failedRequirements.add(all: failed)
        return result
    }
}
