package spire_extensions_injection.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 异常处理测试 ============

/**
 * 测试根容器解析非单例服务时的异常
 * 验证：当启用作用域验证时，根容器不能解析作用域或瞬时服务
 */
@Test
func 测试根容器解析非单例服务异常() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection>()
    let root = services.build({options => options.validateScopes = true})
    
    try {
        root.getOrThrow<IDbConnection>()
        @Fail("根容器不能解析非单例服务")
    } catch (e: Exception) {
        @Expect(e.message.contains("non-singleton"), true)
    }
} 