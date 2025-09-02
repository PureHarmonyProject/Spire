// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.sync.*
import std.collection.*

/*
施工队：根据图纸进行作业
 */
class CallSiteRuntimeResolver <: CallSiteVisitor<RuntimeResolverContext, ?Object> {
    private init() {
    }

    public static let Instance = CallSiteRuntimeResolver()

    public func resolve(callSite: ServiceCallSite, scope: ServiceProviderEngineScope) {
        if (scope.isRootScope && let Some(value) <- callSite.value) {
            return value
        }
        return visitCallSite(callSite, RuntimeResolverContext(scope, RuntimeResolverLock.None))
    }

    /*
    基于图纸类型的工序：工厂模式
     */
    protected func visitFactory(callSite: FactoryCallSite, context: RuntimeResolverContext): ?Object {
        return callSite.factory(context.scope)
    }

    /*
    基于图纸类型的工序：常量模式
     */
    protected func visitConstant(callSite: ConstantCallSite, _: RuntimeResolverContext): ?Object {
        return callSite.value
    }

    /*
    基于图纸类型的工序：构造器模式
     */
    protected func visitConstructor(callSite: ConstructorCallSite, context: RuntimeResolverContext): ?Object {
        let parameterValues = Array<Any>(callSite.parameterCallSites.size, repeat: None)

        for ((index, parameterCallSite) in callSite.parameterCallSites |> enumerate) {
            parameterValues[index] = visitCallSite(parameterCallSite, context).getOrThrow()
        }

        return callSite.constructorInfo.apply(parameterValues) as Object
    }

    protected func visitCollection(callSite: CollectionCallSite, context: RuntimeResolverContext): ?Object {
        let array = IReferenceCollectionWrapper.create(callSite.itemType, callSite.serviceCallSites.size)

        for ((index, callSite) in callSite.serviceCallSites |> enumerate) {
            if (let Some(value) <- visitCallSite(callSite, context)) {
                array[index] = value
            }
        }
        return (array as Object)
    }

    /*
    基于图纸类型的工序：自解析模式
     */
    protected func visitServiceProvider(_: ServiceProviderCallSite, context: RuntimeResolverContext): ?Object {
        return context.scope
    }

    /*
    基于存放位置的工序：存放到释放集合
     */
    public override func visitDisposeCache(callSite: ServiceCallSite, context: RuntimeResolverContext) {
        context.scope.captureDisposable(visitCallSiteMain(callSite, context))
    }

    /*
    基于存放位置的工序：存放到根容器
     */
    public override func visitRootCache(callSite: ServiceCallSite, context: RuntimeResolverContext) {
        if (let Some(value) <- callSite.value) {
            // 表示解析链中已施工图纸的产物
            return value
        }
        let root = context.scope.rootProvder.root
        let lock = callSite.lock
        // 使用图纸锁
        synchronized(lock) {
            if (let Some(value) <- callSite.value) {
                return value
            }

            let acquiredLocks = context.acquiredLocks.add(RuntimeResolverLock.Root)
            let resolved = visitCallSiteMain(callSite, RuntimeResolverContext(root, acquiredLocks))
            // 计算是否需要释放或者暂存
            root.captureDisposable(resolved)
            // 解析结果缓存到图纸上
            callSite.value = resolved
            return resolved
        }
    }

    /*
    基于存放位置的工序：存放到子容器
     */
    public override func visitScopeCache(callSite: ServiceCallSite, context: RuntimeResolverContext) {
        if (context.scope.isRootScope) {
            return visitRootCache(callSite, context)
        } else {
            return visitCache(callSite, context, context.scope, RuntimeResolverLock.Scope)
        }
    }

    /*
    计算缓存
     */
    private func visitCache(callSite: ServiceCallSite, context: RuntimeResolverContext,
        scope: ServiceProviderEngineScope, lockType: RuntimeResolverLock): ?Object {
        var lockTaken = false
        let sync = scope.sync
        let resolvedServices = scope.resolvedServices

        //如果未持有lockType锁，防止重入和死锁
        if (!context.acquiredLocks.has(lockType)) {
            sync.lock()
            lockTaken = true
        }

        try {
            // 如果存在实例，那么直接返回
            if (let Some(resolved) <- resolvedServices.get(callSite.cache.key)) {
                return resolved
            }

            let acquiredLocks = context.acquiredLocks.add(lockType)
            let resolved = visitCallSiteMain(callSite, RuntimeResolverContext(scope, acquiredLocks))
            //计算是否需要释放或者暂存
            scope.captureDisposable(resolved)
            resolvedServices.add(callSite.cache.key, resolved)
            return resolved
        } finally {
            if (lockTaken) {
                sync.unlock()
            }
        }
    }
}

/*
定义施工上下文
 */
struct RuntimeResolverContext {
    RuntimeResolverContext(let scope: ServiceProviderEngineScope, let acquiredLocks: RuntimeResolverLock) {
    }
}

/*
定义一个锁标记
    1. 0000 0001表示子容器维度的锁
    2. 0000 0010表示根容器维度的锁
 */
struct RuntimeResolverLock {
    private var flags: Byte

    private init(flag: Byte) {
        this.flags = flag
    }

    public static let None = RuntimeResolverLock(0)

    public static let Scope = RuntimeResolverLock(1)

    public static let Root = RuntimeResolverLock(2)

    /*
    加锁
     */
    public func add(lock: RuntimeResolverLock) {
        return RuntimeResolverLock(flags | lock.flags)
    }

    /*
    是否存在指定的锁
     */
    public func has(lock: RuntimeResolverLock) {
        return (flags & lock.flags) != 0
    }
}
