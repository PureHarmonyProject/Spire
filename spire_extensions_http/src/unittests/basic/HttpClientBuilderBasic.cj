package spire_extensions_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_http.*
import spire_extensions_http.unittests.*
import spire_extensions_injection.*
import std.reflect.*

/**
 * HTTP客户端构建器配置客户端测试
 * 测试HttpClientBuilder的configureHttpClient方法
 */
@Test
func HTTP客户端构建器配置客户端测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试配置HTTP客户端
    let result = builder.configureHttpClient({ _ => 
        // 配置成功
    })
    
    // 验证返回的是同一个构建器实例
    // result 和 builder 应该是同一个对象引用
    @Expect(refEq(builder, result), true)
    
    // 验证构建器名称保持不变
    @Expect(result.name, "TestClient")
    
    // 验证服务集合不为空
    @Expect(result.services.size != 0)
}

/**
 * HTTP客户端构建器配置客户端带服务测试
 * 测试HttpClientBuilder的configureHttpClient方法（带服务提供者）
 */
@Test
func HTTP客户端构建器配置客户端带服务测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试配置HTTP客户端（带服务提供者）
    let result = builder.configureHttpClient({ _, _ => 
        // 配置成功
    })
    
    // 验证返回的是同一个构建器实例
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器添加消息处理器测试
 * 测试HttpClientBuilder的addHttpMessageHandler方法
 */
@Test
func HTTP客户端构建器添加消息处理器测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试添加HTTP消息处理器
    let result = builder.addHttpMessageHandler({ => 
        LoggingDelegatingHandler()  // 使用真实的委托处理器
    })
    
    // 验证返回的是同一个构建器实例
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器添加消息处理器带服务测试
 * 测试HttpClientBuilder的addHttpMessageHandler方法（带服务提供者）
 */
@Test
func HTTP客户端构建器添加消息处理器带服务测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试添加HTTP消息处理器（带服务提供者）
    let result = builder.addHttpMessageHandler({ _ => 
        LoggingDelegatingHandler()
    })
    
    // 验证返回的是同一个构建器实例
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器添加类型化消息处理器测试
 * 测试HttpClientBuilder的addHttpMessageHandler<THandler>方法
 */
@Test
func HTTP客户端构建器添加类型化消息处理器测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试添加类型化HTTP消息处理器
    let result = builder.addHttpMessageHandler<LoggingDelegatingHandler>()
    
    // 验证返回的是同一个构建器实例
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器配置消息处理器构建器测试
 * 测试HttpClientBuilder的configureHttpMessageHandlerBuilder方法
 */
@Test
func HTTP客户端构建器配置消息处理器构建器测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试配置HTTP消息处理器构建器
    builder.configureHttpMessageHandlerBuilder({ _ => 
        // 配置成功
    })
    
    // 验证方法调用成功（这个方法不返回构建器实例）
    @Expect(builder.name, "TestClient")
}

/**
 * HTTP客户端构建器配置主处理器测试
 * 测试HttpClientBuilder的configurePrimaryHttpMessageHandler方法
 */
@Test
func HTTP客户端构建器配置主处理器测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试配置主HTTP消息处理器
    let result = builder.configurePrimaryHttpMessageHandler({ => 
        LoggingHttpMessageHandler()
    })
    
    // 验证返回的是同一个构建器实例
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器配置主处理器带服务测试
 * 测试HttpClientBuilder的configurePrimaryHttpMessageHandler方法（带服务提供者）
 */
@Test
func HTTP客户端构建器配置主处理器带服务测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试配置主HTTP消息处理器（带服务提供者）
    let result = builder.configurePrimaryHttpMessageHandler({ _ => 
        LoggingHttpMessageHandler()
    })
    
    // 验证返回的是同一个构建器实例
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器配置类型化主处理器测试
 * 测试HttpClientBuilder的configurePrimaryHttpMessageHandler<THandler>方法
 */
@Test
func HTTP客户端构建器配置类型化主处理器测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试配置类型化主HTTP消息处理器
    let result = builder.configurePrimaryHttpMessageHandler<LoggingHttpMessageHandler>()
    
    // 验证返回的是同一个构建器实例
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器添加类型化客户端测试
 * 测试HttpClientBuilder的addTypedClient<TClient>方法
 */
@Test
func HTTP客户端构建器添加类型化客户端测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("TestClient", services)
    
    // 测试添加类型化客户端
    let result = builder.addTypedClient<LoggingTypedClient>({ _, _ => 
        LoggingTypedClient()
    })
    
    // 验证返回的是同一个构建器实例
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器多重配置测试
 * 测试HttpClientBuilder的多重配置功能
 */
