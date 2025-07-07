// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_caching

public interface IDistributedCache {
    func get(key: String): ?Array<Byte>
    
    func refresh(key: String): Unit
    
    func remove(key: String): Unit
    
    func set(key: String, value: Array<Byte>): Unit {
        set(key, value, DistributedCacheEntryOptions())
    }

    func set(key: String, value: Array<Byte>, options: DistributedCacheEntryOptions): Unit

    func getString(key: String): ?String {
        if (let Some(value) <- get(key)) {
            return String.fromUtf8(value)
        }
        return None
    }

    func setString(key: String, value: String): Unit {
        set(key, value.toArray(), DistributedCacheEntryOptions())
    }

    func setString(key: String, value: String, options: DistributedCacheEntryOptions): Unit {
        set(key, value.toArray(), options)
    }
}
