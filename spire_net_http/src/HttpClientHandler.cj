// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import stdx.net.tls.*
import stdx.net.http.*

public class HttpClientHandler <: HttpMessageHandler {
    private let _client: Client

    public init() {
        this(crateDefaultClient())
    }

    public init(client: Client) {
        _client = client
    }

    public func send(request: HttpRequestMessage) {
        let requestBuilder = HttpRequestBuilder()
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
        let response = _client.send(requestBuilder.build())
        return HttpResponseMessage(request, response)
    }

    private static func crateDefaultClient() {
        let builder = ClientBuilder()
        var tlsConfig = TlsClientConfig()
        tlsConfig.verifyMode = CertificateVerifyMode.TrustAll
        builder.tlsConfig(tlsConfig)
        return builder.build()
    }
}
