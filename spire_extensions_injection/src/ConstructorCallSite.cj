// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*

/*
构造器图纸模板
 */
class ConstructorCallSite <: ServiceCallSite {
    private let _serviceType: TypeInfo
    private let _constructorInfo: ConstructorInfo
    private let _parameterCallSites: Array<ServiceCallSite>

    public init(cache: CallSiteResultCache, serviceType: TypeInfo, constructorInfo: ConstructorInfo,
        parameterCallSites: Array<ServiceCallSite>) {
        super(CallSiteKind.Constructor, cache)
        _serviceType = serviceType
        _constructorInfo = constructorInfo
        _parameterCallSites = parameterCallSites
    }

    public prop constructorInfo: ConstructorInfo {
        get() {
            _constructorInfo
        }
    }

    
    public prop parameterCallSites: Array<ServiceCallSite> {
        get() {
            _parameterCallSites
        }
    }

    public prop serviceType: TypeInfo {
        get() {
            _serviceType
        }
    }

    public prop implementationType: ?TypeInfo {
        get() {
            None
        }
    }
}
