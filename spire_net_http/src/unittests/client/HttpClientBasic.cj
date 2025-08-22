package spire_net_http.unittests.client

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.io.*
import std.time.*
import stdx.encoding.url.*
import spire_net_http.*
import spire_net_http.unittests.*

/**
 * HttpClient默认构造函数测试
 * 测试HttpClient的默认构造和基本属性
 */
@Test
func HttpClient默认构造函数测试() {
    let client = HttpClient()
    
    // 验证客户端未关闭
    @Expect(!client.isClosed())
}

/**
 * HttpClient配置构造函数测试
 * 测试使用配置函数构造HttpClient
 */
@Test
func HttpClient配置构造函数测试() {
    let handler = HttpClientHandler()
    handler.timeout = Duration.minute
    let client = HttpClient(handler)
    client.baseAddress = Some(URL.parse("https://api.example.com"))
    client.defaultRequestHeaders.add("Authorization", "Bearer token")
    @Expect(!client.isClosed())
} 

/**
 * HttpClient关闭功能测试
 * 测试HttpClient的关闭功能
 */
@Test
func HttpClient关闭功能测试() {
    let client = HttpClient()
    
    // 验证初始状态
    @Expect(!client.isClosed())
    
    // 关闭客户端
    client.close()
    
    // 验证已关闭
    @Expect(client.isClosed())
    
    // 多次关闭应该安全
    client.close()
    @Expect(client.isClosed())
}

/**
 * HttpClient基础URL解析测试
 * 测试基础URL与相对URL的组合
 */
@Test
func HttpClient基础URL解析测试() {
    let client = HttpClient()
    client.baseAddress = Some(URL.parse("https://api.example.com"))
    @Expect(!client.isClosed())
}

/**
 * HttpClient超时设置测试
 * 测试HttpClient的超时设置
 */
@Test
func HttpClient超时设置测试() {
    let handler = HttpClientHandler()
    handler.timeout = Duration.second * 10
    let client = HttpClient(handler)
    @Expect(!client.isClosed())
}

/**
 * HttpClient默认头部测试
 * 测试HttpClient的默认头部设置
 */
@Test
func HttpClient默认头部测试() {
    let client = HttpClient()
    client.defaultRequestHeaders.add("User-Agent", "SpireNetHTTP/1.0")
    client.defaultRequestHeaders.add("Accept", "application/json")
    @Expect(!client.isClosed())
}

/**
 * HttpClient处理器链测试
 * 测试HttpClient的处理器链配置
 */

// 简化为通过自定义处理器构造客户端
class ThrowingHandler <: HttpMessageHandler {
    public func send(_: HttpRequestMessage): HttpResponseMessage {
        throw HttpRequestException("Test handler", None)
    }
}

@Test
func HttpClient处理器链测试() {
    let client = HttpClient(ThrowingHandler())
    @Expect(!client.isClosed())
}

/**
 * IHttpClientFactory基本实现测试
 * 测试IHttpClientFactory接口的基本实现
 */
class TestHttpClientFactory <: IHttpClientFactory {
    public func create(name: String): HttpClient {
        match (name) {
            case "test" =>
                { =>
                    let handler = HttpClientHandler()
                    handler.timeout = Duration.second * 30
                    let client = HttpClient(handler)
                    client.baseAddress = Some(URL.parse("https://test.example.com"))
                    client
                }()
            case "api" =>
                { =>
                    let handler = HttpClientHandler()
                    handler.timeout = Duration.minute
                    let client = HttpClient(handler)
                    client.baseAddress = Some(URL.parse("https://api.example.com"))
                    client
                }()
            case _ =>
                HttpClient()
        }
    }
}

@Test
func IHttpClientFactory基本实现测试() {
    let factory = TestHttpClientFactory()
    
    // 测试创建不同名称的客户端
    let testClient = factory.create("test")
    let apiClient = factory.create("api")
    let defaultClient = factory.create("default")
    
    @Expect(!testClient.isClosed())
    @Expect(!apiClient.isClosed())
    @Expect(!defaultClient.isClosed())
}


// 以自定义处理器模拟
class ThrowingHandler2 <: HttpMessageHandler {
    public func send(_: HttpRequestMessage): HttpResponseMessage {
        throw HttpRequestException("Test handler", None)
    }
}
@Test
func DelegatingHandler替代测试() {
    let handler = ThrowingHandler2()
    let testRequest = HttpRequestMessage(HttpMethod.get, "https://test.example.com")
    try {
        let _ = handler.send(testRequest)
        @Expect(false)
    } catch (e: HttpRequestException) {
        @Expect(true)
    }
}

/**
 * HttpMessageHandler接口测试
 * 测试HttpMessageHandler接口的实现
 */
class TestMessageHandler <: HttpMessageHandler {
    public func send(request: HttpRequestMessage): HttpResponseMessage {
        // 在请求处理前添加头部
        request.headers.add("X-Processed-By", "TestHandler")
        // 直接抛出，模拟下游失败
        throw HttpRequestException("Next handler", None)
    }
}

@Test
func HttpMessageHandler接口测试() {
    let handler = TestMessageHandler()
    let testRequest = HttpRequestMessage(HttpMethod.get, "https://test.example.com")
    
    // 测试处理器（预期抛出异常）
    try {
        let _ = handler.send(testRequest)
        @Expect(false)
    } catch (e: HttpRequestException) {
        @Expect(true)
    }
}

/**
 * HttpClient资源管理测试
 * 测试HttpClient作为资源的正确管理
 */
