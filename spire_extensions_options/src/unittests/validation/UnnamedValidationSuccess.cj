package spire_extensions_options.unittests.validation

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 单个验证器成功测试
 * 测试单个验证器验证成功的情况
 */
@Test
func 单个验证器成功测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
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
 * 多个验证器成功测试
 * 测试多个验证器同时验证成功的情况
 */
@Test
func 多个验证器成功测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version > 0
        }
        .validate {
            options => return options.version < 10
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
}

/**
 * 服务提供者验证成功测试
 * 测试在服务提供者环境下验证成功的情况
 */
@Test
func 服务提供者验证成功测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
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
 * 复杂验证成功测试
 * 测试复杂条件验证成功的情况
 */
@Test
func 复杂验证成功测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions =>
            configureOptions.version = 2
            configureOptions.name = "test"
            configureOptions.enabled = true
        }
        .validate {
            options => return options.version > 0 && options.name != "" && options.enabled
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
    @Expect(options.value.name, "test")
    @Expect(options.value.enabled, true)
}

/**
 * 边界验证成功测试
 * 测试边界条件验证成功的情况
 */
@Test
func 边界验证成功测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 0
        }
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
} 