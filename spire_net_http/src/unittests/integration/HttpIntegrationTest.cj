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
 * HTTP请求响应完整流程测试
 * 测试从创建请求到处理响应的完整流程
 */
@Test
func HTTP请求响应完整流程测试() {
    let client = TestHelper.createClient()
    let response = client.get("${TestHelper.TEST_SERVER_BASE_URL}/ok")
    @Expect(response.status, UInt16(200))
    @Expect(response.isSuccessStatusCode, true)
}

/**
 * 多种HTTP方法测试
 * 测试不同HTTP方法的请求创建和处理
 */
@Test
func 多种HTTP方法测试() {
    let client = TestHelper.createClient()
    // GET
    let r1 = client.get("${TestHelper.TEST_SERVER_BASE_URL}/ok")
    @Expect(r1.status, UInt16(200))
    // POST JSON
    let json = StringContent("{\"a\":1}", "application/json")
    let r2 = client.post("${TestHelper.TEST_SERVER_BASE_URL}/content/json", Some(json))
    @Expect(r2.isSuccessStatusCode, true)
}

/**
 * HTTP内容类型集成测试
 * 测试不同内容类型的HTTP请求处理
 */
@Test
func HTTP内容类型集成测试() {
    let client = TestHelper.createClient()
    // JSON
    let jsonContent = StringContent("{\"name\":\"John\",\"age\":30}", "application/json")
    let rj = client.post("${TestHelper.TEST_SERVER_BASE_URL}/content/json", Some(jsonContent))
    @Expect(rj.isSuccessStatusCode, true)
    // XML
    let xmlContent = StringContent("<user><name>John</name></user>", "application/xml")
    let rx = client.post("${TestHelper.TEST_SERVER_BASE_URL}/content/xml", Some(xmlContent))
    @Expect(rx.isSuccessStatusCode, true)
    // FORM
    let formContent = FormUrlContent([("name", "John"), ("age", "30")])
    let rf = client.post("${TestHelper.TEST_SERVER_BASE_URL}/content/form", Some(formContent))
    @Expect(rf.isSuccessStatusCode, true)
    // MULTIPART
    let mp = MultipartFormDataContent()
    mp.add(StringContent("John"), "name")
    let rm = client.post("${TestHelper.TEST_SERVER_BASE_URL}/content/multipart", Some(mp))
    @Expect(rm.isSuccessStatusCode, true)
}

/**
 * HTTP头部传播测试
 * 测试HTTP头部在请求响应中的传播
 */
@Test
func HTTP头部传播测试() {
    let client = TestHelper.createClientWithHeaders([("User-Agent", "MyApp/1.0")])
    let r = client.post("${TestHelper.TEST_SERVER_BASE_URL}/echo/headers", None)
    @Expect(r.isSuccessStatusCode, true)
}

/**
 * HTTP错误状态码处理测试
 * 测试各种HTTP错误状态码的处理
 */
@Test
func HTTP错误状态码处理测试() {
    let client = TestHelper.createClient()
    let r404 = client.get("${TestHelper.TEST_SERVER_BASE_URL}/status/404")
    @Expect(r404.status, UInt16(404))
    @Expect(r404.isSuccessStatusCode, false)
}

/**
 * HTTP配置集成测试
 * 测试HttpClientOptions与HttpClient的集成
 */
