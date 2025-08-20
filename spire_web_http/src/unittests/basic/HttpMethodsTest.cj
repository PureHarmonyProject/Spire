package spire_web_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import spire_web_http.unittests.*

/**
 * HTTP方法常量测试
 * 测试HttpMethods结构体中定义的各种HTTP方法常量
 */
@Test
func HTTP方法常量测试() {
    // 验证各种HTTP方法常量的值
    @Expect(HttpMethods.Get, "get")
    @Expect(HttpMethods.Post, "post")
    @Expect(HttpMethods.Put, "put")
    @Expect(HttpMethods.Delete, "delete")
    @Expect(HttpMethods.Patch, "patch")
    @Expect(HttpMethods.Head, "head")
    @Expect(HttpMethods.Options, "options")
    @Expect(HttpMethods.Trace, "trace")
    @Expect(HttpMethods.Connect, "connect")
}

/**
 * GET方法判断测试
 * 测试isGet方法对各种大小写形式的GET方法的识别
 */
@Test
func GET方法判断测试() {
    // 测试标准GET方法
    @Expect(HttpMethods.isGet("GET"))
    @Expect(HttpMethods.isGet("get"))
    @Expect(HttpMethods.isGet("Get"))
    @Expect(HttpMethods.isGet("GET"))
    
    // 测试非GET方法
    @Expect(!HttpMethods.isGet("POST"))
    @Expect(!HttpMethods.isGet("PUT"))
    @Expect(!HttpMethods.isGet("DELETE"))
    @Expect(!HttpMethods.isGet("PATCH"))
    @Expect(!HttpMethods.isGet(""))
    @Expect(!HttpMethods.isGet("INVALID"))
}

/**
 * POST方法判断测试
 * 测试isPost方法对各种大小写形式的POST方法的识别
 */
@Test
func POST方法判断测试() {
    // 测试标准POST方法
    @Expect(HttpMethods.isPost("POST"))
    @Expect(HttpMethods.isPost("post"))
    @Expect(HttpMethods.isPost("Post"))
    @Expect(HttpMethods.isPost("POST"))
    
    // 测试非POST方法
    @Expect(!HttpMethods.isPost("GET"))
    @Expect(!HttpMethods.isPost("PUT"))
    @Expect(!HttpMethods.isPost("DELETE"))
    @Expect(!HttpMethods.isPost("PATCH"))
    @Expect(!HttpMethods.isPost(""))
    @Expect(!HttpMethods.isPost("INVALID"))
}

/**
 * PUT方法判断测试
 * 测试isPut方法对各种大小写形式的PUT方法的识别
 */
@Test
func PUT方法判断测试() {
    // 测试标准PUT方法
    @Expect(HttpMethods.isPut("PUT"))
    @Expect(HttpMethods.isPut("put"))
    @Expect(HttpMethods.isPut("Put"))
    @Expect(HttpMethods.isPut("PUT"))
    
    // 测试非PUT方法
    @Expect(!HttpMethods.isPut("GET"))
    @Expect(!HttpMethods.isPut("POST"))
    @Expect(!HttpMethods.isPut("DELETE"))
    @Expect(!HttpMethods.isPut("PATCH"))
    @Expect(!HttpMethods.isPut(""))
    @Expect(!HttpMethods.isPut("INVALID"))
}

/**
 * DELETE方法判断测试
 * 测试isDelete方法对各种大小写形式的DELETE方法的识别
 */
@Test
func DELETE方法判断测试() {
    // 测试标准DELETE方法
    @Expect(HttpMethods.isDelete("DELETE"))
    @Expect(HttpMethods.isDelete("delete"))
    @Expect(HttpMethods.isDelete("Delete"))
    @Expect(HttpMethods.isDelete("DELETE"))
    
    // 测试非DELETE方法
    @Expect(!HttpMethods.isDelete("GET"))
    @Expect(!HttpMethods.isDelete("POST"))
    @Expect(!HttpMethods.isDelete("PUT"))
    @Expect(!HttpMethods.isDelete("PATCH"))
    @Expect(!HttpMethods.isDelete(""))
    @Expect(!HttpMethods.isDelete("INVALID"))
}

