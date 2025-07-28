// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.matching

import std.collection.*
import spire_web_http.*
import spire_web_routing.http.*

public abstract class EndpointSelector {
    public func select(context: HttpContext, candidates: CandidateSet): Unit
}
