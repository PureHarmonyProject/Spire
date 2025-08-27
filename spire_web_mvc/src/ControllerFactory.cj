package spire_web_mvc

import spire_web_mvc.controllers.*
import spire_extensions_injection.*

class ControllerFactory <: IControllerFactory {
    public func create(context: ControllerContext): Object {
        let instance = ActivatorUtilities.createInstance(context.httpContext.services,
            context.actionDescriptor.controllerType)
        if (let controller: Controller <- instance) {
            controller.setup(context.httpContext)
        }
        return instance
    }
}
