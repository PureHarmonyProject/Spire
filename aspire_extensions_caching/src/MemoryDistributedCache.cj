package aspire_extensions_caching

import std.time.*
import std.sync.*
import std.collection.*
import std.collection.concurrent.*

class MemoryDistributedCache <: IDistributedCache {
    private let _lastExpirationScan: DateTime
    private let _syncCounter = SyncCounter(0)
    private let _options :DistributedCacheOptions
    private let _memory = ConcurrentHashMap<String, CacheEntry>()

    init(options: DistributedCacheOptions) {
        _options = options
    }

    public func get(key: String): ?Array<Byte> {
        refresh(key)
        if (let Some(value) <- _memory.get(key)) {
            return value.data
        }
        return None
    }

    public func set(key: String, value: Array<Byte>, options: DistributedCacheEntryOptions): Unit {
         _memory.entryView(key) { entryView => 
            entryView.value = CacheEntry(value, DateTime.now(), DateTime.now(), options)
        }
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
        if (_options.expirationScanFrequency > DateTime.now() - _lastExpirationScan) {            
            return
        }
        func scheduleTask() {
            spawn {
                
            }
        }
        scheduleTask()
    }

    private func scanForExpiredItems() {
        for (pattern in expression) {
            
        }
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
