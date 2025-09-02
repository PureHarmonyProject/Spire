// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.reflect.*
import std.collection.*

/*
服务描述信息
 */
public class ServiceDescriptor <: ToString {
    private let _serviceType: TypeInfo
    private let _implementationType: ?TypeInfo
    private let _implementationInstance: ?Object
    private let _implementationFactory: ?(IServiceProvider) -> Object
    private let _lifetime: ServiceLifetime

    public init(serviceType: TypeInfo, instance: Any) {
        _serviceType = serviceType
        _implementationType = None
        _implementationFactory = None
        _implementationInstance = (instance as Object).getOrThrow()
        _lifetime = ServiceLifetime.Singleton
    }

    public init(serviceType: TypeInfo, factory: (IServiceProvider) -> Object, lifetime: ServiceLifetime) {
        _serviceType = serviceType
        _implementationType = None
        _implementationFactory = factory
        _implementationInstance = None
        _lifetime = lifetime
    }

    public init(serviceType: TypeInfo, implementationType: TypeInfo, lifetime: ServiceLifetime) {
        if (!implementationType.isSubtypeOf(serviceType)) {
            UnsupportedException(
                "The implementation type '${implementationType}' is not a subtype of the service type '${serviceType}'. ")
        }
        _serviceType = serviceType
        _implementationType = implementationType
        _implementationFactory = None
        _implementationInstance = None
        _lifetime = lifetime
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

    public prop lifetime: ServiceLifetime {
        get() {
            _lifetime
        }
    }

    public prop implementationInstance: ?Object {
        get() {
            _implementationInstance
        }
    }

    public prop implementationFactory: ?(IServiceProvider) -> Object {
        get() {
            _implementationFactory
        }
    }

    public func toString() {
        return serviceType.toString()
    }
}

extend ServiceDescriptor {
    public static func singleton<TServiceType>(instance: TServiceType) {
        ServiceDescriptor(TypeInfo.of<TServiceType>(), instance)
    }

    public static func singleton<TServiceType, TImplementationType>(instance: TImplementationType) {
        ServiceDescriptor(TypeInfo.of<TServiceType>(), instance)
    }

    public static func scoped<TServiceType, TImplementationType>(sp: (IServiceProvider) -> TImplementationType) where TImplementationType <: Object {
        ServiceDescriptor(TypeInfo.of<TServiceType>(), sp, ServiceLifetime.Scoped)
    }

    public static func transient<TServiceType, TImplementationType>(sp: (IServiceProvider) -> TImplementationType) where TImplementationType <: Object {
        ServiceDescriptor(TypeInfo.of<TServiceType>(), sp, ServiceLifetime.Transient)
    }

    public static func singleton<TServiceType, TImplementationType>(sp: (IServiceProvider) -> TImplementationType) where TImplementationType <: Object {
        ServiceDescriptor(TypeInfo.of<TServiceType>(), sp, ServiceLifetime.Singleton)
    }

    public static func scoped<TServiceType, TImplementationType>() {
        scoped(TypeInfo.of<TServiceType>(), TypeInfo.of<TImplementationType>())
    }

    public static func transient<TServiceType, TImplementationType>() {
        transient(TypeInfo.of<TServiceType>(), TypeInfo.of<TImplementationType>())
    }

    public static func singleton<TServiceType, TImplementationType>() {
        singleton(TypeInfo.of<TServiceType>(), TypeInfo.of<TImplementationType>())
    }

    public static func scoped(serviceType: TypeInfo, implementationType: TypeInfo) {
        ServiceDescriptor(serviceType, implementationType, ServiceLifetime.Scoped)
    }

    public static func transient(serviceType: TypeInfo, implementationType: TypeInfo) {
        ServiceDescriptor(serviceType, implementationType, ServiceLifetime.Transient)
    }

    public static func singleton(serviceType: TypeInfo, implementationType: TypeInfo) {
        ServiceDescriptor(serviceType, implementationType, ServiceLifetime.Singleton)
    }
}

extend ArrayList<ServiceDescriptor> {
    internal func indexOf(element: ServiceDescriptor): ?Int64 {
        for (index in 0..this.size) {
            if (refEq(this[index], element)) {
                return index
            }
        }
        return None
    }
}
