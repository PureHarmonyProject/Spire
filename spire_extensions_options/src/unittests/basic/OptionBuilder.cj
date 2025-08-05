package spire_extensions_options.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 基本注册测试
 * 测试选项的基本注册和获取功能
 */
@Test
func 基本注册测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
}

/**
 * 多属性配置测试
 * 测试同时配置多个属性的功能
 */
@Test
func 多属性配置测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions =>
        configureOptions.version = 2
        configureOptions.name = "test"
        configureOptions.enabled = true
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
    @Expect(options.value.name, "test")
    @Expect(options.value.enabled, true)
}

/**
 * 服务提供者集成测试
 * 测试选项与服务提供者的集成
 */
@Test
func 服务提供者集成测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 3
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 3)
}

/**
 * 选项包装器测试
 * 测试OptionsWrapper的功能
 */
@Test
func 选项包装器测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 4
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    let wrapper = OptionsWrapper<TestOptions>(options.value)
    @Expect(wrapper.value.version, 4)
}

/**
 * 选项静态工厂测试
 * 测试Options静态工厂方法
 */
@Test
func 选项静态工厂测试() {
    let testOptions = TestOptions()
    testOptions.version = 5
    let options = Options.create(testOptions)
    @Expect(options.value.version, 5)
} 

/**
 * 选项构建器基础配置测试
 * 测试OptionsBuilder的基本配置功能
 */
@Test
func 选项构建器基础配置测试() {
    let services = ServiceCollection()
    let builder = services.addOptions<TestOptions>()
    builder.configure {
        configureOptions => configureOptions.version = 1
    }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
}

/**
 * 选项构建器链式调用测试
 * 测试OptionsBuilder的链式调用功能
 */
@Test
func 选项构建器链式调用测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .configure {
            configureOptions => configureOptions.name = "test"
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
    @Expect(options.value.name, "test")
}

/**
 * 选项构建器服务提供者配置测试
 * 测试OptionsBuilder与服务提供者的集成
 */
@Test
func 选项构建器服务提供者配置测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
}

/**
 * 后置配置有效性测试
 * 验证后置配置能够正确覆盖前置配置
 */
@Test
func 后置配置有效性测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 2
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
}

/**
 * 后置配置执行顺序测试
 * 验证多个后置配置按正确顺序执行
 */
@Test
func 后置配置执行顺序测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 2
    })
    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 3
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 3)
}

/**
 * 后置配置服务提供者测试
 * 测试后置配置与服务提供者的集成
 */
@Test
func 后置配置服务提供者测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 2
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
}

/**
 * 多个后置配置测试
 * 测试多个后置配置的执行效果
 */
@Test
func 多个后置配置测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 2
    })
    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 3
    })
    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 4
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 4)
}

/**
 * 命名后置配置测试
 * 测试命名选项的后置配置功能
 */
@Test
func 命名后置配置测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 1
    })
    services.configureAfter<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 2
    })
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    @Expect(monitor.get("tenant1").version, 2)
}

/**
 * 后置配置覆盖测试
 * 测试后置配置对前置配置的覆盖效果
 */
@Test
func 后置配置覆盖测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 2
    })
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 3
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
} 

/**
 * 选项构建器验证成功测试
 * 测试OptionsBuilder的验证成功功能
 */
@Test
func 选项构建器验证成功测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>()
        .configure {
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
 * 选项构建器验证失败测试
 * 测试OptionsBuilder的验证失败功能
 */
@Test
func 选项构建器验证失败测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 1
        }
    let provider = services.build()
    try {
        let p = provider.getOrThrow<IOptions<TestOptions>>()
        let _ = p.value
        @Expect(false)
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
}

/**
 * 选项构建器复杂链式调用测试
 * 测试OptionsBuilder的复杂链式调用功能
 */
@Test
func 选项构建器复杂链式调用测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .configure {
            configureOptions => configureOptions.name = "test"
        }
        .configureAfter {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version > 1 && options.name != ""
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
    @Expect(options.value.name, "test")
} 