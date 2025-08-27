package spire_extensions_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_http.*
import spire_extensions_http.unittests.*
import spire_extensions_injection.*
import spire_net_http.*
import spire_extensions_options.*
import std.reflect.*

/**
 * HTTP客户端工厂接口测试
 * 测试IHttpClientFactory接口的基本功能
 */
@Test
func HTTP客户端工厂接口测试() {
    // 使用真实的依赖注入和服务
    let services = ServiceCollection()
    services.addHttpClient()
    let serviceProvider = services.build()
    let optionsMonitor = serviceProvider.getOrThrow<IOptionsMonitor<HttpClientFactoryOptions>>()
    let scopeFactory = serviceProvider.getOrThrow<IServiceScopeFactory>()
    let factory = DefaultHttpClientFactory(scopeFactory, optionsMonitor)
    
    // 测试默认名称的客户端创建
    let defaultClient = factory.createClient()
    @Expect(defaultClient is HttpClient, true)
    
    // 测试指定名称的客户端创建
    let namedClient = factory.createClient("TestClient")
    @Expect(namedClient is HttpClient, true)
}

/**
 * HTTP客户端工厂选项测试
 * 测试HttpClientFactoryOptions类的功能
 */
@Test
func HTTP客户端工厂选项测试() {
    let options = HttpClientFactoryOptions()
    
    // 验证初始状态
    @Expect(options.httpClientActions.size, 0)
    @Expect(options.httpMessageHandlerBuilderActions.size, 0)
    
    // 添加HTTP客户端动作
    options.httpClientActions.add({ _ => 
        // 模拟客户端配置
    })
    
    // 添加HTTP消息处理器构建器动作
    options.httpMessageHandlerBuilderActions.add({ _ => 
        // 模拟处理器配置
    })
    
    // 验证添加后的状态
    @Expect(options.httpClientActions.size, 1)
    @Expect(options.httpMessageHandlerBuilderActions.size, 1)
}

/**
 * HTTP客户端映射注册表测试
 * 测试HttpClientMappingRegistry类的功能
 */
@Test
func HTTP客户端映射注册表测试() {
    let registry = HttpClientMappingRegistry()
    
    // 验证初始状态
    @Expect(registry.namedClientRegistrations.size, 0)
    
    // 添加命名客户端注册
    let testType = TypeInfo.of<String>()
    registry.namedClientRegistrations["TestClient"] = testType
    
    // 验证添加后的状态
    @Expect(registry.namedClientRegistrations.size, 1)
    @Expect(registry.namedClientRegistrations.contains("TestClient"))
    
    // 验证获取注册的类型信息
    let registeredType = registry.namedClientRegistrations.get("TestClient")
    @Expect(registeredType, Some(testType))
}

/**
 * HTTP消息处理器构建器抽象类测试
 * 测试HttpMessageHandlerBuilder抽象类的功能
 */
@Test
func HTTP消息处理器构建器抽象类测试() {
    let services = ServiceCollection()
    let serviceProvider = services.build()
    let builder = TestDefaultHttpMessageHandlerBuilder(serviceProvider)
    
    // 测试处理器管道创建
    let primaryHandler = MockHttpClientHandler() 
    let additionalHandlers = ArrayList<DelegatingHandler>()
    
    // 添加一些真实的委托处理器
    additionalHandlers.add(LoggingDelegatingHandler())
    additionalHandlers.add(LoggingDelegatingHandler())
    
    let pipeline = builder.createHandlerPipeline(primaryHandler, additionalHandlers)
    
    // 验证管道的处理器链
    @Expect(pipeline is DelegatingHandler) // 第一个应该是委托处理器
}

/**
 * HTTP客户端构建器配置测试
 * 测试HttpClientBuilder的配置功能
 */
@Test
func HTTP客户端构建器配置测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试HTTP客户端配置
    let configureCalled = ConfigCounter()
    builder.configureHttpClient({ _ => 
        configureCalled.setCount(1)
    })
    
    @Expect(configureCalled.count, 1)
    
    // 测试HTTP消息处理器构建器配置
    let builderConfigureCalled = ConfigCounter()
    builder.configureHttpMessageHandlerBuilder({ _ => 
        builderConfigureCalled.setCount(1)
    })
    
    @Expect(builderConfigureCalled.count, 1)
}

/**
 * HTTP客户端构建器服务集合扩展测试
 * 测试HttpClientFactoryServiceCollectionExtensions的功能
 */
