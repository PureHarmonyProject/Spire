package spire_extensions_injection

import std.reflect.*

public interface IServiceProviderIsService {
    func isService(serviceType: TypeInfo): Bool
    func isService<T>(): Bool {
        return isService(TypeInfo.of<T>())
    }
}
