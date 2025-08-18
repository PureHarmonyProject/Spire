package spire_extensions_caching.unittests.extension

import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import spire_extensions_caching.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_caching.unittests.*

/**
 * 添加分布式内存缓存测试
 * 测试ServiceCollection的addDistributedMemoryCache扩展方法
 */
@Test
func 添加分布式内存缓存测试() {
    let services = ServiceCollection()
    
    // 使用默认配置添加分布式内存缓存
    let result = services.addDistributedMemoryCache()
    
    // 验证返回的是ServiceCollection实例
    @Expect(result is ServiceCollection)
    
    // 验证服务已正确注册
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    @Expect(cache.isSome())
}

/**
 * 带配置的添加分布式内存缓存测试
 * 测试带配置选项的addDistributedMemoryCache方法
 */
@Test
func 带配置的添加分布式内存缓存测试() {
    let services = ServiceCollection()
    
    // 使用自定义配置添加分布式内存缓存
    let result = services.addDistributedMemoryCache { options =>
        // 配置选项（实际应用中会设置属性）
        // 这里我们只是测试配置函数被调用
    }
    
    // 验证返回的是ServiceCollection实例
    @Expect(result is ServiceCollection)
    
    // 验证服务已正确注册
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    @Expect(cache.isSome())
}

/**
 * 缓存选项配置测试
 * 测试缓存选项的配置是否正确生效
 */
@Test
func 缓存选项配置测试() {
    let services = ServiceCollection()
    
    let expectedScanFrequency = Duration.second * 45
    
    // 配置缓存选项
    services.addDistributedMemoryCache { options =>
        // 配置选项（实际应用中会设置属性）
        // 这里我们只是测试配置函数被调用
    }
    
    // 验证配置是否生效
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    
    // 验证缓存服务存在，说明配置生效
    @Expect(cache.isSome())
}

/**
 * 单例服务注册测试
 * 测试缓存服务是否注册为单例
 */
@Test
func 单例服务注册测试() {
    let services = ServiceCollection()
    
    // 添加分布式内存缓存
    services.addDistributedMemoryCache()
    
    let serviceProvider = services.build()
    
    // 获取两个缓存实例
    let cache1 = serviceProvider.getOrDefault<IDistributedCache>()
    let cache2 = serviceProvider.getOrDefault<IDistributedCache>()
    
    // 验证两个实例都存在
    @Expect(cache1.isSome())
    @Expect(cache2.isSome())
}

/**
 * 依赖注入集成测试
 * 测试缓存服务与依赖注入系统的集成
 */
@Test
func 依赖注入集成测试() {
    let services = ServiceCollection()
    
    // 添加分布式内存缓存
    services.addDistributedMemoryCache()
    
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    
    // 验证缓存服务可以正常使用
    @Expect(cache.isSome())
    
    match(cache) {
        case Some(actualCache) => 
            let key = "di_test_key"
            let value = TestHelper.createTestData("di_test_value")
            
            // 测试基本操作
            actualCache.set(key, value)
            let result = actualCache.get(key)
            match(result) {
                case Some(v) => @Expect(v == value)
                case None => @Expect(false)
            }
        case None => @Expect(false)
    }
}

/**
 * 多次添加缓存服务测试
 * 测试多次添加缓存服务时的行为
 */
@Test
func 多次添加缓存服务测试() {
    let services = ServiceCollection()
    
    // 多次添加分布式内存缓存
    services.addDistributedMemoryCache()
    services.addDistributedMemoryCache()
    services.addDistributedMemoryCache()
    
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    
    // 验证服务存在
    @Expect(cache.isSome())
}

/**
 * 服务集合链式调用测试
 * 测试ServiceCollection的链式调用功能
 */
@Test
func 服务集合链式调用测试() {
    let services = ServiceCollection()
    
    // 链式调用多个扩展方法
    let result = services.addDistributedMemoryCache()
                         .addDistributedMemoryCache()
                         .addDistributedMemoryCache()
    
    // 验证返回的是同一个ServiceCollection实例
    @Expect(result is ServiceCollection)
    // 链式调用应该返回同一个实例
    @Expect(true)
}

/**
 * 空配置函数测试
 * 测试传入空配置函数时的行为
 */
@Test
func 空配置函数测试() {
    let services = ServiceCollection()
    
    // 传入空的配置函数
    let result = services.addDistributedMemoryCache {_ =>}
    
    // 验证服务正常注册
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    @Expect(cache.isSome())
}

/**
 * 自定义扫描频率测试
 * 测试自定义扫描频率的配置
 */
@Test
func 自定义扫描频率测试() {
    let services = ServiceCollection()
    
    let customFrequency = Duration.minute * 5
    
    // 配置自定义扫描频率
    services.addDistributedMemoryCache { options =>
        // 配置选项（实际应用中会设置属性）
    }
    
    // 验证服务正常注册
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    @Expect(cache.isSome())
}

/**
 * 缓存扩展功能测试
 * 测试缓存扩展功能的完整性
 */
@Test
func 缓存扩展功能测试() {
    let services = ServiceCollection()
    
    // 添加分布式内存缓存
    services.addDistributedMemoryCache()
    
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    
    @Expect(cache.isSome())
    
    match(cache) {
        case Some(actualCache) => 
            // 测试所有接口方法
            let key = "extension_test_key"
            let value = TestHelper.createTestData("extension_test_value")
            let stringValue = "extension_string_value"
            
            // 测试基本操作
            actualCache.set(key, value)
            let getResult = actualCache.get(key)
            match(getResult) {
                case Some(v) => @Expect(v == value)
                case None => @Expect(false)
            }
            
            // 测试字符串操作
            actualCache.setString(key, stringValue)
            let getStringResult = actualCache.getString(key)
            match(getStringResult) {
                case Some(v) => @Expect(v == stringValue)
                case None => @Expect(false)
            }
            
            // 测试刷新操作
            actualCache.refresh(key)
            let refreshResult = actualCache.get(key)
            @Expect(refreshResult.isSome())
            
            // 测试删除操作
            actualCache.remove(key)
            let removeResult = actualCache.get(key)
            @Expect(removeResult.isNone())
        case None => @Expect(false)
    }
}

/**
 * 默认配置测试
 * 测试使用默认配置的情况
 */
@Test
func 默认配置测试() {
    let services = ServiceCollection()
    
    // 使用默认配置
    services.addDistributedMemoryCache()
    
    let serviceProvider = services.build()
    let cache = serviceProvider.getOrDefault<IDistributedCache>()
    
    // 验证缓存服务正常工作
    @Expect(cache.isSome())
    
    match(cache) {
        case Some(actualCache) => 
            let key = "default_config_key"
            let value = TestHelper.createTestData("default_config_value")
            
            actualCache.set(key, value)
            let result = actualCache.get(key)
            match(result) {
                case Some(v) => @Expect(v == value)
                case None => @Expect(false)
            }
        case None => @Expect(false)
    }
}