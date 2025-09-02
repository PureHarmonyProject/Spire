// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*

/*
集合类型图纸模板
 */
class CollectionCallSite <: ServiceCallSite {
    private let _itemType: TypeInfo
    private let _serviceType: TypeInfo
    private let _serviceCallSites: Array<ServiceCallSite>

    public init(cache: CallSiteResultCache, serviceType: TypeInfo, itemType: TypeInfo,
        serviceCallSites: Array<ServiceCallSite>) {
        super(CallSiteKind.Collection, cache)
        _itemType = itemType
        _serviceType = serviceType
        _serviceCallSites = serviceCallSites
    }

    public prop serviceCallSites: Array<ServiceCallSite> {
        get() {
            _serviceCallSites
        }
    }

    public prop itemType: TypeInfo {
        get() {
            _itemType
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
