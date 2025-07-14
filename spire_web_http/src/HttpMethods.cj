// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_http

public struct HttpMethods {
    public static const Get = "get"
    public static const Put = "put"
    public static const Post = "post"
    public static const Head = "head"
    public static const Patch = "patch"
    public static const Trace = "trace"
    public static const Delete = "delete"
    public static const Connect = "connect"
    public static const Options = "options"

    public static func isGet(method: String) {
        return equals(Get, method)
    }
    public static func isPut(method: String) {
        return equals(Put, method)
    }
    public static func isPost(method: String) {
        return equals(Post, method)
    }
    public static func isHead(method: String) {
        return equals(Head, method)
    }
    public static func isPatch(method: String) {
        return equals(Patch, method)
    }
    public static func isTrace(method: String) {
        return equals(Trace, method)
    }
    public static func isDelete(method: String) {
        return equals(Delete, method)
    }
    public static func isConnect(method: String) {
        return equals(Connect, method)
    }
    public static func isOptions(method: String) {
        return equals(Options, method)
    }

    private static func equals(left: String, right: String) {
        left.equalsIgnoreAsciiCase(right)
    }    
}
