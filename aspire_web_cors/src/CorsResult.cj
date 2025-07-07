// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_cors

import std.collection.*

public class CorsResult {
    public var varyByOrigin = false
    public var isOriginAllowed = false
    public var isPreflightRequest = false
    public var supportsCredentials = false
    public var allowedOrigin: ?String = None
    public var preflightMaxAge: ?Duration = None
    public var allowedMethods :List<String> = ArrayList<String>()
    public var allowedHeaders :List<String> = ArrayList<String>()
    public var allowedExposedHeaders :List<String> = ArrayList<String>()
}