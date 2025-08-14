package spire_comparison_example
import std.collection.*
import stdx.serialization.serialization.*
import stdx.encoding.json.*

public class CreateUserRequest {
    public var name: String
    public var email: String
    public var age: Int64   
    
    public init(name: String, email: String, age: Int64) {
        this.name = name
        this.email = email
        this.age = age
    }
    
    public func validate(): ValidationResult {
        let errors = ArrayList<String>()
        
        if (name.size < 2 || name.size > 50) {
            errors.add("Name must be between 2 and 50 characters")
        }
        
        if (!email.contains("@")) {
            errors.add("Invalid email format")
        }
        
        if (age < 18) {
            errors.add("Age must be at least 18")
        }
        
        return ValidationResult(errors.isEmpty(), errors.toArray())
    }

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<String>("name", name))
            .add(field<String>("email", email))
            .add(field<Int64>("age", age))
    }

    public static func deserialize(dm: DataModel): CreateUserRequest {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = CreateUserRequest("", "", 0)
        result.name = String.deserialize(dms.get("name"))
        result.email = String.deserialize(dms.get("email"))
        result.age = Int64.deserialize(dms.get("age"))
        return result
    }
}