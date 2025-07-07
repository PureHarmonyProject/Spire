// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.io.*
import std.collection.*

public class StreamContent <: HttpContent {
    private let _stream: InputStream

    public init(stream: InputStream) {
        _stream = stream
    }

    public func readAsStream(): InputStream {
        _stream
    }
}
