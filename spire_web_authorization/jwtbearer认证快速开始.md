# Spire JWT Bearer 认证快速开始

本指南帮助你在 Spire Web 项目中快速集成 JWT Bearer 认证，实现基于 JWT 的 API 安全访问。

---

## 1. 环境准备

- 已完成 Spire Web 项目初始化
- 已在 `cjpm.toml` 添加如下依赖：

```bash
[dependencies]
  spire_web_http = { path = "/spire_web_http"}
  spire_web_hosting = { path = "/spire_web_hosting"}
  spire_web_authentication = { path = "/spire_web_authentication"}
  spire_web_authentication_jwtbearer = { path = "/spire_web_authentication_jwtbearer"}
  spire_extensions_injection = { path = "/spire_extensions_injection"}
```

---

## 2. 快速集成 JWT Bearer 认证

### 步骤一：注册 JWT Bearer 认证服务

```cangjie
let builder = WebHost.createBuilder()
builder.services.addAuthentication().addJwtBearer("jwt", options => {
    options.authority = "https://your-auth-server.com" // JWT 签发方（可选）
    options.audience = "your-api-audience"            // 受众
    options.requireHttpsMetadata = true                // 生产环境建议开启
    options.tokenValidationParameters = {
        validateIssuer: true,
        validateAudience: true,
        validateLifetime: true,
        validateIssuerSigningKey: true
    }
    // 其他参数可按需配置
})
```

### 步骤二：启用认证中间件

```cangjie
let host = builder.build()
host.useAuthentication()
```

### 步骤三：注册受保护的路由

```cangjie
host.useEndpoints { endpoints =>
    endpoints.mapGet("secure", context => {
        // 只有携带有效JWT的用户可访问
        context.response.write("secure api")
    })
}
```

---

## 3. JWT 配置参数说明

- `authority`：JWT 签发方地址（如 Auth0、IdentityServer、Keycloak 等）
- `audience`：API 受众标识
- `requireHttpsMetadata`：是否强制 HTTPS
- `tokenValidationParameters`：令牌校验参数

---

## 4. 最佳实践

- 生产环境务必启用 HTTPS
- JWT 密钥和配置建议放在安全的配置文件中
- 可结合授权中间件实现细粒度权限控制
- JWT 过期时间不宜过长，提升安全性

---

通过本快速开始，你可以在 Spire Web 项目中高效集成 JWT Bearer 认证。如需更复杂的认证场景，请参考官方文档和高级示例。
