package spire_extensions_options.unittests.boundary

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 空服务提供者测试
 * 测试空服务提供者的处理
 */
@Test
func 空服务提供者测试() {
    let services = ServiceCollection()
    // 不添加任何配置，测试空服务提供者
    let provider = services.build()
    
    // 测试从空服务提供者获取选项时应该抛出异常
    try {
        let _ = provider.getOrThrow<IOptions<TestOptions>>()
        @Expect(false) // 不应该到达这里
    } catch (ex: Exception) {
        @Expect(true) // 应该抛出异常
    }
}
    
/**
 * 空配置器列表测试
 * 测试空配置器列表的处理
 */
@Test
func 空配置器列表测试() {
    let services = ServiceCollection()
    // 添加配置但不添加验证器
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
}

/**
 * 空验证器列表测试
 * 测试空验证器列表的处理
 */
@Test
func 空验证器列表测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
}

/**
 * 空名称测试
 * 测试空名称选项的处理
 */
@Test
func 空名称测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("")
        .configure {
            configureOptions => configureOptions.version = 1
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    @Expect(monitor.get("").version, 1)
}

/**
 * 特殊字符名称测试
 * 测试包含特殊字符的名称选项
 */
@Test
func 特殊字符名称测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("test@#$%")
        .configure {
            configureOptions => configureOptions.version = 1
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    @Expect(monitor.get("test@#$%").version, 1)
}

/**
 * 配置器异常测试
 * 测试配置器中抛出异常的处理
 */
@Test
func 配置器异常测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        _ => throw Exception("配置器异常")
    })
    let provider = services.build()
    try {
        let p = provider.getOrThrow<IOptions<TestOptions>>()
        let _ = p.value
        @Expect(false)
    } catch (ex: Exception) {
        @Expect(true)
    }
}

/**
 * 验证器异常测试
 * 测试验证器中抛出异常的处理
 */
@Test
func 验证器异常测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            _ => throw Exception("验证器异常")
        }
    let provider = services.build()
    try {
        let p = provider.getOrThrow<IOptions<TestOptions>>()
        let _ = p.value
        @Expect(false)
    } catch (ex: Exception) {
        @Expect(true)
    }
}

/**
 * 后置配置器异常测试
 * 测试后置配置器中抛出异常的处理
 */
@Test
func 后置配置器异常测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configureAfter<TestOptions>({
        _ => throw Exception("后置配置器异常")   
    })
    let provider = services.build()
    try {
        let p = provider.getOrThrow<IOptions<TestOptions>>()
        let _ = p.value
        @Expect(false)
    } catch (ex: Exception) {
        @Expect(true)
    }
} 