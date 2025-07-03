package aspire_web_quickstart.infrastructure

import std.collection.*
import aspire_web_http.*
import aspire_web_routing.*
import aspire_extensions_logging.*
import aspire_extensions_caching.*
import aspire_web_mvc.abstractions.*

/*
用于生成请求接口（简易版）
 */
public class OpenApiMiddleware <: IMiddleware {
    private let _cache: IDistributedCache
    private let _dataSource: EndpointDataSource
    private let _logger: ILogger

    public init(cache: IDistributedCache, dataSource: EndpointDataSource, loggerFactory: ILoggerFactory) {
        _cache = cache
        _dataSource = dataSource
        _logger = loggerFactory.createLogger<OpenApiMiddleware>()
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (context.request.path.value == "/openapi") {
            if (let Some(value) <- _cache.getString("openapi")) {
                context.response.write(value)
                _logger.info("from cache")
            }else {
                let document = createDocument()
                _cache.setString("openapi", document)
                context.response.write(document)
            }
            context.response.addHeader("context-type", "text/html")
        } else {
            next()
        }
    }

    private func createDocument() {
         let sb = StringBuilder()
        sb.append("<html>")
        sb.append("<body>")
        for (pattern in _dataSource.endpoints |> filterMap {f => f as RouteEndpoint}) {
            let methods = pattern.metadata |> filterMap{f => f as IHttpMethodMetadata} |> flatMap{f => f.httpMethods} |> collectArray
            sb.append("<a href='${pattern.routePattern}'>${methods}${pattern.routePattern}</a><br/>")
        }
        sb.append("</body>")
        sb.append("</html>")
        return sb.toString()
    }
}
