package aspire_extensions_caching

import std.collection.concurrent.*

main(): Int64 {
    let cache: IDistributedCache = MemoryDistributedCache()
    cache.setString("mobile", "ff", DistributedCacheEntryOptions(slidingExpiration: Duration.second * 10))
    println(cache.get("mobile"))
    sleep(Duration.second * 11)
    cache.refresh("mobile")
    if (let Some(mobile) <- cache.get("mobile")) {
        println(String.fromUtf8(mobile))
    }else {
        println("no value")
    }
    return 0
}
