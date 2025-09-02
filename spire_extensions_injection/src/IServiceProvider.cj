package spire_extensions_injection

import std.reflect.*

public interface IServiceProvider <: IServiceScopeFactory {
    func getOrDefault(serviceType: TypeInfo): ?Object

    func getOrThrow(serviceType: TypeInfo): Object {
        getOrDefault(serviceType).getOrThrow {
            UnsupportedException("No service for type '${serviceType}' has been registered.")
        }
    }

    func getOrDefault<T>(): ?T {
        return getOrDefault(TypeInfo.of<T>()).flatMap {f => f as T}
    }

    func getOrThrow<T>(): T {
        return getOrDefault<T>().getOrThrow {
            UnsupportedException("No service for type '${TypeInfo.of<T>()}' has been registered.")
        }
    }

    func getAll<T>(): Collection<T> {
        return getOrDefault<Collection<T>>() ?? []
    }
}