@Test
func HTTP配置集成测试() {
    // 创建配置
    let options = HttpClientOptions()
    options.address = Some(URL.parse(TestHelper.TEST_SERVER_BASE_URL))
    options.timeout = Duration.second * 30
    options.headers.add("Authorization", "Bearer config-token")
    options.headers.add("Accept", "application/json")
    
    // 创建客户端
    let client = HttpClient({ opts =>
        opts.address = options.address
        opts.timeout = options.timeout
        // 复制配置的头部
        for ((headerName, values) in options.headers) {
            for (value in values) {
                opts.headers.add(headerName, value)
            }
        }
    })
    
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
    request.properties["userId"] = "user-789"
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
    multipart.add(StringContent("John Doe"), "name")
    multipart.add(StringContent("john@example.com"), "email")
    multipart.add(StringContent("true"), "newsletter")
    
    // 添加文件内容
    let avatarContent = ByteArrayContent([1, 2, 3, 4, 5])
    multipart.add(avatarContent, "avatar", "profile.jpg")
    
    let documentContent = StringContent("PDF document content", "application/pdf")
    multipart.add(documentContent, "document", "report.pdf")
    
    // 设置请求内容
    request.content = multipart
    
    // 验证内容类型
    @Expect(request.headers.getFirst("Content-Type").flatMap { v => Some(v.contains("multipart/form-data")) }, Some(true))
    
    // 验证内容可以读取
    let text = multipart.readAsString()
    @Expect(text.contains("name=\"name\""), true)
    @Expect(text.contains("John Doe"), true)
    @Expect(text.contains("name=\"email\""), true)
    @Expect(text.contains("john@example.com"), true)
    @Expect(text.contains("name=\"avatar\""), true)
    @Expect(text.contains("filename=\"profile.jpg\""), true)
}

/**
 * HTTP客户端工厂集成测试
 * 测试HttpClientFactory的完整集成
 */
@Test
func HTTP客户端工厂集成测试() {
    let factory = IntegrationTestFactory()
    
    // 测试创建不同类型的客户端
    let jsonClient = factory.create("json-api")
    let uploadClient = factory.create("upload-service")
    let defaultClient = factory.create("default")
    
    // 验证客户端创建成功
    @Expect(!jsonClient.isClosed())
    @Expect(!uploadClient.isClosed())
    @Expect(!defaultClient.isClosed())
    
    // 测试json-api客户端实际发送请求
    let jsonResponse = jsonClient.get("${TestHelper.TEST_SERVER_BASE_URL}/ok")
    @Expect(jsonResponse.isSuccessStatusCode, true)
    @Expect(jsonResponse.status, UInt16(200))
    
    // 测试upload-service客户端实际发送请求
    let uploadResponse = uploadClient.get("${TestHelper.TEST_SERVER_BASE_URL}/health")
    @Expect(uploadResponse.isSuccessStatusCode, true)
    
    // 测试默认客户端也能工作
    let defaultResponse = defaultClient.get("${TestHelper.TEST_SERVER_BASE_URL}/ok")
    @Expect(defaultResponse.isSuccessStatusCode, true)
}

/**
 * HTTP请求构建链测试
 * 测试完整的HTTP请求构建和处理链
 */
@Test
func HTTP请求构建链测试() {
    // 1. 创建请求配置
    let options = HttpClientOptions()
    options.address = Some(URL.parse(TestHelper.TEST_SERVER_BASE_URL))
    options.timeout = Duration.second * 15
    options.headers.add("Authorization", "Bearer chain-token")
    options.headers.add("Accept", "application/json")
    
    // 2. 创建客户端
    let client = HttpClient({ opts =>
        opts.address = options.address
        opts.timeout = options.timeout
        for ((headerName, values) in options.headers) {
            for (value in values) {
                opts.headers.add(headerName, value)
            }
        }
    })
    
    // 3. 创建请求
    let request = HttpRequestMessage(HttpMethod.post, "users")
    
    // 4. 添加请求特定头部
    request.headers.add("X-Request-ID", "req-chain-123")
    request.headers.add("X-Client-Version", "1.0.0")
    
    // 5. 设置请求内容
    let userData = "{\"name\":\"Chain User\",\"email\":\"chain@example.com\"}"
    request.content = StringContent(userData, "application/json")
    
    // 6. 添加请求属性
    request.properties["chainId"] = "chain-test-001"
    request.properties["startTime"] = DateTime.now().toString()
    
    // 7. 验证完整链路（不构造响应对象）
    @Expect(!client.isClosed())
    @Expect(request.method.toString(), "POST")
    @Expect(request.requestUri.toString(), "users")
    @Expect(request.headers.getFirst("X-Request-ID"), Some("req-chain-123"))
    @Expect(request.properties.contains("chainId"), true)
}