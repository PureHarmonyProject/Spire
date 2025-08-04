package spire_extensions_options.unittests.validation

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 单个验证器失败测试
 * 测试单个验证器验证失败的情况
 */
@Test
func 单个验证器失败测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
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
 * 多个验证器失败测试
 * 测试多个验证器同时验证失败的情况
 */
@Test
func 多个验证器失败测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 0
        }
        .validate {
            options => return options.version < 1
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
 * 服务提供者验证失败测试
 * 测试在服务提供者环境下验证失败的情况
 */
@Test
func 服务提供者验证失败测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 1
        }
    let provider = services.build()
    try {
        let p = provider.getOrThrow<IOptions<TestOptions>>()
        let _ = p.value // 这里会触发验证
        @Expect(false) // 如果验证失败，这里不会执行
    } catch (ex: OptionsValidationException) {
        @Expect(true) // 验证失败时应该抛出OptionsValidationException
    } catch (ex: Exception) {
        @Expect(false) // 其他异常不应该发生
    }
}

/**
 * 复杂验证失败测试
 * 测试复杂条件验证失败的情况
 */
@Test
func 复杂验证失败测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions =>
            configureOptions.version = 1
            configureOptions.name = "test"
            configureOptions.enabled = false
        }
        .validate {
            options => return options.version > 0 && options.name != "" && options.enabled
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
 * 边界验证失败测试
 * 测试边界条件验证失败的情况
 */
@Test
func 边界验证失败测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 0
        }
        .validate {
            options => return options.version > 0
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