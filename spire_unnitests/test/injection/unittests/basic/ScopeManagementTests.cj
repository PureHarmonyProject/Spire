package spire_unnitests.injection.unittests.basic

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_unnitests.injection.unittests.*

// ============ 作用域管理测试 ============

/** 
 * 测试作用域资源的自动释放
 * 验证：作用域结束时，其中的Resource类型服务会被自动释放
 */
@Test
func 测试作用域资源自动释放() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    var connection: ?IDbConnection = None
    try (scope = root.createScope()) {
        connection = scope.services.getOrThrow<IDbConnection>()
        @Expect(connection.getOrThrow().isClosed(), false)
    }
    
    @Expect(connection.getOrThrow().isClosed(), true)
}

/**
 * 测试嵌套作用域的管理
 * 验证：
 * 1. 内外作用域的服务实例是独立的
 * 2. 内部作用域结束时不影响外部作用域
 * 3. 外部作用域结束时内部资源已被释放
 */
@Test
func 测试嵌套作用域() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    var outerConnection: ?IDbConnection = None
    var innerConnection: ?IDbConnection = None
    
    try (outerScope = root.createScope()) {
        outerConnection = outerScope.services.getOrThrow<IDbConnection>()
        
        try (innerScope = root.createScope()) {
            innerConnection = innerScope.services.getOrThrow<IDbConnection>()
            @Expect(refEq((outerConnection.getOrThrow() as Object).getOrThrow(), 
                          (innerConnection.getOrThrow() as Object).getOrThrow()), false)
        }
        
        @Expect(innerConnection.getOrThrow().isClosed(), true)
        @Expect(outerConnection.getOrThrow().isClosed(), false)
    }
    
    @Expect(outerConnection.getOrThrow().isClosed(), true)
} 