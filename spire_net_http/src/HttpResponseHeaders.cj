// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.collection.*
import stdx.net.http.HttpHeaders

public class HttpResponseHeaders <: Iterable<(String, Collection<String>)> {
    private let _headers: HttpHeaders

    init(headers: HttpHeaders) {
        _headers = headers
    }

    public func iterator() {
        _headers.iterator()
    }

    public func get(name: String) {
        _headers.get(name)
    }

    public func getFirst(name: String) {
        _headers.getFirst(name)
    }
}
