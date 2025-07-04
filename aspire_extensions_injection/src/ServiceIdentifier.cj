// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_injection

import std.reflect.*

/*
服务唯一性标识
 */
struct ServiceIdentifier <: Hashable & Equatable<ServiceIdentifier> & ToString {
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

    public static func fromDescriptor(descriptor: ServiceDescriptor) {
        ServiceIdentifier(descriptor.serviceType)
    }

    public operator func ==(oth: ServiceIdentifier) {
        return this._serviceType == oth._serviceType
    }

    public func hashCode() {
        return _serviceType.hashCode()
    }

    public func toString() {
        "${_serviceType}"
    }
}
