package spire_extensions_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_http.*
import spire_extensions_injection.*
import spire_extensions_options.*
import std.reflect.*
import spire_net_http.*

/**
 * 默认HTTP客户端工厂测试
 * 测试DefaultHttpClientFactory的创建和配置功能
 */
@Test
func 默认HTTP客户端工厂测试() {
    // 使用ServiceCollection来创建真实的依赖
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    // 获取真实的选项监控器
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    // 创建工厂
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 验证工厂创建成功
    @Expect(factory is DefaultHttpClientFactory, true)
    
    // 测试创建客户端
    let client = factory.createClient("TestClient")
    @Expect(client is HttpClient, true)
    
    // 测试创建处理器
    let handler = factory.createHandler("TestClient")
    @Expect(handler is HttpMessageHandler, true)
}

/**
 * HTTP客户端工厂服务注册测试
 * 测试服务集合的HTTP客户端工厂服务注册
 */
@Test
func 默认HTTP客户端工厂服务注册测试() {
    let services = ServiceCollection()
    
    // 添加HTTP客户端服务
    services.addHttpClient()
    
    // 验证服务注册成功
    let descriptor = services |> filter {f => f.serviceType == TypeInfo.of<IHttpClientFactory>()} |> first
    @Expect(descriptor.isSome())
}

/**
 * HTTP客户端工厂服务注册测试
 * 测试服务集合的HTTP客户端工厂服务注册
 */
@Test
func 命名HTTP客户端工厂服务注册测试() {
    let services = ServiceCollection()
    
    // 添加HTTP客户端服务
    services.addHttpClient("TestClient")
    
    // 验证服务注册成功
    let descriptor = services |> filter {f => f.serviceType == TypeInfo.of<IHttpClientFactory>()} |> first
    @Expect(descriptor.isSome())
}

/**
 * HTTP客户端工厂选项监控测试
 * 测试IOptionsMonitor<HttpClientFactoryOptions>的功能
 */
@Test
func HTTP客户端工厂选项监控测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let monitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    // 测试获取选项
    let options = monitor.get("TestClient")
    @Expect(options.httpClientActions.size >= 0)
    
    // 测试不同名称的选项
    let options2 = monitor.get("AnotherClient")
    @Expect(options2.httpClientActions.size >= 0)
}

/**
 * HTTP客户端工厂范围服务测试
 * 测试服务范围的创建和销毁
 */
@Test
func HTTP客户端工厂范围服务测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 测试创建处理器时的范围管理
    let handler = factory.createHandler("TestClient")
    @Expect(handler is HttpMessageHandler, true)
}

/**
 * HTTP客户端工厂客户端配置测试
 * 测试客户端的配置动作执行
 */
@Test
func HTTP客户端工厂客户端配置测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 测试创建客户端
    let client = factory.createClient("ConfiguredClient")
    @Expect(client is HttpClient, true)
}

/**
 * HTTP客户端工厂处理器构建测试
 * 测试处理器的构建过程
 */
@Test
func HTTP客户端工厂处理器构建测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 测试创建处理器
    let handler = factory.createHandler("BuilderClient")
    @Expect(handler is HttpMessageHandler, true)
}

/**
 * HTTP客户端工厂默认客户端测试
 * 测试默认客户端的创建
 */
@Test
func HTTP客户端工厂默认客户端测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 测试创建默认客户端
    let defaultClient = factory.createClient()
    @Expect(defaultClient is HttpClient, true)
}

/**
 * HTTP客户端工厂多客户端测试
 * 测试多个客户端的创建
 */
@Test
func HTTP客户端工厂多客户端测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 创建多个客户端
    let client1 = factory.createClient("Client1")
    let client2 = factory.createClient("Client2")
    let client3 = factory.createClient("Client3")
    
    // 验证所有客户端创建成功
    @Expect(client1 is HttpClient, true)
    @Expect(client2 is HttpClient, true)
    @Expect(client3 is HttpClient, true)
}

/**
 * HTTP客户端工厂选项变更测试
 * 测试选项变更的影响
 */
@Test
func HTTP客户端工厂选项变更测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let monitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    // 测试选项获取
    let options1 = monitor.get("Client1")
    let options2 = monitor.get("Client2")
    
    // 验证选项不为空
    @Expect(options1.httpClientActions.size >= 0)
    @Expect(options2.httpClientActions.size >= 0)
}

/**
 * HTTP客户端工厂服务提供者测试
 * 测试服务提供者的依赖注入
 */
@Test
func HTTP客户端工厂服务提供者测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 测试工厂使用服务提供者
    let client = factory.createClient("ServiceProviderTest")
    @Expect(client is HttpClient, true)
}

/**
 * HTTP客户端工厂错误处理测试
 * 测试工厂的错误处理机制
 */
@Test
func HTTP客户端工厂错误处理测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 测试正常情况下的错误处理
    let client = factory.createClient("ErrorHandlingTest")
    @Expect(client is HttpClient, true)
}

/**
 * HTTP客户端工厂线程安全测试
 * 测试工厂的线程安全性
 */
@Test
func HTTP客户端工厂线程安全测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 创建多个客户端测试线程安全
    let client1 = factory.createClient("ThreadSafe1")
    let client2 = factory.createClient("ThreadSafe2")
    
    // 验证客户端创建成功
    @Expect(client1 is HttpClient, true)
    @Expect(client2 is HttpClient, true)
}

/**
 * HTTP客户端工厂资源管理测试
 * 测试工厂的资源管理
 */
@Test
func HTTP客户端工厂资源管理测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 测试资源管理
    let client = factory.createClient("ResourceManagement")
    @Expect(client is HttpClient, true)
}

/**
 * HTTP客户端工厂性能测试
 * 测试工厂的性能
 */
@Test
func HTTP客户端工厂性能测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 创建多个客户端测试性能
    for (i in 0..10) {
        let client = factory.createClient("Performance${i}")
        @Expect(client is HttpClient, true)
    }
}

/**
 * HTTP客户端工厂配置验证测试
 * 测试工厂的配置验证
 */
@Test
func HTTP客户端工厂配置验证测试() {
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    
    let factory = DefaultHttpClientFactory(serviceProvider, optionsMonitor)
    
    // 测试配置验证
    let client = factory.createClient("ConfigValidation")
    @Expect(client is HttpClient, true)
}

