// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.reflect.*
import std.sync.*

public abstract class DelegatingHandler <: HttpMessageHandler {
    private var _innerHandler: ?HttpMessageHandler
    private let _isClosed = AtomicBool(false)
    private let _operationStarted = AtomicBool(false)

    protected init() {
        _innerHandler = None
    }

    protected init(innerHandler: HttpMessageHandler) {
        _innerHandler = innerHandler
    }

    public mut prop innerHandler: ?HttpMessageHandler {
        get() {
            _innerHandler
        }
        set(value) {
            checkClosedOrStarted()
            _innerHandler = value
        }
    }

    public open func isClosed() {
        return _isClosed.load()
    }

    public func close(closing: Bool) {
        if (closing && _isClosed.compareAndSwap(false, true)) {
            if (let Some(innerHandler) <- innerHandler && !innerHandler.isClosed()) {
                innerHandler.close()
            }
        }
        super.close(closing)
    }

    protected open func send(request: HttpRequestMessage): HttpResponseMessage {
        setOperationStarted()
        if (let Some(innerHandler) <- _innerHandler) {
            innerHandler.send(request)
        } else {
            throw UnsupportedException(StringResx.net_http_handler_not_assigned)
        }
    }

    private func checkClosed() {
        if (_isClosed.load()) {
            throw ObjectDisposedException(ClassTypeInfo.of(this).toString())
        }
    }

    private func checkClosedOrStarted() {
        checkClosed()
        if (_operationStarted.load()) {
            throw UnsupportedException(StringResx.net_http_handler_not_assigned)
        }
    }

    private func setOperationStarted() {
        checkClosed()
        _operationStarted.compareAndSwap(false, true)
    }
}
