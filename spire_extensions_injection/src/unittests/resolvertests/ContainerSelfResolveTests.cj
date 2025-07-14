package spire_extensions_injection.unittests.resolvertests

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 容器自身解析测试 ============

/**
 * 测试根容器能否解析自己
 * 验证IServiceProvider服务是否正确注册为容器自身
 */
@Test
func 测试解析容器自己_根容器() {
    let services = ServiceCollection()
    let root = services.build()
    let providerSelf = root.getOrThrow<IServiceProvider>()
    @Expect(refEq((root as Object).getOrThrow(), (providerSelf as Object).getOrThrow()), true)
}

/**
 * 测试子容器能否解析自己，并验证子容器与根容器的区别
 * 验证作用域创建后，子容器的IServiceProvider指向子容器本身而不是根容器
 */
@Test
func 测试解析容器自己_子容器() {
    let services = ServiceCollection()
    let root = services.build()

    //测试子容器
    try (scope = root.createScope()) {
        let providerSelf = scope.services.getOrThrow<IServiceProvider>()
        @Expect(refEq((root as Object).getOrThrow(), (scope.services as Object).getOrThrow()), false)
        @Expect(refEq((providerSelf as Object).getOrThrow(), (scope.services as Object).getOrThrow()), true)
    }
} 