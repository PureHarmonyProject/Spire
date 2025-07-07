package spire_identity_server.hosting

import spire_web_http.*

public interface IEndpointRouter {
    func routing(context: HttpContext): ?IEndpointHandler
}