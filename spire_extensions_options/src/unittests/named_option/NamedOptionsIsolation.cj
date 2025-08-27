package spire_extensions_options.unittests.named_option

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 命名选项隔离测试
 * 验证不同名称的选项之间相互隔离
 */
@Test
func 命名选项隔离测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configure<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 2
    })
    services.configure<TestOptions>("tenant2", {
        configureOptions => configureOptions.version = 3
    })
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    
    @Expect(monitor.get("").version, 1)
    @Expect(monitor.get("tenant1").version, 2)
    @Expect(monitor.get("tenant2").version, 3)
}

/**
 * 命名选项缓存测试
 * 验证同名选项的缓存机制
 */
@Test
func 命名选项缓存测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 1
    })
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    
    let options1 = monitor.get("tenant1")
    let options2 = monitor.get("tenant1")
    @Expect(refEq(options1, options2), true)
}

/**
 * 命名选项配置覆盖测试
 * 测试默认选项和命名选项的配置覆盖关系
 */
@Test
func 命名选项配置覆盖测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configure<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 2
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    
    @Expect(options.value.version, 1)
    @Expect(monitor.get("tenant1").version, 2)
}

/**
 * 命名选项服务提供者测试
 * 测试命名选项与服务提供者的集成
 */
@Test
func 命名选项服务提供者测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 1
    })
    let provider = services.build()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    
    @Expect(monitor.get("tenant1").version, 1)
}

/**
 * 默认名称选项测试
 * 测试默认名称选项的行为
 */
@Test
func 默认名称选项测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    let monitor = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    
    @Expect(options.value.version, 1)
    @Expect(monitor.get("").version, 1)
} 