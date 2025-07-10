package spire_extensions_injection.unittests.LifecycleTests

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 单例生命周期测试 ============

/**
 * 测试基本的单例类型注册
 * 注册方式：直接类型到类型的映射 addSingleton<MySqlConnection, MySqlConnection>()
 * 验证：多次获取应返回同一实例
 */
@Test
func 测试解析生命周期_单例1() {
    let services = ServiceCollection()
    services.addSingleton<MySqlConnection, MySqlConnection>()
    let root = services.build()
    let instance1 = root.getOrThrow<MySqlConnection>()
    let instance2 = root.getOrThrow<MySqlConnection>()
    @Expect(refEq(instance1, instance2), true)
}

/**
 * 测试实例注册的单例模式
 * 注册方式：直接注册预创建的实例 addSingleton(MySqlConnection())
 * 验证：多次获取应返回同一个预创建实例
 */
@Test
func 测试解析生命周期_单例2() {
    let services = ServiceCollection()
    services.addSingleton(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<MySqlConnection>()
    let instance2 = root.getOrThrow<MySqlConnection>()
    @Expect(refEq(instance1, instance2), true)
}

/**
 * 测试接口到实例的单例注册
 * 注册方式：将具体实例注册为接口类型 addSingleton<IDbConnection>(MySqlConnection())
 * 验证：通过接口获取的实例应为同一个
 */
@Test
func 测试解析生命周期_单例3() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection>(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

/**
 * 测试完整的单例注册（接口+实现+实例）
 * 注册方式：明确指定接口、实现类型和具体实例 addSingleton<IDbConnection, MySqlConnection>(MySqlConnection())
 * 验证：通过接口获取应返回指定的实例
 */
@Test
func 测试解析生命周期_单例4() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

/**
 * 测试工厂方法的单例注册
 * 注册方式：使用Lambda表达式作为工厂函数 addSingleton<IDbConnection, MySqlConnection> {_ => MySqlConnection()}
 * 验证：工厂函数只应被调用一次，多次获取返回同一实例
 */
@Test
func 测试解析生命周期_单例5() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection> {_ => MySqlConnection()}
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

/**
 * 测试有依赖关系的单例服务
 * 注册方式：注册有依赖关系的多个单例服务
 * 验证：依赖的服务也应为单例，整个依赖链保持单例语义
 */
@Test
func 测试解析生命周期_单例6() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<DbContext, DbContext>()
    let root = services.build()
    let context1 = root.getOrThrow<DbContext>()
    let context2 = root.getOrThrow<DbContext>()
    @Expect(refEq(context1, context2), true)
    @Expect(refEq((context1.connection as Object).getOrThrow(), (context2.connection as Object).getOrThrow()), true)
} 