package spire_identity_server.endpoints

import spire_web_http.*
import spire_identity_server.hosting.*

public class AuthorizeEndpoint <: EndpointHandler {
    public func handle(_: HttpContext) {
        return methodNotAllowed()
    }
}
