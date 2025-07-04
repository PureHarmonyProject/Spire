// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_identity_claims

import std.collection.*

public class ClaimsIdentity {
    private let _claims: ArrayList<Claim>
    private var _authenticationType: ?String = None

    public init(claims: Array<Claim>) {
        _claims = ArrayList<Claim>(claims)
    }

    public init(authenticationType: String, claims: Array<Claim>) {
        _claims = ArrayList<Claim>(claims)
        _authenticationType = authenticationType
    }

    public prop claims: Collection<Claim> {
        get() {
            _claims
        }
    }

    public prop isAuthenticated: Bool {
        get() {
            authenticationType.isSome()
        }
    }

    public prop authenticationType: ?String {
        get() {
            _authenticationType
        }
    }

    public func addClaim(Claim: Claim) {
        _claims.add(Claim)
    }

    public func addClaim(name: String, value: String) {
        _claims.add(Claim(name, value))
    }

    public func addClaim(name: String, value: String, valueType: ?String) {
        _claims.add(Claim(name, value, valueType))
    }

    public func addClaims(claims: Collection<Claim>) {
        _claims.add(all: claims)
    }

    public func findAll(predicate: (Claim) -> Bool) {
        _claims |> filter(predicate)
    }

    public func findAll(name: String) {
        _claims |> filter{f => f.name == name}
    }

    public func findFirst(predicate: (Claim) -> Bool) {
        findAll(predicate) |> first
    }

    public func findFirst(name: String) {
        findAll(name) |> first
    }

    public func hasClaim(predicate: (Claim) -> Bool) {
        _claims |> any(predicate)
    }

    public func hasClaim(name: String, value: String) {
        return hasClaim{f => f.name == name && f.value == value}
    }
}
