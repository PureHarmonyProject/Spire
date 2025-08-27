// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

public class HttpMethod <: ToString {
    private let _method: String

    public init(method: String) {
        _method = method
    }

    public static let Get = HttpMethod("GET")
    public static let Post = HttpMethod("POST")
    public static let Put = HttpMethod("PUT")
    public static let Delete = HttpMethod("DELETE")
    public static let Patch = HttpMethod("PATCH")
    public static let Head = HttpMethod("HEAD")
    public static let Options = HttpMethod("OPTIONS")
    public static let Trace = HttpMethod("TRACE")
    public static let Connect = HttpMethod("CONNECT")

    public func toString() {
        return _method.toAsciiUpper()
    }
}
