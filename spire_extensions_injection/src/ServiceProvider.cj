package spire_extensions_injection

import std.reflect.*
import std.collection.*
import std.collection.concurrent.*

/*
根容器
 */
public class ServiceProvider <: IServiceProvider & Resource {
    private var _isClosed = false
    private let _services: ServiceCollection
    private let _engine: ServiceProviderEngine
    private let _options: ServiceProviderOptions
    private let _callSiteFactory: CallSiteFactory
    private var _root: ?ServiceProviderEngineScope = None
    private var _callSiteValidator: ?CallSiteValidator = None
    private let _serviceAccessors: ConcurrentHashMap<ServiceIdentifier, ServiceAccessor>

    init(services: ServiceCollection, options: ServiceProviderOptions) {
        _services = services
        _options = options
        _engine = DynamicServiceProviderEngine()
        _callSiteFactory = CallSiteFactory(services)
        _serviceAccessors = ConcurrentHashMap<ServiceIdentifier, ServiceAccessor>()
        _root = ServiceProviderEngineScope(this, isRootScope: true)

        //添加IServiceProvider图纸：注意它返回的是this不是常量
        _callSiteFactory.add(ServiceIdentifier.fromServiceType(TypeInfo.of<IServiceProvider>()),
            ServiceProviderCallSite())

        //添加IServiceScopeFactory图纸    
        _callSiteFactory.add(ServiceIdentifier.fromServiceType(TypeInfo.of<IServiceScopeFactory>()),
            ConstantCallSite(TypeInfo.of<IServiceScopeFactory>(), root))

        //添加IServiceProviderIsService图纸        
        _callSiteFactory.add(ServiceIdentifier.fromServiceType(TypeInfo.of<IServiceProviderIsService>()),
            ConstantCallSite(TypeInfo.of<IServiceProviderIsService>(), _callSiteFactory))

        // 每次解析时验证作业域
        if (options.validateScopes) {
            _callSiteValidator = CallSiteValidator()
        }

        // 在启动阶段验证作用域
        if (options.validateOnBuild) {
            var exceptions: ?ArrayList<Exception> = None
            for (pattern in services) {
                try {
                    validateService(pattern)
                } catch (exception: Exception) {
                    exceptions = exceptions ?? ArrayList<Exception>()
                    exceptions?.add(exception)
                }
            }
        }
    }

    internal prop root: ServiceProviderEngineScope {
        get() {
            _root.getOrThrow()
        }
    }

    public func getOrDefault(serviceType: TypeInfo) {
        return root.getOrDefault(serviceType)
    }

    public func close() {
        root.close()
        _isClosed = true
    }

    public func isClosed() {
        return _isClosed
    }

    public func createScope(): IServiceScope {
        checkIsClosed()
        return ServiceProviderEngineScope(this, isRootScope: false)
    }

    internal func getAll<T>(identifier: ServiceIdentifier, scope: ServiceProviderEngineScope): Iterable<T> {
        if (let Some(array) <- getOrDefault(identifier, scope)) {
            return (array as Iterable<T>).getOrThrow()
        }
        return Array<T>()
    }

    internal func getOrDefault(identifier: ServiceIdentifier, scope: ServiceProviderEngineScope): ?Object {
        checkIsClosed()

        let serviceAccessor = _serviceAccessors.entryView(identifier) {
            view => if (view.value.isNone()) {
                view.value = createServiceAccessor(identifier)
            }
        }.getOrThrow()

        onResolve(serviceAccessor.callSite, scope)

        return serviceAccessor.realizedService(scope)
    }

    private func checkIsClosed() {
        if (isClosed()) {
            throw UnsupportedException("Cannot access a disposed object.\r\nObject name: 'IServiceProvider'.")
        }
    }

    private func createServiceAccessor(identifier: ServiceIdentifier): ServiceAccessor {
        if (let Some(callSite) <- _callSiteFactory.getCallSite(identifier, CallSiteChain())) {
            if (callSite.cache.location == CallSiteResultCacheLocation.Root) {
                let value = CallSiteRuntimeResolver.Instance.resolve(callSite, root)
                return ServiceAccessor(callSite) {
                    _ => value
                }
            }
            let realizedService = _engine.realizeService(callSite)
            return ServiceAccessor(callSite, realizedService)
        } else {
            return ServiceAccessor(None, {_ => None})
        }
    }

    private func validateService(descriptor: ServiceDescriptor) {
        try {
            if (let Some(callSite) <- _callSiteFactory.getCallSite(descriptor, CallSiteChain())) {
                onCreate(callSite)
            }
        } catch (exception: Exception) {
            throw UnsupportedException(
                "Error while validating the service descriptor '${descriptor}': ${exception.message}")
        }
    }

    private func onCreate(callSite: ServiceCallSite) {
        _callSiteValidator?.validateCallSite(callSite)
    }

    private func onResolve(callSite: ?ServiceCallSite, scope: IServiceScope) {
        if (let Some(callSite) <- callSite) {
            _callSiteValidator?.validateResolution(callSite, scope, root)
        }
    }
}

/*
服务访问器，用于缓描述每个图纸的解析引擎
 */
private class ServiceAccessor {
    ServiceAccessor(let callSite: ?ServiceCallSite, let realizedService: (ServiceProviderEngineScope) -> ?Object) {
    }
}
