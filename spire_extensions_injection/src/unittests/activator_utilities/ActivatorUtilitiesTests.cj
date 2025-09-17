package spire_extensions_injection.unittests.activator_utilities

import std.unittest.*
import std.unittest.testmacro.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

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
        @Expect(e.message.contains("DbContext"), true)
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
    
    let service = ActivatorUtilities.createInstance<SimpleService>(root, [])
    @Expect(service.id, "simple")
}

/**
 * 测试只有容器服务参数的构造函数
 * 验证：所有参数都从容器解析，无需用户提供额外参数
 */
@Test
func 测试仅容器服务解析() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    // 使用ActivatorUtilities创建DbContext实例，所有参数从容器解析
    let instance = ActivatorUtilities.createInstance<DbContext>(root, [])
    
    @Expect(instance.connection is MySqlConnection, true)
}

/**
 * 测试参数类型正确匹配逻辑
 * 验证：用户提供的参数类型能被正确识别和使用
 */
@Test
func 测试参数类型匹配() {
    let services = ServiceCollection()
    services.addSingleton<DbContext, DbContext>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    // 测试String类型参数的正确匹配
    let instance = ActivatorUtilities.createInstance<DbDataSource>(root, ["matchedParam"])
    
    @Expect(instance.name, "matchedParam")
    @Expect(instance.contex.connection is MySqlConnection, true)
}

/**
 * 测试构造函数参数全覆盖验证
 * 验证：确保所有用户提供的参数都被正确使用
 */
@Test
func 测试参数全覆盖验证() {
    let services = ServiceCollection()
    services.addSingleton<DbContext, DbContext>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    // 提供两个String参数测试参数覆盖逻辑
    try {
        // DbDataSource只需要1个String，但我们提供了2个，应该失败
        ActivatorUtilities.createInstance<DbDataSource>(root, ["param1", "param2"])
        @Fail("应该抛出异常，因为参数数量不匹配")
    } catch (e: Exception) {
        @Expect(e.message.contains("suitable constructor"), true)
    }
} 