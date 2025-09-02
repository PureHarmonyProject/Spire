package spire_extensions_injection

enum CallSiteResultCacheLocation <: Comparable<CallSiteResultCacheLocation> {
    Root
    | Scope
    | Dispose
    | None

    private prop value: Int64 {
        get() {
            match (this) {
                case Root => 0
                case Scope => 1
                case Dispose => 2
                case None => 3
            }
        }
    }

    public func compare(that: CallSiteResultCacheLocation) {
        if (value == that.value) {
            Ordering.EQ
        } else if (value >= that.value) {
            Ordering.GT
        } else {
            Ordering.LT
        }
    }
}
