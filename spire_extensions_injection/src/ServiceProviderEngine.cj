package spire_extensions_injection

/*
容器引擎
 */
abstract class ServiceProviderEngine {
    public func realizeService(callSite: ServiceCallSite): (ServiceProviderEngineScope) -> ?Object
}
