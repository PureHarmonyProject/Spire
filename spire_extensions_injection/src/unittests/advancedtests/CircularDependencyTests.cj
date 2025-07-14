package spire_extensions_injection.unittests.advancedtests

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 循环依赖测试 ============

/**
 * 测试循环依赖检测功能
 * 验证：当启用循环依赖验证时，应该检测到并抛出异常
 */
@Test
func 测试循环依赖检测() {
    let services = ServiceCollection()
    services.addSingleton<ServiceA, ServiceA>()
    services.addSingleton<ServiceB, ServiceB>()
    let root = services.build({options => options.validateLoopDependency = true})
    
    try {
        root.getOrThrow<ServiceA>()
        @Fail("应该检测到循环依赖并抛出异常")
    } catch (e: Exception) {
        @Expect(e.message.contains("circular dependency"), true)
    }
} 