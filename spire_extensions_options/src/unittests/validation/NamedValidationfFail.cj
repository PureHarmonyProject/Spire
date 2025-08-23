package spire_extensions_options.unittests.validation

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 单个命名验证器失败测试
 * 测试单个命名验证器验证失败的情况
 */
@Test
func 单个命名验证器失败测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 1
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    try {
        let _ = monitor.get("tenant1")
        @Expect(false)
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
}

/**
 * 多个命名选项失败测试
 * 测试多个命名选项验证失败的情况
 */
@Test
func 多个命名选项失败测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 1
        }
    services.addOptions<TestOptions>("tenant2")
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version < 2
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    try {
        let _ = monitor.get("tenant1")
        @Expect(false)
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
}

/**
 * 服务提供者命名验证失败测试
 * 测试在服务提供者环境下命名验证失败的情况
 */
@Test
func 服务提供者命名验证失败测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 1
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    try {
        let _ = monitor.get("tenant1")
        @Expect(false)
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
}

/**
 * 复杂命名验证失败测试
 * 测试复杂条件命名验证失败的情况
 */
@Test
func 复杂命名验证失败测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
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
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    try {
        let _ = monitor.get("tenant1")
        @Expect(false)
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
}

/**
 * 边界命名验证失败测试
 * 测试边界条件命名验证失败的情况
 */
@Test
func 边界命名验证失败测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
        .configure {
            configureOptions => configureOptions.version = 0
        }
        .validate {
            options => return options.version > 0
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    try {
        let _ = monitor.get("tenant1")
        @Expect(false)
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
} 