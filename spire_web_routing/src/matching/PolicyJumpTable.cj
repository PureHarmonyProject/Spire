// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_routing.matching

import std.reflect.*
import spire_web_http.*

/*策略跳转表*/
public abstract class PolicyJumpTable {
    public func getDestination(context: HttpContext): Int64

    protected open func debuggerToString(): String {
        ClassTypeInfo.of(this).qualifiedName
    }
}
