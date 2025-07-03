package aspire_extensions_caching

import std.time.*
import std.sync.*
import std.collection.*
import std.collection.concurrent.*

import aspire_extensions_options.*

class MemoryDistributedCache <: IDistributedCache {
    private var _lastExpirationScan: DateTime
    private let _options :DistributedCacheOptions
    private let _memory = ConcurrentHashMap<String, CacheEntry>()

    public init(options: IOptions<DistributedCacheOptions>) {
        _options = options.value
        _lastExpirationScan = DateTime.now()
    }

    public func get(key: String): ?Array<Byte> {
        refresh(key)
        if (let Some(value) <- _memory.get(key) && !value.isExpired()) {
            return value.data
        }
        return None
    }

    public func set(key: String, value: Array<Byte>, options: DistributedCacheEntryOptions): Unit {
        _memory.entryView(key) { entryView => 
            entryView.value = CacheEntry(value, DateTime.now(), DateTime.now(), options)
        }
        startScanForExpiredItemsIfNeeded()
    }

    public func refresh(key: String): Unit {
        _memory.entryView(key) {
            entryView => if (let Some(value) <- entryView.value) {
                if (value.isExpired()) {
                    entryView.value = None
                }else {
                    value.lastAccessTime = DateTime.now()
                }
            }
        }
        startScanForExpiredItemsIfNeeded()
    }

    public func remove(key: String): Unit {
        _memory.remove(key)
        startScanForExpiredItemsIfNeeded()
    }

    /*
    扫描过期项
    */
    private func startScanForExpiredItemsIfNeeded() {
        func scheduleTask() {
            spawn {
                //不考虑极端情况，不然会造成阻塞
                if (!canStartScanForExpiredItems()) {            
                    return
                }
                scanForExpiredItems()
            }
        }
        scheduleTask()
    }

    private func scanForExpiredItems() {
        if (!canStartScanForExpiredItems()) {            
            return
        }
        _lastExpirationScan = DateTime.now()
        for ((key, value) in getCacheEntries()) {
           if (value.isExpired()) {
                _memory.remove(key)
           }
        }
    }

    private func canStartScanForExpiredItems() {
        if (_options.expirationScanFrequency < DateTime.now() - _lastExpirationScan && _memory.size > 0) {            
            return true
        }
        return false
    }

    private func getCacheEntries() {
        _memory |> collectArray
    }

    internal func getEntryCount() {
        _memory.size
    }
}

class CacheEntry {

    CacheEntry(
        let data: Array<Byte>,
        let creationTime: DateTime,
        var lastAccessTime: DateTime, 
        let options: DistributedCacheEntryOptions) {

    }

    func isExpired() {
        options.absoluteExpirationRelativeToNow.flatMap{span => DateTime.now() - creationTime > span} == true || 
        options.absoluteExpiration.flatMap{time => DateTime.now() > time} == true ||
        options.slidingExpiration.flatMap{span => (DateTime.now() - lastAccessTime) > span} == true
    }
}
