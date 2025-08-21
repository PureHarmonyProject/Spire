// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.sync.*
import std.reflect.*
import std.collection.*
import std.collection.concurrent.*

let SERVICE_PROVIDER_TYPE = TypeInfo.of<IServiceProvider>()
let SERVICE_SCOPE_FACTORY_TYPE = TypeInfo.of<IServiceScopeFactory>()

public class ServiceProvider <: IServiceProvider & IServiceScopeFactory & Resource {
    private var _isClosed = false
    private let _root: ?ServiceProvider
    private let _services: ServiceCollection
    private let _options: ServiceProviderOptions
    private let _resources = ConcurrentLinkedQueue<Resource>()
    private let _instances = ConcurrentHashMap<ServiceCacheKey, Object>()

    init(services: ServiceCollection, options: ServiceProviderOptions, root!: ?ServiceProvider = None) {
        _root = root
        _options = options
        _services = services
    }

    public func createScope(): IServiceScope {
        //永远通过根容器来创建作用域
        let root = _root ?? this
        return ServiceScope(ServiceProvider(_services, _options, root: root))
    }

    public func getOrDefault(serviceType: TypeInfo): ?Object {
        //解析容器本身，返回this
        if (serviceType == SERVICE_PROVIDER_TYPE) {
            return getServiceProviderEngine() as Object
        }
        
        if (serviceType == SERVICE_SCOPE_FACTORY_TYPE) {
            return getServiceProviderEngine() as Object
        }

        if (let Some(descriptor) <- _services.findLast(serviceType)) {
            return resolve(descriptor, getServiceProviderEngine())
        }
        return None
    }

    public func getAll<T>(): Array<T> {
        let serviceType = TypeInfo.of<T>()
        let descriptors = _services.findAll(serviceType)
        let list = ArrayList<T>()
        var slot = 0
        while (slot < descriptors.size) {
            //反转使得最后注册的slot为0，因为getOrDefault默认就是获取最后一个，并设置slot为0
            if (let instance: T <- resolve(descriptors[slot], getServiceProviderEngine(),
                slot: descriptors.size - slot - 1)) {
                list.add(instance)
            }
            slot++
        }
        return list |> collectArray
    }

    private func getServiceProviderEngine(): IServiceProvider {
        //判断是否启用循环依赖检测
        if (_options.validateLoopDependency) {
            return ServiceProviderEngine(this)
        }
        return this
    }

    internal func resolve(descriptor: ServiceDescriptor, engine: IServiceProvider, slot!: Int64 = 0): Object {
        let identifier = ServiceIdentifier.fromDescriptor(descriptor)
        if (!descriptor.lifetime.isSingleton() && isRoot && _options.validateScopes) {
            throw UnsupportedException("Cannot resolve non-singleton service from the root container.")
        }
        if (descriptor.lifetime.isSingleton() && let Some(root) <- _root) {
            return root.resolve(descriptor, engine)
        }
        let cacheKey = ServiceCacheKey(identifier, slot)
        let instance = tryGetInstance(cacheKey, descriptor, engine)
        return instance
    }

    /*
    尝试从缓存获取
     */
    private func tryGetInstance(cacheKey: ServiceCacheKey, descriptor: ServiceDescriptor, engine: IServiceProvider): Object {
        //如果是瞬时的那么立即创建并返回
        if (descriptor.lifetime.isTransient()) {
            let instance = createInstance(descriptor, engine)
            return instance
        }

        //如果容器中存在缓存，那么立即返回
        if (_instances.contains(cacheKey)) {
            return _instances[cacheKey]
        }

        return _instances
            .entryView(cacheKey) {
                entry => if (entry.value.isNone()) {
                    entry.value = createInstance(descriptor, engine)
                }
            }
            .getOrThrow()
    }

    private func createInstance(descriptor: ServiceDescriptor, serviceProvider: IServiceProvider): Object {
        let instance = if (let Some(implementationFactory) <- descriptor
            .implementationFactory
            .flatMap {f => f as (IServiceProvider) -> Object}) {
            implementationFactory(serviceProvider)
        } else if (let Some(obj) <- descriptor.implementationInstance) {
            obj
        } else if (let Some(implementationType) <- descriptor.implementationType) {
            ActivatorUtilities.createInstance(serviceProvider, implementationType)
        } else {
            throw UnsupportedException(
                "Unable to create an instance for the service descriptor. The descriptor lacks a valid implementation factory, instance, or type. Please ensure that at least one of these is provided.")
        }

        //保存需释放的资源
        if (let resource: Resource <- instance) {
            _resources.add(resource)
        }

        return instance
    }

    internal prop services: ServiceCollection {
        get() {
            _services
        }
    }

    internal prop resources: Collection<Resource> {
        get() {
            _resources
        }
    }

    internal prop isRoot: Bool {
        get() {
            _root.isNone()
        }
    }

    public func isClosed() {
        _isClosed
    }

    public func close() {
        for (pattern in _resources) {
            if (pattern.isClosed()) {
                continue
            }
            try {
                pattern.close()
            } catch (_: Exception) {
            }
        }
        _isClosed = true
    }

    ~init() {
        for (pattern in _resources) {
            if (pattern.isClosed()) {
                continue
            }
            try {
                pattern.close()
            } catch (_: Exception) {
            }
        }
    }
}
