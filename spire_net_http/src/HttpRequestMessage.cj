// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.collection.*
import stdx.encoding.url.*

public class HttpRequestMessage {
    private var _requestUri: ?URL
    private let _method: HttpMethod
    private let _headers = HttpRequestHeaders()
    private let _properties = HashMap<String, Any>()

    public init(method: HttpMethod, requestUri: String) {
        this(method, URL.parse(requestUri))
    }

    public init(method: HttpMethod, requestUri: URL) {
        _method = method
        _requestUri = requestUri
    }

    public var content: ?HttpContent = None

    public prop method: HttpMethod {
        get() {
            _method
        }
    }

    public mut prop requestUri: ?URL {
        get() {
            _requestUri
        }
        set(value) {
            _requestUri = value
        }
    }

    public prop headers: HttpRequestHeaders {
        get() {
            _headers
        }
    }

    public prop properties: HashMap<String, Any> {
        get() {
            _properties
        }
    }
}
