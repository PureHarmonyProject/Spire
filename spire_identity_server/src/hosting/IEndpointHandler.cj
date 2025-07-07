package spire_identity_server.hosting

import spire_web_http.*

public interface IEndpointHandler {
    func handle(context: HttpContext): IEndpointResult
}