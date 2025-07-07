package spire_web_quickstart.infrastructure

import spire_web_http.*
import spire_extensions_logging.*

public class ExceptionHandlerMiddleware <: IMiddleware {
    private let _logger: ILogger

    public init(logFactory: ILoggerFactory) {
        _logger = logFactory.createLogger<ExceptionHandlerMiddleware>()
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        try {
            next()
        } catch (ex: Exception) {
            _logger.error(ex.message)
            ex.printStackTrace()
            context.response.status(StatusCodes.InternalServerError)
        }
    }
}
