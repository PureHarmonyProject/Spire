// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.runtime.*

public abstract class HttpMessageHandler <: Resource {
    protected func send(request: HttpRequestMessage): HttpResponseMessage

    public open func isClosed() {
        return true
    }

    public open func close() {
    }
}
