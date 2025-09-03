package spire_unnitests.injection.unittests.lifetime

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_injection.*
import spire_unnitests.injection.unittests.*

// ============ 瞬时生命周期测试 ============

/**
 * 测试瞬时服务的生命周期管理
 * 验证：
 * 1. 每次获取都返回新实例
 * 2. 作用域结束时实例被正确释放
 */
@Test
func 测试解析生命周期_瞬时1() {
    let services = ServiceCollection()
    services.addTransient<IDbConnection, MySqlConnection>()
    let root = services.build()

    var connection1: ?IDbConnection = None
    var connection2: ?IDbConnection = None
    var connection3: ?IDbConnection = None

    try (scope1 = root.createScope()) {
        connection1 = scope1.services.getOrThrow<IDbConnection>()
        connection2 = scope1.services.getOrThrow<IDbConnection>()
        @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection2.getOrThrow() as Object).getOrThrow()), false)
    }

    try (scope2 = root.createScope()) {
        connection3 = scope2.services.getOrThrow<IDbConnection>()
    }

    @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection3.getOrThrow() as Object).getOrThrow()), false)
    @Expect(connection1.getOrThrow().isClosed(), true)
    @Expect(connection2.getOrThrow().isClosed(), true)
} 