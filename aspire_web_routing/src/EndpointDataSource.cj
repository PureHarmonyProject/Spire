// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_routing

import std.reflect.*
import std.collection.*

public abstract class EndpointDataSource <: Equatable<EndpointDataSource> & Hashable {

    public prop endpoints: ReadOnlyList<Endpoint>

   
    public operator func ==(oth: EndpointDataSource) {
        refEq(this, oth)
    }

    public func hashCode() {
        ClassTypeInfo.of(this).hashCode()
    }
}
