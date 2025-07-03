package aspire_extensions_caching

public class DistributedCacheOptions {
    public let _expirationScanFrequency: Duration

    public init() {
        _expirationScanFrequency = Duration.minute * 60
    }

    public init(expirationScanFrequency: Duration) {
        _expirationScanFrequency = expirationScanFrequency
    }

    public prop expirationScanFrequency: Duration {
        get() {
            _expirationScanFrequency
        }
    }
}
