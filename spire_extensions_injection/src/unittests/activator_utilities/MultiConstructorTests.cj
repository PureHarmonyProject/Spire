package spire_extensions_injection.unittests.activator_utilities

import std.unittest.*
import std.unittest.testmacro.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 多构造函数选择测试 ============

/**
 * 测试多构造函数选择：最多参数优先策略
 * 验证：ActivatorUtilities会选择参数最多且能满足的构造函数
 */
@Test
func 测试多构造函数选择_最多参数优先() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    let service = ActivatorUtilities.createInstance<MultiConstructorService>(root, "test")
    @Expect(service.value, "with_connection_and_name")
}

/**
 * 测试多构造函数选择：部分参数匹配
 * 验证：出现歧义时抛出异常
 */
@Test
func 测试多构造函数选择_部分匹配() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    try {
        let _ = ActivatorUtilities.createInstance<MultiConstructorService>(root)
        @Expect(false)
    } catch (e: Exception) {
        @Expect(true)
    }
}
