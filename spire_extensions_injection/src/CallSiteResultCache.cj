// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*

/*
用于描述服务存放位置
*/
struct CallSiteResultCache {
    CallSiteResultCache(let key: ServiceCacheKey, let location: CallSiteResultCacheLocation) {
    }

    init(key: ServiceCacheKey, lifetime: ServiceLifetime) {
        this(key, match (lifetime) {
            case ServiceLifetime.Transient => CallSiteResultCacheLocation.Dispose
            case ServiceLifetime.Scoped => CallSiteResultCacheLocation.Scope
            case ServiceLifetime.Singleton => CallSiteResultCacheLocation.Root
        })
    }

    public static func none(serviceType: TypeInfo) {
        let cacheKey = ServiceCacheKey(0, ServiceIdentifier.fromServiceType(serviceType))
        return CallSiteResultCache(cacheKey, CallSiteResultCacheLocation.None)
    }
}
