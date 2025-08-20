package spire_web_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import spire_web_http.unittests.*

/**
 * 成功状态码测试
 * 测试2xx范围内的状态码常量
 */
@Test
func 成功状态码测试() {
    // 验证2xx成功状态码
    @Expect(StatusCodes.Ok, 200)
    @Expect(StatusCodes.Created, 201)
    @Expect(StatusCodes.Accepted, 202)
    @Expect(StatusCodes.NonAuthoritativeInfo, 203)
    @Expect(StatusCodes.NoContent, 204)
    @Expect(StatusCodes.ResetContent, 205)
    @Expect(StatusCodes.PartialContent, 206)
    @Expect(StatusCodes.MultiStatus, 207)
    @Expect(StatusCodes.AlreadyReported, 208)
    @Expect(StatusCodes.ImUsed, 226)
}

/**
 * 重定向状态码测试
 * 测试3xx范围内的状态码常量
 */
@Test
func 重定向状态码测试() {
    // 验证3xx重定向状态码
    @Expect(StatusCodes.MultipleChoices, 300)
    @Expect(StatusCodes.MovedPermanently, 301)
    @Expect(StatusCodes.Found, 302)
    @Expect(StatusCodes.SeeOther, 303)
    @Expect(StatusCodes.NotModified, 304)
    @Expect(StatusCodes.UseProxy, 305)
    @Expect(StatusCodes.TemporaryRedirect, 307)
    @Expect(StatusCodes.PermanentRedirect, 308)
}

/**
 * 客户端错误状态码测试
 * 测试4xx范围内的状态码常量
 */
@Test
func 客户端错误状态码测试() {
    // 验证4xx客户端错误状态码
    @Expect(StatusCodes.BadRequest, 400)
    @Expect(StatusCodes.Unauthorized, 401)
    @Expect(StatusCodes.PaymentRequired, 402)
    @Expect(StatusCodes.Forbidden, 403)
    @Expect(StatusCodes.NotFound, 404)
    @Expect(StatusCodes.MethodNotAllowed, 405)
    @Expect(StatusCodes.NotAcceptable, 406)
    @Expect(StatusCodes.ProxyAuthRequired, 407)
    @Expect(StatusCodes.RequestTimeout, 408)
    @Expect(StatusCodes.Conflict, 409)
    @Expect(StatusCodes.Gone, 410)
    @Expect(StatusCodes.LengthRequired, 411)
    @Expect(StatusCodes.PreconditionFailed, 412)
    @Expect(StatusCodes.RequestContentTooLarge, 413)
    @Expect(StatusCodes.RequestUriTooLong, 414)
    @Expect(StatusCodes.UnsupportedMediaType, 415)
    @Expect(StatusCodes.RequestedRangeNotSatisfiable, 416)
    @Expect(StatusCodes.ExpectationFailed, 417)
    @Expect(StatusCodes.Teapot, 418)
    @Expect(StatusCodes.MisdirectedRequest, 421)
    @Expect(StatusCodes.UnprocessableEntity, 422)
    @Expect(StatusCodes.Locked, 423)
    @Expect(StatusCodes.FailedDependency, 424)
    @Expect(StatusCodes.TooEarly, 425)
    @Expect(StatusCodes.UpgradeRequired, 426)
    @Expect(StatusCodes.PreconditionRequired, 428)
    @Expect(StatusCodes.TooManyRequests, 429)
    @Expect(StatusCodes.RequestHeaderFieldsTooLarge, 431)
    @Expect(StatusCodes.UnavailableForLegalReasons, 451)
}

/**
 * 服务器错误状态码测试
 * 测试5xx范围内的状态码常量
 */
