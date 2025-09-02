package spire_extensions_injection

import std.reflect.*

struct ServiceIdentifier <: Equatable<ServiceIdentifier> & Hashable {
    private let _serviceType: TypeInfo

    public init(serviceType: TypeInfo) {
        _serviceType = serviceType
    }

    public prop serviceType: TypeInfo {
        get() {
            _serviceType
        }
    }

    public static func fromServiceType(serviceType: TypeInfo) {
        ServiceIdentifier(serviceType)
    }

    public static func fromDescriptor(serviceDescriptor: ServiceDescriptor) {
        ServiceIdentifier(serviceDescriptor.serviceType)
    }

    public func hashCode() {
        return serviceType.hashCode()
    }

    public operator func ==(that: ServiceIdentifier) {
        return that.serviceType == this.serviceType
    }
}
