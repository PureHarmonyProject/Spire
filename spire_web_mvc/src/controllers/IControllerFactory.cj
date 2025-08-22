package spire_web_mvc.controllers

public interface IControllerFactory {
    func create(context: ControllerContext): Object
}
