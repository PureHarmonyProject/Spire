# Aspire

## 许可证
MIT License

## 项目愿景

我们致力于将 Cangjie 与 ASP.NET Core 深度整合，打造新一代开发框架：

✨ **核心特性**：
- **现代化架构**：基于最新 .NET 技术栈
- **轻量化设计**：低侵入、零冗余依赖
- **模块化扩展**：功能按需组合
- **快速集成**：通过 gitcode 配置即可接入
- **微服务友好**：完善的微服务生态支持
- **AI 融合**：持续探索 AI 技术集成方案

## 加入我们
诚邀开发者共同构建：
- 🧩 标准化组件库
- 🔗 统一技术生态
- 🌐 开源协作平台

## 快速开始
[入门指南](https://gitcode.com/soulsoft/aspire/tree/main/aspire_web_quickstart)

## 功能模块

| 模块分类          | 模块名称                                | 必要性   | 功能描述                     |
|-------------------|---------------------------------------|----------|----------------------------|
| **Web 核心**      | aspire_web_http                       | 必需     | HTTP 核心接口               |
|                   | aspire_web_routing                    | 必需     | 路由与终结点管理            |
|                   | aspire_web_hosting                    | 必需     | Web 主机服务                |
| **Web 扩展**      | aspire_web_mvc                        | 可选     | MVC 功能支持                |
|                   | aspire_web_staticfiles                | 可选     | 静态文件中间件              |
| **安全认证**      | aspire_web_authorization              | 可选     | 授权中间件                  |
|                   | aspire_web_authentication             | 可选     | 基础认证中间件              |
|                   | aspire_web_authentication_jwtbearer   | 可选     | JWT 认证方案                |
| **基础设施**      | aspire_extensions_options             | 必需     | 配置选项管理                |
|                   | aspire_extensions_configuration       | 可选     | 统一配置系统                |
|                   | aspire_extensions_hosting             | 可选     | 通用主机服务                |
| **运维支持**      | aspire_web_healthchecks               | 可选     | 健康检查中间件              |
|                   | aspire_extensions_healthchecks        | 可选     | 健康检查服务                |
|                   | aspire_extensions_logging             | 可选     | 日志系统                    |
| **身份管理**      | aspire_identity_server                | 可选     | OAuth2.0/OIDC 认证服务      |
|                   | aspire_identity_tokens_jwt            | 可选     | JWT 令牌支持                |
|                   | aspire_identity_protocols_oidc        | 可选     | OpenID Connect 协议实现     |