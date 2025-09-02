package spire_extensions_injection

import std.reflect.*

/*
返回this
*/
class ServiceProviderCallSite <: ServiceCallSite {
    private let _serviceType: TypeInfo
    private let _implementationType: TypeInfo

    public init() {
        super(CallSiteKind.ServiceProvider, CallSiteResultCache.none(TypeInfo.of<IServiceProvider>()))
        _serviceType = TypeInfo.of<IServiceProvider>()
        _implementationType = TypeInfo.of<ServiceProvider>()
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
