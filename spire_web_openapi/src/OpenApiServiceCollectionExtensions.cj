package spire_web_openapi

import spire_extensions_injection.*

public interface OpenApiServiceCollectionExtensions {
    func addOpenApi(): ServiceCollection
}

extend ServiceCollection <: OpenApiServiceCollectionExtensions{
    public func addOpenApi(): ServiceCollection {
        return this
    }
}