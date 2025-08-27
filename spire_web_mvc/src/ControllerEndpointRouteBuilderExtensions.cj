package spire_web_mvc

import std.collection.*
import spire_web_routing.*
import spire_web_mvc.routing.*

public interface ControllerEndpointRouteBuilderExtensions {
    func mapControllers(): ControllerActionEndpointConventionBuilder
}

extend EndpointRouteBuilder <: ControllerEndpointRouteBuilderExtensions {
   
    public func mapControllers() {
        let dataSource = getOrCreateEndpointDataSource(this)
        return dataSource.defaultBuilder
    }

    private func getOrCreateEndpointDataSource(endpoints: EndpointRouteBuilder): ControllerActionEndpointDataSource {
        for (pattern in dataSources) {
            if (let dataSources: ControllerActionEndpointDataSource <- pattern) {
                return dataSources
            }
        }
        let dataSource = ControllerActionEndpointDataSource(serviceProivder)
        endpoints.dataSources.add(dataSource)
        return dataSource
    }
}
