// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

enum CallSiteResultCacheLocation <: Comparable<CallSiteResultCacheLocation> {
    Root
    | Scope
    | Dispose
    | None

    private prop value: Int64 {
        get() {
            match (this) {
                case Root => 0
                case Scope => 1
                case Dispose => 2
                case None => 3
            }
        }
    }

    public func compare(that: CallSiteResultCacheLocation) {
        let a = value
        let b = that.value
        if (a == b) {
            Ordering.EQ
        } else if (a >= b) {
            Ordering.GT
        } else {
            Ordering.LT
        }
    }
}
