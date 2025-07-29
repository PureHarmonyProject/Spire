// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_tokens

import std.collection.*

public class TokenValidationParameters {
    public var validateIssuer = true
    public var validateLifetime = true
    public var validateAudience = true
    public var requireExpirationTime = true
    public var validateIssuerSigningKey = true
    public var validIssuers = Array<String>()
    public var validAudiences = Array<String>()
    public var validIssuer = Option<String>.None
    public var validAudience = Option<String>.None
    public var issuerSigningKey: ?SecurityKey = None
    public var issuerSigningKeys: List<SecurityKey> = ArrayList<SecurityKey>()
    public var authenticationType: String = "AuthenticationTypes.Federation"

    public init() {
        
    }
    
    public init(that: TokenValidationParameters) {
        validateIssuer = that.validateIssuer
        validateLifetime = that.validateLifetime
        validateAudience = that.validateAudience
        requireExpirationTime = that.requireExpirationTime
        validateIssuerSigningKey = that.validateIssuerSigningKey
        validIssuers = that.validIssuers.clone()
        validAudiences = that.validAudiences.clone()
        validIssuer = that.validIssuer?.clone()
        validAudience = that.validAudience?.clone()
        authenticationType = that.authenticationType.clone()
        issuerSigningKey = that.issuerSigningKey
        issuerSigningKeys = that.issuerSigningKeys
    }

    public func clone() {
        return TokenValidationParameters(this)
    }
}
