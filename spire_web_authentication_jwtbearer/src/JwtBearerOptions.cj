// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication_jwtbearer

import spire_identity_tokens.*
import spire_web_authentication.*
import spire_identity_protocols.*
import spire_identity_protocols_oidc.*

public class JwtBearerOptions <: AuthenticationSchemeOptions {
    public var saveToken = true
    public var authority = String.empty
    public var metadataAddress = String.empty
    public var requireHttpsMetadata = false
    public let events = JwtBearerEvents()
    public var challenge = JwtBearerDefaults.Scheme
    public var configuration: ?OpenIdConnectConfiguration = None
    public var configurationManager: ?IConfigurationManager<OpenIdConnectConfiguration> = None
    public var tokenValidationParameters: TokenValidationParameters = TokenValidationParameters()
}
