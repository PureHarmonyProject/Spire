# Spire Net HTTP 学习文档

## 概述

Spire Net HTTP 是一个基于 Cangjie 语言的 HTTP 客户端库，提供了简洁而强大的 HTTP 请求功能。该库采用了中间件架构，支持多种内容类型，并提供了类型安全的 API。

## 推荐学习顺序

### 第一阶段：基础概念
1. **HttpMethod** - HTTP 方法枚举
2. **HttpRequestException** - 异常处理
3. **HttpClientOptions** - 配置选项

### 第二阶段：核心组件
4. **HttpRequestMessage** - HTTP 请求消息
5. **HttpResponseMessage** - HTTP 响应消息
6. **HttpMessageHandler** - 消息处理器接口

### 第三阶段：内容系统
7. **HttpContent** - HTTP 内容基类
8. **StringContent** - 字符串内容
9. **ByteArrayContent** - 字节数组内容
10. **StreamContent** - 流内容
11. **FormUrlContent** - 表单编码内容
12. **MultipartFormDataContent** - 多部分表单数据

### 第四阶段：头部管理
13. **HttpRequestHeaders** - 请求头部
14. **HttpResponseHeaders** - 响应头部
15. **HttpContentHeaders** - 内容头部

### 第五阶段：高级功能
16. **DelegatingHandler** - 委托处理器
17. **IHttpClientFactory** - 客户端工厂
18. **HttpClient** - 主要的 HTTP 客户端

---

## 详细类说明

### 1. HttpMethod

**文件位置**: `src/HttpMethod.cj`

**作用**: 表示 HTTP 方法（GET、POST、PUT、DELETE 等）

**主要特性**:
- 提供所有标准 HTTP 方法的静态实例
- 类型安全的 HTTP 方法表示

**使用示例**:
```cj
// 使用静态实例
let method = HttpMethod.get

// 在请求中使用
let request = HttpRequestMessage {
    method = HttpMethod.post,
    requestUri = URL.parse("https://api.example.com/data")
}
```

**API 方法**:
- `get`: GET 方法
- `post`: POST 方法
- `put`: PUT 方法
- `delete`: DELETE 方法
- `patch`: PATCH 方法
- `head`: HEAD 方法
- `options`: OPTIONS 方法
- `trace`: TRACE 方法
- `connect`: CONNECT 方法

### 2. HttpRequestException

**文件位置**: `src/HttpRequestException.cj`

**作用**: HTTP 请求异常类，用于处理 HTTP 相关错误

**主要特性**:
- 包含 HTTP 状态码信息
- 提供详细的错误信息

**使用示例**:
```cj
try {
    let response = client.get("https://api.example.com/data")
    response.ensureSuccessStatusCode()
} catch (e: HttpRequestException) {
    println("HTTP 请求失败: ${e.message}")
    println("状态码: ${e.statusCode}")
}
```

### 3. HttpClientOptions

**文件位置**: `src/HttpClientOptions.cj`

**作用**: HttpClient 的配置选项类

**主要特性**:
- 构建器模式的配置
- 支持基础 URL、超时、默认头部等设置

**使用示例**:
```cj
// 基本配置
let options = HttpClientOptions {
    address = URL.parse("https://api.example.com"),
    timeout = Duration.second * 30
}

// 完整配置
let options = HttpClientOptions { opts =>
    opts.address = URL.parse("https://api.example.com")
    opts.timeout = Duration.minute * 5
    opts.headers.add("Authorization", "Bearer token")
    opts.headers.add("User-Agent", "MyApp/1.0")
}
```

**主要属性**:
- `address: URL?`: 基础 URL 地址
- `timeout: Duration`: 请求超时时间
- `headers: HttpRequestHeaders`: 默认请求头部
- `handlers: Array<HttpMessageHandler>`: 中间件处理器链

### 4. HttpRequestMessage

**文件位置**: `src/HttpRequestMessage.cj`

**作用**: 表示 HTTP 请求消息

**主要特性**:
- 封装 HTTP 请求的所有组件
- 支持属性字典存储额外信息

**使用示例**:
```cj
// 基本请求
let request = HttpRequestMessage {
    method = HttpMethod.get,
    requestUri = URL.parse("https://api.example.com/data")
}

// 带内容的请求
let request = HttpRequestMessage {
    method = HttpMethod.post,
    requestUri = URL.parse("https://api.example.com/create"),
    content = StringContent("{\"name\":\"John\"}", "application/json")
}

// 设置头部
request.headers.add("Authorization", "Bearer token")
request.headers.add("Accept", "application/json")

// 添加属性
request.properties["traceId"] = "12345"
```

