package spire_identity_server.hosting

import spire_web_http.*

public interface IEndpointResult {
    func execute(context: HttpContext): Unit
}