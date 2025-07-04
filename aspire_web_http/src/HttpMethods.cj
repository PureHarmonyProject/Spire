// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_http

public struct HttpMethods {
    public static const get = "get"
    public static const put = "put"
    public static const post = "post"
    public static const head = "head"
    public static const patch = "patch"
    public static const trace = "trace"
    public static const delete = "delete"
    public static const connect = "connect"
    public static const options = "options"

    public static func isGet(method: String) {
        return equals(get, method)
    }
    public static func isPut(method: String) {
        return equals(put, method)
    }
    public static func isPost(method: String) {
        return equals(post, method)
    }
    public static func isHead(method: String) {
        return equals(head, method)
    }
    public static func isPatch(method: String) {
        return equals(patch, method)
    }
    public static func isTrace(method: String) {
        return equals(trace, method)
    }
    public static func isDelete(method: String) {
        return equals(delete, method)
    }
    public static func isConnect(method: String) {
        return equals(connect, method)
    }
    public static func isOptions(method: String) {
        return equals(options, method)
    }

    private static func equals(left: String, right: String) {
        left.equalsIgnoreAsciiCase(right)
    }    
}
