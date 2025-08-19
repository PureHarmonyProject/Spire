package spire_extensions_caching.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import spire_extensions_caching.*
import spire_extensions_options.*
import spire_extensions_caching.unittests.*

/**
 * 基本存取操作测试
 * 测试缓存的基本get和set功能
 */
@Test
func 基本存取操作测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 准备测试数据
    let key = "test_key"
    let value = TestHelper.createTestData("test_value")
    
    // 设置值
    cache.set(key, value)
    
    // 获取值
    let result = cache.get(key)
    match(result) {
        case Some(v) => @Expect(v == value)
        case None => @Expect(false)
    }
}

/**
 * 字符串存取操作测试
 * 测试缓存的getString和setString功能
 */
@Test
func 字符串存取操作测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 准备测试数据
    let key = "string_key"
    let value = "test_string_value"
    
    // 设置字符串值
    cache.setString(key, value)
    
    // 获取字符串值
    let result = cache.getString(key)
    match(result) {
        case Some(v) => @Expect(v == value)
        case None => @Expect(false)
    }
}

/**
 * 键不存在时获取测试
 * 测试获取不存在的键时返回None
 */
@Test
func 键不存在时获取测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 获取不存在的键
    let result = cache.get("nonexistent_key")
    @Expect(result.isNone())
    
    // 获取不存在的字符串键
    let stringResult = cache.getString("nonexistent_string_key")
    @Expect(stringResult.isNone())
}

/**
 * 键的删除操作测试
 * 测试缓存的remove功能
 */
@Test
func 键的删除操作测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 准备测试数据
    let key = "remove_key"
    let value = TestHelper.createTestData("remove_value")
    
    // 设置值
    cache.set(key, value)
    
    // 验证值存在
    let beforeRemove = cache.get(key)
    match(beforeRemove) {
        case Some(v) => @Expect(v == value)
        case None => @Expect(false)
    }
    
    // 删除键
    cache.remove(key)
    
    // 验证键已被删除
    let afterRemove = cache.get(key)
    @Expect(afterRemove.isNone())
}

/**
 * 刷新操作测试
 * 测试缓存的refresh功能
 */
@Test
func 刷新操作测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 准备测试数据
    let key = "refresh_key"
    let value = TestHelper.createTestData("refresh_value")
    
    // 设置值
    cache.set(key, value)
    
    // 刷新键
    cache.refresh(key)
    
    // 验证值仍然存在
    let result = cache.get(key)
    match(result) {
        case Some(v) => @Expect(v == value)
        case None => @Expect(false)
    }
}

/**
 * 刷新不存在的键测试
 * 测试刷新不存在的键时不会抛出异常
 */
@Test
func 刷新不存在的键测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 刷新不存在的键,验证操作正常完成
    try {
        cache.refresh("nonexistent_key")
        @Expect(true)
    } catch (e: Exception) {
        @Expect(false)
    }
}

/**
 * 删除不存在的键测试
 * 测试删除不存在的键时不会抛出异常
 */
@Test
func 删除不存在的键测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 删除不存在的键，验证操作正常完成
    try {
        cache.remove("nonexistent_key")
        @Expect(true)
    } catch (e: Exception) {
        @Expect(false)
    }
}

/**
 * 多个键的存取测试
 * 测试缓存处理多个键的能力
 */
@Test
func 多个键的存取测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 准备多个测试数据
    let testData = TestHelper.createMultipleTestData(5)
    
    // 设置所有值
    for ((key, value) in testData) {
        cache.set(key, value)
    }
    
    // 验证所有值都存在
    for ((key, value) in testData) {
        let result = cache.get(key)
        match(result) {
            case Some(v) => @Expect(v == value)
            case None => @Expect(false)
        }
    }
}

/**
 * 多个字符串键的存取测试
 * 测试缓存处理多个字符串键的能力
 */
@Test
func 多个字符串键的存取测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    // 准备多个字符串测试数据
    let testData = TestHelper.createStringTestData(5)
    
    // 设置所有字符串值
    for ((key, value) in testData) {
        cache.setString(key, value)
    }
    
    // 验证所有字符串值都存在
    for ((key, value) in testData) {
        let result = cache.getString(key)
        match(result) {
            case Some(v) => @Expect(v == value)
            case None => @Expect(false)
        }
    }
}

/**
 * 更新已存在的键测试
 * 测试更新已存在键的值
 */
@Test
func 更新已存在的键测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let key = "update_key"
    let originalValue = TestHelper.createTestData("original_value")
    let updatedValue = TestHelper.createTestData("updated_value")
    
    // 设置原始值
    cache.set(key, originalValue)
    
    // 验证原始值
    let originalResult = cache.get(key)
    match(originalResult) {
        case Some(v) => @Expect(v == originalValue)
        case None => @Expect(false)
    }
    
    // 更新值
    cache.set(key, updatedValue)
    
    // 验证更新后的值
    let updatedResult = cache.get(key)
    match(updatedResult) {
        case Some(v) => @Expect(v == updatedValue)
        case None => @Expect(false)
    }
}

/**
 * 更新已存在的字符串键测试
 * 测试更新已存在字符串键的值
 */
@Test
func 更新已存在的字符串键测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let key = "update_string_key"
    let originalValue = "original_string_value"
    let updatedValue = "updated_string_value"
    
    // 设置原始值
    cache.setString(key, originalValue)
    
    // 验证原始值
    let originalResult = cache.getString(key)
    match(originalResult) {
        case Some(v) => @Expect(v == originalValue)
        case None => @Expect(false)
    }
    
    // 更新值
    cache.setString(key, updatedValue)
    
    // 验证更新后的值
    let updatedResult = cache.getString(key)
    match(updatedResult) {
        case Some(v) => @Expect(v == updatedValue)
        case None => @Expect(false)
    }
}