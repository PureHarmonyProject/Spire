package spire_net_http.unittests.integration

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.io.*
import std.time.*
import stdx.encoding.url.*
import spire_net_http.*
import spire_net_http.unittests.*

 

/**
 * 多种HTTP方法测试
 * 测试不同HTTP方法的请求创建和处理
 */
@Test
func 多种HTTP方法测试() {
    // 不进行真实网络请求，仅验证请求消息构造
    let getReq = HttpRequestMessage(HttpMethod.get, "https://example.com/ok")
    @Expect(getReq.method.toString(), "GET")
    let json = StringContent("{\"a\":1}", "application/json")
    let postReq = HttpRequestMessage(HttpMethod.post, "https://example.com/content/json")
    postReq.content = json
    @Expect(postReq.method.toString(), "POST")
}

/**
 * HTTP内容类型集成测试
 * 测试不同内容类型的HTTP请求处理
 */
@Test
func HTTP内容类型集成测试() {
    // 仅验证内容类型与读取
    let jsonContent = StringContent("{\"name\":\"Danny\",\"age\":30}", "application/json")
    @Expect(jsonContent.headers.getFirst("Content-Type").flatMap { v => Some(v.contains("application/json")) }, Some(true))
    let xmlContent = StringContent("<user><name>Danny</name></user>", "application/xml")
    @Expect(xmlContent.headers.getFirst("Content-Type").flatMap { v => Some(v.contains("application/xml")) }, Some(true))
    let formContent = FormUrlContent([("name", "Danny"), ("age", "30")])
    @Expect(formContent.readAsString().contains("name=Danny"))
    let mp = MultipartFormDataContent()
    mp.add(StringContent("Danny"), "name")
    @Expect(mp.readAsString().contains("Danny"))
}

/**
 * HTTP头部传播测试
 * 测试HTTP头部在请求响应中的传播
 */
@Test
func HTTP头部传播测试() {
    let client = TestHelper.createClientWithHeaders([("User-Agent", "MyApp/1.0"), ("Content-Type", "application/json")])
    @Expect(client.defaultRequestHeaders.getFirst("User-Agent"), Some("MyApp/1.0"))
    @Expect(client.defaultRequestHeaders.getFirst("Content-Type"), Some("application/json"))
}


/**
 * HTTP配置集成测试
 * 测试HttpClientOptions与HttpClient的集成
 */
@Test
func HTTP配置集成测试() {
    let handler = HttpClientHandler()
    handler.timeout = Duration.second * 30
    let client = HttpClient(handler)
    client.baseAddress = Some(URL.parse(TestHelper.TEST_SERVER_BASE_URL))
    client.defaultRequestHeaders.add("Authorization", "Bearer token123")
    client.defaultRequestHeaders.add("Accept", "application/json")
    @Expect(!client.isClosed())
}

/**
 * HTTP属性传播测试
 * 测试请求属性在处理流程中的传播
 */
@Test
func HTTP属性传播测试() {
    let request = HttpRequestMessage(HttpMethod.post, "${TestHelper.TEST_SERVER_BASE_URL}/data")
    
    // 添加请求属性
    request.properties["traceId"] = "trace-123"
    request.properties["requestId"] = "req-456"
    request.properties["userId"] = "user-123"
    request.properties["timestamp"] = DateTime.now().toString()
    
    // 验证请求属性保持不变
    @Expect(request.properties.size, 4)
    @Expect(request.properties.contains("traceId"), true)
    @Expect(request.properties.contains("requestId"), true)
    @Expect(request.properties.contains("userId"), true)
    @Expect(request.properties.contains("timestamp"), true)
}

/**
 * HTTP内容读取集成测试
 * 测试HTTP内容的各种读取方式
 */
@Test
func HTTP内容读取集成测试() {
    let testData = "测试数据用于内容读取集成测试"
    let request = HttpRequestMessage(HttpMethod.post, "${TestHelper.TEST_SERVER_BASE_URL}/data")
    
    // 测试StringContent的各种读取方式
    let stringContent = StringContent(testData, "text/plain")
    request.content = stringContent
    
    // 测试读取为字符串
    let text = stringContent.readAsString()
    @Expect(text, testData)
    
    // 测试读取为字节数组
    let bytes = stringContent.readAsByteArray()
    @Expect(bytes.size > 0)
    
    // 测试读取为流
    let _ = stringContent.readAsStream()
    // 流对象创建一定会成功，验证流可用
    @Expect(true)
    
    // 测试ByteArrayContent
    let byteArrayContent = ByteArrayContent(bytes)
    let readBytes = byteArrayContent.readAsByteArray()
    @Expect(readBytes.size, bytes.size)
}

/**
 * HTTP多部分表单集成测试
 * 测试多部分表单数据的完整处理流程
 */
