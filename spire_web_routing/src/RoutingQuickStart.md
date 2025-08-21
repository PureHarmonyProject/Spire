# Spire 路由系统快速入门

Spire 路由系统负责将传入的 HTTP 请求匹配到应用中定义的终结点（Endpoint），并将请求分发给相应的处理逻辑。通过灵活的 API，开发者可高效配置 URL 匹配、参数绑定和中间件集成。

---

## 路由基础

以下代码演示了最基础的路由注册与处理流程：

```cangjie
import spire_web_routing.*
import spire_web_http.*
import spire_extensions_dependencyinjection.*

// 创建服务容器并注册路由服务
yet services = ServiceCollection()
services.addRouting()
let serviceProvider = services.buildServiceProvider()

// 使用服务提供器初始化路由构建器
let builder = EndpointRouteBuilder(serviceProvider)
builder.mapGet("/", context => {
    context.response.write("Hello, Spire!")
})

let dataSource = builder.build()
// 使用DfaMatcher而非Matcher
let matcher = DfaMatcher(dataSource)

func handleRequest(context: HttpContext) {
    let routeValues = RouteValues()
    let result = matcher.invoke(context)
    if result == RouteFlags.Ok {
        if let Some(endpoint) = context.getEndpoint() {
            endpoint.delegate(context)
        }
    } else if result == RouteFlags.MethodNotAllowed {
        context.response.statusCode = 405
        context.response.write("Method Not Allowed")
    } else {
        context.response.statusCode = 404
        context.response.write("Not Found")
    }
}
```

- 当 HTTP GET 请求发送到根路径 `/` 时，返回 `Hello, Spire!`。
- 其他路径或方法未匹配时，返回 404。

---

## 终结点（Endpoint）

终结点是应用中可执行的请求处理单元。可通过 `mapGet`、`mapPost` 等方法注册不同类型的终结点。

```cangjie
builder.mapGet("/about", AboutHandler())

class AboutHandler {
    public func invoke(context: HttpContext): Unit {
        context.response.write("About Page")
    }
}
```

---

## 路由模板与参数

Spire 路由支持参数化模板，可自动提取 URL 中的变量：

```cangjie
builder.mapGet("/user/{id}", context => {
    let userId = context.request.routeValues["id"]
    context.response.write("User ID: " + userId)
})
```

- 路由模板 `/user/{id}` 匹配如 `/user/123`，并将 `id` 绑定到 `routeValues`。

---

## 中间件集成

可通过 `use` 方法为路由添加中间件，实现认证、日志等通用功能：

```cangjie
// 使用ApplicationBuilder注册中间件
let app = ApplicationBuilder(serviceProvider).build()
app.use(AuthMiddleware())
app.useRouting()
app.useEndpoints(builder => {
    builder.mapGet("/secure", SecureHandler())
})
```

- 中间件会在终结点处理前依次执行。

---

## 常见用法

- 支持多种 HTTP 方法：

```cangjie
builder.mapPost("/submit", SubmitHandler())
builder.mapDelete("/item/{id}", DeleteHandler())
```

- 获取所有路由参数：

```cangjie
let params = context.routeValues
```

- 构建后可多次复用 matcher 进行请求分发。

---

## 推荐实践

- 路由注册建议集中在应用启动阶段完成。
- Handler 逻辑应保持单一职责，便于维护与测试。
- 使用中间件处理通用横切关注点（如认证、日志、异常处理）。
- 路由模板应简洁明了，避免歧义。

---

通过以上步骤，您可在 Spire 项目中快速集成高效、灵活的路由系统。如需更多高级用法，请查阅完整开发文档或源码注释。