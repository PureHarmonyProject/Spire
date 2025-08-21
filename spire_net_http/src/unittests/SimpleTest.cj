package spire_net_http.unittests

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.io.*
import std.time.*
import stdx.encoding.url.*
import spire_net_http.*

/**
 * 简单的HTTP客户端测试
 * 验证基本功能是否正常工作
 */
@Test
func 简单HTTP客户端测试() {
    let client = HttpClient()
    @Expect(client.isClosed() == false, true)
    
    client.close()
    @Expect(client.isClosed() == true, true)
}

/**
 * 简单的HTTP消息测试
 * 验证HTTP消息的基本功能
 */
@Test
func 简单HTTP消息测试() {
    let request = HttpRequestMessage(HttpMethod.get, "https://api.example.com/users")
    @Expect(request.method.toString() == "GET", true)
    @Expect(request.requestUri.toString() == "https://api.example.com/users", true)
}

/**
 * 简单的HTTP异常测试
 * 验证HTTP异常的基本功能
 */
@Test
func 简单HTTP异常测试() {
    let exception = HttpRequestException("测试异常", None)
    @Expect(exception.message == "测试异常", true)
    @Expect(exception.status.isSome() == false, true)
}

/**
 * 简单的HTTP头部测试
 * 验证HTTP头部的基本功能
 */
@Test
func 简单HTTP头部测试() {
    let headers = HttpRequestHeaders()
    headers.add("Content-Type", "application/json")
    
    @Expect(headers.getFirst("Content-Type") != None, true)
    @Expect(headers.getFirst("Content-Type"), Some("application/json"))
}