# Spire OIDC 认证快速开始

本指南帮助你在 Spire Web 项目中快速集成 OIDC（OpenID Connect）认证，实现与主流身份提供商（如 Authing、Auth0、Azure AD、企业微信等）的单点登录。

---

## 1. 环境准备

- 已完成 Spire Web 项目初始化
- 已在 `cjpm.toml` 添加如下依赖：

```bash
[dependencies]
  spire_web_http = { path = "/spire_web_http"}
  spire_web_hosting = { path = "/spire_web_hosting"}
  spire_web_authentication = { path = "/spire_web_authentication"}
  spire_web_authentication_oidc = { path = "/spire_web_authentication_oidc"}
  spire_extensions_injection = { path = "/spire_extensions_injection"}
```

---

## 2. 快速集成 OIDC 认证

### 步骤一：注册 OIDC 认证服务

```cangjie
let builder = WebHost.createBuilder()
builder.services.addAuthentication().addOpenIdConnect("oidc", options => {
    options.authority = "https://your-oidc-provider.com" // OIDC 服务端地址
    options.clientId = "your-client-id"
    options.clientSecret = "your-client-secret"
    options.responseType = "code"
    options.saveTokens = true
    options.scope.add("openid")
    options.scope.add("profile")
    // 其他OIDC参数可按需配置
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
    endpoints.mapGet("profile", context => {
        // 只有登录用户可访问
        context.response.write("user profile")
    })
}
```

---

## 3. 典型 OIDC 配置参数说明

- `authority`：OIDC 服务端地址（如 Auth0、Authing、Azure AD 等）
- `clientId`/`clientSecret`：应用在 OIDC 平台的注册信息
- `responseType`：推荐使用 `code`（授权码模式）
- `scope`：建议包含 `openid`、`profile` 等
- `saveTokens`：是否保存 access_token/refresh_token

---

## 4. 最佳实践

- 生产环境务必启用 HTTPS
- OIDC 配置建议放在安全的配置文件中
- 可结合授权中间件实现细粒度权限控制
- 登录回调地址需在 OIDC 平台正确配置

---

通过本快速开始，你可以在 Spire Web 项目中高效集成 OIDC 单点登录。如需更复杂的认证场景，请参考官方文档和高级示例。
