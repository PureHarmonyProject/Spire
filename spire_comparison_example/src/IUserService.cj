package spire_comparison_example

public interface IUserService {
    func getAll(): Array<User>
    func getById(id: Int64): Option<User>
    func create(user: User): User
    func update(user: User): User
    func delete(id: Int64): Bool
    func findActiveUsers(): Array<User>
    func search(keyword: String): Array<User>
    func search(keyword: String, page: Int32, size: Int32): Array<User>
    func existsByEmail(email: String): Bool
}