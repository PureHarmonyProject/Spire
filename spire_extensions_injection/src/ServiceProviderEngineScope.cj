// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_injection

import std.sync.*
import std.reflect.*
import std.collection.*

/*
子容器
 */
class ServiceProviderEngineScope <: IServiceProvider & IServiceScope & IServiceScopeFactory {
    private let _sync = Mutex()
    private var _isClosed = false
    private var _disposables: ?List<Object> = None
    private let _resolvedServices = HashMap<ServiceCacheKey, ?Object>()

    ServiceProviderEngineScope(let rootProvder: ServiceProvider, let isRootScope!: Bool) {
    }

    public prop sync: Mutex {
        get() {
            _sync
        }
    }

    public prop resolvedServices: HashMap<ServiceCacheKey, ?Object> {
        get() {
            _resolvedServices
        }
    }

    public func createScope(): IServiceScope {
        return rootProvder.createScope()
    }

    public func getOrDefault(serviceType: TypeInfo): ?Object {
        checkIsClosed()
        rootProvder.getOrDefault(ServiceIdentifier(serviceType), this)
    }

    public prop services: IServiceProvider {
        get() {
            this
        }
    }

    public func close() {
        if (let Some(list) <- beginDispose()) {
            for (pattern in list |> filterMap {f => f as Resource}) {
                pattern.close()
            }
        }
    }

    public func isClosed() {
        _isClosed
    }

    private func checkIsClosed() {
        if (isClosed()) {
            throw UnsupportedException("Cannot access a disposed object.\r\nObject name: 'IServiceProvider'.")
        }
    }

    /*
    如果A线程在解析服务时持有容器，B线程恰好也在解析服务，A线程解析完成释放容器
    1. 如果A线将容器释放，那么B线程解析出来的服务应立即释放防止内存泄漏
     */
    internal func captureDisposable(serivce: ?Object) {

        //如果它是this，或者不是非托管资源
        if (let Some(serivce) <- serivce) {
            if (refEq(serivce, this) || !(serivce is Resource)) {
                return serivce
            }
        }

        if (let Some(serivce) <- serivce) {
            var disposed = false

            synchronized(_sync) {
                if (_isClosed) {
                    disposed = true
                } else {
                    if (let Some(disposables) <- _disposables) {
                        disposables.add(serivce)
                    } else {
                        _disposables = ArrayList<Object>([serivce])
                    }
                }
            }

            if (disposed) {
                if (let resource: Resource <- serivce && !resource.isClosed()) {
                    resource.close()
                }
            }
        }
        return serivce
    }

    private func beginDispose(): ?List<Object> {
        synchronized(sync) {
            if (_isClosed) {
                return None
            }
            _isClosed = true

            if (isRootScope && !rootProvder.isClosed()) {
                rootProvder.close()
            }

            return _disposables
        }
    }
}
