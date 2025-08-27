package spire_extensions_options.unittests.extensions

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 添加选项测试
 * 测试addOptions扩展方法的功能
 */
@Test
func 添加选项测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>()
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 0)
}

/**
 * 配置测试
 * 测试configure扩展方法的功能
 */
@Test
func extensions_配置测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
}

/**
 * 后置配置测试
 * 测试configureAfter扩展方法的功能
 */
@Test
func extensions_后置配置测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .configureAfter {
            configureOptions => configureOptions.version = 2
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
}

/**
 * 链式调用测试
 * 测试扩展方法的链式调用功能
 */
@Test
func extensions_链式调用测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .configureAfter {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version > 1
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
}

/**
 * 多个命名选项测试
 * 测试扩展方法处理多个命名选项的功能
 */
@Test
func extensions_多个命名选项测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
    services.configure<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 1
    })
    services.configure<TestOptions>("tenant2", {
        configureOptions => configureOptions.version = 2
    })
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    @Expect(monitor.get("tenant1").version, 1)
    @Expect(monitor.get("tenant2").version, 2)
}

/**
 * 扩展方法异常处理测试
 * 测试扩展方法中的异常处理功能
 */
@Test
func extensions_扩展方法异常处理测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            _ => throw Exception("配置异常")
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
 * ConfigureAll基础测试
 * 测试configureAll扩展方法的基础功能
 */
@Test
func extensions_ConfigureAll基础测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
    services.configureAll<TestOptions>({
        configureOptions => configureOptions.version = 2
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
}

/**
 * ConfigureAll命名选项测试
 * 测试configureAll对命名选项的影响
 */
@Test
func extensions_ConfigureAll命名选项测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
    services.configure<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 10
    })
    services.configure<TestOptions>("tenant2", {
        configureOptions => configureOptions.version = 20
    })
    services.configureAll<TestOptions>({
        configureOptions => configureOptions.version = configureOptions.version + 100
    })
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    @Expect(monitor.get("").version, 101) // 默认选项: 1 + 100
    @Expect(monitor.get("tenant1").version, 110) // tenant1: 10 + 100
    @Expect(monitor.get("tenant2").version, 120) // tenant2: 20 + 100
}

/**
 * ConfigureAll服务提供者测试
 * 测试configureAll与服务提供者的集成
 */
@Test
func extensions_ConfigureAll服务提供者测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
    services.configureAll<TestOptions>({
        configureOptions, _ => 
        configureOptions.version = configureOptions.version + 50
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 51)
}

/**
 * ConfigureAfterAll基础测试
 * 测试configureAfterAll扩展方法的基础功能
 */
@Test
func extensions_ConfigureAfterAll基础测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
    services.configureAfterAll<TestOptions>({
        configureOptions => configureOptions.version = 3
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 3)
}

/**
 * ConfigureAll和ConfigureAfterAll组合测试
 * 测试configureAll和configureAfterAll的组合使用
 */
@Test
func extensions_ConfigureAll和ConfigureAfterAll组合测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
    services.configureAll<TestOptions>({
        configureOptions => configureOptions.version = configureOptions.version + 10
    })
    services.configureAfterAll<TestOptions>({
        configureOptions => configureOptions.version = configureOptions.version + 20
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 31) // 1 + 10 + 20
} 