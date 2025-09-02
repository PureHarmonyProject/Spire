// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

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