**主要属性**:
- `method: HttpMethod`: HTTP 方法
- `requestUri: URL`: 请求 URL
- `headers: HttpRequestHeaders`: 请求头部
- `content: HttpContent?`: 请求内容
- `properties: Map<String, Any>`: 属性字典

### 5. HttpResponseMessage

**文件位置**: `src/HttpResponseMessage.cj`

**作用**: 表示 HTTP 响应消息

**主要特性**:
- 封装 HTTP 响应的所有组件
- 提供状态码验证方法

**使用示例**:
```cj
// 检查响应状态
if (response.isSuccessStatusCode) {
    println("请求成功")
} else {
    println("请求失败，状态码: ${response.status}")
}

// 确保成功状态
response.ensureSuccessStatusCode() // 失败时抛出异常

// 读取响应内容
let content = response.content.readAsString()
let bytes = response.content.readAsByteArray()
let stream = response.content.readAsStream()
```

**主要属性**:
- `status: Int`: HTTP 状态码
- `headers: HttpResponseHeaders`: 响应头部
- `content: HttpContent`: 响应内容
- `request: HttpRequestMessage`: 原始请求
- `isSuccessStatusCode: Bool`: 是否为成功状态码 (2xx)

**主要方法**:
- `ensureSuccessStatusCode()`: 确保响应状态码为 2xx，否则抛出异常

### 6. HttpMessageHandler

**文件位置**: `src/HttpMessageHandler.cj`

**作用**: HTTP 消息处理器接口，定义中间件契约

**主要特性**:
- 定义中间件处理模式
- 支持请求/响应处理管道

**使用示例**:
```cj
// 自定义处理器
class LoggingHandler : HttpMessageHandler {
    func send(request: HttpRequestMessage, next: DelegatingHandler) -> HttpResponseMessage {
        println("发送请求: ${request.method} ${request.requestUri}")
        let response = next(request)
        println("收到响应: ${response.status}")
        return response
    }
}
```

### 7. HttpContent

**文件位置**: `src/HttpContent.cj`

**作用**: HTTP 内容的抽象基类

**主要特性**:
- 提供统一的内容接口
- 内置类型转换方法

**使用示例**:
```cj
// 读取内容
let text = content.readAsString()
let bytes = content.readAsByteArray()
let stream = content.readAsStream()

// 访问内容头部
let contentType = content.headers.contentType
let contentLength = content.headers.contentLength
```

**主要方法**:
- `readAsString()`: 读取为字符串
- `readAsByteArray()`: 读取为字节数组
- `readAsStream()`: 读取为流

### 8. StringContent

**文件位置**: `src/StringContent.cj`

**作用**: 字符串类型的 HTTP 内容

**主要特性**:
- 支持自定义媒体类型和编码
- 自动设置 Content-Type 头部

**使用示例**:
```cj
// 简单文本
let content1 = StringContent("Hello World")

// JSON 内容
let content2 = StringContent("{\"name\":\"John\"}", "application/json")

// 自定义媒体类型和编码
let content3 = StringContent("data", "text/plain", "utf-8")
```

### 9. ByteArrayContent

**文件位置**: `src/ByteArrayContent.cj`

**作用**: 字节数组类型的 HTTP 内容

**主要特性**:
- 用于二进制数据传输
- 自动设置 Content-Length 头部

**使用示例**:
```cj
// 基本用法
let bytes = [1, 2, 3, 4, 5]
let content = ByteArrayContent(bytes)

// 指定媒体类型
let content = ByteArrayContent(bytes, "application/octet-stream")
```

### 10. StreamContent

**文件位置**: `src/StreamContent.cj`

**作用**: 流类型的 HTTP 内容

**主要特性**:
- 支持大文件传输
- 内存高效的流式处理

**使用示例**:
```cj
// 文件流
let fileStream = File.open("data.bin")
let content = StreamContent(fileStream, "application/octet-stream")

// 内存流
let memoryStream = MemoryStream()
let content = StreamContent(memoryStream, "text/plain")
```

### 11. FormUrlContent

**文件位置**: `src/FormUrlContent.cj`

**作用**: 表单编码的 HTTP 内容

**主要特性**:
- 自动 URL 编码
- 适合表单数据提交

**使用示例**:
```cj
// 简单表单
let formData = [("name", "John"), ("age", "30")]
let content = FormUrlContent(formData)

// 复杂表单
let formData = [
    ("username", "john_doe"),
    ("email", "john@example.com"),
    ("password", "secret123")
]
let content = FormUrlContent(formData)
```

### 12. MultipartFormDataContent