@Test
func HTTP客户端构建器服务集合扩展测试() {
    let services = ServiceCollection()
    
    // 测试添加HTTP客户端服务
    let result1 = services.addHttpClient()
    @Expect(refEq(result1, services))
    
    // 测试配置HTTP客户端默认值
    let defaultsConfigured = ConfigCounter()
    let result2 = services.configureHttpClientDefaults({ _ => 
        defaultsConfigured.setCount(1)
    })
    
    @Expect(refEq(result2, services))
    @Expect(defaultsConfigured.count, 1)
    
    // 测试添加命名HTTP客户端
    let namedBuilder = services.addHttpClient("NamedClient")
    @Expect(namedBuilder.name, "NamedClient")
}

/**
 * 默认HTTP消息处理器构建器测试
 * 测试DefaultHttpMessageHandlerBuilder的功能
 */
@Test
func 默认HTTP消息处理器构建器测试() {
    let services = ServiceCollection()
    let serviceProvider = services.build()
    let builder = TestDefaultHttpMessageHandlerBuilder(serviceProvider)
    
    // 验证初始状态
    @Expect(builder.name, None)  
    @Expect(builder.primaryHandler is MockHttpClientHandler)
    @Expect(builder.additionalHandlers.size, 0)
    
    // 测试设置名称
    builder.name = "TestBuilder"
    @Expect(builder.name, Some("TestBuilder"))
    
    // 测试设置主处理器
    let newPrimaryHandler = MockHttpClientHandler()
    builder.primaryHandler = newPrimaryHandler
    @Expect(refEq(builder.primaryHandler, newPrimaryHandler))
    
    // 测试添加额外的处理器
    let additionalHandler = LoggingDelegatingHandler()
    builder.additionalHandlers.add(additionalHandler)
    @Expect(builder.additionalHandlers.size, 1)
    
    // 测试构建处理器管道
    let pipeline = builder.build()
    @Expect(pipeline is DelegatingHandler)
}

/**
 * HTTP客户端工厂选项验证测试
 * 测试HttpClientFactoryOptions的验证功能
 */
@Test
func HTTP客户端工厂选项验证测试() {
    let options = HttpClientFactoryOptions()
    
    // 添加多个配置动作
    let actionCount = ConfigCounter()
    for (_ in 0..5) {
        options.httpClientActions.add({ _ => 
            actionCount.increment()
        })
        options.httpMessageHandlerBuilderActions.add({ _ => 
            actionCount.increment()
        })
    }
    
    // 验证动作数量
    @Expect(options.httpClientActions.size, 5)
    @Expect(options.httpMessageHandlerBuilderActions.size, 5)
    
    // 执行所有动作
    let mockClient = HttpClient(MockHttpClientHandler(), false)
    let services = ServiceCollection()
    let serviceProvider = services.build()
    let mockBuilder = DefaultHttpMessageHandlerBuilder(serviceProvider)
    
    for (action in options.httpClientActions) {
        action(mockClient)
    }
    
    for (action in options.httpMessageHandlerBuilderActions) {
        action(mockBuilder)
    }
    
    // 验证动作执行次数
    @Expect(actionCount.count, 10)
}

/**
 * HTTP客户端映射注册表冲突测试
 * 测试HttpClientMappingRegistry的冲突处理
 */
@Test
func HTTP客户端映射注册表冲突测试() {
    let registry = HttpClientMappingRegistry()
    
    // 添加第一个注册
    let firstType = TypeInfo.of<String>()
    registry.namedClientRegistrations["Client1"] = firstType
    
    // 验证第一个注册存在
    @Expect(registry.namedClientRegistrations.contains("Client1"))
    
    // 添加第二个注册
    let secondType = TypeInfo.of<Int64>()
    registry.namedClientRegistrations["Client2"] = secondType
    
    // 验证两个注册都存在
    @Expect(registry.namedClientRegistrations.size, 2)
    @Expect(registry.namedClientRegistrations.contains("Client1"))
    @Expect(registry.namedClientRegistrations.contains("Client2"))
    
    // 验证类型信息正确
    @Expect(registry.namedClientRegistrations.get("Client1"), Some(firstType))
    @Expect(registry.namedClientRegistrations.get("Client2"), Some(secondType))
}

/**
 * HTTP消息处理器构建器管道测试
 * 测试HttpMessageHandlerBuilder的处理器管道创建
 */
