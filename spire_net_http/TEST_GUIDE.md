# SpireNetHTTP 测试指南

## 测试环境准备

### 1. 启动测试服务器

首先需要启动 .NET 测试 API 服务器：

```bash
# 进入测试服务器目录
cd web_api_for_test

# 启动服务器（默认端口5010）
dotnet run
```

服务器启动后会显示：
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5010
```

### 2. 验证服务器正常运行

在浏览器或使用 curl 测试：
```bash
curl http://127.0.0.1:5010/health
# 应该返回：{"status":"healthy","timestamp":"..."}
```

## 运行测试

### 1. 编译项目
```bash
# 在项目根目录执行
cjpm build
```

### 2. 运行单元测试
```bash
# 运行所有测试
cjpm test

# 或者运行特定测试包
cjpm test spire_net_http.unittests.basic
cjpm test spire_net_http.unittests.integration
cjpm test spire_net_http.unittests.content
```

## 测试配置

所有测试配置都统一在 `src/unittests/TestHelper.cj` 中：

```cj
// 服务器配置
public static let TEST_SERVER_HOST = "127.0.0.1"
public static let TEST_SERVER_PORT = 5010
public static let TEST_SERVER_BASE_URL = "http://127.0.0.1:5010"

// 常用端点
public static let ENDPOINT_OK = "http://127.0.0.1:5010/ok"
public static let ENDPOINT_CONTENT_JSON = "http://127.0.0.1:5010/content/json"
// ... 等等
```

如需修改测试服务器地址或端口，只需修改 `TestHelper.cj` 中的配置即可。

## 测试端点说明

测试服务器提供以下端点：

### 基础端点
- `GET /health` - 健康检查
- `GET /ok` - 返回 200 状态码
- `GET /created` - 返回 201 状态码
- `GET /nocontent` - 返回 204 状态码

### 状态码测试
- `GET /status/{code}` - 返回指定状态码

### 头部测试
- `GET /headers` - 返回带自定义头部的响应
- `POST /echo/headers` - 回显请求头部

### 内容类型测试
- `POST /content/json` - 接受并验证 JSON 内容
- `POST /content/xml` - 接受并验证 XML 内容
- `POST /content/form` - 接受并验证表单数据
- `POST /content/multipart` - 接受并验证多部分表单数据

### 延迟测试
- `GET /delay/{ms}` - 延迟指定毫秒后响应

## 测试用例分类

### 1. 基础功能测试 (`basic/`)
- `HttpClientOptionsBasic.cj` - HttpClient 配置测试
- `HttpMethodBasic.cj` - HTTP 方法测试

### 2. 客户端测试 (`client/`)
- `HttpClientBasic.cj` - HttpClient 功能测试

### 3. 内容测试 (`content/`)
- `HttpContentBasic.cj` - HTTP 内容类型测试

### 4. 异常测试 (`exception/`)
- `HttpExceptionTest.cj` - HTTP 异常处理测试

### 5. 头部测试 (`headers/`)
- `HttpHeadersBasic.cj` - HTTP 头部测试

### 6. 消息测试 (`message/`)
- `HttpMessageBasic.cj` - HTTP 消息测试

### 7. 集成测试 (`integration/`)
- `HttpIntegrationTest.cj` - 端到端集成测试（需要测试服务器）

## 故障排除

### 1. 连接失败
- 确保测试服务器已启动
- 检查端口 5010 是否被占用
- 验证防火墙设置

### 2. 编译错误
- 确保所有依赖已正确安装
- 检查 `cjpm.toml` 配置

### 3. 测试超时
- 检查网络连接
- 调整 `TestHelper.createClient()` 中的超时设置

## 持续集成

在 CI/CD 环境中：

1. 启动测试服务器
2. 等待服务器就绪
3. 运行测试
4. 清理资源

示例脚本：
```bash
#!/bin/bash
# 启动测试服务器
cd web_api_for_test
dotnet run &
SERVER_PID=$!

# 等待服务器启动
sleep 5

# 运行测试
cd ..
cjpm test

# 清理
kill $SERVER_PID
```
