package spire_identity_server.hosting

import spire_web_http.*
import stdx.serialization.serialization.*

public class ContentEndpointResult <: IEndpointResult {
    public ContentEndpointResult(let data: String, let contentType: String) {
    }

    public func execute(context: HttpContext) {
        context.response.write(data)
        context.response.addHeader("content-type", contentType)
    }
}