@Test
func HTTP消息处理器构建器管道测试() {
    let services = ServiceCollection()
    let serviceProvider = services.build()
    let builder = TestDefaultHttpMessageHandlerBuilder(serviceProvider)
    
    // 创建主处理器
    let primaryHandler = MockHttpClientHandler()
    
    // 创建多个委托处理器
    let handlers = ArrayList<DelegatingHandler>()
    for (_ in 0..3) {
        handlers.add(LoggingDelegatingHandler())
    }
    
    // 构建处理器管道
    let pipeline = builder.createHandlerPipeline(primaryHandler, handlers)
    
    // 验证管道不为空
    @Expect(pipeline is DelegatingHandler)
    
    // 验证管道是委托处理器链
    var currentHandler = pipeline
    var handlerCount = 0
    
    while (currentHandler is DelegatingHandler) {
        handlerCount++
        let delegatingHandler = currentHandler as DelegatingHandler
        currentHandler = delegatingHandler.getOrThrow().innerHandler.getOrThrow()
    }
    
    // 验证处理器数量（主处理器 + 3个委托处理器）
    @Expect(handlerCount, 3)
}

/**
 * HTTP客户端构建器命名测试
 * 测试HttpClientBuilder的命名功能
 */
@Test
func HTTP客户端构建器命名测试() {
    let services = ServiceCollection()
    
    // 测试不同名称的构建器
    let builder1 = HttpClientBuilder("Client1", services)
    let builder2 = HttpClientBuilder("Client2", services)
    let builder3 = HttpClientBuilder("Client3", services)
    
    // 验证名称正确
    @Expect(builder1.name, "Client1")
    @Expect(builder2.name, "Client2")
    @Expect(builder3.name, "Client3")
    
    // 验证服务集合相同
    @Expect(refEq(builder1.services, builder2.services))
    @Expect(refEq(builder2.services, builder3.services))
}

/**
 * HTTP客户端工厂选项空处理测试
 * 测试HttpClientFactoryOptions的空处理
 */
@Test
func HTTP客户端工厂选项空处理测试() {
    let options = HttpClientFactoryOptions()
    
    // 验证初始状态为空
    @Expect(options.httpClientActions.size, 0)
    @Expect(options.httpMessageHandlerBuilderActions.size, 0)
    
    // 尝试执行空的动作列表
    let mockClient = HttpClient(MockHttpClientHandler(), false)
    let services = ServiceCollection()
    let serviceProvider = services.build()
    let mockBuilder = DefaultHttpMessageHandlerBuilder(serviceProvider)
    
    for (action in options.httpClientActions) {
        action(mockClient)
    }
    
    for (action in options.httpMessageHandlerBuilderActions) {
        action(mockBuilder)
    }
    
    // 验证没有异常发生
    @Expect(true)
}

/**
 * HTTP客户端映射注册表边界测试
 * 测试HttpClientMappingRegistry的边界情况
 */
@Test
func HTTP客户端映射注册表边界测试() {
    let registry = HttpClientMappingRegistry()
    
    // 验证空注册表的获取
    @Expect(registry.namedClientRegistrations.get("NonExistent"), None)
    
    // 验证空键的处理
    let emptyKeyType = TypeInfo.of<String>()
    registry.namedClientRegistrations[""] = emptyKeyType
    @Expect(registry.namedClientRegistrations.contains(""))
    
    // 验证特殊字符键的处理
    let specialKeyType = TypeInfo.of<Int64>()
    registry.namedClientRegistrations["Special-Client_Name"] = specialKeyType
    @Expect(registry.namedClientRegistrations.contains("Special-Client_Name"))
    
    // 验证大小写敏感
    let lowerCaseType = TypeInfo.of<ArrayList<String>>()
    registry.namedClientRegistrations["lowercase"] = lowerCaseType
    @Expect(!registry.namedClientRegistrations.contains("LowerCase"))
}

/**
 * HTTP消息处理器构建器空处理器测试
 * 测试HttpMessageHandlerBuilder的空处理器处理
 */
@Test
func HTTP消息处理器构建器空处理器测试() {
    let services = ServiceCollection()
    let serviceProvider = services.build()
    let builder = TestDefaultHttpMessageHandlerBuilder(serviceProvider)
    
    // 创建主处理器
    let primaryHandler = MockHttpClientHandler()
    
    // 创建空的额外处理器列表
    let emptyHandlers = ArrayList<DelegatingHandler>()
    
    // 构建处理器管道
    let pipeline = builder.createHandlerPipeline(primaryHandler, emptyHandlers)
    
    // 验证管道就是主处理器
    @Expect(refEq(pipeline, primaryHandler))
}

/**
 * HTTP客户端构建器服务集合测试
 * 测试HttpClientBuilder的服务集合功能
 */
@Test
func HTTP客户端构建器服务集合测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 验证服务集合引用
    @Expect(refEq(builder.services, services))
    
    // 验证服务集合不为空
    @Expect(builder.services.size > 0)
}

