package spire_comparison_example

import std.collection.*

public class UserService <: IUserService {
    private var users = HashMap<Int64, User>()
    private var nextId: Int64 = 1
    
    public init() {}
    
    public func getAll(): Array<User> {
        return users.values().toArray()
    }
    
    public func getById(id: Int64): Option<User> {
        return users.get(id)
    }
    
    public func create(user: User): User {
        let newId = nextId
        nextId = nextId + 1
        let newUser = User(newId, user.name, user.email, user.age)
        users.add(newId, newUser)
        return newUser
    }
    
    public func update(user: User): User {
        users.add(user.id.getOrThrow(), user)
        return user
    }
    
    public func delete(id: Int64): Bool {
        return users.remove(id).isSome()
    }
    
    public func findActiveUsers(): Array<User> {
        return Array<User>()
    }
    
    public func search(keyword: String): Array<User> {
        return Array<User>()
    }
    
    public func search(keyword: String, page: Int32, size: Int32): Array<User> {
        return Array<User>()
    }
    
    public func existsByEmail(email: String): Bool {
        return false
    }
}