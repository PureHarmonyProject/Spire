package spire_comparison_example

import spire_web_mvc.*

@Route["api/users"]
public class UserController <: Controller {
    private let userService: IUserService
    
    public init(userService: IUserService) {
        this.userService = userService
    }
    
    @HttpGet["{id}"]
    public func getUser(@FromRoute id: Int64): IActionResult {
        let user = userService.getById(id)
        if (user.isSome()) { 
            return json(user.getOrThrow())
        } else { 
            return notFound() 
        }
    }
    
    @HttpPost
    public func createUser(@FromBody request: CreateUserRequest): IActionResult {
        let validationResult = request.validate()
        if (!validationResult.isValid) {
            return badRequest()
        }
        
        let user = User(
            0,
            request.name,
            request.email,
            request.age
        )
        
        let created = userService.create(user)
        return json(created)
    }
}