// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_injection

import std.reflect.*

struct ServiceCacheKey <: Hashable & Equatable<ServiceCacheKey> {
    private let _slot: Int64
    private let _identifier: ServiceIdentifier

    init(identifier: ServiceIdentifier, slot: Int64) {
        _identifier = identifier
        _slot = slot
    }

    public operator func ==(rhs: ServiceCacheKey): Bool {
        if (_identifier != rhs._identifier) {
            return false
        }
        if (_slot != rhs._slot) {
            return false
        }
        return true
    }

    @OverflowWrapping
    public func hashCode() {
        (_identifier.hashCode() * 397) ^ _slot
    }
}
