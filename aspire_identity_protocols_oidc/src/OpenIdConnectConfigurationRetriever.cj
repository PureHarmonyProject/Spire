// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_identity_protocols_oidc

import aspire_identity_protocols.*

public class OpenIdConnectConfigurationRetriever <: IConfigurationRetriever<OpenIdConnectConfiguration> {
    public func getConfiguration(address: String, documentRetriever: IDocumentRetriever): OpenIdConnectConfiguration {
        let document = documentRetriever.getDocument(address)
        return OpenIdConnectConfiguration.create(document)
    }
}