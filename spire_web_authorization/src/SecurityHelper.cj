// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authorization

import std.collection.*
import spire_identity_claims.*

class SecurityHelper {
    public static func mergeUserPrincipal(existingPrincipal: ?ClaimsPrincipal, additionalPrincipal: ?ClaimsPrincipal): ClaimsPrincipal {
        if (existingPrincipal.isNone() && let Some(additionalPrincipal) <- additionalPrincipal) {
            return additionalPrincipal
        }

        let newPrincipal = ClaimsPrincipal()
        if (let Some(additionalPrincipal) <- additionalPrincipal) {
            newPrincipal.addIdentity(additionalPrincipal.identies)
        }

        if (let Some(existingPrincipal) <- existingPrincipal) {
            let identities = existingPrincipal.identies |> filter {f => f.isAuthenticated || f.claims.size > 0} |>
                collectArray
            newPrincipal.addIdentity(identities)
        }
        return newPrincipal
    }
}