@Test
func 服务器错误状态码测试() {
    // 验证5xx服务器错误状态码
    @Expect(StatusCodes.InternalServerError, 500)
    @Expect(StatusCodes.NotImplemented, 501)
    @Expect(StatusCodes.BadGateway, 502)
    @Expect(StatusCodes.ServiceUnavailable, 503)
    @Expect(StatusCodes.GatewayTimeout, 504)
    @Expect(StatusCodes.HttpVersionNotSupported, 505)
    @Expect(StatusCodes.VariantAlsoNegotiates, 506)
    @Expect(StatusCodes.InsufficientStorage, 507)
    @Expect(StatusCodes.LoopDetected, 508)
    @Expect(StatusCodes.NotExtended, 510)
    @Expect(StatusCodes.NetworkAuthenticationRequired, 511)
}

/**
 * 信息性状态码测试
 * 测试1xx范围内的状态码常量
 */
@Test
func 信息性状态码测试() {
    // 验证1xx信息性状态码
    @Expect(StatusCodes.Continue, 100)
    @Expect(StatusCodes.SwitchingProtocols, 101)
    @Expect(StatusCodes.Processing, 102)
    @Expect(StatusCodes.EarlyHints, 103)
}

/**
 * 常用状态码验证测试
 * 测试最常用的状态码常量值
 */
@Test
func 常用状态码验证测试() {
    // 验证最常用的状态码
    @Expect(StatusCodes.Ok, 200)                    // 成功
    @Expect(StatusCodes.Created, 201)               // 创建成功
    @Expect(StatusCodes.NoContent, 204)             // 无内容
    @Expect(StatusCodes.BadRequest, 400)            // 错误请求
    @Expect(StatusCodes.Unauthorized, 401)          // 未授权
    @Expect(StatusCodes.Forbidden, 403)             // 禁止访问
    @Expect(StatusCodes.NotFound, 404)              // 未找到
    @Expect(StatusCodes.InternalServerError, 500)  // 服务器内部错误
    @Expect(StatusCodes.ServiceUnavailable, 503)    // 服务不可用
}

/**
 * 状态码范围验证测试
 * 验证状态码是否在正确的范围内
 */
@Test
func 状态码范围验证测试() {
    // 验证1xx范围 (100-199)
    @Expect(StatusCodes.Continue >= 100 && StatusCodes.Continue < 200)
    @Expect(StatusCodes.SwitchingProtocols >= 100 && StatusCodes.SwitchingProtocols < 200)
    @Expect(StatusCodes.Processing >= 100 && StatusCodes.Processing < 200)
    @Expect(StatusCodes.EarlyHints >= 100 && StatusCodes.EarlyHints < 200)
    
    // 验证2xx范围 (200-299)
    @Expect(StatusCodes.Ok >= 200 && StatusCodes.Ok < 300)
    @Expect(StatusCodes.Created >= 200 && StatusCodes.Created < 300)
    @Expect(StatusCodes.NoContent >= 200 && StatusCodes.NoContent < 300)
    
    // 验证3xx范围 (300-399)
    @Expect(StatusCodes.MultipleChoices >= 300 && StatusCodes.MultipleChoices < 400)
    @Expect(StatusCodes.MovedPermanently >= 300 && StatusCodes.MovedPermanently < 400)
    @Expect(StatusCodes.Found >= 300 && StatusCodes.Found < 400)
    
    // 验证4xx范围 (400-499)
    @Expect(StatusCodes.BadRequest >= 400 && StatusCodes.BadRequest < 500)
    @Expect(StatusCodes.Unauthorized >= 400 && StatusCodes.Unauthorized < 500)
    @Expect(StatusCodes.NotFound >= 400 && StatusCodes.NotFound < 500)
    
    // 验证5xx范围 (500-599)
    @Expect(StatusCodes.InternalServerError >= 500 && StatusCodes.InternalServerError < 600)
    @Expect(StatusCodes.ServiceUnavailable >= 500 && StatusCodes.ServiceUnavailable < 600)
    @Expect(StatusCodes.BadGateway >= 500 && StatusCodes.BadGateway < 600)
}

/**
 * 状态码连续性测试
 * 验证常用状态码的连续性和正确性
 */
