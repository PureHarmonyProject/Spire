package spire_net_http.unittests.content

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.io.*
import std.time.*
import spire_net_http.*

/**
 * StringContent默认构造函数测试
 * 测试StringContent的基本构造功能
 */
@Test
func StringContent默认构造函数测试() {
    let content = StringContent("Hello, World!")
    
    @Expect(content.headers.getFirst("Content-Type"), Some("text/plain; charset=utf-8"))
    
    // 测试读取内容
    let text = content.readAsString()
    @Expect(text, "Hello, World!")
}

/**
 * StringContent自定义媒体类型测试
 * 测试指定媒体类型的StringContent构造
 */
@Test
func StringContent自定义媒体类型测试() {
    let content = StringContent("{\"name\":\"John\"}", "application/json")
    
    @Expect(content.headers.getFirst("Content-Type"), Some("application/json; charset=utf-8"))
    
    let text = content.readAsString()
    @Expect(text, "{\"name\":\"John\"}")
}

/**
 * StringContent完整参数构造函数测试
 * 测试指定媒体类型和编码的StringContent构造
 */
@Test
func StringContent完整参数构造函数测试() {
    let content = StringContent("测试数据", "text/html", "gbk")
    
    @Expect(content.headers.getFirst("Content-Type"), Some("text/html; charset=gbk"))
    
    let text = content.readAsString()
    @Expect(text, "测试数据")
}

/**
 * StringContent空字符串测试
 * 测试处理空字符串的StringContent
 */
@Test
func StringContent空字符串测试() {
    let content = StringContent("")
    
    @Expect(content.headers.getFirst("Content-Type"), Some("text/plain; charset=utf-8"))
    
    let text = content.readAsString()
    @Expect(text, "")
}

/**
 * StringContent特殊字符测试
 * 测试包含特殊字符的StringContent
 */
@Test
func StringContent特殊字符测试() {
    let specialText = "特殊字符：!@#$%^&*()_+-=[]{}|;':\",./<>?"
    let content = StringContent(specialText)
    
    let text = content.readAsString()
    @Expect(text, specialText)
}

/**
 * StringContent长文本测试
 * 测试处理长文本的StringContent
 */
@Test
func StringContent长文本测试() {
    let longText = "这是一个很长的文本。" * 1000 // 重复1000次
    let content = StringContent(longText)
    
    let text = content.readAsString()
    @Expect(text, longText)
}

/**
 * StringContentUnicode字符测试
 * 测试包含Unicode字符的StringContent
 */
@Test
func StringContentUnicode字符测试() {
    let unicodeText = "Unicode测试：中文 English 日本語 한국어 Русский العربية Español"
    let content = StringContent(unicodeText)
    
    let text = content.readAsString()
    @Expect(text, unicodeText)
}

/**
 * ByteArrayContent构造函数测试
 * 测试ByteArrayContent的基本构造功能
 */
@Test
func ByteArrayContent构造函数测试() {
    let bytes = Array<Byte>(5) { i => UInt8(i + 1) }
    let content = ByteArrayContent(bytes)
    
    @Expect(content.headers.getFirst("Content-Type"), Some("application/octet-stream"))
    
    // 测试读取字节数组
    let readBytes = content.readAsByteArray()
    @Expect(readBytes.size, 5)
    @Expect(readBytes[0], 1)
    @Expect(readBytes[4], 5)
}

/**
 * ByteArrayContent空数组测试
 * 测试处理空字节数组的ByteArrayContent
 */
@Test
func ByteArrayContent空数组测试() {
    let bytes = Array<Byte>(0) { _ => UInt8(0) }
    let content = ByteArrayContent(bytes)
    
    let readBytes = content.readAsByteArray()
    @Expect(readBytes.size, 0)
}

/**
 * ByteArrayContent大数据测试
 * 测试处理大量字节数据的ByteArrayContent
 */
@Test
func ByteArrayContent大数据测试() {
    let bytes = Array<Byte>(1000) { i => UInt8(i % 256) }
    let content = ByteArrayContent(bytes)
    
    let readBytes = content.readAsByteArray()
    @Expect(readBytes.size, 1000)
    
    // 验证数据完整性
    for (i in 0..1000) {
        @Expect(readBytes[i], (i % 256) as Byte)
    }
}

/**
 * StreamContent构造函数测试
 * 测试StreamContent的基本构造功能
 */
@Test
func StreamContent构造函数测试() {
    let testData = "Stream test data"
    let stringContent = StringContent(testData)
    let stream = stringContent.readAsStream()
    let content = StreamContent(stream)
    
    @Expect(content.headers.getFirst("Content-Type"), Some("application/octet-stream"))
    
    // 测试读取为字符串
    let text = content.readAsString()
    @Expect(text, testData)
}

/**
 * StreamContent指定媒体类型测试
 * 测试指定媒体类型的StreamContent构造
 */
