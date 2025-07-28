package spire_web_mvc

import std.collection.*
import spire_web_http.*
import spire_web_routing.*
import spire_web_mvc.bindings.*
import spire_web_mvc.controllers.*
import spire_extensions_injection.*
import spire_web_routing.patterns.*
import spire_web_mvc.abstractions.*

class ActionEndpointFactory {
    private let _services: IServiceProvider
    private let _modelBinder: IModelBinder
    private let _controllerFactory: IControllerFactory

    public init(services: IServiceProvider, modelBinder: IModelBinder, controllerFactory: IControllerFactory) {
        _services = services
        _modelBinder = modelBinder
        _controllerFactory = controllerFactory
    }

    public func addEndpoints(endpoints: List<Endpoint>, actionDescriptor: ControllerActionDescriptor,
        conventions: ArrayList<(EndpointBuilder) -> Unit>) {
        let default = actionDescriptor.controllerType.annotations |> filterMap {f => f as IRouteTemplateProvider} |>
            filterMap {f => f.template} |> first
        let templates = actionDescriptor.actionFunction.annotations |> filterMap {f => f as IRouteTemplateProvider} |>
            filterMap {f => f.template}
        for (pattern in templates) {
            let template: ?String = if (pattern.startsWith('/')) {
                pattern
            } else if (let Some(default) <- default) {
                "${default}/${pattern}"
            } else {
                None
            }
            //create endpoints
            if (let Some(template) <- template) {
                let routePattern = createRoutePattern(template, actionDescriptor)
                let builder = createEndpointBuilder(routePattern, actionDescriptor)
                configureEndpointBuilder(builder, conventions)
                configureEndpointMetadata(builder, actionDescriptor)
                endpoints.add(builder.build())
            }
        }
    }

    private func createRoutePattern(template: String, action: ControllerActionDescriptor) {
        let path = template.replace("[controller]", action.controllerName).replace("[action]", action.actionName)
        return RoutePattern.parse(path)
    }

    private func createEndpointBuilder(routePattern: RoutePattern, action: ControllerActionDescriptor) {
        let requestDelegate = createRequestDelegate(action)
        return RouteEndpointBuilder(routePattern, requestDelegate, _services)
    }

    private func configureEndpointBuilder(
        builder: RouteEndpointBuilder,
        conventions: ArrayList<(EndpointBuilder) -> Unit>
    ) {
        for (convention in conventions) {
            convention(builder)
        }
        builder.metadata
        return builder
    }

    private func configureEndpointMetadata(builder: RouteEndpointBuilder, actionDescriptor: ControllerActionDescriptor) {
        builder.metadata.add(actionDescriptor)
        builder.metadata.add(all: actionDescriptor.endpointMetadata)
        for (pattern in actionDescriptor.endpointMetadata) {
            if (let httpMethodMetadata: IActionHttpMethodProvider <- pattern) {
                builder.metadata.add(HttpMethodMetadata(httpMethodMetadata.httpMethods))
            }
        }
        return builder
    }

    private func createRequestDelegate(action: ControllerActionDescriptor): RequestDelegate {
        return { context =>
            let controller = createController(context, action)
            let args = _modelBinder.bind(ModelBindingContext(context, action.actionFunction.parameters))
            let result = action.actionFunction.apply(controller, args)
            if (let actionResult : IActionResult <- result) {
                actionResult.invoke(context)
            }
        }
    }

    private func createController(httpContext: HttpContext, action: ControllerActionDescriptor) {
        return _controllerFactory.create(ControllerContext(httpContext, action))
    }
}
