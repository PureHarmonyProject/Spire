package spire_identity_server.endpoints

import spire_web_http.*
import spire_identity_server.hosting.*
import spire_identity_protocols_oidc.*
import spire_identity_server.services.*

public class DiscoveryEndpoint <: EndpointHandler {
    private let _discoveryDecument: IDiscoveryDecumentService

    public init(discoveryDecument: IDiscoveryDecumentService) {
        _discoveryDecument = discoveryDecument
    }

    public func handle(_: HttpContext): IEndpointResult {
        let document = _discoveryDecument.createDiscoveryDocument()
        return json(OpenIdConnectConfiguration.wirte(document))
    }
}
