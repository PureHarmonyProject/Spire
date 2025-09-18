# spire 天擎

一个基于仓颉语言开发、借鉴 ASP.NET Core 设计哲学的现代化 Web 框架。我们与仓颉官方团队共同研发，致力于打造轻量级、高性能、可扩展的应用开发体验。

✨ **核心特性**：

- **轻量化架构**：低侵入性设计，高度可配置
- **模块化扩展**：功能组件按需组合
- **快速集成**：通过 GitCode 配置即可快速接入
- **微服务支持**：持续提供完善微服务组件生态
- **AI 集成**：持续探索智能化开发方案

以仓颉语言为核心，构建新一代高效开发框架。

## 加入我们

诚邀开发者共同构建：

- 🧩 标准化组件库
- 🔗 统一技术生态
- 🌐 开源协作平台

> 官方交流 QQ 群 `307564339`

## 快速开始

[项目文档](https://docs.cangjie-spire.com)

## 功能模块

| 模块分类       | 模块名称                            | 必要性 | 功能描述                |
| -------------- | ----------------------------------- | ------ | ----------------------- |
| **Web 核心**   | spire_web_http                     | 必需   | HTTP 核心接口           |
|                | spire_web_routing                  | 必需   | 路由与终结点管理        |
|                | spire_web_hosting                  | 必需   | Web 主机服务            |
| **Web 中间件** | spire_web_mvc                      | 可选   | MVC 功能支持            |
|                | spire_web_cors              | 可选   | 跨域中间件          |
|                | spire_web_staticfiles              | 可选   | 静态文件中间件          |
|                | spire_web_healthchecks             | 可选   | 健康检查中间件          |
| **身份认证**   | spire_web_authorization            | 可选   | 授权中间件              |
|                | spire_web_authentication           | 可选   | 基础认证中间件          |
|                | spire_web_authentication_jwtbearer | 可选   | JWT 认证方案            |
| **基础设施**   | spire_extensions_options           | 必需   | 配置选项管理            |
|                | spire_extensions_injection         | 必需   | 依赖注入                |
|                | spire_extensions_hosting           | 可选   | 通用主机服务            |
|                | spire_extensions_caching           | 可选   | 分布式内存缓存          |
|                | spire_extensions_healthchecks      | 可选   | 健康检查服务            |
|                | spire_extensions_configuration     | 可选   | 统一配置系统            |
|                | spire_extensions_logging           | 可选   | 日志系统                |
| **认证设施**   | spire_identity_server              | 可选   | OAuth2.0/OIDC 认证服务  |
|                | spire_identity_claims              | 可选   | 身份声明                |
|                | spire_identity_tokens_jwt          | 可选   | JWT 令牌支持            |
|                | spire_identity_protocols_oidc      | 可选   | OpenID Connect 协议实现 |
| **对象序列化**| spire_serialization      | 可选   | 基于字段驱动的对象序列化工具 |
| **ORM**        | sqlsharp      | 可选   | 轻量级ORM |
|                        | sqlsharp-utils      | 可选   | 实体生成工具 |


## 发布时间线

- [x] 0.9.0 版本
- [x] 1.0.0 版本 2025年08月04日 已上线

## 许可证

MIT License
