// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_formats_asn1

class SetOfValueComparer <: Comparable<Array<Byte>> {
    
    public func compare(right: Array<Byte>) {
        if(this == right) {
            Ordering.EQ
        }
        else if(this > right) {
            Ordering.GT
        }
        else {
             Ordering.LT
        }
    }
}