@Test
func 状态码连续性测试() {
    // 验证基本状态码的连续性
    @Expect(StatusCodes.Ok, 200)
    @Expect(StatusCodes.Created, 201)
    @Expect(StatusCodes.Accepted, 202)
    @Expect(StatusCodes.NonAuthoritativeInfo, 203)
    @Expect(StatusCodes.NoContent, 204)
    @Expect(StatusCodes.ResetContent, 205)
    @Expect(StatusCodes.PartialContent, 206)
    
    // 验证错误状态码的连续性
    @Expect(StatusCodes.BadRequest, 400)
    @Expect(StatusCodes.Unauthorized, 401)
    @Expect(StatusCodes.PaymentRequired, 402)
    @Expect(StatusCodes.Forbidden, 403)
    @Expect(StatusCodes.NotFound, 404)
    @Expect(StatusCodes.MethodNotAllowed, 405)
    @Expect(StatusCodes.NotAcceptable, 406)
}

/**
 * 特殊状态码测试
 * 测试一些特殊的状态码
 */
@Test
func 特殊状态码测试() {
    // 验证特殊状态码
    @Expect(StatusCodes.Teapot, 418)                           // I'm a teapot (RFC 2324)
    @Expect(StatusCodes.EarlyHints, 103)                       // Early Hints (RFC 8297)
    @Expect(StatusCodes.MisdirectedRequest, 421)              // Misdirected Request (RFC 7540)
    @Expect(StatusCodes.UnprocessableEntity, 422)            // Unprocessable Entity (WebDAV)
    @Expect(StatusCodes.TooEarly, 425)                       // Too Early (RFC 8470)
    @Expect(StatusCodes.PreconditionRequired, 428)            // Precondition Required (RFC 6585)
    @Expect(StatusCodes.TooManyRequests, 429)                // Too Many Requests (RFC 6585)
    @Expect(StatusCodes.RequestHeaderFieldsTooLarge, 431)     // Request Header Fields Too Large (RFC 6585)
    @Expect(StatusCodes.UnavailableForLegalReasons, 451)       // Unavailable For Legal Reasons (RFC 7725)
}

/**
 * 状态码类型验证测试
 * 验证状态码常量的类型为UInt16
 */
@Test
func 状态码类型验证测试() {
    // 验证状态码常量的类型
    let okCode: UInt16 = StatusCodes.Ok
    let notFoundCode: UInt16 = StatusCodes.NotFound
    let serverErrorCode: UInt16 = StatusCodes.InternalServerError
    
    @Expect(okCode, 200)
    @Expect(notFoundCode, 404)
    @Expect(serverErrorCode, 500)
}

/**
 * 状态码比较测试
 * 测试状态码之间的比较关系
 */
@Test
func 状态码比较测试() {
    // 验证状态码的比较关系
    @Expect(StatusCodes.Ok < StatusCodes.BadRequest)
    @Expect(StatusCodes.BadRequest < StatusCodes.InternalServerError)
    @Expect(StatusCodes.Created > StatusCodes.Ok)
    @Expect(StatusCodes.NotFound > StatusCodes.BadRequest)
    @Expect(StatusCodes.ServiceUnavailable > StatusCodes.InternalServerError)
    
    // 验证状态码的相等性
    @Expect(StatusCodes.Ok == 200)
    @Expect(StatusCodes.NotFound == 404)
    @Expect(StatusCodes.InternalServerError == 500)
}

/**
 * 状态码映射测试
 * 测试状态码与描述的映射关系
 */
@Test
func 状态码映射测试() {
    let statusCodesData = TestHelper.createStatusCodesData()
    
    // 验证状态码映射
    @Expect(statusCodesData[200], "OK")
    @Expect(statusCodesData[201], "Created")
    @Expect(statusCodesData[204], "No Content")
    @Expect(statusCodesData[400], "Bad Request")
    @Expect(statusCodesData[401], "Unauthorized")
    @Expect(statusCodesData[403], "Forbidden")
    @Expect(statusCodesData[404], "Not Found")
    @Expect(statusCodesData[500], "Internal Server Error")
    @Expect(statusCodesData[503], "Service Unavailable")
}