**文件位置**: `src/MultipartFormDataContent.cj`

**作用**: 多部分表单数据内容

**主要特性**:
- 支持文件上传
- 自动边界管理
- 混合内容类型支持

**使用示例**:
```cj
// 创建多部分内容
let multipart = MultipartFormDataContent()

// 添加文本字段
multipart.add(StringContent("John Doe"), "name")
multipart.add(StringContent("john@example.com"), "email")

// 添加文件
let fileContent = ByteArrayContent(fileBytes)
multipart.add(fileContent, "avatar", "profile.jpg", "image/jpeg")

// 发送请求
let response = client.post("https://api.example.com/upload", multipart)
```

### 13. HttpRequestHeaders

**文件位置**: `src/HttpRequestHeaders.cj`

**作用**: HTTP 请求头部管理

**主要特性**:
- 类型安全的头部操作
- 支持多值头部

**使用示例**:
```cj
let headers = HttpRequestHeaders()

// 添加头部
headers.add("Authorization", "Bearer token")
headers.add("Accept", "application/json")
headers.add("User-Agent", "MyApp/1.0")

// 设置头部（替换现有值）
headers.set("Content-Type", "application/json")

// 获取头部
let auth = headers.getFirst("Authorization")
let accepts = headers.get("Accept")

// 删除头部
headers.remove("User-Agent")
```

**主要方法**:
- `add(name: String, value: String)`: 添加头部值
- `set(name: String, value: String)`: 设置头部值（替换）
- `remove(name: String)`: 删除头部
- `get(name: String)`: 获取所有头部值
- `getFirst(name: String)`: 获取第一个头部值

### 14. HttpResponseHeaders

**文件位置**: `src/HttpResponseHeaders.cj`

**作用**: HTTP 响应头部管理（只读）

**主要特性**:
- 只读访问响应头部
- 类型安全的头部查询

**使用示例**:
```cj
// 获取响应头部
let contentType = response.headers.getFirst("Content-Type")
let contentLength = response.headers.getFirst("Content-Length")
let server = response.headers.getFirst("Server")

// 检查头部是否存在
if (response.headers.contains("Cache-Control")) {
    let cacheControl = response.headers.getFirst("Cache-Control")
}
```

### 15. HttpContentHeaders

**文件位置**: `src/HttpContentHeaders.cj`

**作用**: HTTP 内容特定头部管理

**主要特性**:
- 管理 Content-Type、Content-Length 等内容头部
- 自动计算内容长度

**使用示例**:
```cj
// 访问内容头部
let contentType = content.headers.contentType
let contentLength = content.headers.contentLength
let contentEncoding = content.headers.contentEncoding

// 设置内容类型
content.headers.contentType = "application/json"
content.headers.contentEncoding = "gzip"
```

### 16. DelegatingHandler

**文件位置**: `src/DelegatingHandler.cj`

**作用**: 委托处理器，表示处理链中的函数类型

**主要特性**:
- 函数式处理器定义
- 支持中间件链构建

**使用示例**:
```cj
// 创建委托处理器
let handler: DelegatingHandler = { request =>
    // 处理请求
    println("Processing: ${request.method} ${request.requestUri}")
    
    // 调用下一个处理器
    let response = nextHandler(request)
    
    // 处理响应
    println("Response status: ${response.status}")
    return response
}
```

### 17. IHttpClientFactory

**文件位置**: `src/IHttpClientFactory.cj`

**作用**: HttpClient 工厂接口

**主要特性**:
- 工厂模式创建客户端
- 支持命名客户端

**使用示例**:
```cj
// 实现工厂
class MyHttpClientFactory : IHttpClientFactory {
    func create(name: String) -> HttpClient {
        match (name) {
            case "api" => {
                return HttpClient({ opts =>
                    opts.address = URL.parse("https://api.example.com")
                    opts.timeout = Duration.second * 30
                })
            }
            case "upload" => {
                return HttpClient({ opts =>
                    opts.address = URL.parse("https://upload.example.com")
                    opts.timeout = Duration.minute * 5
                })
            }
            case _ => {
                return HttpClient()
            }
        }
    }
}

// 使用工厂
let factory = MyHttpClientFactory()
let apiClient = factory.create("api")
let uploadClient = factory.create("upload")
```

### 18. HttpClient

**文件位置**: `src/HttpClient.cj`

**作用**: 主要的 HTTP 客户端类

**主要特性**:
- 简化的 HTTP 操作 API
- 中间件管道支持
- 资源管理

**使用示例**:

#### 基本 HTTP 操作
```cj
// 创建客户端
let client = HttpClient()

// GET 请求
let response = client.get("https://api.example.com/data")
let data = response.content.readAsString()

// POST 请求
let content = StringContent("{\"name\":\"John\"}", "application/json")
let response = client.post("https://api.example.com/users", content)

// PUT 请求
let content = StringContent("{\"name\":\"Jane\"}", "application/json")
let response = client.put("https://api.example.com/users/1", content)

// DELETE 请求
let response = client.delete("https://api.example.com/users/1")
```

#### 便捷方法
```cj
// 直接获取字符串
let data = client.getString("https://api.example.com/data")

// 直接获取字节数组
let bytes = client.getByteArray("https://api.example.com/file.pdf")

// 直接获取流
let stream = client.getStream("https://api.example.com/large-file.zip")
```

#### 自定义配置
```cj
// 带配置的客户端
let client = HttpClient({ opts =>
    opts.address = URL.parse("https://api.example.com")
    opts.timeout = Duration.second * 30
    opts.headers.add("Authorization", "Bearer token")
    opts.headers.add("User-Agent", "MyApp/1.0")
})

// 发送自定义请求
let request = HttpRequestMessage {
    method = HttpMethod.post,
    requestUri = URL.parse("https://api.example.com/create"),
    content = StringContent("{\"name\":\"John\"}", "application/json")
}
let response = client.send(request)
```

#### 中间件使用
```cj
// 添加中间件
let client = HttpClient({ opts =>
    opts.handlers.add(LoggingHandler())
    opts.handlers.add(RetryHandler())
    opts.handlers.add(CacheHandler())
})

// 或者使用构建器模式
let client = HttpClient()
    .addHandler(LoggingHandler())
    .addHandler(RetryHandler())
    .build()
```

**主要方法**:
- `get(url: String)`: GET 请求
- `post(url: String, content: HttpContent?)`: POST 请求
- `put(url: String, content: HttpContent?)`: PUT 请求
- `delete(url: String)`: DELETE 请求
- `getString(url: String)`: GET 请求并返回字符串
- `getByteArray(url: String)`: GET 请求并返回字节数组
- `getStream(url: String)`: GET 请求并返回流
- `send(request: HttpRequestMessage)`: 发送自定义请求
- `close()`: 关闭客户端，释放资源

---

## 实际应用示例

### 1. REST API 客户端

```cj
class ApiClient {
    private let client: HttpClient
    
    public init(baseURL: String, token: String) {
        self.client = HttpClient({ opts =>
            opts.address = URL.parse(baseURL)
            opts.timeout = Duration.second * 30
            opts.headers.add("Authorization", "Bearer ${token}")
            opts.headers.add("Accept", "application/json")
        })
    }
    
    public func getUsers() -> Array<User> {
        let response = client.get("/users")
        response.ensureSuccessStatusCode()
        let json = response.content.readAsString()
        return JSON.parse(json).asArray()
    }
    
    public func createUser(user: User) -> User {
        let content = StringContent(JSON.stringify(user), "application/json")
        let response = client.post("/users", content)
        response.ensureSuccessStatusCode()
        let json = response.content.readAsString()
        return JSON.parse(json).asObject()
    }
    
    public func updateUser(id: String, user: User) -> User {
        let content = StringContent(JSON.stringify(user), "application/json")
        let response = client.put("/users/${id}", content)
        response.ensureSuccessStatusCode()
        let json = response.content.readAsString()
        return JSON.parse(json).asObject()
    }
    
    public func deleteUser(id: String) -> Void {
        let response = client.delete("/users/${id}")
        response.ensureSuccessStatusCode()
    }
}
```

### 2. 文件上传客户端

```cj
class FileUploader {
    private let client: HttpClient
    
    public init(uploadURL: String) {
        self.client = HttpClient({ opts =>
            opts.address = URL.parse(uploadURL)
            opts.timeout = Duration.minute * 10
        })
    }
    
    public func uploadFile(filePath: String, fieldName: String) -> String {
        // 读取文件
        let fileBytes = File.readAllBytes(filePath)
        let fileName = Path.getFileName(filePath)
        let contentType = getContentType(fileName)
        
        // 创建多部分内容
        let multipart = MultipartFormDataContent()
        multipart.add(ByteArrayContent(fileBytes, contentType), fieldName, fileName)
        
        // 发送请求
        let response = client.post("/upload", multipart)
        response.ensureSuccessStatusCode()
        
        // 返回上传结果
        let result = response.content.readAsString()
        return JSON.parse(result).get("url").asString()
    }
    
    private func getContentType(fileName: String) -> String {
        let extension = Path.getExtension(fileName).toLowerCase()
        match (extension) {
            case ".jpg" | ".jpeg" => "image/jpeg"
            case ".png" => "image/png"
            case ".pdf" => "application/pdf"
            case ".txt" => "text/plain"
            case _ => "application/octet-stream"
        }
    }
}
```

