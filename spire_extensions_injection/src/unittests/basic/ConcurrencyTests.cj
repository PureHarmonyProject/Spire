package spire_extensions_injection.unittests.basic

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*
import spire_extensions_injection.unittests.*

// ============ 并发测试 ============

/**
 * 测试1000个并发线程同时解析单例服务
 * 验证：
 * 1. 线程安全性：所有线程获取到的是同一个实例
 * 2. 性能：大量并发请求不会导致问题
 */
@Test
func 测试并发解析1000线程次() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    let root = services.build()
    let default :IDbConnection = MySqlConnection()
    let tasks = ArrayList<Future<IDbConnection>>()
    for (_ in 1..1001) {
        let task = spawn {
            return root.getOrThrow<IDbConnection>()
            //default
        }
        tasks.add(task)
    }
    let instances = ArrayList<IDbConnection>()
    for (pattern in tasks) {
        instances.add(pattern.get())
    }
    let set = instances |> map {f => f.id} |> collectHashSet
    @Expect(set.size == 1, true)
    @Expect(instances.size == 1000, true)
} 