package spire_extensions_injection.unittests.service_collection_operate

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ========== ServiceCollection 操作测试 ==========

/**
 * 测试TryAdd功能：如果服务已存在则不添加
 * 验证：tryAddSingleton不会覆盖已存在的服务注册
 */
@Test
func 测试ServiceCollection_TryAdd功能() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.tryAddSingleton<IDbConnection, MsSqlConnection>() // 不应该添加
    let root = services.build()
    let connection = root.getOrThrow<IDbConnection>()
    @Expect(connection is MySqlConnection, true)
}

/**
 * 测试从ServiceCollection中移除指定位置的服务
 * 验证：remove(at:)方法的正确性
 */
@Test
func 测试ServiceCollection_移除服务() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    @Expect(services.size, 1)
    services.remove(at: 0)
    @Expect(services.size, 0)
}

/**
 * 测试清空ServiceCollection中的所有服务
 * 验证：clear()方法和isEmpty()属性的正确性
 */
@Test
func 测试ServiceCollection_清空服务() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addScoped<SimpleService, SimpleService>()
    @Expect(services.size, 2)
    services.clear()
    @Expect(services.size, 0)
    @Expect(services.isEmpty(), true)
}

/**
 * 测试ServiceCollection在构建后变为只读状态
 * 验证：构建容器后不能再添加服务，应抛出异常
 */
@Test
func 测试ServiceCollection_只读状态异常() {
    let services = ServiceCollection()
    services.addSingleton<SimpleService, SimpleService>()
    services.build() // 构建后变为只读
    try {
        services.addSingleton<IDbConnection, MySqlConnection>()
        @Fail("应该抛出异常")
    } catch (e: Exception) {
        @Expect(e.message.contains("read-only"), true)
    }
}

/**
 * 测试TryAddEnumerable功能：避免重复添加相同的服务描述符
 * 验证：相同类型和实现的服务描述符不会重复添加
 */
@Test
func 测试TryAddEnumerable功能() {
    let services = ServiceCollection()
    let descriptor1 = ServiceDescriptor.singleton<IDbConnection, MySqlConnection>()
    let descriptor2 = ServiceDescriptor.singleton<IDbConnection, MySqlConnection>()
    services.tryAddEnumerable(descriptor1)
    services.tryAddEnumerable(descriptor2) // 相同类型和实现，不应该重复添加
    @Expect(services.size, 1)
}

/**
 * 测试空ServiceCollection的属性
 * 验证：新创建的ServiceCollection的各种属性初始状态
 */
@Test
func 测试ServiceCollection_空集合属性() {
    let services = ServiceCollection()
    @Expect(services.isEmpty(), true)
    @Expect(services.size, 0)
    @Expect(services.first.isNone(), true)
    @Expect(services.last.isNone(), true)
}

/**
 * 测试批量添加服务描述符
 * 验证：add(all:)方法能正确添加多个服务描述符
 */
@Test
func 测试ServiceCollection_添加集合() {
    let services = ServiceCollection()
    let descriptors = ArrayList<ServiceDescriptor>()
    descriptors.add(ServiceDescriptor.singleton<IDbConnection, MySqlConnection>())
    descriptors.add(ServiceDescriptor.singleton<SimpleService, SimpleService>())
    
    services.add(all: descriptors)
    @Expect(services.size, 2)
}

/**
 * 测试在指定位置插入服务描述符
 * 验证：add(at:)方法能在指定位置正确插入服务描述符
 */
@Test
func 测试ServiceCollection_指定位置操作() {
    let services = ServiceCollection()
    let descriptor1 = ServiceDescriptor.singleton<IDbConnection, MySqlConnection>()
    let descriptor2 = ServiceDescriptor.singleton<SimpleService, SimpleService>()
    
    services.add(descriptor1)
    services.add(descriptor2, at: 0) // 在开头插入
    
    @Expect(services.size, 2)
    @Expect(services[0].serviceType, TypeInfo.of<SimpleService>())
    @Expect(services[1].serviceType, TypeInfo.of<IDbConnection>())
}

/**
 * 测试条件删除服务描述符
 * 验证：removeIf方法能根据条件删除匹配的服务描述符
 */
@Test
func 测试ServiceCollection_移除条件() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<SimpleService, SimpleService>()
    
    services.removeIf {descriptor => descriptor.serviceType == TypeInfo.of<SimpleService>()}
    @Expect(services.size, 1)
    @Expect(services[0].serviceType, TypeInfo.of<IDbConnection>())
} 