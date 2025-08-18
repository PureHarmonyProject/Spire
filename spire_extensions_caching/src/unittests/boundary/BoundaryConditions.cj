package spire_extensions_caching.unittests.boundary

import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import spire_extensions_caching.*
import spire_extensions_options.*
import spire_extensions_caching.unittests.*

/**
 * 空键处理测试
 * 测试缓存对空字符串键的处理
 */
@Test
func 空键处理测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let emptyKey = ""
    let value = TestHelper.createTestData("empty_key_value")
    
    // 使用空键设置值
    cache.set(emptyKey, value)
    
    // 使用空键获取值
    let result = cache.get(emptyKey)
    match(result) {
        case Some(v) => @Expect(v == value)
        case None => @Expect(false)
    }
    
    // 删除空键
    cache.remove(emptyKey)
    
    // 验证空键已被删除
    let afterRemove = cache.get(emptyKey)
    @Expect(afterRemove.isNone())
}

/**
 * 空字符串键处理测试
 * 测试缓存对空字符串键的字符串操作
 */
@Test
func 空字符串键处理测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let emptyKey = ""
    let value = "empty_string_value"
    
    // 使用空键设置字符串值
    cache.setString(emptyKey, value)
    
    // 使用空键获取字符串值
    let result = cache.getString(emptyKey)
    match(result) {
        case Some(v) => @Expect(v == value)
        case None => @Expect(false)
    }
}

/**
 * 空值处理测试
 * 测试缓存对空字节数组的处理
 */
@Test
func 空值处理测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let key = "empty_value_key"
    let emptyValue = Array<Byte>()
    
    // 设置空值
    cache.set(key, emptyValue)
    
    // 获取空值
    let result = cache.get(key)
    match(result) {
        case Some(v) => @Expect(v.size == 0)
        case None => @Expect(false)
    }
}

/**
 * 大数据量测试
 * 测试缓存处理大量数据的能力
 */
@Test
func 大数据量测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let itemCount = 1000
    let testData = TestHelper.createMultipleTestData(itemCount)
    
    // 批量设置数据
    for ((key, value) in testData) {
        cache.set(key, value)
    }
    
    // 验证所有数据都存在
    for ((key, value) in testData) {
        let result = cache.get(key)
        match(result) {
            case Some(v) => @Expect(v == value)
            case None => @Expect(false)
        }
    }
}

/**
 * 大数据量字符串测试
 * 测试缓存处理大量字符串数据的能力
 */
@Test
func 大数据量字符串测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let itemCount = 1000
    let testData = TestHelper.createStringTestData(itemCount)
    
    // 批量设置字符串数据
    for ((key, value) in testData) {
        cache.setString(key, value)
    }
    
    // 验证所有字符串数据都存在
    for ((key, value) in testData) {
        let result = cache.getString(key)
        match(result) {
            case Some(v) => @Expect(v == value)
            case None => @Expect(false)
        }
    }
}

/**
 * 特殊字符键测试
 * 测试缓存对包含特殊字符键的处理
 */
@Test
func 特殊字符键测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let specialData = TestHelper.createSpecialCharTestData()
    
    // 设置特殊字符键的数据
    for ((key, value) in specialData) {
        cache.set(key, value)
    }
    
    // 验证特殊字符键的数据
    for ((key, value) in specialData) {
        let result = cache.get(key)
        match(result) {
            case Some(v) => @Expect(v == value)
            case None => @Expect(false)
        }
    }
}

/**
 * 长键测试
 * 测试缓存对超长键的处理
 */
@Test
func 长键测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let longKey = TestHelper.generateRandomString(1000)
    let value = TestHelper.createTestData("long_key_value")
    
    // 使用长键设置值
    cache.set(longKey, value)
    
    // 使用长键获取值
    let result = cache.get(longKey)
    match(result) {
        case Some(v) => @Expect(v == value)
        case None => @Expect(false)
    }
}

/**
 * 长值测试
 * 测试缓存对超长值的处理
 */
@Test
func 长值测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let key = "long_value_key"
    let longValue = TestHelper.generateRandomBytes(10000)
    
    // 设置长值
    cache.set(key, longValue)
    
    // 获取长值
    let result = cache.get(key)
    match(result) {
        case Some(v) => @Expect(v == longValue)
        case None => @Expect(false)
    }
}

/**
 * 长字符串测试
 * 测试缓存对超长字符串的处理
 */
@Test
func 长字符串测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let key = "long_string_key"
    let longString = TestHelper.generateRandomString(10000)
    
    // 设置长字符串
    cache.setString(key, longString)
    
    // 获取长字符串
    let result = cache.getString(key)
    match(result) {
        case Some(v) => @Expect(v == longString)
        case None => @Expect(false)
    }
}

/**
 * 重复键测试
 * 测试缓存对重复键的处理
 */
@Test
func 重复键测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let key = "duplicate_key"
    let value1 = TestHelper.createTestData("value1")
    let value2 = TestHelper.createTestData("value2")
    let value3 = TestHelper.createTestData("value3")
    
    // 多次设置同一个键
    cache.set(key, value1)
    cache.set(key, value2)
    cache.set(key, value3)
    
    // 验证最后设置的值
    let result = cache.get(key)
    match(result) {
        case Some(v) => @Expect(v == value3)
        case None => @Expect(false)
    }
}

/**
 * 重复字符串键测试
 * 测试缓存对重复字符串键的处理
 */
@Test
func 重复字符串键测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let key = "duplicate_string_key"
    let value1 = "string_value1"
    let value2 = "string_value2"
    let value3 = "string_value3"
    
    // 多次设置同一个字符串键
    cache.setString(key, value1)
    cache.setString(key, value2)
    cache.setString(key, value3)
    
    // 验证最后设置的字符串值
    let result = cache.getString(key)
    match(result) {
        case Some(v) => @Expect(v == value3)
        case None => @Expect(false)
    }
}

/**
 * 混合操作测试
 * 测试缓存在混合操作下的稳定性
 */
@Test
func 混合操作测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let testData = TestHelper.createMultipleTestData(100)
    
    // 执行混合操作：设置、获取、删除、刷新
    for ((key, value) in testData) {
        cache.set(key, value)
        let getResult = cache.get(key)
        match(getResult) {
            case Some(v) => @Expect(v == value)
            case None => @Expect(false)
        }
        
        cache.refresh(key)
        let refreshResult = cache.get(key)
        match(refreshResult) {
            case Some(v) => @Expect(v == value)
            case None => @Expect(false)
        }
        
        if (key.endsWith("_5")) {
            cache.remove(key)
            let removeResult = cache.get(key)
            @Expect(removeResult.isNone())
        }
    }
}

/**
 * 频繁操作测试
 * 测试缓存在频繁操作下的性能和稳定性
 */
@Test
func 频繁操作测试() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    
    let key = "frequent_operation_key"
    let value = TestHelper.createTestData("frequent_value")
    
    // 频繁执行操作
    for (i in 1..99) {
        cache.set(key, value)
        let result = cache.get(key)
        match(result) {
            case Some(v) => @Expect(v == value)
            case None => @Expect(false)
        }
        
        cache.refresh(key)
        cache.remove(key)
        
        let afterRemove = cache.get(key)
        @Expect(afterRemove.isNone())
    }
}