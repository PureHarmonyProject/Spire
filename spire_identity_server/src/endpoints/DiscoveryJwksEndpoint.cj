package spire_identity_server.endpoints

import spire_web_http.*
import spire_identity_tokens.*
import spire_identity_server.hosting.*
import spire_identity_server.services.*

public class DiscoveryJwksEndpoint <: EndpointHandler {
    private let _discoveryDecument: IDiscoveryDecumentService

    public init(discoveryDecument: IDiscoveryDecumentService) {
        _discoveryDecument = discoveryDecument
    }

    public func handle(_: HttpContext): IEndpointResult {
        let jwks = _discoveryDecument.createJwksDocument()
        return json(jwks)
    }

}
