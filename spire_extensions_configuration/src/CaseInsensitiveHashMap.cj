// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_configuration

import std.collection.*

/// 不区分大小写的HashMap实现
/// 用于配置系统，支持不区分大小写的键访问
public class CaseInsensitiveHashMap<V> {
    private let _innerMap = HashMap<String, (String, V)>()
    
    public init() {
        // 父类构造函数
    }
    
    public init(entries: Collection<(String, V)>) {
        for ((key, value) in entries) {
            this.set(key, value)
        }
    }
    
    /// 将键转换为小写用于内部存储
    private func normalizeKey(key: String): String {
        return key.toAsciiLower()
    }
    
    /// 获取值
    public func get(key: String): ?V {
        let normalizedKey = normalizeKey(key)
        if (let Some((originalKey, value)) <- _innerMap.get(normalizedKey)) {
            return value
        }
        return None
    }
    
    /// 设置值
    public func set(key: String, value: V): Unit {
        let normalizedKey = normalizeKey(key)
        _innerMap[normalizedKey] = (key, value)
    }
    
    /// 检查是否包含键
    public func contains(key: String): Bool {
        let normalizedKey = normalizeKey(key)
        return _innerMap.contains(normalizedKey)
    }
    
    /// 删除键
    public func remove(key: String): ?V {
        let normalizedKey = normalizeKey(key)
        if (let Some((originalKey, value)) <- _innerMap.remove(normalizedKey)) {
            return Some(value)
        }
        return None
    }
    
    /// 获取所有键（返回原始键）
    public func keys(): Iterable<String> {
        var keys = ArrayList<String>()
        for ((_, (originalKey, _)) in _innerMap) {
            keys.add(originalKey)
        }
        return keys
    }
    
    /// 获取所有值
    public func values(): Iterable<V> {
        var values = ArrayList<V>()
        for ((_, (_, value)) in _innerMap) {
            values.add(value)
        }
        return values
    }
    
    /// 获取所有键值对
    public func entries(): Iterable<(String, V)> {
        var entries = ArrayList<(String, V)>()
        for ((_, (key, value)) in _innerMap) {
            entries.add((key, value))
        }
        return entries
    }
    
    /// 获取大小
    public prop size: Int64 {
        get() {
            _innerMap.size
        }
    }
    
    /// 清空
    public func clear(): Unit {
        _innerMap.clear()
    }
    
    /// 检查是否为空
    public func isEmpty(): Bool {
        return _innerMap.isEmpty()
    }
    
    /// 支持for循环
    public func iterator(): Iterator<(String, V)> {
        return entries().iterator()
    }
    
    /// 获取内部数据（用于兼容性）
    public func getInnerData(): HashMap<String, (String, V)> {
        return _innerMap
    }
    
    /// 批量添加
    public func addAll(entries: Collection<(String, V)>): Unit {
        for ((key, value) in entries) {
            this.set(key, value)
        }
    }
    
    /// 获取子键集合，用于配置系统
    /// 根据父路径获取所有子键，支持冒号分隔的层级结构
    public func getChildKeys(earlierKeys: Iterable<String>, parentPath: ?String): Iterable<String> {
        let results = HashSet<String>()
        if (let Some(parentPath) <- parentPath) {
            for (pattern in this.keys()) {
                if (pattern.size > parentPath.size && pattern.startsWith(parentPath) && pattern[parentPath.size..parentPath.size + 1] == ":") {
                    results.add(segment(pattern, parentPath.size + 1))
                }
            }
        } else {
            for (pattern in this.keys()) {
                results.add(segment(pattern, 0))
            }
        }
        for (key in earlierKeys) {
            results.add(key)
        }
        return results
    }
    
    /// 私有方法：提取键的段
    private func segment(key: String, prefixLength: Int64): String {
        if (let Some(index) <- key.indexOf(':', prefixLength)) {
            return key[prefixLength..index]
        }
        return key[prefixLength..]
    }
    
    /// 获取或设置操作符
    public operator func [](key: String): ?V {
        return get(key)
    }
    
    public operator func [](key: String, value!: V): Unit {
        set(key, value)
    }
}

/// 扩展函数，将标准HashMap转换为CaseInsensitiveHashMap
public func toCaseInsensitiveHashMap<V>(map: HashMap<String, V>): CaseInsensitiveHashMap<V> {
    let result = CaseInsensitiveHashMap<V>()
    for ((key, value) in map) {
            result.set(key, value)
        }
    return result
}

/// 扩展函数，将集合转换为CaseInsensitiveHashMap
public func toCaseInsensitiveHashMap<V>(entries: Collection<(String, V)>): CaseInsensitiveHashMap<V> {
    return CaseInsensitiveHashMap<V>(entries)
}