package spire_comparison_example

import spire_web_mvc.*

@Route["api/users"]
public class UserController <: Controller {
    
    @HttpGet
    public func get() {
        context.response.write("Hello from Users API!")
    }
    
    @HttpGet["{id}"]
    public func getById(@FromRoute id: Int64) {
        context.response.write("User ID: ${id}")
    }
}