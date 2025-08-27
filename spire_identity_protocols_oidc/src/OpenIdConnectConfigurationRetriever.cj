// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_identity_protocols_oidc

import spire_identity_tokens.*
import spire_identity_protocols.*

public class OpenIdConnectConfigurationRetriever <: IConfigurationRetriever<OpenIdConnectConfiguration> {
    public func get(address: String, retriever: IDocumentRetriever): OpenIdConnectConfiguration {
        let json = retriever.getDocument(address)
        let configuration = OpenIdConnectConfiguration.create(json)
        if (!configuration.jwksUri.isEmpty()) {
            let json = retriever.getDocument(configuration.jwksUri)
            let jsonWebKey = JsonWebKeySet.create(json)
            for (jwk in jsonWebKey.keys) {
                configuration.signingKeys.add(jwk)
            }
        }
        return configuration
    }

    public func getConfiguration(address: String, documentRetriever: IDocumentRetriever): OpenIdConnectConfiguration {
        return  get(address, documentRetriever)
    }
}
