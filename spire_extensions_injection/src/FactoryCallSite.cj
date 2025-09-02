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
