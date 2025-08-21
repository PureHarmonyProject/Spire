# 静态文件中间件

静态文件中间件用于高效地处理和提供 HTML、CSS、JS、图片等静态资源请求，是 Web 应用开发中不可或缺的基础能力。

## 快速启动

只需 3 步即可为你的 Spire 应用添加静态文件服务：

```cangjie{3,7,8,9,10}
import spire_web_hosting.*

main() {
    let builder = WebHost.createBuilder()
    let host = builder.build()
    // 1. 启用欢迎页中间件（可选，自动查找默认首页文件）
    host.useDefaultFiles()
    // 2. 启用静态文件中间件（提供 wwwroot 下的静态资源）
    host.useStaticFiles()
    // 3. 启动主机
    host.run()
    return 0
}
```

## 默认文件中间件

欢迎页中间件会自动查找 `wwwroot` 目录下的默认首页文件（如 `index.html`）。你也可以自定义欢迎页文件名：

```cangjie
host.useDefaultFiles { options =>
    // 添加自定义欢迎页文件名
    options.defaultFileNames.add("welcome.html")
}
```

## 静态文件中间件配置

你可以自定义内容类型映射、默认内容类型等高级选项：

```cangjie
host.useStaticFiles { options =>
    // 自定义内容类型映射
    let contentTypeProvider = ContentTypeProvider()
    contentTypeProvider.mappings[".bcmap"] = "application/octet-stream"
    options.contentTypeProvider = contentTypeProvider
}
```

或设置默认内容类型：

```cangjie
host.useStaticFiles { options =>
    options.serveUnknownFileTypes = true
    options.defaultContentType = "application/octet-stream"
}
```

## 目录结构建议

```
项目根目录/
├─ src/
├─ wwwroot/
│  ├─ index.html
│  ├─ style.css
│  └─ ...
└─ ...
```

所有静态资源建议统一放置于 `wwwroot` 目录下，便于统一管理和访问。

## 最佳实践

- 推荐将所有前端静态资源（HTML、CSS、JS、图片等）集中放在 `wwwroot` 目录。
- 使用 `useDefaultFiles()` 可自动支持首页访问体验。
- 通过 `useStaticFiles()` 提供高性能的静态资源服务。
- 如需自定义内容类型或支持特殊文件扩展名，可通过 `contentTypeProvider` 配置。

---

如需更详细的配置和扩展用法，请参考源码或相关文档。