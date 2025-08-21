// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.sync.*
import std.reflect.*

public open class HttpMessageInvoker <: Resource {
    private let _closeHandler: Bool
    private let _isClosed = AtomicBool(false)
    private let _handler: HttpMessageHandler

    public init(handler: HttpMessageHandler) {
        this(handler, true)
    }

    public init(handler: HttpMessageHandler, closeHandler: Bool) {
        _handler = handler
        _closeHandler = closeHandler
    }

    public open func send(request: HttpRequestMessage) {
        checkClosed()
        return _handler.send(request)
    }

    public open func isClosed() {
        return _isClosed.load()
    }

    public open func close() {
        close(true)
    }

    protected open func close(closing: Bool) {
        if (closing && _isClosed.compareAndSwap(false, true)) {
            if (_closeHandler) {
                _handler.close()
            }
        }
    }

    protected func checkClosed() {
        if (_isClosed.load()) {
            throw ObjectDisposedException(ClassTypeInfo.of(this).toString())
        }
    }
}
