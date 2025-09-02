package spire_extensions_injection

struct ServiceCacheKey <: Equatable<ServiceCacheKey> & Hashable {
    public let slot: Int64
    public let identifier: ServiceIdentifier

    init(slot: Int64, identifier: ServiceIdentifier) {
        this.slot = slot
        this.identifier = identifier
    }

    public operator func ==(that: ServiceCacheKey) {
        this.identifier == that.identifier && this.slot == that.slot
    }

    @OverflowWrapping
    public func hashCode() {
        (identifier.hashCode() * 397) ^ slot
    }
}
