// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_http

import std.io.InputStream

public abstract class HttpResponse {
    public func status(status: UInt16): Unit
    public func write(text: String): Unit
    public func write(bytes: Array<Byte>): Unit
    public func write(stream: InputStream): Unit
    public func addHeader(name: String, value: String): Unit
}
