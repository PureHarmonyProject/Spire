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

    public static let get = HttpMethod("GET")
    public static let post = HttpMethod("POST")
    public static let put = HttpMethod("PUT")
    public static let delete = HttpMethod("DELETE")
    public static let patch = HttpMethod("PATCH")
    public static let head = HttpMethod("HEAD")
    public static let options = HttpMethod("OPTIONS")
    public static let trace = HttpMethod("TRACE")
    public static let connect = HttpMethod("CONNECT")

    public func toString() {
        return _method.toAsciiUpper()
    }
}
