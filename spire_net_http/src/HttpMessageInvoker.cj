package spire_net_http

public open class HttpMessageInvoker <: Resource {
    private var _isColsed = false
    private let _closeHandler: Bool
    private let _handler: HttpMessageHandler

    public init(handler: HttpMessageHandler) {
        this(handler, true)
    }

    public init(handler: HttpMessageHandler, closeHandler: Bool) {
        _handler = handler
        _closeHandler = closeHandler
    }

    public open func send(request: HttpRequestMessage) {
        return _handler.send(request)
    }

    public func isClosed() {
        return _isColsed
    }

    public func close() {
        if (_closeHandler && !_handler.isClosed()) {
            _handler.close()
        }
        _isColsed = true
    }
}
