package spire_net_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import stdx.encoding.url.*
import spire_net_http.*

/**
 * HttpClient默认配置测试（替代原HttpClientOptions）
 */
@Test
func HttpClient默认配置测试() {
    let client = HttpClient()
    @Expect(client.isClosed(), false)
}

/**
 * HttpClient基础地址设置测试
 */
@Test
func HttpClient基础地址设置测试() {
    let client = HttpClient()
    let validUrl = URL.parse("https://api.example.com")
    client.baseAddress = Some(validUrl)
    @Expect(client.baseAddress.isSome(), true)
    @Expect(client.baseAddress.flatMap { u => Some(u.toString()) }, Some("https://api.example.com"))
    client.baseAddress = None
    @Expect(client.baseAddress.isSome(), false)
}

/**
 * HttpClient超时设置测试（通过HttpClientHandler）
 */
@Test
func HttpClient超时设置测试_通过处理器() {
    let handler = HttpClientHandler()
    handler.timeout = Duration.second * 60
    let client = HttpClient(handler)
    @Expect(client.isClosed(), false)
}

/**
 * HttpClient默认头部管理测试（通过defaultRequestHeaders）
 */
@Test
func HttpClient默认头部管理测试() {
    let client = HttpClient()
    client.defaultRequestHeaders.add("User-Agent", "SpireNetHTTP/1.0")
    @Expect(client.defaultRequestHeaders.getFirst("User-Agent"), Some("SpireNetHTTP/1.0"))
    client.defaultRequestHeaders.add("Accept", "application/json")
    @Expect(client.defaultRequestHeaders.getFirst("Accept"), Some("application/json"))
}

/**
 * HttpClient多重配置测试
 */
@Test
func HttpClient多重配置测试() {
    let baseUrl = URL.parse("https://api.example.com")
    let handler = HttpClientHandler()
    handler.timeout = Duration.second * 45
    let client = HttpClient(handler)
    client.baseAddress = Some(baseUrl)
    client.defaultRequestHeaders.add("Content-Type", "application/json")
    client.defaultRequestHeaders.add("Accept", "application/json")
    client.defaultRequestHeaders.add("User-Agent", "MyApp/1.0")
    @Expect(client.baseAddress.isSome(), true)
    @Expect(client.baseAddress.flatMap { u => Some(u.toString()) }, Some(baseUrl.toString()))
}

/**
 * HttpClient头部覆盖测试
 */
@Test
func HttpClient头部覆盖测试() {
    let client = HttpClient()
    client.defaultRequestHeaders.add("Test-Header", "InitialValue")
    @Expect(client.defaultRequestHeaders.getFirst("Test-Header"), Some("InitialValue"))
    client.defaultRequestHeaders.set("Test-Header", "UpdatedValue")
    @Expect(client.defaultRequestHeaders.getFirst("Test-Header"), Some("UpdatedValue"))
    client.defaultRequestHeaders.add("Multi-Header", "Value1")
    client.defaultRequestHeaders.add("Multi-Header", "Value2")
    let multiValues = client.defaultRequestHeaders.get("Multi-Header")
    @Expect(multiValues.size > 0)
}