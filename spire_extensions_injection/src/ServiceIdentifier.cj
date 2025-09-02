// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*

struct ServiceIdentifier <: Equatable<ServiceIdentifier> & Hashable {
    private let _serviceType: TypeInfo

    public init(serviceType: TypeInfo) {
        _serviceType = serviceType
    }

    public prop serviceType: TypeInfo {
        get() {
            _serviceType
        }
    }

    public static func fromServiceType(serviceType: TypeInfo) {
        ServiceIdentifier(serviceType)
    }

    public static func fromDescriptor(serviceDescriptor: ServiceDescriptor) {
        ServiceIdentifier(serviceDescriptor.serviceType)
    }

    public func hashCode() {
        return serviceType.hashCode()
    }

    public operator func ==(that: ServiceIdentifier) {
        return that.serviceType == this.serviceType
    }
}