@Test
func StreamContent指定媒体类型测试() {
    let testData = "{\"key\":\"value\"}"
    let stringContent = StringContent(testData)
    let stream = stringContent.readAsStream()
    let content = StreamContent(stream)
    
    // 手动设置Content-Type头部，因为StreamContent构造函数只接受stream参数
    content.headers.set("Content-Type", "application/json")
    @Expect(content.headers.getFirst("Content-Type"), Some("application/json"))
    
    let text = content.readAsString()
    @Expect(text, testData)
}

/**
 * FormUrlContent构造函数测试
 * 测试FormUrlContent的基本构造功能
 */
@Test
func FormUrlContent构造函数测试() {
    let formData = [("name", "John"), ("age", "30"), ("city", "New York")]
    let content = FormUrlContent(formData)
    
    @Expect(content.headers.getFirst("Content-Type"), Some("application/x-www-form-urlencoded"))
    
    // 测试读取编码后的表单数据
    let text = content.readAsString()
    @Expect(text.contains("name=John"))
    @Expect(text.contains("age=30"))
    @Expect(text.contains("city=New+York"))
}

/**
 * FormUrlContent空数据测试
 * 测试处理空表单数据的FormUrlContent
 */
@Test
func FormUrlContent空数据测试() {
    let formData = Array<(String, String)>(0) { _ => ("", "") }
    let content = FormUrlContent(formData)
    
    let text = content.readAsString()
    @Expect(text, "")
}

/**
 * FormUrlContent特殊字符测试
 * 测试包含特殊字符的表单数据编码
 */
@Test
func FormUrlContent特殊字符测试() {
    let formData = [("query", "搜索测试"), ("symbols", "!@#$%^&*()")]
    let content = FormUrlContent(formData)
    
    let text = content.readAsString()
    // 特殊字符应该被URL编码
    @Expect(text.contains("query="))
    @Expect(text.contains("symbols="))
}

/**
 * FormUrlContent多值测试
 * 测试表单数据中的多值处理
 */
@Test
func FormUrlContent多值测试() {
    let formData = [
        ("color", "red"),
        ("color", "green"),
        ("color", "blue"),
        ("size", "large")
    ]
    let content = FormUrlContent(formData)
    
    let text = content.readAsString()
    @Expect(text.contains("color=red"))
    @Expect(text.contains("color=green"))
    @Expect(text.contains("color=blue"))
    @Expect(text.contains("size=large"))
}

/**
 * MultipartFormDataContent默认构造函数测试
 * 测试MultipartFormDataContent的默认构造功能
 */
@Test
func MultipartFormDataContent默认构造函数测试() {
    let content = MultipartFormDataContent()
    
    // 验证Content-Type头部包含multipart/form-data和boundary
    let contentType = content.headers.getFirst("Content-Type")
    // 对象创建一定会成功，直接验证内容
    @Expect(contentType.flatMap { v => Some(v.contains("multipart/form-data")) }, Some(true))
    @Expect(contentType.flatMap { v => Some(v.contains("boundary=")) }, Some(true))
}

/**
 * MultipartFormDataContent自定义边界测试
 * 测试使用自定义边界的MultipartFormDataContent
 */
@Test
func MultipartFormDataContent自定义边界测试() {
    let content = MultipartFormDataContent("custom_boundary_123")
    
    let contentType = content.headers.getFirst("Content-Type")
    // 对象创建一定会成功，直接验证内容
    @Expect(contentType.flatMap { v => Some(v.contains("boundary=custom_boundary_123")) }, Some(true))
}

/**
 * MultipartFormDataContent添加内容测试
 * 测试向多部分表单添加各种内容
 */
@Test
func MultipartFormDataContent添加内容测试() {
    let content = MultipartFormDataContent()
    
    // 添加文本内容
    let textContent = StringContent("John Doe")
    content.add(textContent, "name")
    
    // 添加带文件名的内容
    let fileContent = ByteArrayContent(Array<Byte>(5) { i => UInt8(i + 1) })
    content.add(fileContent, "avatar", "profile.jpg")
    
    // 验证内容被正确添加
    let text = content.readAsString()
    @Expect(text.contains("name=\"name\""))
    @Expect(text.contains("John Doe"))
    @Expect(text.contains("name=\"avatar\""))
    @Expect(text.contains("filename=\"profile.jpg\""))
}

/**
 * MultipartFormDataContent复杂结构测试
 * 测试复杂的多部分表单数据结构
 */
@Test
func MultipartFormDataContent复杂结构测试() {
    let content = MultipartFormDataContent()
    
    // 添加多个字段
    content.add(StringContent("user123"), "username")
    content.add(StringContent("user@example.com"), "email")
    content.add(StringContent("true"), "newsletter")
    
    // 添加文件
    let pdfContent = StringContent("%PDF-1.4...", "application/pdf")
    content.add(pdfContent, "document", "report.pdf")
    
    let text = content.readAsString()
    @Expect(text.contains("name=\"username\""))
    @Expect(text.contains("user123"))
    @Expect(text.contains("name=\"email\""))
    @Expect(text.contains("user@example.com"))
    @Expect(text.contains("name=\"document\""))
    @Expect(text.contains("filename=\"report.pdf\""))
}