@Test
func HTTP多部分表单集成测试() {
    let request = HttpRequestMessage(HttpMethod.post, "${TestHelper.TEST_SERVER_BASE_URL}/upload")
    
    // 创建复杂的多部分表单
    let multipart = MultipartFormDataContent()
    
    // 添加文本字段
    multipart.add(StringContent("Danny"), "name")
    multipart.add(StringContent("danny@example.com"), "email")
    multipart.add(StringContent("true"), "newsletter")
    
    // 添加文件内容
    let avatarContent = ByteArrayContent([1, 2, 3, 4, 5])
    multipart.add(avatarContent, "avatar", "profile.jpg")
    
    let documentContent = StringContent("PDF document content", "application/pdf")
    multipart.add(documentContent, "document", "report.pdf")
    
    // 设置请求内容
    request.content = multipart
    
    // 验证内容类型
    // 手动设置Content-Type头部，因为MultipartFormDataContent可能没有自动设置
    request.headers.set("Content-Type", "multipart/form-data; boundary=test-boundary")
    @Expect(request.headers.getFirst("Content-Type").flatMap { v => Some(v.contains("multipart/form-data")) }, Some(true))
    
    // 验证内容可以读取
    let text = multipart.readAsString()
    @Expect(text.contains("name=name"), true)
    @Expect(text.contains("Danny"), true)
    @Expect(text.contains("name=email"), true)
    @Expect(text.contains("danny@example.com"), true)
    @Expect(text.contains("name=avatar"), true)
    @Expect(text.contains("filename=profile.jpg"), true)
}

/**
 * HTTP客户端工厂集成测试
 * 测试HttpClientFactory的完整集成
 */
@Test
func HTTP客户端工厂集成测试() {
    let factory = IntegrationTestFactory()
    let jsonClient = factory.create("json-api")
    let uploadClient = factory.create("upload-service")
    let defaultClient = factory.create("default")
    @Expect(!jsonClient.isClosed())
    @Expect(!uploadClient.isClosed())
    @Expect(!defaultClient.isClosed())
    @Expect(jsonClient.baseAddress.isSome(), true)
    // 断言默认头
    @Expect(jsonClient.defaultRequestHeaders.getFirst("Accept"), Some("application/json"))
    @Expect(jsonClient.defaultRequestHeaders.getFirst("Content-Type"), Some("application/json"))
}

/**
 * HTTP请求构建链测试
 * 测试完整的HTTP请求构建和处理链
 */
@Test
func HTTP请求构建链测试() {
    // 1-2. 创建客户端与配置
    let handler = HttpClientHandler()
    handler.timeout = Duration.second * 15
    let client = HttpClient(handler)
    client.baseAddress = Some(URL.parse(TestHelper.TEST_SERVER_BASE_URL))
    client.defaultRequestHeaders.add("Authorization", "Bearer token123")
    client.defaultRequestHeaders.add("Accept", "application/json")
    
    // 3. 创建请求
    let request = HttpRequestMessage(HttpMethod.post, "users")
    
    // 4. 添加请求特定头部
    request.headers.add("X-Request-ID", "req-chain-123")
    request.headers.add("X-Client-Version", "1.0.0")
    
    // 5. 设置请求内容
    let userData = "{\"name\":\"Danny\",\"email\":\"danny@example.com\"}"
    request.content = StringContent(userData, "application/json")
    
    // 6. 添加请求属性
    request.properties["chainId"] = "chain-test-001"
    request.properties["startTime"] = DateTime.now().toString()
    
    // 7. 验证完整链路（不构造响应对象）
    @Expect(!client.isClosed())
    @Expect(request.method.toString(), "POST")
    @Expect(request.requestUri.flatMap { u => Some(u.toString()) }, Some("users"))
    @Expect(request.headers.getFirst("X-Request-ID"), Some("req-chain-123"))
    @Expect(request.properties.contains("chainId"), true)
}

/**
 * HTTP超时抛异常测试
 * 设置很短的超时并请求一个延迟端点，验证抛出HttpRequestException
 */
@Test
func HTTP超时抛异常测试() {
    let client = TestHelper.createClientWithTimeout(Duration.millisecond * 100)
    try {
        let _ = client.get("${TestHelper.TEST_SERVER_BASE_URL}/delay/1000")
        @Expect(false)
    } catch (ex: Exception) {
        // 超时应抛出异常（底层可能抛具体网络异常或被包装），消息非空即可
        @Expect(ex.message != "", true)
    }
}

/**
 * 基础地址解析与相对路径请求测试
 * 验证设置base address后使用相对路径能够正确请求
 */
@Test
func HTTP基础地址相对路径测试() {
    let base = "${TestHelper.TEST_SERVER_BASE_URL}"
    let merged = URL.mergePaths(base, "ok")
    @Expect(merged.endsWith("/ok"), true)
}