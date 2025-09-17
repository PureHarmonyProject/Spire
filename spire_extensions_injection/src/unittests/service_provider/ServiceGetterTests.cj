package spire_extensions_injection.unittests.service_provider

import std.unittest.*
import std.unittest.testmacro.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 服务获取功能测试 ============

/**
 * 测试获取所有服务实现
 * 验证：getAll方法返回指定接口的所有注册实现
 */
@Test
func 测试获取所有服务_多实现() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()   // 第一个注册
    services.addSingleton<IDbConnection, MsSqlConnection>()   // 第二个注册
    let root = services.build()
    
    let connections = root.getAll<IDbConnection>().toArray()
    @Expect(connections.size, 2)
    // 尝试相反的顺序：第一个注册的在前，第二个注册的在后
    @Expect(connections[0] is MySqlConnection, true)  // 第一个注册的
    @Expect(connections[1] is MsSqlConnection, true)  // 第二个注册的
}

/**
 * 测试获取所有服务时无注册实现的情况
 * 验证：getAll在没有注册实现时返回空集合
 */
@Test
func 测试获取所有服务_空集合() {
    let services = ServiceCollection()
    let root = services.build()
    
    let connections = root.getAll<IDbConnection>()
    @Expect(connections.size, 0)
}

/**
 * 测试获取不存在服务时返回None
 * 验证：getOrDefault方法在服务不存在时返回None而不抛出异常
 */
@Test
func 测试获取不存在的服务返回None() {
    let services = ServiceCollection()
    let root = services.build()
    
    let connection = root.getOrDefault<IDbConnection>()
    @Expect(connection.isNone(), true)
} 