### 3. 带缓存的 HTTP 客户端

```cj
class CacheHandler : HttpMessageHandler {
    private let cache: Map<String, HttpResponseMessage> = Map()
    
    public func send(request: HttpRequestMessage, next: DelegatingHandler) -> HttpResponseMessage {
        // 生成缓存键
        let cacheKey = "${request.method}:${request.requestUri}"
        
        // 检查缓存
        if (cache.contains(cacheKey)) {
            return cache[cacheKey]
        }
        
        // 发送请求
        let response = next(request)
        
        // 缓存 GET 请求的响应
        if (request.method == HttpMethod.get && response.isSuccessStatusCode) {
            cache[cacheKey] = response
        }
        
        return response
    }
}

// 使用缓存客户端
let client = HttpClient({ opts =>
    opts.handlers.add(CacheHandler())
    opts.handlers.add(LoggingHandler())
})
```

### 4. 带重试机制的 HTTP 客户端

```cj
class RetryHandler : HttpMessageHandler {
    private let maxRetries: Int
    private let retryDelay: Duration
    
    public init(maxRetries: Int = 3, retryDelay: Duration = Duration.second) {
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
    }
    
    public func send(request: HttpRequestMessage, next: DelegatingHandler) -> HttpResponseMessage {
        for (i in 0..maxRetries) {
            try {
                let response = next(request)
                if (response.isSuccessStatusCode) {
                    return response
                }
                
                // 如果是服务器错误，则重试
                if (response.status >= 500 && response.status < 600) {
                    if (i < maxRetries - 1) {
                        Thread.sleep(retryDelay)
                        continue
                    }
                }
                
                return response
            } catch (e: Exception) {
                if (i < maxRetries - 1) {
                    Thread.sleep(retryDelay)
                    continue
                }
                throw e
            }
        }
        
        throw HttpRequestException("重试次数已用完")
    }
}

// 使用重试客户端
let client = HttpClient({ opts =>
    opts.handlers.add(RetryHandler(5, Duration.second * 2))
    opts.timeout = Duration.second * 10
})
```

## 最佳实践

### 1. 资源管理
```cj
// 使用 using 语句确保资源释放
using (let client = HttpClient()) {
    let response = client.get("https://api.example.com/data")
    return response.content.readAsString()
}

// 或者手动关闭
let client = HttpClient()
try {
    let response = client.get("https://api.example.com/data")
    return response.content.readAsString()
} finally {
    client.close()
}
```

### 2. 错误处理
```cj
try {
    let response = client.get("https://api.example.com/data")
    response.ensureSuccessStatusCode()
    return response.content.readAsString()
} catch (e: HttpRequestException) {
    println("HTTP 错误: ${e.message}")
    println("状态码: ${e.statusCode}")
    throw e
} catch (e: Exception) {
    println("网络错误: ${e.message}")
    throw e
}
```

### 3. 配置管理
```cj
// 使用配置文件
class HttpClientConfig {
    public static func createClient(configName: String) -> HttpClient {
        let config = loadConfig(configName)
        return HttpClient({ opts =>
            opts.address = URL.parse(config.baseURL)
            opts.timeout = Duration.second * config.timeout
            opts.headers.add("User-Agent", config.userAgent)
            
            if (config.authToken != null) {
                opts.headers.add("Authorization", "Bearer ${config.authToken}")
            }
        })
    }
}
```

### 4. 性能优化
```cj
// 重用 HttpClient 实例
class HttpClientPool {
    private let clients: Map<String, HttpClient> = Map()
    
    public func getClient(name: String) -> HttpClient {
        if (!clients.contains(name)) {
            clients[name] = createClient(name)
        }
        return clients[name]
    }
    
    private func createClient(name: String) -> HttpClient {
        return HttpClient({ opts =>
            opts.address = URL.parse(getBaseURL(name))
            opts.timeout = Duration.second * 30
        })
    }
}
```

## 总结

Spire Net HTTP 提供了一个功能完整、设计良好的 HTTP 客户端库。通过本学习文档，您应该能够：

1. 理解库的整体架构和设计模式
2. 掌握各个组件的使用方法
3. 构建复杂的 HTTP 客户端应用
4. 实现自定义中间件和内容类型
5. 遵循最佳实践进行开发

建议按照推荐的学习顺序逐步学习，并在实际项目中应用这些概念。