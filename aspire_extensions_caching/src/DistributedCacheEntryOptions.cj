package aspire_extensions_caching

import std.time.*

public class DistributedCacheEntryOptions {
    public DistributedCacheEntryOptions(
        public var slidingExpiration!: ?Duration = None,
        public var absoluteExpiration!: ?DateTime = None, 
        public var absoluteExpirationRelativeToNow!: ?Duration = None) {
    }
}
