package spire_web_mvc.controllers

public interface IActionDescriptorFactory {
    func create(context: ActionContext): ControllerActionDescriptor
}

public class ActionDescriptorFactory <: IActionDescriptorFactory {
    public func create(context: ActionContext): ControllerActionDescriptor {
        let actionName = context.actionFunction.name
        let controllerName = context.controllerType.name.removeSuffix("Controller").toAsciiLower()
        let descriptor = ControllerActionDescriptor(actionName, controllerName, context.controllerType, context.actionFunction)
        applyAnnotations(descriptor, context.controllerType.annotations)
        applyAnnotations(descriptor, context.actionFunction.annotations)
        return descriptor
    }


    private func applyAnnotations(descriptor: ControllerActionDescriptor, annotations: Collection<Object>) {
        for (annotation in annotations) {
            descriptor.endpointMetadata.add(annotation)
        }
    }
}
