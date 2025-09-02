// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

struct ServiceCacheKey <: Equatable<ServiceCacheKey> & Hashable {
    public let slot: Int64
    public let identifier: ServiceIdentifier

    init(slot: Int64, identifier: ServiceIdentifier) {
        this.slot = slot
        this.identifier = identifier
    }

    public operator func ==(that: ServiceCacheKey) {
        this.identifier == that.identifier && this.slot == that.slot
    }

    @OverflowWrapping
    public func hashCode() {
        (identifier.hashCode() * 397) ^ slot
    }
}