/**
 * PATCH方法判断测试
 * 测试isPatch方法对各种大小写形式的PATCH方法的识别
 */
@Test
func PATCH方法判断测试() {
    // 测试标准PATCH方法
    @Expect(HttpMethods.isPatch("PATCH"))
    @Expect(HttpMethods.isPatch("patch"))
    @Expect(HttpMethods.isPatch("Patch"))
    @Expect(HttpMethods.isPatch("PATCH"))
    
    // 测试非PATCH方法
    @Expect(!HttpMethods.isPatch("GET"))
    @Expect(!HttpMethods.isPatch("POST"))
    @Expect(!HttpMethods.isPatch("PUT"))
    @Expect(!HttpMethods.isPatch("DELETE"))
    @Expect(!HttpMethods.isPatch(""))
    @Expect(!HttpMethods.isPatch("INVALID"))
}

/**
 * HEAD方法判断测试
 * 测试isHead方法对各种大小写形式的HEAD方法的识别
 */
@Test
func HEAD方法判断测试() {
    // 测试标准HEAD方法
    @Expect(HttpMethods.isHead("HEAD"))
    @Expect(HttpMethods.isHead("head"))
    @Expect(HttpMethods.isHead("Head"))
    @Expect(HttpMethods.isHead("HEAD"))
    
    // 测试非HEAD方法
    @Expect(!HttpMethods.isHead("GET"))
    @Expect(!HttpMethods.isHead("POST"))
    @Expect(!HttpMethods.isHead("PUT"))
    @Expect(!HttpMethods.isHead("DELETE"))
    @Expect(!HttpMethods.isHead(""))
    @Expect(!HttpMethods.isHead("INVALID"))
}

/**
 * OPTIONS方法判断测试
 * 测试isOptions方法对各种大小写形式的OPTIONS方法的识别
 */
@Test
func OPTIONS方法判断测试() {
    // 测试标准OPTIONS方法
    @Expect(HttpMethods.isOptions("OPTIONS"))
    @Expect(HttpMethods.isOptions("options"))
    @Expect(HttpMethods.isOptions("Options"))
    @Expect(HttpMethods.isOptions("OPTIONS"))
    
    // 测试非OPTIONS方法
    @Expect(!HttpMethods.isOptions("GET"))
    @Expect(!HttpMethods.isOptions("POST"))
    @Expect(!HttpMethods.isOptions("PUT"))
    @Expect(!HttpMethods.isOptions("DELETE"))
    @Expect(!HttpMethods.isOptions(""))
    @Expect(!HttpMethods.isOptions("INVALID"))
}

/**
 * TRACE方法判断测试
 * 测试isTrace方法对各种大小写形式的TRACE方法的识别
 */
@Test
func TRACE方法判断测试() {
    // 测试标准TRACE方法
    @Expect(HttpMethods.isTrace("TRACE"))
    @Expect(HttpMethods.isTrace("trace"))
    @Expect(HttpMethods.isTrace("Trace"))
    @Expect(HttpMethods.isTrace("TRACE"))
    
    // 测试非TRACE方法
    @Expect(!HttpMethods.isTrace("GET"))
    @Expect(!HttpMethods.isTrace("POST"))
    @Expect(!HttpMethods.isTrace("PUT"))
    @Expect(!HttpMethods.isTrace("DELETE"))
    @Expect(!HttpMethods.isTrace(""))
    @Expect(!HttpMethods.isTrace("INVALID"))
}

/**
 * CONNECT方法判断测试
 * 测试isConnect方法对各种大小写形式的CONNECT方法的识别
 */
