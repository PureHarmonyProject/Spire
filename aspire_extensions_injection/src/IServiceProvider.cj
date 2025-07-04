// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_injection

import std.reflect.*

public interface IServiceProvider {
    func createScope(): IServiceScope
    func getAll<T>(): Array<T>
    func getOrDefault(typeInfo: TypeInfo): ?Object
    func getOrDefault<T>(): ?T {
        if (let Some(instance) <- getOrDefault(TypeInfo.of<T>()).flatMap{ f => f as T}) {
            return instance
        }
        return None
    }

    func getOrThrow(typeInfo: TypeInfo): Object {
        getOrDefault(typeInfo).getOrThrow()
    }

    func getOrThrow<T>(): T {
        getOrDefault<T>().getOrThrow()
    }
}
