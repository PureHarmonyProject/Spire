// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package spire_net_http

public abstract class DelegatingHandler <: HttpMessageHandler {
    private var _innerHandler: ?HttpMessageHandler

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
            _innerHandler = value
        }
    }

    protected open func send(request: HttpRequestMessage): HttpResponseMessage {
        if (let Some(innerHandler) <- _innerHandler) {
            innerHandler.send(request)
        } else {
            throw UnsupportedException(StringResx.net_http_handler_not_assigned)
        }
    }
}
