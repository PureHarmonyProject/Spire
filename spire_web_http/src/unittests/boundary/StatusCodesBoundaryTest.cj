package spire_web_http.unittests.boundary

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import std.collection.*

/**
 * StatusCodes边界值测试
 * 测试状态码的边界值
 */
@Test
func StatusCodes边界值测试() {
    // 验证最小和最大状态码
    @Expect(StatusCodes.Continue, 100)                               // 最小的标准状态码
    @Expect(StatusCodes.NetworkAuthenticationRequired, 511)         // 最大的标准状态码
    
    // 验证各个范围的最小值
    @Expect(StatusCodes.Continue, 100)                              // 1xx最小
    @Expect(StatusCodes.Ok, 200)                                    // 2xx最小
    @Expect(StatusCodes.MultipleChoices, 300)                       // 3xx最小
    @Expect(StatusCodes.BadRequest, 400)                           // 4xx最小
    @Expect(StatusCodes.InternalServerError, 500)                  // 5xx最小
}

/**
 * StatusCodes特殊状态码边界测试
 * 测试特殊和边界状态码
 */
@Test
func StatusCodes特殊状态码边界测试() {
    // 测试不常用的状态码
    @Expect(StatusCodes.Processing, 102)                             // 处理中
    @Expect(StatusCodes.EarlyHints, 103)                            // 早期提示
    @Expect(StatusCodes.NotExtended, 510)                           // 未扩展
    @Expect(StatusCodes.NetworkAuthenticationRequired, 511)         // 需要网络认证
    
    // 测试边界状态码的含义
    @Expect(StatusCodes.Continue >= 100 && StatusCodes.Continue < 200, true)  // 1xx范围
    @Expect(StatusCodes.Ok >= 200 && StatusCodes.Ok < 300, true)            // 2xx范围
    @Expect(StatusCodes.MultipleChoices >= 300 && StatusCodes.MultipleChoices < 400, true)  // 3xx范围
    @Expect(StatusCodes.BadRequest >= 400 && StatusCodes.BadRequest < 500, true)  // 4xx范围
    @Expect(StatusCodes.InternalServerError >= 500 && StatusCodes.InternalServerError < 600, true)  // 5xx范围
}

/**
 * StatusCodes状态码范围边界测试
 * 测试状态码范围的边界情况
 */
@Test
func StatusCodes状态码范围边界测试() {
    // 测试状态码分类的边界值
    let informationalCodes = ArrayList<Int64>()
    let successCodes = ArrayList<Int64>()
    let redirectCodes = ArrayList<Int64>()
    let clientErrorCodes = ArrayList<Int64>()
    let serverErrorCodes = ArrayList<Int64>()
    
    // 收集各个范围的状态码
    for (i in 100..600) {
        if (i >= 100 && i < 200) {
            informationalCodes.add(i)
        } else if (i >= 200 && i < 300) {
            successCodes.add(i)
        } else if (i >= 300 && i < 400) {
            redirectCodes.add(i)
        } else if (i >= 400 && i < 500) {
            clientErrorCodes.add(i)
        } else if (i >= 500 && i < 600) {
            serverErrorCodes.add(i)
        }
    }
    
    // 验证每个范围都有状态码
    @Expect(informationalCodes.size > 0)
    @Expect(successCodes.size > 0)
    @Expect(redirectCodes.size > 0)
    @Expect(clientErrorCodes.size > 0)
    @Expect(serverErrorCodes.size > 0)
    
    // 验证范围边界
    @Expect(informationalCodes[0], 100)
    @Expect(successCodes[0], 200)
    @Expect(redirectCodes[0], 300)
    @Expect(clientErrorCodes[0], 400)
    @Expect(serverErrorCodes[0], 500)
}

/**
 * StatusCodes状态码比较边界测试
 * 测试状态码比较的边界情况
 */
@Test
func StatusCodes状态码比较边界测试() {
    // 测试状态码比较的边界情况
    let minCode = StatusCodes.Continue      // 100
    let maxCode = StatusCodes.NetworkAuthenticationRequired  // 511
    
    // 测试边界比较
    @Expect(minCode < maxCode, true)
    @Expect(minCode <= maxCode, true)
    @Expect(maxCode > minCode, true)
    @Expect(maxCode >= minCode, true)
    
    // 测试中间值比较
    let midCode = StatusCodes.Ok            // 200
    @Expect(midCode > minCode && midCode < maxCode, true)
    
    // 测试边界值相等性
    @Expect(minCode == 100, true)
    @Expect(maxCode == 511, true)
}