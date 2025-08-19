// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.sync.*
import std.reflect.*
import stdx.net.tls.*
import stdx.net.http.*

public class HttpClientHandler <: HttpMessageHandler {
    private let _client: Client
    private var _isClosed = AtomicBool(false)
    private let _operationStarted = AtomicBool(false)
    private var _timeout: Duration = Duration.second * 100

    public init() {
        this(crateDefaultClient())
    }

    public init(client: Client) {
        _client = client
    }

    public mut prop timeout: Duration {
        get() {
            _timeout
        }
        set(value) {
            checkClosedOrStarted()
            _timeout = value
        }
    }

    public func send(request: HttpRequestMessage) {
        setOperationStarted()
        let response = _client.send(createHttpRequest(request))
        return HttpResponseMessage(request, response)
    }

    private func createHttpRequest(request: HttpRequestMessage) {
        let requestBuilder = HttpRequestBuilder()
        requestBuilder.readTimeout(_timeout)
        requestBuilder.writeTimeout(_timeout)
        requestBuilder.url(request.requestUri.getOrThrow())
        requestBuilder.method(request.method.toString())
        if (let Some(content) <- request.content) {
            for ((name, values) in content.headers) {
                for (value in values) {
                    requestBuilder.header(name, value)
                }
            }
            requestBuilder.body(content.readAsStream())
        }
        return requestBuilder.build()
    }

    private static func crateDefaultClient() {
        let builder = ClientBuilder()
        var tlsConfig = TlsClientConfig()
        tlsConfig.verifyMode = CertificateVerifyMode.TrustAll
        builder.tlsConfig(tlsConfig)
        return builder.build()
    }

    public override func isClosed() {
        return _isClosed.load()
    }

    public override func close(closing: Bool) {
        if (closing && _isClosed.compareAndSwap(false, true)) {
            _client.close()
        }
        super.close(closing)
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
