package spire_web_openapi

import spire_web_http.*

public interface OpenApiEndpointRouteBuilderExtensions {
    func useOpenApi(): Unit
}

extend ApplicationBuilder <: OpenApiEndpointRouteBuilderExtensions {
    public func useOpenApi(): Unit {
    }
}