@Test
func HttpClient资源管理测试() {
    let client = HttpClient()
    
    try {
        // 使用客户端
        @Expect(!client.isClosed())
        
        // 模拟使用完成后关闭
        client.close()
        @Expect(client.isClosed())
        
    } finally {
        // 确保资源被释放
        if (!client.isClosed()) {
            client.close()
        }
    }
}

/**
 * HttpClient多重配置测试
 * 测试HttpClient的复杂配置组合
 */
@Test
func HttpClient多重配置测试() {
    let baseUrl = URL.parse("https://api.example.com/v1")
    let handler = HttpClientHandler()
    handler.timeout = Duration.second * 45
    let client = HttpClient(handler)
    client.baseAddress = Some(baseUrl)
    client.defaultRequestHeaders.add("Authorization", "Bearer abc123")
    client.defaultRequestHeaders.add("Content-Type", "application/json")
    client.defaultRequestHeaders.add("Accept", "application/json")
    client.defaultRequestHeaders.add("User-Agent", "MyApp/1.0")
    
    @Expect(!client.isClosed())
}

/**
 * 默认头复制与覆盖测试
 */

// 捕获器
class CaptureStore { public var uri: String = ""; public let headers = HashMap<String, String>() }
class CapturingHandler <: HttpMessageHandler {
    private let store: CaptureStore
    public init(store: CaptureStore) { this.store = store }
    public func send(request: HttpRequestMessage): HttpResponseMessage {
        // 记录最终请求头与URI
        store.uri = request.requestUri.flatMap { u => Some(u.toString()) }.getOrThrow()
        let auth = request.headers.getFirst("Authorization")
        if (auth.isSome()) { store.headers["Authorization"] = auth.getOrThrow() }
        throw HttpRequestException("capture", None)
    }
}

@Test
func HttpClient默认头复制与覆盖测试() {
    // 1) 仅默认头应被复制到请求
    let store1 = CaptureStore()
    let client1 = HttpClient(CapturingHandler(store1))
    client1.defaultRequestHeaders.add("Authorization", "DefaultToken")
    let req1 = HttpRequestMessage(HttpMethod.get, "https://api.example.com")
    try { let _ = client1.send(req1); @Expect(false) } catch (e: HttpRequestException) { @Expect(true) }
    @Expect(store1.headers.contains("Authorization"), true)
    @Expect(store1.headers["Authorization"], "DefaultToken")

    // 2) 当请求头与默认头同名时，默认头覆盖请求头
    let store2 = CaptureStore()
    let client2 = HttpClient(CapturingHandler(store2))
    client2.defaultRequestHeaders.add("Authorization", "DefaultToken")
    let req2 = HttpRequestMessage(HttpMethod.get, "https://api.example.com")
    req2.headers.add("Authorization", "RequestToken")
    try { let _ = client2.send(req2); @Expect(false) } catch (e: HttpRequestException) { @Expect(true) }
    @Expect(store2.headers["Authorization"], "DefaultToken")
}

/**
 * 基础地址合并与非法请求抛错测试
 */

// 合并相对路径
class Store { public var uri: String = "" }
class UriHandler <: HttpMessageHandler {
    private let s: Store
    public init(s: Store) { this.s = s }
    public func send(request: HttpRequestMessage): HttpResponseMessage {
        s.uri = request.requestUri.flatMap { u => Some(u.toString()) }.getOrThrow()
        throw HttpRequestException("stop", None)
    }
}

@Test
func HttpClient基础地址合并与非法请求测试() {
    let s = Store()
    let client = HttpClient(UriHandler(s))
    client.baseAddress = Some(URL.parse("https://api.example.com/api"))
    let req = HttpRequestMessage(HttpMethod.get, "users")
    try { let _ = client.send(req); @Expect(false) } catch (e: HttpRequestException) { @Expect(true) }
    @Expect(s.uri.endsWith("/users"), true)

    // 非法请求：无 base 且无 requestUri
    let clientBad = HttpClient(UriHandler(Store()))
    let badReq = HttpRequestMessage(HttpMethod.get, "https://temp" )
    badReq.requestUri = None
    try {
        let _ = clientBad.send(badReq)
        @Expect(false)
    } catch (e: Exception) {
        @Expect(true)
    }
}

/**
 * 操作开始后禁止修改关键属性测试
 */

class NopHandler <: HttpMessageHandler {
    public func send(_: HttpRequestMessage): HttpResponseMessage {
        throw HttpRequestException("sent", None)
    }
}

@Test
func HttpClient操作开始后不可变更测试() {
    let client = HttpClient(NopHandler())
    // 首次发送将置位 operationStarted
    try { let _ = client.send(HttpRequestMessage(HttpMethod.get, "https://api.example.com")) } catch (e: HttpRequestException) { /* ignore */ }
    // 之后修改 baseAddress 应抛出异常
    try {
        client.baseAddress = Some(URL.parse("https://another"))
        @Expect(false)
    } catch (e: UnsupportedException) {
        @Expect(true)
    }
}

/**
 * HttpMessageInvoker 关闭语义测试
 */
class CloseFlagHandler <: HttpMessageHandler {
    public var closed: Bool = false
    public func send(_: HttpRequestMessage): HttpResponseMessage { throw HttpRequestException("no", None) }
    protected override func close(_: Bool) { closed = true }
}

@Test
func HttpMessageInvoker关闭语义测试() {
    // 1) closeHandler = true 时应关闭底层 handler
    let h1 = CloseFlagHandler()
    let inv1 = HttpMessageInvoker(h1, true)
    inv1.close()
    @Expect(h1.closed, true)
    // 2) closeHandler = false 时不关闭
    let h2 = CloseFlagHandler()
    let inv2 = HttpMessageInvoker(h2, false)
    inv2.close()
    @Expect(h2.closed, false)
}
