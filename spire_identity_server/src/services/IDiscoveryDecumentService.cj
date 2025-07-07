package spire_identity_server.services

import spire_identity_tokens.JsonWebKeySet
import spire_identity_protocols_oidc.OpenIdConnectConfiguration

public interface IDiscoveryDecumentService {
    func createJwksDocument() : JsonWebKeySet
    func createDiscoveryDocument(): OpenIdConnectConfiguration
}