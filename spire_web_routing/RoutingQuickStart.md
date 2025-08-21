# Spire 路由匹配模块 · 快速开始

Spire 路由系统为 Web 应用提供灵活、高效的 URL 匹配与分发能力。通过简洁的 API，开发者可轻松实现请求路由、参数绑定与中间件集成。

## 基本概念

- **Endpoint**：终结点，表示可被路由到的处理单元（如控制器方法、处理函数等）。
- **RoutePattern**：路由模式，定义 URL 匹配规则。
- **EndpointDataSource**：终结点数据源，管理所有可用 Endpoint。
- **Matcher**：路由匹配器，根据请求查找匹配的 Endpoint。

## 快速上手五步法

```cangjie
import spire_web_routing.*

class HelloHandler {
    public func invoke(context) {
        context.response.write("Hello, Spire Routing!")
    }
}

// 1. 创建路由构建器
let routeBuilder = EndpointRouteBuilder()

// 2. 添加路由
routeBuilder.mapGet("/hello", HelloHandler())

// 3. 构建 Endpoint 数据源
let dataSource = routeBuilder.build()

// 4. 创建路由匹配器
let matcher = Matcher(dataSource)

// 5. 在请求处理中进行路由匹配
func handleRequest(context) {
    let endpoint = matcher.match(context.request)
    if endpoint != null {
        endpoint.invoke(context)
    } else {
        context.response.statusCode = 404
        context.response.write("Not Found")
    }
}
```

## 常用 API 说明

- `EndpointRouteBuilder.mapGet(path, handler)`  
  注册 GET 路由及其处理器。
- `EndpointRouteBuilder.build()`  
  构建 Endpoint 数据源。
- `Matcher.match(request)`  
  根据请求查找匹配的 Endpoint。

## 路由参数与模式

支持带参数的路由：

```cangjie
routeBuilder.mapGet("/user/{id}", UserHandler())
```

在 Handler 中通过 `context.routeValues` 获取参数：

```cangjie
class UserHandler {
    public func invoke(context) {
        let userId = context.routeValues["id"]
        context.response.write("User ID: " + userId)
    }
}
```

## 中间件支持

可通过中间件扩展路由处理流程：

```cangjie
routeBuilder.use(SomeMiddleware())
routeBuilder.mapGet("/hello", HelloHandler())
```

## 进阶用法

- 支持多种 HTTP 方法（GET、POST、PUT、DELETE 等）
- 支持自定义路由约束与优先级
- 可扩展 Endpoint、Matcher 等核心组件


## 最佳实践

- 路由注册建议集中在应用启动阶段完成
- 合理拆分 Handler，保持单一职责
- 使用中间件处理通用逻辑（如认证、日志）