package aspire_extensions_caching

import aspire_extensions_injection
import aspire_extensions_options.OptionsServiceCollectionExtensions
import aspire_extensions_injection.*

public interface DistributedCacheExtensions {
    func addDistributedMemoryCache(): Unit {
        addDistributedMemoryCache {_ =>}
    }
    func addDistributedMemoryCache(configureOptions: (DistributedCacheOptions) -> Unit): Unit
}

extend ServiceCollection {
    public func addDistributedMemoryCache(configureOptions: (DistributedCacheOptions) -> Unit) {
        this.configure<DistributedCacheOptions>(configureOptions)
        this.tryAddSingleton<IDistributedCache, MemoryDistributedCache>()
    }
}
