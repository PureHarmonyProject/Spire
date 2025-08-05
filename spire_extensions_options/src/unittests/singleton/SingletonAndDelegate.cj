package spire_extensions_options.unittests.singleton

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 单例引用相等性测试
 * 验证多次获取选项返回相同的实例引用
 */
@Test
func 单例引用相等性测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    let provider = services.build()
    let options1 = provider.getOrThrow<IOptions<TestOptions>>()
    let options2 = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(refEq(options1.value, options2.value), true)
}

/**
 * 委托执行次数测试
 * 验证配置委托只执行一次
 */
@Test
func 委托执行次数测试() {
    let counter = ArrayList<Int64>()
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions =>
        configureOptions.version = 1
        counter.add(1)
    })
    let provider = services.build()
    let p = provider.getOrThrow<IOptions<TestOptions>>()
    let _ = p.value
    let p2 = provider.getOrThrow<IOptions<TestOptions>>()
    let _ = p2.value
    @Expect(counter.size, 1)
}

/**
 * 单例状态一致性测试
 * 验证单例选项的状态在多个引用间保持一致
 */
@Test
func 单例状态一致性测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 2
    })
    let provider = services.build()
    let options1 = provider.getOrThrow<IOptions<TestOptions>>()
    let options2 = provider.getOrThrow<IOptions<TestOptions>>()
    options1.value.version = 3
    @Expect(options2.value.version, 3)
} 