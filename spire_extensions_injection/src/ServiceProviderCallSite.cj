// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*

/*
返回this
*/
class ServiceProviderCallSite <: ServiceCallSite {
    private let _serviceType: TypeInfo
    private let _implementationType: TypeInfo

    public init() {
        super(CallSiteKind.ServiceProvider, CallSiteResultCache.none(TypeInfo.of<IServiceProvider>()))
        _serviceType = TypeInfo.of<IServiceProvider>()
        _implementationType = TypeInfo.of<ServiceProvider>()
    }

    public prop serviceType: TypeInfo {
        get() {
            _serviceType
        }
    }

    public prop implementationType: ?TypeInfo {
        get() {
            _implementationType
        }
    }
}
