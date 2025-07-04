// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_authorization

import std.reflect.*

public interface IAuthorizationRequirement <: Hashable & Equatable<IAuthorizationRequirement> & ToString {
    operator func ==(other: IAuthorizationRequirement) {
        refEq((this as Object).getOrThrow(), (other as Object).getOrThrow())
    }

    func hashCode() {
        ClassTypeInfo.of(this).hashCode()
    }
}
