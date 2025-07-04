// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_identity_tokens

import std.collection.*

public class TokenValidationParameters {
    public var validateIssuer = true
    public var validateLifetime = true
    public var validateAudience = true
    public var requireExpirationTime = true
    public var validateIssuerSigningKey= true
    public var validIssuers = Array<String>()
    public var validAudiences = Array<String>()
    public var validIssuer = Option<String>.None
    public var validAudience = Option<String>.None
    public var issuerSigningKey: ?SecurityKey = None
    public let issuerSigningKeys: List<SecurityKey> = ArrayList<SecurityKey>()
    public var authenticationType: String = "AuthenticationTypes.Federation"
}
