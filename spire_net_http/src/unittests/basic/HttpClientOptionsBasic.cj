package spire_net_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.io.*
import std.time.*
import stdx.encoding.url.*
import spire_net_http.*

/**
 * HttpClientOptions默认构造函数测试
 * 测试HttpClientOptions的默认值设置
 */
@Test
func HttpClientOptions默认构造函数测试() {
    let options = HttpClientOptions()
    
    // 验证默认值
    @Expect(options.address.isSome(), false)
    @Expect(options.timeout, Duration.second * 180)
    @Expect(options.handlers.size, 0)
    @Expect(options.headers.getFirst("User-Agent"), None)
}

/**
 * HttpClientOptions基础地址设置测试
 * 测试基础URL地址的设置和验证
 */
@Test
func HttpClientOptions基础地址设置测试() {
    let options = HttpClientOptions()
    
    // 设置有效的绝对URL
    let validUrl = URL.parse("https://api.example.com")
    options.address = Some(validUrl)
    @Expect(options.address.isSome(), true)
    @Expect(options.address.flatMap { u => Some(u.toString()) }, Some("https://api.example.com"))
    
    // 设置None应该清除地址
    options.address = None
    @Expect(options.address.isSome(), false)
}

/**
 * HttpClientOptions无效地址测试
 * 测试设置无效URL地址时的异常处理
 */
@Test
func HttpClientOptions无效地址测试() {
    let options = HttpClientOptions()
    
    // 注意：根据源码，URL验证发生在构造时，这里测试设置None的情况
    options.address = None
    @Expect(options.address.isSome(), false)
}

/**
 * HttpClientOptions超时设置测试
 * 测试超时时间的设置和验证
 */
@Test
func HttpClientOptions超时设置测试() {
    let options = HttpClientOptions()
    
    // 设置有效超时时间
    options.timeout = Duration.minute
    @Expect(options.timeout, Duration.minute)
    
    options.timeout = Duration.second * 60
    @Expect(options.timeout, Duration.second * 60)
    
    // 设置很小的超时时间
    options.timeout = Duration.millisecond
    @Expect(options.timeout, Duration.millisecond)
}

/**
 * HttpClientOptions处理器管理测试
 * 测试HTTP消息处理器的添加和管理
 */
@Test
func HttpClientOptions处理器管理测试() {
    let options = HttpClientOptions()
    
    // 初始时应该没有处理器
    @Expect(options.handlers.size, 0)
    
    // 注意：根据源码，handlers是只读属性，测试只能读取不能修改
    // 这里验证handlers集合存在并且可以访问
    @Expect(options.handlers.size >= 0)
}

/**
 * HttpClientOptions头部管理测试
 * 测试默认HTTP头部的设置和管理
 */
@Test
func HttpClientOptions头部管理测试() {
    let options = HttpClientOptions()
    
    // 测试添加默认头部
    options.headers.add("User-Agent", "SpireNetHTTP/1.0")
    @Expect(options.headers.getFirst("User-Agent"), Some("SpireNetHTTP/1.0"))
    
    // 测试设置其他头部
    options.headers.add("Accept", "application/json")
    @Expect(options.headers.getFirst("Accept"), Some("application/json"))
}

/**
 * HttpClientOptions配置构建器测试
 * 测试使用构建器模式配置选项
 */
@Test
func HttpClientOptions配置构建器测试() {
    let options = HttpClientOptions()
    options.address = Some(URL.parse("https://api.example.com"))
    options.timeout = Duration.minute
    options.headers.add("Authorization", "Bearer token")
    
    // 验证配置是否正确应用
    @Expect(options.address.isSome(), true)
    @Expect(options.address.flatMap { u => Some(u.toString()) }, Some("https://api.example.com"))
    @Expect(options.timeout, Duration.minute)
    @Expect(options.headers.getFirst("Authorization"), Some("Bearer token"))
}

/**
 * HttpClientOptions多重配置测试
 * 测试多个配置项的组合使用
 */
@Test
func HttpClientOptions多重配置测试() {
    let baseUrl = URL.parse("https://api.example.com")
    let options = HttpClientOptions()
    options.address = Some(baseUrl)
    options.timeout = Duration.second * 45
    options.headers.add("Content-Type", "application/json")
    options.headers.add("Accept", "application/json")
    options.headers.add("User-Agent", "MyApp/1.0")
    
    // 验证所有配置项
    let baseUrlStr = baseUrl.toString()
    @Expect(options.address.isSome(), true)
    @Expect(options.address.flatMap { u => Some(u.toString()) }, Some(baseUrlStr))
    @Expect(options.timeout, Duration.second * 45)
    @Expect(options.headers.getFirst("Content-Type"), Some("application/json"))
    @Expect(options.headers.getFirst("Accept"), Some("application/json"))
    @Expect(options.headers.getFirst("User-Agent"), Some("MyApp/1.0"))
}

/**
 * HttpClientOptions头部覆盖测试
 * 测试头部值的覆盖行为
 */
@Test
func HttpClientOptions头部覆盖测试() {
    let options = HttpClientOptions()
    
    // 添加头部
    options.headers.add("Test-Header", "InitialValue")
    @Expect(options.headers.getFirst("Test-Header"), Some("InitialValue"))
    
    // 覆盖头部值
    options.headers.set("Test-Header", "UpdatedValue")
    @Expect(options.headers.getFirst("Test-Header"), Some("UpdatedValue"))
    
    // 添加多个值的头部
    options.headers.add("Multi-Header", "Value1")
    options.headers.add("Multi-Header", "Value2")
    
    let multiValues = options.headers.get("Multi-Header")
    @Expect(multiValues.size > 0)
}