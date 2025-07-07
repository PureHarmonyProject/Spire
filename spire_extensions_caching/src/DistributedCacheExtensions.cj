// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_caching

import spire_extensions_options.*
import spire_extensions_injection.*

public interface DistributedCacheExtensions {
    func addDistributedMemoryCache(): ServiceCollection {
        return addDistributedMemoryCache {_ =>}
    }
    func addDistributedMemoryCache(configureOptions: (DistributedCacheOptions) -> Unit): ServiceCollection
}

extend ServiceCollection <: DistributedCacheExtensions {
    public func addDistributedMemoryCache(configureOptions: (DistributedCacheOptions) -> Unit): ServiceCollection {
        this.configure<DistributedCacheOptions>(configureOptions)
        this.tryAddSingleton<IDistributedCache, MemoryDistributedCache>()
        return this
    }
}
