package spire_comparison_example

public class User {
    public var id: ?Int64
    public var name: ?String
    public var email: ?String
    public var age: ?Int32
    
    public init(id: ?Int64, name: ?String, email: ?String, age: ?Int32) {
        this.id = id
        this.name = name
        this.email = email
        this.age = age
    }
}