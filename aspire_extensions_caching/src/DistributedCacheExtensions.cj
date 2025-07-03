package aspire_extensions_caching

import aspire_extensions_options.*
import aspire_extensions_injection.*

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
