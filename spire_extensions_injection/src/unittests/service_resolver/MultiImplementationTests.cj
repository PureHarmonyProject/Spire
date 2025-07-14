package spire_extensions_injection.unittests.service_resolver

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 多实现测试 ============

/**
 * 测试同一接口的多个实现注册
 * 验证：后注册的实现会覆盖先注册的实现，getOrThrow返回最后注册的实现
 */
@Test
func 测试多实现1() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let connection = root.getOrThrow<IDbConnection>()
    @Expect(connection is MySqlConnection, true)
}

/**
 * 测试多实现的getAll功能
 * 验证：getAll可以获取所有注册的实现，且包含getOrThrow返回的实例
 */
@Test
func 测试多实现2() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let connection = root.getOrThrow<IDbConnection>()
    let connections = root.getAll<IDbConnection>()
    let flag = connections |> any {f => refEq((f as Object).getOrThrow(), (connection as Object).getOrThrow())}
    @Expect(flag, true)
} 