// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_caching

import std.time.*
import std.sync.*
import std.collection.*
import std.collection.concurrent.*

import aspire_extensions_options.*

class MemoryDistributedCache <: IDistributedCache {
    private var _lastExpirationScan: DateTime
    private let _isScanning = AtomicBool(false)
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
                    //滑动过期
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
        if (!canStartScanForExpiredItems()) {            
            return
        }
        func scheduleTask() {            
            spawn {
                try {
                    scanForExpiredItems()
                }finally {
                    _isScanning.store(false)
                }
            }
        }
        //处理极端场景
        if (_isScanning.compareAndSwap(false, true)) {
            scheduleTask()
        }
    }

    private func scanForExpiredItems() {      
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
