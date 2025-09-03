// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.io.*

public class StringContent <: ByteArrayContent {

    public init(content: String) {
        this(content, "text/plain", "utf-8")
    }

    public init(content: String, mediaType: String) {
        this(content, mediaType, "utf-8")
    }

    public init(content: String, mediaType: String, encoding: String) {
        super(content.toArray())
        headers.add(HeaderNames.ContentType, "${mediaType}; charset=${encoding}")
    }
}
