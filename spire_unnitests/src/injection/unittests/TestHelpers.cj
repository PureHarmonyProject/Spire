package spire_unnitests.injection.unittests

import std.random.*

// ============ 测试辅助类和接口定义 ============

// 用于测试依赖注入的数据库上下文类
class DbContext {
    public DbContext(public let connection: IDbConnection) {

    }
}

// 用于测试多参数构造函数的数据源类
class DbDataSource {
    public DbDataSource(public let contex: DbContext, public let name: String) {
        
    }
}

// 数据库连接接口，实现了ToString和Resource，用于测试接口注入
interface IDbConnection <: ToString & Resource {
    prop id: String
}

// MySQL连接实现，用于测试具体实现的注入
class MySqlConnection <: IDbConnection {
    private let _id: String
    private var _isClosed = false

    public init() {
        _id = Random().nextUInt64().toString()
    }

    public prop id: String {
        get() {
            _id
        }
    }

    public func toString() {
        _id
    }

    public func isClosed() {
        return _isClosed
    }

    public func close() {
        _isClosed = true
    }
}

// MsSQL连接实现，用于测试多实现场景
class MsSqlConnection <: IDbConnection {
    private let _id: String
    private var _isClosed = false

    public init() {
        _id = Random().nextUInt64().toString()
    }

    public prop id: String {
        get() {
            _id
        }
    }

    public func toString() {
        _id
    }

    public func isClosed() {
        return _isClosed
    }

    public func close() {
        _isClosed = true
    }
}

// 用于测试循环依赖的类A
class ServiceA {
    public ServiceA(_b: ServiceB) {
        // 消除未使用警告
        let _ = _b
    }
}

// 用于测试循环依赖的类B
class ServiceB {
    public ServiceB(_a: ServiceA) {
        // 消除未使用警告
        let _ = _a
    }
}

// 用于测试多构造函数选择的类
class MultiConstructorService {
    public let value: String

    public init() {
        value = "default"
    }

    public init(_connection: IDbConnection) {
        value = "with_connection"
        // 消除未使用警告
        let _ = _connection
    }

    public init(_connection: IDbConnection, _name: String) {
        value = "with_connection_and_name"
        // 消除未使用警告
        let _ = _connection
        let _ = _name
    }
}

// 用于测试无构造函数参数的简单服务类
class SimpleService {
    public let id: String

    public init() {
        id = "simple"
    }
} 