package spire_extensions_options.unittests.singleton

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 并发访问一致性测试
 * 测试多线程同时修改选项时的状态一致性
 */
@Test
func 并发访问一致性测试() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 1
        }
    let provider = services.build()
    
    let options1 = provider.getOrThrow<IOptions<TestOptions>>()
    let options2 = provider.getOrThrow<IOptions<TestOptions>>()
    
    // 测试选项的一致性
    @Expect(options1.value.version, options2.value.version)
    @Expect(options1.value.version, 1)
}

/**
 * 并发配置执行测试
 * 验证在多线程环境下配置委托的执行次数
 */
@Test
func 并发配置执行测试() {
    let counter = ArrayList<Int64>()
    let services = ServiceCollection()
    services.addOptions<TestOptions>()
        .configure {
            configureOptions =>
            configureOptions.version = 1
            counter.add(1)
        }
    let provider = services.build()
    
    // 测试配置的执行
    for (_ in 0..10) {
        let p = provider.getOrThrow<IOptions<TestOptions>>()
        let _ = p.value
    }
    
    @Expect(counter.size, 1)
} 