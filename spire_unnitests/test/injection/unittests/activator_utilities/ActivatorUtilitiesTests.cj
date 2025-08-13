package spire_unnitests.injection.unittests.activator_utilities

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_unnitests.injection.unittests.*

// ============ ActivatorUtilities 功能测试 ============

/**
 * 测试ActivatorUtilities创建未注册服务但注入已注册依赖
 * 验证：可以创建未在容器中注册的服务，但其依赖项会从容器中解析
 * 同时测试额外参数的传递功能
 */
@Test
func 测试解析容器不存在的服务并注入额外参数() {
    let services = ServiceCollection()
    services.addSingleton<DbContext, DbContext>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let context = ActivatorUtilities.createInstance<DbDataSource>(root, "zs")
    @Expect(context.name, "zs")
}

/**
 * 测试创建实例时服务不存在的异常处理
 * 验证：当依赖的服务未注册时，应抛出明确的异常
 */
@Test
func 测试服务不存在时的异常() {
    let services = ServiceCollection()
    let root = services.build()
    
    try {
        ActivatorUtilities.createInstance<DbContext>(root)
        @Fail("应该抛出服务不存在异常")
    } catch (e: Exception) {
        @Expect(e.message.contains("No service"), true)
    }
}

/**
 * 测试无参构造函数的调用
 * 验证：当没有依赖需要注入时，能正确调用无参构造函数
 */
@Test
func 测试无参构造函数() {
    let services = ServiceCollection()
    let root = services.build()
    
    let service = ActivatorUtilities.createInstance<SimpleService>(root)
    @Expect(service.id, "simple")
} 