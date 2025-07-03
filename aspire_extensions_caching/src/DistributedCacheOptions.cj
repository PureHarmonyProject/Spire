package aspire_extensions_caching

public class DistributedCacheOptions {
    public var sizeLimit: ?Int64 = None 
    public var expirationScanFrequency = Duration.minute * 60
}