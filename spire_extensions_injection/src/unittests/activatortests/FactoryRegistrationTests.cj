package spire_extensions_injection.unittests.activatortests

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 工厂注册测试 ============

/**
 * 测试单例工厂注册功能
 * 验证：工厂函数在单例模式下只被调用一次
 */
@Test  
func 测试工厂注册功能() {
    let services = ServiceCollection()
    // 使用特殊的连接ID来验证工厂是否被调用
    services.addSingleton<IDbConnection, MySqlConnection> { _ =>
        let connection = MySqlConnection()
        return connection
    }
    let root = services.build()
    let connection1 = root.getOrThrow<IDbConnection>()
    let connection2 = root.getOrThrow<IDbConnection>()
    // 单例模式下应该返回相同的实例
    @Expect(refEq((connection1 as Object).getOrThrow(), (connection2 as Object).getOrThrow()), true)
}

/**
 * 测试作用域工厂注册功能
 * 验证：
 * 1. 同一作用域内工厂只调用一次
 * 2. 不同作用域各自调用工厂
 */
@Test
func 测试作用域工厂注册() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection> { _ =>
        return MySqlConnection()
    }
    let root = services.build()
    
    var scope1Connection1: ?IDbConnection = None
    var scope1Connection2: ?IDbConnection = None
    var scope2Connection: ?IDbConnection = None
    
    try (scope1 = root.createScope()) {
        scope1Connection1 = scope1.services.getOrThrow<IDbConnection>()
        scope1Connection2 = scope1.services.getOrThrow<IDbConnection>()
        // 同一作用域内应该返回相同实例
        @Expect(refEq((scope1Connection1.getOrThrow() as Object).getOrThrow(), (scope1Connection2.getOrThrow() as Object).getOrThrow()), true)
    }
    
    try (scope2 = root.createScope()) {
        scope2Connection = scope2.services.getOrThrow<IDbConnection>()
    }
    
    // 不同作用域应该返回不同实例
    @Expect(refEq((scope1Connection1.getOrThrow() as Object).getOrThrow(), (scope2Connection.getOrThrow() as Object).getOrThrow()), false)
}

/**
 * 测试瞬时工厂注册功能
 * 验证：每次获取都会调用工厂函数创建新实例
 */
@Test
func 测试瞬时工厂注册() {
    let services = ServiceCollection()
    services.addTransient<IDbConnection, MySqlConnection> { _ =>
        return MySqlConnection()
    }
    let root = services.build()
    
    var connection1: ?IDbConnection = None
    var connection2: ?IDbConnection = None
    
    try (scope = root.createScope()) {
        connection1 = scope.services.getOrThrow<IDbConnection>()
        connection2 = scope.services.getOrThrow<IDbConnection>()
    }
    
    // 瞬时模式每次应该返回不同实例
    @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection2.getOrThrow() as Object).getOrThrow()), false)
} 