package spire_extensions_injection

/*
该类表示它使用动态反射技术来解析服务
*/
class DynamicServiceProviderEngine <: ServiceProviderEngine {
    init() {
    }

    public func realizeService(callSite: ServiceCallSite): (ServiceProviderEngineScope) -> ?Object {
        return {
            // 后续可以在此处介入动态编译技术
            scope => CallSiteRuntimeResolver.Instance.resolve(callSite, scope)
        }
    }
}
