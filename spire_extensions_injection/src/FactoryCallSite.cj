// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*

/*
工厂图纸模板
 */
class FactoryCallSite <: ServiceCallSite {
    private let _kind: CallSiteKind
    private let _serviceType: TypeInfo

    private let _factory: (IServiceProvider) -> Object

    public init(cache: CallSiteResultCache, serviceType: TypeInfo, factory: (IServiceProvider) -> Object) {
        super(CallSiteKind.Factory, cache)
        _kind = CallSiteKind.Factory
        _serviceType = serviceType
        _factory = factory
    }

    public prop factory: (IServiceProvider) -> Object {
        get() {
            _factory
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
