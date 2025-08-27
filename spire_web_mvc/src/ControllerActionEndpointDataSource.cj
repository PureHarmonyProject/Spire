package spire_web_mvc

import std.collection.*
import spire_web_http.*
import spire_web_mvc.routing.*
import spire_web_mvc.controllers.*
import spire_extensions_injection.*

class ControllerActionEndpointDataSource <: ActionEndpointDataSourceBase {
    public init(services: IServiceProvider) {
        super(services)
    }

    protected func createEndpoints(
        actions: ReadOnlyList<ControllerActionDescriptor>,
        conventions: ArrayList<(EndpointBuilder) -> Unit>
    ): ReadOnlyList<Endpoint> {
        let actionEndpointFactory = services.getOrThrow<ActionEndpointFactory>()
        let endpoints = ArrayList<Endpoint>()
        for (action in actions) {
            actionEndpointFactory.addEndpoints(endpoints, action, conventions)
        }
        return endpoints
    }
}
