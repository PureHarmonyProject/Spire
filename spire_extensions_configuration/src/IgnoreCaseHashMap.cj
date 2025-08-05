package spire_extensions_configuration

import std.collection.*

class IgnoreCaseHashMap<TValue> <: Map<String, TValue> {
    private let _items: HashMap<String, TValue>

    init() {
        _items = HashMap<String, TValue>()
    }

    init(capacity: Int64) {
        _items = HashMap<String, TValue>(capacity)
    }

    public operator func [](key: String) {
        _items[key.toLowerStr()]
    }

    public operator func [](key: String, value!: TValue) {
        _items[key.toLowerStr()] = value
    }

    public func add(key: String, value: TValue) {
        _items.add(key.toLowerStr(), value)
    }

    public func add(all!: Collection<(String, TValue)>) {
        _items.add(all: all |> map {f => (f[0].toLowerStr(), f[1])} |> collectArray)
    }

    public func remove(key: String) {
        _items.remove(key.toLowerStr())
    }

    public func remove(all!: Collection<String>) {
        _items.remove(all: all |> map {key => key.toLowerStr()} |> collectArray)
    }

    public func removeIf(predicate: (String, TValue) -> Bool): Unit {
        _items.removeIf {
            key, value => predicate(key.toLowerStr(), value)
        }
    }

    public func clear() {
        _items.clear()
    }

    public func contains(key: String) {
        _items.contains(key.toLowerStr())
    }

    public func contains(all!: Collection<String>) {
        _items.contains(all: all |> map {key => key.toLowerStr()} |> collectArray)
    }

    public func entryView(key: String): MapEntryView<String, TValue> {
        _items.entryView(key.toLowerStr())
    }

    public func replace(key: String, value: TValue) {
        _items.replace(key.toLowerStr(), value)
    }

    public func get(key: String) {
        _items.get(key.toLowerStr())
    }

    public func keys() {
        _items.keys()
    }

    public func values() {
        _items.values()
    }

    public func isEmpty() {
        _items.isEmpty()
    }

    public func iterator() {
        _items.iterator()
    }

    public prop size: Int64 {
        get() {
            _items.size
        }
    }
}
