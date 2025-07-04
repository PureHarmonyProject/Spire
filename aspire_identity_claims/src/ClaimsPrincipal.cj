// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_identity_claims

import std.collection.*

public class ClaimsPrincipal {
    private let _identies: ArrayList<ClaimsIdentity>
    private static var _selectPrimaryIdentity = selectPrimaryIdentity

    public init(claimsIdenties: Array<ClaimsIdentity>) {
        _identies = ArrayList<ClaimsIdentity>(claimsIdenties)
    }

    public prop claims: Collection<Claim> {
        get() {
            _identies |> flatMap {f => f.claims} |> collectArray
        }
    }

    public func addIdentity(claimsIdenty: ClaimsIdentity) {
        _identies.add(claimsIdenty)
    }

    public func addIdentity(claimsIdenties: Collection<ClaimsIdentity>) {
        _identies.add(all: claimsIdenties)
    }

    public prop identity: ?ClaimsIdentity {
        get() {
            selectPrimaryIdentity(_identies)
        }
    }

    public prop identies: Collection<ClaimsIdentity> {
        get() {
            _identies
        }
    }

    public func findAll(selector: (Claim) -> Bool) {
        _identies |> flatMap {f => f.claims} |> filter {f => selector(f)}
    }

    public func findFirst(selector: (Claim) -> Bool) {
        findAll(selector) |> first
    }

    public func findFirstValue(selector: (Claim) -> Bool) {
        findFirst(selector).flatMap {f => f.value}
    }

    public func findAll(name: String) {
        findAll {f => f.name == name}
    }

    public func findFirst(name: String) {
        findFirst {f => f.name == name}
    }

    public func findFirstValue(name: String) {
        findFirstValue {f => f.name == name}
    }

    public static func setPrimaryIdentitySelector(selector: (identies: Collection<ClaimsIdentity>) -> ?ClaimsIdentity) {
        _selectPrimaryIdentity = selector
    }

    private static func selectPrimaryIdentity(identies: Collection<ClaimsIdentity>) {
        identies |> first
    }
}