@Test
func HTTP客户端构建器多重配置测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("MultiConfigClient", services)
    
    // 测试多重配置
    let counter = ConfigCounter()
    
    // 使用ConfigCounter来避免lambda捕获可变变量的问题
    builder.configureHttpClient({ _ => counter.increment() })
    builder.addHttpMessageHandler({ => LoggingDelegatingHandler() })
    builder.configureHttpMessageHandlerBuilder({ _ => counter.increment() })
    builder.configurePrimaryHttpMessageHandler({ => LoggingHttpMessageHandler() })
    
    // 验证配置方法调用成功
    @Expect(builder.name, "MultiConfigClient")
    // 注意：配置动作只是注册，不会立即执行，所以counter.count仍然是0
    @Expect(counter.count, 0)
}

/**
 * HTTP客户端构建器链式调用测试
 * 测试HttpClientBuilder的链式调用功能
 */
@Test
func HTTP客户端构建器链式调用测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("ChainClient", services)
    
    // 测试链式调用
    let result = builder
        .configureHttpClient({ _ => })
        .addHttpMessageHandler({ => LoggingDelegatingHandler() })
        .configureHttpMessageHandlerBuilder({ _ => })
        .configurePrimaryHttpMessageHandler({ => LoggingHttpMessageHandler() })
    
    // 验证链式调用返回同一个构建器
    @Expect(refEq(builder, result), true)
}

/**
 * HTTP客户端构建器不同名称测试
 * 测试HttpClientBuilder的不同名称配置
 */
@Test
func HTTP客户端构建器不同名称测试() {
    let services = ServiceCollection()
    
    // 创建不同名称的构建器
    let builder1 = HttpClientBuilder("Name1", services)
    let builder2 = HttpClientBuilder("Name2", services)
    let builder3 = HttpClientBuilder("Name3", services)
    
    // 验证名称不同
    @Expect(builder1.name != builder2.name)
    @Expect(builder2.name != builder3.name)
    @Expect(builder1.name != builder3.name)
    
    // 验证服务集合相同
    @Expect(refEq(builder1.services, builder2.services), true)
    @Expect(refEq(builder2.services, builder3.services), true)
}

/**
 * HTTP客户端构建器服务集合操作测试
 * 测试HttpClientBuilder对服务集合的操作
 */
@Test
func HTTP客户端构建器服务集合操作测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("ServiceTest", services)
    
    // 验证服务集合引用
    @Expect(refEq(builder.services, services), true)
    
    // 验证服务集合可操作
    builder.services.addSingleton<LoggingService>(LoggingService())
    
    let service = services |> filter { d: ServiceDescriptor => d.serviceType == TypeInfo.of<LoggingService>()} |> first
    @Expect(service.isSome(), true)
}

/**
 * HTTP客户端构建器配置验证测试
 * 测试HttpClientBuilder的配置验证
 */
@Test
func HTTP客户端构建器配置验证测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("ValidationTest", services)

    let counter = ConfigCounter()
    
    // 测试各种配置方法
    builder.configureHttpClient({ _ => counter.increment() })
    builder.addHttpMessageHandler({ => 
        counter.increment()
        LoggingDelegatingHandler()
    })
    builder.configureHttpMessageHandlerBuilder({ _ => counter.increment() })
    builder.configurePrimaryHttpMessageHandler({ => 
        counter.increment()
        LoggingHttpMessageHandler()
    })
    builder.addTypedClient<LoggingTypedClient>({ _, _ => LoggingTypedClient() })
    
    // 验证所有配置方法均执行
    @Expect(counter.count, 4)
    
    // 验证配置方法调用成功
    @Expect(builder.name, "ValidationTest")
}

/**
 * HTTP客户端构建器错误处理测试
 * 测试HttpClientBuilder的错误处理
 */
@Test
func HTTP客户端构建器错误处理测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("ErrorTest", services)
    
    // 测试错误处理配置
    builder.configureHttpClient({ _ => 
        // 配置成功
    })
    
    // 验证没有异常抛出
    @Expect(builder.name, "ErrorTest")
}

/**
 * HTTP客户端构建器空配置测试
 * 测试HttpClientBuilder的空配置处理
 */
@Test
func HTTP客户端构建器空配置测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("EmptyConfigTest", services)
    
    // 测试空配置
    let emptyResult = builder.configureHttpClient({ _ => })
    
    // 验证空配置处理
    @Expect(emptyResult is HttpClientBuilder, true)
}

/**
 * HTTP客户端构建器重复配置测试
 * 测试HttpClientBuilder的重复配置
 */
@Test
func HTTP客户端构建器重复配置测试() {
    let services = ServiceCollection()
    let builder = HttpClientBuilder("DuplicateConfigTest", services)
    
    let configCount = ConfigCounter()
    // 测试重复配置
    builder.configureHttpClient({ _ => configCount.setCount(1) })
    builder.configureHttpClient({ _ => configCount.setCount(2) })
    builder.configureHttpClient({ _ => configCount.setCount(3) })
    
    // 验证重复配置覆盖
    @Expect(configCount.count, 3)
}

