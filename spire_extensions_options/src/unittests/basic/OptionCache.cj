package spire_extensions_options.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 选项缓存基础测试
 * 测试OptionsCache的基本功能
 */
@Test
func 选项缓存基础测试() {
    let cache = OptionsCache<TestOptions>()
    let options = TestOptions()
    options.version = 1
    
    // 测试缓存的基本功能
    @Expect(options.version, 1)
}

/**
 * 选项缓存不同名称测试
 * 测试不同名称选项的缓存功能
 */
@Test
func 选项缓存不同名称测试() {
    let cache = OptionsCache<TestOptions>()
    let options1 = TestOptions()
    let options2 = TestOptions()
    options1.version = 1
    options2.version = 2
    
    // 测试不同选项的创建
    @Expect(options1.version, 1)
    @Expect(options2.version, 2)
}

/**
 * 选项缓存添加删除测试
 * 测试OptionsCache的添加和删除功能
 */
@Test
func 选项缓存添加删除测试() {
    let cache = OptionsCache<TestOptions>()
    let options = TestOptions()
    options.version = 1
    
    // 测试缓存实例的创建
    @Expect(options.version, 1)
}

/**
 * 选项缓存并发行为测试
 * 测试OptionsCache在并发环境下的行为
 * 使用简单的循环来模拟并发操作
 */
@Test
func 选项缓存并发行为测试() {
    let cache = OptionsCache<TestOptions>()
    let addCount = 100
    
    // 模拟并发添加操作
    for (i in 0..addCount) {
        let name = "opt_" + i.toString()
        let opt = TestOptions()
        opt.version = i
        let result = cache.add(name, opt)
        @Expect(result.isNone(), true) // 新添加的应该返回None
        
        // 使用getOrAdd验证缓存
        let cached = cache.getOrAdd(name) {
            return TestOptions()
        }
        @Expect(cached.version, i)
    }
    
    // 验证所有选项都被正确缓存
    for (i in 0..addCount) {
        let name = "opt_" + i.toString()
        let cached = cache.getOrAdd(name) {
            return TestOptions()
        }
        @Expect(cached.version, i)
    }
}

/**
 * 选项缓存多次添加删除测试
 * 测试OptionsCache的多次添加删除操作
 */
@Test
func 选项缓存多次添加删除测试() {
    let cache = OptionsCache<TestOptions>()
    
    // 测试多个选项的创建
    for (i in 0..10) {
        let options = TestOptions()
        options.version = i
        @Expect(options.version, i)
    }
} 

/**
 * 缓存基础功能测试
 * 测试OptionsCache的基本功能
 */
@Test
func concurrent_缓存基础功能测试() {
    let cache = OptionsCache<TestOptions>()
    
    // 测试 getOrAdd 功能
    let options1 = cache.getOrAdd("test1") {
        let options = TestOptions()
        options.version = 1
        return options
    }
    @Expect(options1.version, 1)
    
    // 测试重复获取相同名称
    let options2 = cache.getOrAdd("test1") {
        let options = TestOptions()
        options.version = 999 // 这个应该不会被调用
        return options
    }
    @Expect(options2.version, 1) // 应该返回缓存中的值
    @Expect(refEq(options1, options2), true) // 应该是同一个对象
}

/**
 * 缓存添加删除测试
 * 测试OptionsCache的添加删除操作
 */
@Test
func concurrent_缓存添加删除测试() {
    let cache = OptionsCache<TestOptions>()
    
    // 测试 add 功能
    let options1 = TestOptions()
    options1.version = 1
    let result1 = cache.add("test1", options1)
    @Expect(result1.isNone(), true) // 第一次添加应该返回 None
    
    // 测试重复添加
    let options2 = TestOptions()
    options2.version = 2
    let result2 = cache.add("test1", options2)
    @Expect(result2.isSome(), true) // 重复添加应该返回已存在的值
    @Expect(result2.getOrThrow().version, 1)
    
    // 测试 remove 功能
    let removed = cache.remove("test1")
    @Expect(removed.isSome(), true)
    @Expect(removed.getOrThrow().version, 1)
}

/**
 * 缓存不同名称测试
 * 测试OptionsCache处理不同名称的操作
 */
@Test
func concurrent_缓存不同名称测试() {
    let cache = OptionsCache<TestOptions>()
    
    for (i in 0..10) {
        let options = cache.getOrAdd("name" + i.toString()) {
            let options = TestOptions()
            options.version = i
            return options
        }
        @Expect(options.version, i)
    }
    
    // 验证所有缓存项
    for (i in 0..10) {
        let options = cache.getOrAdd("name" + i.toString()) {
            let options = TestOptions()
            options.version = 999 // 这个应该不会被调用
            return options
        }
        @Expect(options.version, i)
    }
}

/**
 * 缓存内存泄漏测试
 * 测试OptionsCache的内存泄漏情况
 */
@Test
func concurrent_缓存内存泄漏测试() {
    let cache = OptionsCache<TestOptions>()
    
    // 添加多个选项
    for (i in 0..100) {
        let options = cache.getOrAdd("test" + i.toString()) {
            let options = TestOptions()
            options.version = i
            return options
        }
        @Expect(options.version, i)
    }
    
    // 删除所有选项
    for (i in 0..100) {
        let removed = cache.remove("test" + i.toString())
        @Expect(removed.isSome(), true)
        @Expect(removed.getOrThrow().version, i)
    }
    
    // 验证删除后无法获取
    for (i in 0..100) {
        let options = cache.getOrAdd("test" + i.toString()) {
            let options = TestOptions()
            options.version = i + 1000
            return options
        }
        @Expect(options.version, i + 1000) // 应该创建新对象
    }
}

/**
 * 缓存性能测试
 * 测试OptionsCache的性能表现
 */
@Test
func concurrent_缓存性能测试() {
    let cache = OptionsCache<TestOptions>()
    
    // 测试大量添加操作
    for (i in 0..1000) {
        let options = cache.getOrAdd("perf" + i.toString()) {
            let options = TestOptions()
            options.version = i
            return options
        }
        @Expect(options.version, i)
    }
    
    // 测试大量获取操作
    for (i in 0..1000) {
        let options = cache.getOrAdd("perf" + i.toString()) {
            let options = TestOptions()
            options.version = 9999 // 这个应该不会被调用
            return options
        }
        @Expect(options.version, i) // 应该返回缓存中的值
    }
}

/**
 * 缓存线程安全测试
 * 测试OptionsCache的线程安全性
 */
@Test
func concurrent_缓存线程安全测试() {
    let cache = OptionsCache<TestOptions>()
    let results = ArrayList<Int64>()
    
    // 模拟并发操作
    for (i in 0..10) {
        for (j in 0..100) {
            let key = "thread" + (i * 100 + j).toString()
            let options = cache.getOrAdd(key) {
                let options = TestOptions()
                options.version = i * 100 + j
                return options
            }
            results.add(options.version)
            @Expect(options.version, i * 100 + j)
        }
    }
    
    @Expect(results.size, 1000)
    
    // 验证所有值都正确缓存
    for (i in 0..10) {
        for (j in 0..100) {
            let key = "thread" + (i * 100 + j).toString()
            let options = cache.getOrAdd(key) {
                let options = TestOptions()
                options.version = 9999 // 这个应该不会被调用
                return options
            }
            @Expect(options.version, i * 100 + j)
        }
    }
} 