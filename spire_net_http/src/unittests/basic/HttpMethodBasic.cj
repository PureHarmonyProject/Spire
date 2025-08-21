package spire_net_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.io.*
import std.time.*
import spire_net_http.*

/**
 * HTTP方法静态实例测试
 * 测试HttpMethod类中预定义的静态方法实例
 */
@Test
func HTTP方法静态实例测试() {
    // 验证所有标准HTTP方法都存在
    @Expect(HttpMethod.get.toString(), "GET")
    @Expect(HttpMethod.post.toString(), "POST")
    @Expect(HttpMethod.put.toString(), "PUT")
    @Expect(HttpMethod.delete.toString(), "DELETE")
    @Expect(HttpMethod.patch.toString(), "PATCH")
    @Expect(HttpMethod.head.toString(), "HEAD")
    @Expect(HttpMethod.options.toString(), "OPTIONS")
    @Expect(HttpMethod.trace.toString(), "TRACE")
    @Expect(HttpMethod.connect.toString(), "CONNECT")
}

/**
 * HTTP方法构造函数测试
 * 测试HttpMethod的自定义构造函数
 */
@Test
func HTTP方法构造函数测试() {
    // 测试自定义HTTP方法
    let customMethod = HttpMethod("CUSTOM")
    @Expect(customMethod.toString(), "CUSTOM")
    
    // 测试小写方法名会转换为大写
    let lowerMethod = HttpMethod("custom")
    @Expect(lowerMethod.toString(), "CUSTOM")
    
    // 测试混合大小写方法名会转换为大写
    let mixedMethod = HttpMethod("CuStOm")
    @Expect(mixedMethod.toString(), "CUSTOM")
}

/**
 * HTTP方法相等性测试
 * 测试HttpMethod对象的相等性比较
 */
@Test
func HTTP方法相等性测试() {
    let get1 = HttpMethod.get
    let get2 = HttpMethod.get
    let get3 = HttpMethod("GET")
    let post = HttpMethod.post
    
    // 相同方法应该相等
    @Expect(get1.toString(), get2.toString())
    @Expect(get1.toString(), get3.toString())
    
    // 不同方法应该不相等
    @Expect(get1.toString() != post.toString())
}

/**
 * HTTP异常构造函数测试
 * 测试HttpRequestException的基本构造功能
 */
@Test
func HTTP异常构造函数测试() {
    // 测试带消息的异常
    let exception1 = HttpRequestException("测试异常", None)
    @Expect(exception1.message, "测试异常")
    @Expect(exception1.status, None)
    
    // 测试带消息和状态码的异常
    let exception2 = HttpRequestException("404错误", Some(404))
    @Expect(exception2.message, "404错误")
    @Expect(exception2.status, UInt16(404))
}

/**
 * HTTP异常状态码测试
 * 测试HttpRequestException中的状态码处理
 */
@Test
func HTTP异常状态码测试() {
    // 测试不同状态码的异常
    let notFound = HttpRequestException("未找到", Some(404))
    let serverError = HttpRequestException("服务器错误", Some(500))
    let unauthorized = HttpRequestException("未授权", Some(401))
    
    @Expect(notFound.status, UInt16(404))
    @Expect(serverError.status, UInt16(500))
    @Expect(unauthorized.status, UInt16(401))
}

/**
 * HTTP异常消息测试
 * 测试HttpRequestException的消息处理
 */
@Test
func HTTP异常消息测试() {
    // 测试空消息
    let emptyMessage = HttpRequestException("", None)
    @Expect(emptyMessage.message, "")
    
    // 测试长消息
    let longMessage = "这是一个非常长的错误消息，用于测试异常对象能否正确处理较长的错误描述文本" * 1000
    let longException = HttpRequestException(longMessage, None)
    @Expect(longException.message, longMessage)
    
    // 测试特殊字符消息
    let specialMessage = "错误：包含特殊字符！@#$%^&*()"
    let specialException = HttpRequestException(specialMessage, None)
    @Expect(specialException.message, specialMessage)
}