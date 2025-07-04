// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_net_http

public interface IHttpMessageHandler {
    func send(request: HttpRequestMessage, next: DelegatingHandler): HttpResponseMessage
}
