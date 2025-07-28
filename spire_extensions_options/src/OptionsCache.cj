package spire_extensions_options

import std.collection.concurrent.*

public class OptionsCache<TOptions> <: IOptionsMonitorCache<TOptions> where TOptions <: Object {
    private let _cache = ConcurrentHashMap<String, TOptions>()

    public func getOrAdd(name: String, createOptions: () -> TOptions): TOptions {
        return _cache.entryView(name) {
            view => if (view.value.isNone()) {
                view.value = createOptions()
            }
        }.getOrThrow()
    }

    public func add(name: String, options: TOptions): ?TOptions {
        return _cache.addIfAbsent(name, options)
    }

    public func remove(name: String): ?TOptions {
        _cache.remove(name)
    }
}
