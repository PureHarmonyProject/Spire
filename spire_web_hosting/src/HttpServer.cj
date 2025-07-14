// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_hosting

import std.convert.*
import std.collection.*
import stdx.encoding.url.*
import stdx.log.LogLevel as StdLogLevel
import stdx.net.http.HttpContext as HttpContextBase
import stdx.net.http.{FuncHandler, ServerBuilder, HttpRequestDistributor, HttpRequestHandler}

public class HttpServer {
    private let _app: RequestDelegate
    private let _services: IServiceProvider
    private let _shutdownEvents = ArrayList<() -> Unit>()

    init(app: RequestDelegate, services: IServiceProvider) {
        _app = app
        _services = services
    }

    public func listen(urls: Array<String>) {
        let url = URL.parse(urls[0])
        let builder = ServerBuilder()
            .addr(url.hostName)
            .port(UInt16.parse(url.port.toString()))
            .distributor(DefaultHttpRequestDistributor(_app, _services))
        for (pattern in _shutdownEvents) {
            builder.onShutdown(pattern)
        }
        let server = builder.build()
        server.logger.level = StdLogLevel.OFF
        server.serve()
    }

    public func onShutdown(callback: () -> Unit) {
        _shutdownEvents.add(callback)
        return this
    }
}

class DefaultHttpRequestDistributor <: HttpRequestDistributor {
    private let _app: RequestDelegate
    private let _services: IServiceProvider

    init(app: RequestDelegate, services: IServiceProvider) {
        _app = app
        _services = services
    }

    public func register(_: String, _: HttpRequestHandler): Unit {

    }

    public func register(_: String, _: (HttpContextBase) -> Unit): Unit {

    }

    public func distribute(_: String) {
        let logger = _services.getOrThrow<ILoggerFactory>().createLogger("spire.hosting.lifetime")
        return FuncHandler { context => 
            try (requestScope = _services.createScope()) {  
                let contextImpl = HttpContextImpl(context, requestScope.services)
                try {
                    setHttpContextAccessor(contextImpl)
                    _app(contextImpl)
                } catch (ex: Exception) {
                    contextImpl.response.write("Internal Server Error")
                    contextImpl.response.status(StatusCodes.InternalServerError)
                    contextImpl.response.addHeader(HeaderNames.ContentType, "text/plain; charset=utf-8")
                    logger.error(ex, ex.message)
                }
            }
        }
    }

    private func setHttpContextAccessor(context: HttpContextImpl): Unit {
        if (let Some(contextAccessor) <- context.services.getOrDefault<IHttpContextAccessor>()) {
            if (let internalContextAccessor: HttpContextAccessor <- contextAccessor) {
                internalContextAccessor.setup(context)
            }
        }
    }
}