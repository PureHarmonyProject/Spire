// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*

/*
常量图纸模板
 */
class ConstantCallSite <: ServiceCallSite {
    private let _serviceType: TypeInfo
    private let _defaultValue: ?Object
    private let _implementationType: TypeInfo

    public init(serviceType: TypeInfo, defaultValue: ?Object) {
        super(CallSiteKind.Constant, CallSiteResultCache.none(serviceType))
        _serviceType = serviceType
        _defaultValue = defaultValue
        _implementationType = defaultValue.flatMap {f => ClassTypeInfo.of(f)} ?? serviceType
        this.value = defaultValue
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
