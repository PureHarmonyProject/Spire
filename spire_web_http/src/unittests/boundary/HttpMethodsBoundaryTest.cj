package spire_web_http.unittests.boundary

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import spire_web_http.unittests.*
import std.collection.*

/**
 * HttpMethods空字符串和null处理边界测试
 * 测试对空字符串和无效输入的处理
 */
@Test
func HttpMethods空字符串和null处理边界测试() {
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
 * HttpMethods混合大小写边界测试
 * 测试各种混合大小写形式的HTTP方法
 */
@Test
func HttpMethods混合大小写边界测试() {
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
    
    @Expect(HttpMethods.isDelete("DeLeTe"))
    @Expect(HttpMethods.isDelete("DELete"))
    @Expect(HttpMethods.isDelete("delETE"))
}

/**
 * HttpMethods特殊字符边界测试
 * 测试包含特殊字符的HTTP方法（应该返回false）
 */
@Test
func HttpMethods特殊字符边界测试() {
    // 测试包含特殊字符的方法名（应该返回false）
    @Expect(!HttpMethods.isGet("GET/"))
    @Expect(!HttpMethods.isGet("GET?"))
    @Expect(!HttpMethods.isGet("GET#"))
    @Expect(!HttpMethods.isGet("GET "))
    @Expect(!HttpMethods.isGet(" GET"))
    @Expect(!HttpMethods.isGet("GET\n"))
    @Expect(!HttpMethods.isGet("GET\t"))
    
    // 测试其他特殊字符组合
    @Expect(!HttpMethods.isPost("POST@"))
    @Expect(!HttpMethods.isPost("POST$"))
    @Expect(!HttpMethods.isPost("POST%"))
    @Expect(!HttpMethods.isPost("POST&"))
    @Expect(!HttpMethods.isPost("POST*"))
    
    // 测试包含数字的情况
    @Expect(!HttpMethods.isPut("PUT1"))
    @Expect(!HttpMethods.isPut("PUT2"))
    @Expect(!HttpMethods.isPut("1PUT"))
    @Expect(!HttpMethods.isPut("2PUT"))
}

/**
 * HttpMethods长度边界测试
 * 测试不同长度的HTTP方法字符串
 */
@Test
func HttpMethods长度边界测试() {
    // 测试标准长度
    @Expect(HttpMethods.isGet("GET"))      // 3字符
    @Expect(HttpMethods.isPost("POST"))    // 4字符
    @Expect(HttpMethods.isPut("PUT"))      // 3字符
    @Expect(HttpMethods.isDelete("DELETE")) // 6字符
    @Expect(HttpMethods.isPatch("PATCH"))   // 5字符
    @Expect(HttpMethods.isHead("HEAD"))     // 4字符
    @Expect(HttpMethods.isOptions("OPTIONS")) // 7字符
    @Expect(HttpMethods.isTrace("TRACE"))   // 5字符
    @Expect(HttpMethods.isConnect("CONNECT")) // 7字符
    
    // 测试超长字符串（应该返回false）
    @Expect(!HttpMethods.isGet("GETTOOLONG"))
    @Expect(!HttpMethods.isPost("POSTTOOLONG"))
    @Expect(!HttpMethods.isPut("PUTTOOLONG"))
    
    // 测试过短字符串（应该返回false）
    @Expect(!HttpMethods.isGet("GE"))
    @Expect(!HttpMethods.isPost("PO"))
    @Expect(!HttpMethods.isPut("PU"))
}

/**
 * HttpMethodsUnicode边界测试
 * 测试包含Unicode字符的HTTP方法
 */
@Test
func HttpMethodsUnicode边界测试() {
    // 测试包含Unicode字符的方法名（应该返回false）
    @Expect(!HttpMethods.isGet("获取"))
    @Expect(!HttpMethods.isGet("GÉT"))
    @Expect(!HttpMethods.isGet("GÈT"))
    @Expect(!HttpMethods.isGet("GËT"))
    
    @Expect(!HttpMethods.isPost("发布"))
    @Expect(!HttpMethods.isPost("PÖST"))
    @Expect(!HttpMethods.isPost("PØST"))
    
    @Expect(!HttpMethods.isPut("放置"))
    @Expect(!HttpMethods.isPut("PÜT"))
    @Expect(!HttpMethods.isPut("PÙT"))
}

/**
 * HttpMethods所有方法识别边界测试
 * 测试对测试数据中所有HTTP方法的正确识别
 */
@Test
func HttpMethods所有方法识别边界测试() {
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