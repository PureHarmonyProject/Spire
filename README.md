# Aspire 天擎

一个基于仓颉开发的现代化 Web 框架，轻量，高性能，可扩展，跟仓颉官方团队共同研发

以 **仓颉语言** 为核心，打造新一代开发框架：

✨ **核心特性**：

- **轻量化设计**：低侵入、可配置
- **模块化扩展**：功能按需组合
- **快速集成**：通过 gitcode 配置即可接入
- **微服务友好**：持续提供微服务相关组件
- **AI 融合**：持续探索 AI 技术集成方案

## 加入我们

诚邀开发者共同构建：

- 🧩 标准化组件库
- 🔗 统一技术生态
- 🌐 开源协作平台

> 官方交流 QQ 群 `307564339`

## 快速开始

[入门指南](https://gitcode.com/soulsoft/aspire/tree/main/aspire_web_quickstart)

## 功能模块

| 模块分类       | 模块名称                            | 必要性 | 功能描述                |
| -------------- | ----------------------------------- | ------ | ----------------------- |
| **Web 核心**   | aspire_web_http                     | 必需   | HTTP 核心接口           |
|                | aspire_web_routing                  | 必需   | 路由与终结点管理        |
|                | aspire_web_hosting                  | 必需   | Web 主机服务            |
| **Web 中间件** | aspire_web_mvc                      | 可选   | MVC 功能支持            |
|                | aspire_web_staticfiles              | 可选   | 静态文件中间件          |
|                | aspire_web_healthchecks             | 可选   | 健康检查中间件          |
| **身份认证**   | aspire_web_authorization            | 可选   | 授权中间件              |
|                | aspire_web_authentication           | 可选   | 基础认证中间件          |
|                | aspire_web_authentication_jwtbearer | 可选   | JWT 认证方案            |
| **基础设施**   | aspire_extensions_options           | 必需   | 配置选项管理            |
|                | aspire_extensions_injection         | 必需   | 依赖注入                |
|                | aspire_extensions_hosting           | 可选   | 通用主机服务            |
|                | aspire_extensions_caching           | 可选   | 分布式内存缓存          |
|                | aspire_extensions_healthchecks      | 可选   | 健康检查服务            |
|                | aspire_extensions_configuration     | 可选   | 统一配置系统            |
|                | aspire_extensions_logging           | 可选   | 日志系统                |
| **身份管理**   | aspire_identity_server              | 可选   | OAuth2.0/OIDC 认证服务  |
|                | aspire_identity_claims              | 可选   | 身份声明                |
|                | aspire_identity_tokens_jwt          | 可选   | JWT 令牌支持            |
|                | aspire_identity_protocols_oidc      | 可选   | OpenID Connect 协议实现 |

## 发布时间线

- [x] 0.9.0 版本
- [ ] 1.0.0 版本 预计时间7月底

## 许可证

MIT License
