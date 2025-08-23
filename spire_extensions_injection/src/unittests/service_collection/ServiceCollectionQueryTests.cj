package spire_extensions_injection.unittests.service_collection

import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ ServiceCollection 查询功能测试 ============

/**
 * 测试查找最后注册的服务描述符
 * 验证：findLast方法返回指定类型的最后注册的服务描述符
 */
@Test
func 测试ServiceCollection_FindLast() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    
    let descriptor = services.findLast(TypeInfo.of<IDbConnection>())
    @Expect(descriptor.isSome(), true)
}

/**
 * 测试查找所有匹配的服务描述符
 * 验证：findAll方法返回指定类型的所有服务描述符
 */
@Test
func 测试ServiceCollection_FindAll() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    
    let descriptors = services.findAll(TypeInfo.of<IDbConnection>())
    @Expect(descriptors.size, 2)
} 