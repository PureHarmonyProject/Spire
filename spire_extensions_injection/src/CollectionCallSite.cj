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
