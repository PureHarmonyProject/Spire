// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_http

import std.collection.*
import spire_extensions_injection.*

public abstract class EndpointBuilder {
    protected init() {
        
    }
    public prop metadata: List<Any>
    public prop delegate: RequestDelegate
    public prop services: IServiceProvider
    public prop displayName: ?String
    public func build(): Endpoint
}