@Test
func CONNECT方法判断测试() {
    // 测试标准CONNECT方法
    @Expect(HttpMethods.isConnect("CONNECT"))
    @Expect(HttpMethods.isConnect("connect"))
    @Expect(HttpMethods.isConnect("Connect"))
    @Expect(HttpMethods.isConnect("CONNECT"))
    
    // 测试非CONNECT方法
    @Expect(!HttpMethods.isConnect("GET"))
    @Expect(!HttpMethods.isConnect("POST"))
    @Expect(!HttpMethods.isConnect("PUT"))
    @Expect(!HttpMethods.isConnect("DELETE"))
    @Expect(!HttpMethods.isConnect(""))
    @Expect(!HttpMethods.isConnect("INVALID"))
}

/**
 * 空字符串和null处理测试
 * 测试对空字符串和无效输入的处理
 */
@Test
func 空字符串和null处理测试() {
    // 测试空字符串
    @Expect(!HttpMethods.isGet(""))
    @Expect(!HttpMethods.isPost(""))
    @Expect(!HttpMethods.isPut(""))
    @Expect(!HttpMethods.isDelete(""))
    @Expect(!HttpMethods.isPatch(""))
    @Expect(!HttpMethods.isHead(""))
    @Expect(!HttpMethods.isOptions(""))
    @Expect(!HttpMethods.isTrace(""))
    @Expect(!HttpMethods.isConnect(""))
}

/**
 * 混合大小写HTTP方法测试
 * 测试各种混合大小写形式的HTTP方法
 */
@Test
func 混合大小写HTTP方法测试() {
    // 测试各种混合大小写形式
    @Expect(HttpMethods.isGet("GeT"))
    @Expect(HttpMethods.isGet("GEt"))
    @Expect(HttpMethods.isGet("gEt"))
    @Expect(HttpMethods.isGet("gET"))
    
    @Expect(HttpMethods.isPost("PoSt"))
    @Expect(HttpMethods.isPost("POst"))
    @Expect(HttpMethods.isPost("pOsT"))
    @Expect(HttpMethods.isPost("pOST"))
    
    @Expect(HttpMethods.isPut("PuT"))
    @Expect(HttpMethods.isPut("PUt"))
    @Expect(HttpMethods.isPut("pUt"))
    @Expect(HttpMethods.isPut("pUT"))
}

/**
 * 特殊字符HTTP方法测试
 * 测试包含特殊字符的HTTP方法（应该返回false）
 */
@Test
func 特殊字符HTTP方法测试() {
    // 测试包含特殊字符的方法名（应该返回false）
    @Expect(!HttpMethods.isGet("GET/"))
    @Expect(!HttpMethods.isGet("GET?"))
    @Expect(!HttpMethods.isGet("GET#"))
    @Expect(!HttpMethods.isGet("GET "))
    @Expect(!HttpMethods.isGet(" GET"))
    @Expect(!HttpMethods.isGet("GET\n"))
    @Expect(!HttpMethods.isGet("GET\t"))
}

/**
 * 所有HTTP方法识别测试
 * 测试对测试数据中所有HTTP方法的正确识别
 */
@Test
func 所有HTTP方法识别测试() {
    let testData = TestHelper.createHttpMethodsData()
    
    for (method in testData) {
        let lowerMethod = method.toAsciiLower()
        
        if (lowerMethod == "get") {
            @Expect(HttpMethods.isGet(method))
        } else if (lowerMethod == "post") {
            @Expect(HttpMethods.isPost(method))
        } else if (lowerMethod == "put") {
            @Expect(HttpMethods.isPut(method))
        } else if (lowerMethod == "delete") {
            @Expect(HttpMethods.isDelete(method))
        } else if (lowerMethod == "patch") {
            @Expect(HttpMethods.isPatch(method))
        } else if (lowerMethod == "head") {
            @Expect(HttpMethods.isHead(method))
        } else if (lowerMethod == "options") {
            @Expect(HttpMethods.isOptions(method))
        } else if (lowerMethod == "trace") {
            @Expect(HttpMethods.isTrace(method))
        } else if (lowerMethod == "connect") {
            @Expect(HttpMethods.isConnect(method))
        }
    }
}