// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_extensions_caching

import std.time.*

public class DistributedCacheEntryOptions {
    public DistributedCacheEntryOptions(
        public var slidingExpiration!: ?Duration = None,
        public var absoluteExpiration!: ?DateTime = None, 
        public var absoluteExpirationRelativeToNow!: ?Duration = None) {
    }
}
