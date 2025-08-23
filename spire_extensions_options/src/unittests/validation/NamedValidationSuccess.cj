package spire_extensions_options.unittests.validation

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 单个命名验证器成功测试
 * 测试单个命名验证器验证成功的情况
 */
@Test
func 单个命名验证器成功测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version > 1
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    let options = monitor.get("tenant1")
    @Expect(options.version, 2)
}

/**
 * 多个命名验证器成功测试
 * 测试多个命名验证器同时验证成功的情况
 */
@Test
func 多个命名验证器成功测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
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
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    let options = monitor.get("tenant1")
    @Expect(options.version, 2)
}

/**
 * 服务提供者命名验证成功测试
 * 测试在服务提供者环境下命名验证成功的情况
 */
@Test
func 服务提供者命名验证成功测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version > 1
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    let options = monitor.get("tenant1")
    @Expect(options.version, 2)
}

/**
 * 复杂命名验证成功测试
 * 测试复杂条件命名验证成功的情况
 */
@Test
func 复杂命名验证成功测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("tenant1")
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
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    let options = monitor.get("tenant1")
    @Expect(options.version, 2)
    @Expect(options.name, "test")
    @Expect(options.enabled, true)
}

/**
 * 边界命名验证成功测试
 * 测试边界条件命名验证成功的情况
 */
@Test
func 边界命名验证成功测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>("tenant1")
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 0
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    let options = monitor.get("tenant1")
    @Expect(options.version, 1)
}

/**
 * 命名验证隔离测试
 * 测试不同命名选项的验证相互隔离
 */
@Test
func 命名验证隔离测试() {
    let services = ServiceCollection()
    services
        .addOptions<TestOptions>("tenant1")
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version > 1
        }
    services
        .addOptions<TestOptions>("tenant2")
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version > 0
        }
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    let options1 = monitor.get("tenant1")
    let options2 = monitor.get("tenant2")
    @Expect(options1.version, 2)
    @Expect(options2.version, 1)
} 