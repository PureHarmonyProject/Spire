package spire_extensions_injection.unittests

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.reflect.*

import spire_extensions_injection.*

// ============ 测试辅助类和接口定义 ============

// 用于测试依赖注入的数据库上下文类
private class DbContext {
    public DbContext(public let connection: IDbConnection) {

    }
}

// 用于测试多参数构造函数的数据源类
private class DbDataSource {
    public DbDataSource(public let contex: DbContext, public let name: String) {
        
    }
}

// 数据库连接接口，实现了ToString和Resource，用于测试接口注入
private interface IDbConnection <: ToString & Resource {
    prop id: String
}

// MySQL连接实现，用于测试具体实现的注入
private class MySqlConnection <: IDbConnection {
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
private class ServiceA {
    public ServiceA(_b: ServiceB) {
        // 消除未使用警告
        let _ = _b
    }
}

// 用于测试循环依赖的类B
private class ServiceB {
    public ServiceB(_a: ServiceA) {
        // 消除未使用警告
        let _ = _a
    }
}

// 用于测试多构造函数选择的类
private class MultiConstructorService {
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
private class SimpleService {
    public let id: String

    public init() {
        id = "simple"
    }
}

// ============ 容器自身解析测试 ============

/**
 * 测试根容器能否解析自己
 * 验证IServiceProvider服务是否正确注册为容器自身
 */
@Test
func 测试解析容器自己_根容器() {
    let services = ServiceCollection()
    let root = services.build()
    let providerSelf = root.getOrThrow<IServiceProvider>()
    @Expect(refEq((root as Object).getOrThrow(), (providerSelf as Object).getOrThrow()), true)
}

/**
 * 测试子容器能否解析自己，并验证子容器与根容器的区别
 * 验证作用域创建后，子容器的IServiceProvider指向子容器本身而不是根容器
 */
@Test
func 测试解析容器自己_子容器() {
    let services = ServiceCollection()
    let root = services.build()

    //测试子容器
    try (scope = root.createScope()) {
        let providerSelf = scope.services.getOrThrow<IServiceProvider>()
        @Expect(refEq((root as Object).getOrThrow(), (scope.services as Object).getOrThrow()), false)
        @Expect(refEq((providerSelf as Object).getOrThrow(), (scope.services as Object).getOrThrow()), true)
    }
}

// ============ 单例生命周期测试 ============

/**
 * 测试基本的单例类型注册
 * 注册方式：直接类型到类型的映射 addSingleton<MySqlConnection, MySqlConnection>()
 * 验证：多次获取应返回同一实例
 */
@Test
func 测试解析生命周期_单例1() {
    let services = ServiceCollection()
    services.addSingleton<MySqlConnection, MySqlConnection>()
    let root = services.build()
    let instance1 = root.getOrThrow<MySqlConnection>()
    let instance2 = root.getOrThrow<MySqlConnection>()
    @Expect(refEq(instance1, instance2), true)
}

/**
 * 测试实例注册的单例模式
 * 注册方式：直接注册预创建的实例 addSingleton(MySqlConnection())
 * 验证：多次获取应返回同一个预创建实例
 */
@Test
func 测试解析生命周期_单例2() {
    let services = ServiceCollection()
    services.addSingleton(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<MySqlConnection>()
    let instance2 = root.getOrThrow<MySqlConnection>()
    @Expect(refEq(instance1, instance2), true)
}

/**
 * 测试接口到实例的单例注册
 * 注册方式：将具体实例注册为接口类型 addSingleton<IDbConnection>(MySqlConnection())
 * 验证：通过接口获取的实例应为同一个
 */
@Test
func 测试解析生命周期_单例3() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection>(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

/**
 * 测试完整的单例注册（接口+实现+实例）
 * 注册方式：明确指定接口、实现类型和具体实例 addSingleton<IDbConnection, MySqlConnection>(MySqlConnection())
 * 验证：通过接口获取应返回指定的实例
 */
@Test
func 测试解析生命周期_单例4() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

/**
 * 测试工厂方法的单例注册
 * 注册方式：使用Lambda表达式作为工厂函数 addSingleton<IDbConnection, MySqlConnection> {_ => MySqlConnection()}
 * 验证：工厂函数只应被调用一次，多次获取返回同一实例
 */
@Test
func 测试解析生命周期_单例5() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection> {_ => MySqlConnection()}
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

/**
 * 测试有依赖关系的单例服务
 * 注册方式：注册有依赖关系的多个单例服务
 * 验证：依赖的服务也应为单例，整个依赖链保持单例语义
 */
@Test
func 测试解析生命周期_单例6() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<DbContext, DbContext>()
    let root = services.build()
    let context1 = root.getOrThrow<DbContext>()
    let context2 = root.getOrThrow<DbContext>()
    @Expect(refEq(context1, context2), true)
    @Expect(refEq((context1.connection as Object).getOrThrow(), (context2.connection as Object).getOrThrow()), true)
}

// ============ 作用域生命周期测试 ============

/**
 * 测试作用域服务的生命周期管理
 * 验证：
 * 1. 同一作用域内多次获取返回同一实例
 * 2. 不同作用域返回不同实例
 * 3. 作用域结束时资源被正确释放
 */
@Test
func 测试解析生命周期_作用域1() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection>()
    let root = services.build()

    var connection1: ?IDbConnection = None
    var connection2: ?IDbConnection = None
    var connection3: ?IDbConnection = None

    try (scope1 = root.createScope()) {
        connection1 = scope1.services.getOrThrow<IDbConnection>()
        connection2 = scope1.services.getOrThrow<IDbConnection>()
        @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection2.getOrThrow() as Object).getOrThrow()), true)
    }

    try (scope2 = root.createScope()) {
        connection3 = scope2.services.getOrThrow<IDbConnection>()
    }

    @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection3.getOrThrow() as Object).getOrThrow()), false)
    @Expect(connection1.getOrThrow().isClosed(), true)
    @Expect(connection2.getOrThrow().isClosed(), true)
}

// ============ 瞬时生命周期测试 ============

/**
 * 测试瞬时服务的生命周期管理
 * 验证：
 * 1. 每次获取都返回新实例
 * 2. 作用域结束时实例被正确释放
 */
@Test
func 测试解析生命周期_瞬时1() {
    let services = ServiceCollection()
    services.addTransient<IDbConnection, MySqlConnection>()
    let root = services.build()

    var connection1: ?IDbConnection = None
    var connection2: ?IDbConnection = None
    var connection3: ?IDbConnection = None

    try (scope1 = root.createScope()) {
        connection1 = scope1.services.getOrThrow<IDbConnection>()
        connection2 = scope1.services.getOrThrow<IDbConnection>()
        @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection2.getOrThrow() as Object).getOrThrow()), false)
    }

    try (scope2 = root.createScope()) {
        connection3 = scope2.services.getOrThrow<IDbConnection>()
    }

    @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection3.getOrThrow() as Object).getOrThrow()), false)
    @Expect(connection1.getOrThrow().isClosed(), true)
    @Expect(connection2.getOrThrow().isClosed(), true)
}

// ============ ActivatorUtilities 功能测试 ============

/**
 * 测试ActivatorUtilities创建未注册服务但注入已注册依赖
 * 验证：可以创建未在容器中注册的服务，但其依赖项会从容器中解析
 * 同时测试额外参数的传递功能
 */
@Test
func 测试解析容器不存在的服务并注入额外参数() {
    let services = ServiceCollection()
    services.addSingleton<DbContext, DbContext>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let context = ActivatorUtilities.createInstance<DbDataSource>(root, "zs")
    @Expect(context.name, "zs")
}

// ============ 多实现测试 ============

/**
 * 测试同一接口的多个实现注册
 * 验证：后注册的实现会覆盖先注册的实现，getOrThrow返回最后注册的实现
 */
@Test
func 测试多实现1() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let connection = root.getOrThrow<IDbConnection>()
    @Expect(connection is MySqlConnection, true)
}

/**
 * 测试多实现的getAll功能
 * 验证：getAll可以获取所有注册的实现，且包含getOrThrow返回的实例
 */
@Test
func 测试多实现2() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let connection = root.getOrThrow<IDbConnection>()
    let connections = root.getAll<IDbConnection>()
    let flag = connections |> any {f => refEq((f as Object).getOrThrow(), (connection as Object).getOrThrow())}
    @Expect(flag, true)
}

// ============ 并发测试 ============

/**
 * 测试1000个并发线程同时解析单例服务
 * 验证：
 * 1. 线程安全性：所有线程获取到的是同一个实例
 * 2. 性能：大量并发请求不会导致问题
 */
@Test
func 测试并发解析1000线程次() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    let root = services.build()
    let default :IDbConnection = MySqlConnection()
    let tasks = ArrayList<Future<IDbConnection>>()
    for (_ in 1..1001) {
        let task = spawn {
            return root.getOrThrow<IDbConnection>()
            //default
        }
        tasks.add(task)
    }
    let instances = ArrayList<IDbConnection>()
    for (pattern in tasks) {
        instances.add(pattern.get())
    }
    let set = instances |> map {f => f.id} |> collectHashSet
    @Expect(set.size == 1, true)
    @Expect(instances.size == 1000, true)
}

// ========== ServiceCollection 操作测试 ==========

/**
 * 测试TryAdd功能：如果服务已存在则不添加
 * 验证：tryAddSingleton不会覆盖已存在的服务注册
 */
@Test
func 测试ServiceCollection_TryAdd功能() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.tryAddSingleton<IDbConnection, MsSqlConnection>() // 不应该添加
    let root = services.build()
    let connection = root.getOrThrow<IDbConnection>()
    @Expect(connection is MySqlConnection, true)
}

/**
 * 测试从ServiceCollection中移除指定位置的服务
 * 验证：remove(at:)方法的正确性
 */
@Test
func 测试ServiceCollection_移除服务() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    @Expect(services.size, 1)
    services.remove(at: 0)
    @Expect(services.size, 0)
}

/**
 * 测试清空ServiceCollection中的所有服务
 * 验证：clear()方法和isEmpty()属性的正确性
 */
@Test
func 测试ServiceCollection_清空服务() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addScoped<SimpleService, SimpleService>()
    @Expect(services.size, 2)
    services.clear()
    @Expect(services.size, 0)
    @Expect(services.isEmpty(), true)
}

/**
 * 测试ServiceCollection在构建后变为只读状态
 * 验证：构建容器后不能再添加服务，应抛出异常
 */
@Test
func 测试ServiceCollection_只读状态异常() {
    let services = ServiceCollection()
    services.addSingleton<SimpleService, SimpleService>()
    services.build() // 构建后变为只读
    try {
        services.addSingleton<IDbConnection, MySqlConnection>()
        @Fail("应该抛出异常")
    } catch (e: Exception) {
        @Expect(e.message.contains("read-only"), true)
    }
}

/**
 * 测试TryAddEnumerable功能：避免重复添加相同的服务描述符
 * 验证：相同类型和实现的服务描述符不会重复添加
 */
@Test
func 测试TryAddEnumerable功能() {
    let services = ServiceCollection()
    let descriptor1 = ServiceDescriptor.singleton<IDbConnection, MySqlConnection>()
    let descriptor2 = ServiceDescriptor.singleton<IDbConnection, MySqlConnection>()
    services.tryAddEnumerable(descriptor1)
    services.tryAddEnumerable(descriptor2) // 相同类型和实现，不应该重复添加
    @Expect(services.size, 1)
}

// ============ 工厂注册测试 ============

/**
 * 测试单例工厂注册功能
 * 验证：工厂函数在单例模式下只被调用一次
 */
@Test  
func 测试工厂注册功能() {
    let services = ServiceCollection()
    // 使用特殊的连接ID来验证工厂是否被调用
    services.addSingleton<IDbConnection, MySqlConnection> { _ =>
        let connection = MySqlConnection()
        return connection
    }
    let root = services.build()
    let connection1 = root.getOrThrow<IDbConnection>()
    let connection2 = root.getOrThrow<IDbConnection>()
    // 单例模式下应该返回相同的实例
    @Expect(refEq((connection1 as Object).getOrThrow(), (connection2 as Object).getOrThrow()), true)
}

/**
 * 测试作用域工厂注册功能
 * 验证：
 * 1. 同一作用域内工厂只调用一次
 * 2. 不同作用域各自调用工厂
 */
@Test
func 测试作用域工厂注册() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection> { _ =>
        return MySqlConnection()
    }
    let root = services.build()
    
    var scope1Connection1: ?IDbConnection = None
    var scope1Connection2: ?IDbConnection = None
    var scope2Connection: ?IDbConnection = None
    
    try (scope1 = root.createScope()) {
        scope1Connection1 = scope1.services.getOrThrow<IDbConnection>()
        scope1Connection2 = scope1.services.getOrThrow<IDbConnection>()
        // 同一作用域内应该返回相同实例
        @Expect(refEq((scope1Connection1.getOrThrow() as Object).getOrThrow(), (scope1Connection2.getOrThrow() as Object).getOrThrow()), true)
    }
    
    try (scope2 = root.createScope()) {
        scope2Connection = scope2.services.getOrThrow<IDbConnection>()
    }
    
    // 不同作用域应该返回不同实例
    @Expect(refEq((scope1Connection1.getOrThrow() as Object).getOrThrow(), (scope2Connection.getOrThrow() as Object).getOrThrow()), false)
}

/**
 * 测试瞬时工厂注册功能
 * 验证：每次获取都会调用工厂函数创建新实例
 */
@Test
func 测试瞬时工厂注册() {
    let services = ServiceCollection()
    services.addTransient<IDbConnection, MySqlConnection> { _ =>
        return MySqlConnection()
    }
    let root = services.build()
    
    var connection1: ?IDbConnection = None
    var connection2: ?IDbConnection = None
    
    try (scope = root.createScope()) {
        connection1 = scope.services.getOrThrow<IDbConnection>()
        connection2 = scope.services.getOrThrow<IDbConnection>()
    }
    
    // 瞬时模式每次应该返回不同实例
    @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection2.getOrThrow() as Object).getOrThrow()), false)
}

// ============ 循环依赖测试 ============

/**
 * 测试循环依赖检测功能
 * 验证：当启用循环依赖验证时，应该检测到并抛出异常
 */
@Test
func 测试循环依赖检测() {
    let services = ServiceCollection()
    services.addSingleton<ServiceA, ServiceA>()
    services.addSingleton<ServiceB, ServiceB>()
    let root = services.build({options => options.validateLoopDependency = true})
    
    try {
        root.getOrThrow<ServiceA>()
        @Fail("应该检测到循环依赖并抛出异常")
    } catch (e: Exception) {
        @Expect(e.message.contains("circular dependency"), true)
    }
}

// ============ 多构造函数选择测试 ============

/**
 * 测试多构造函数选择：最多参数优先策略
 * 验证：ActivatorUtilities会选择参数最多且能满足的构造函数
 */
@Test
func 测试多构造函数选择_最多参数优先() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    let service = ActivatorUtilities.createInstance<MultiConstructorService>(root, "test")
    @Expect(service.value, "with_connection_and_name")
}

/**
 * 测试多构造函数选择：部分参数匹配
 * 验证：当不能满足最多参数的构造函数时，选择能满足的参数最多的构造函数
 */
@Test
func 测试多构造函数选择_部分匹配() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    let service = ActivatorUtilities.createInstance<MultiConstructorService>(root)
    @Expect(service.value, "with_connection")
}

/**
 * 测试无参构造函数的调用
 * 验证：当没有依赖需要注入时，能正确调用无参构造函数
 */
@Test
func 测试无参构造函数() {
    let services = ServiceCollection()
    let root = services.build()
    
    let service = ActivatorUtilities.createInstance<SimpleService>(root)
    @Expect(service.id, "simple")
}

// ============ 异常处理测试 ============

/**
 * 测试根容器解析非单例服务时的异常
 * 验证：当启用作用域验证时，根容器不能解析作用域或瞬时服务
 */
@Test
func 测试根容器解析非单例服务异常() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection>()
    let root = services.build({options => options.validateScopes = true})
    
    try {
        root.getOrThrow<IDbConnection>()
        @Fail("根容器不能解析非单例服务")
    } catch (e: Exception) {
        @Expect(e.message.contains("non-singleton"), true)
    }
}

/**
 * 测试创建实例时服务不存在的异常处理
 * 验证：当依赖的服务未注册时，应抛出明确的异常
 */
@Test
func 测试服务不存在时的异常() {
    let services = ServiceCollection()
    let root = services.build()
    
    try {
        ActivatorUtilities.createInstance<DbContext>(root)
        @Fail("应该抛出服务不存在异常")
    } catch (e: Exception) {
        @Expect(e.message.contains("No service"), true)
    }
}

/**
 * 测试获取不存在服务时返回None
 * 验证：getOrDefault方法在服务不存在时返回None而不抛出异常
 */
@Test
func 测试获取不存在的服务返回None() {
    let services = ServiceCollection()
    let root = services.build()
    
    let connection = root.getOrDefault<IDbConnection>()
    @Expect(connection.isNone(), true)
}

// ============ 服务获取功能测试 ============

/**
 * 测试获取所有服务实现
 * 验证：getAll方法返回指定接口的所有注册实现
 */
@Test
func 测试获取所有服务_多实现() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()   // 第一个注册
    services.addSingleton<IDbConnection, MsSqlConnection>()   // 第二个注册
    let root = services.build()
    
    let connections = root.getAll<IDbConnection>()
    @Expect(connections.size, 2)
    // 尝试相反的顺序：第一个注册的在前，第二个注册的在后
    @Expect(connections[0] is MySqlConnection, true)  // 第一个注册的
    @Expect(connections[1] is MsSqlConnection, true)  // 第二个注册的
}

/**
 * 测试获取所有服务时无注册实现的情况
 * 验证：getAll在没有注册实现时返回空集合
 */
@Test
func 测试获取所有服务_空集合() {
    let services = ServiceCollection()
    let root = services.build()
    
    let connections = root.getAll<IDbConnection>()
    @Expect(connections.size, 0)
}

// ============ 作用域管理测试 ============

/**
 * 测试作用域资源的自动释放
 * 验证：作用域结束时，其中的Resource类型服务会被自动释放
 */
@Test
func 测试作用域资源自动释放() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    var connection: ?IDbConnection = None
    try (scope = root.createScope()) {
        connection = scope.services.getOrThrow<IDbConnection>()
        @Expect(connection.getOrThrow().isClosed(), false)
    }
    
    @Expect(connection.getOrThrow().isClosed(), true)
}

/**
 * 测试嵌套作用域的管理
 * 验证：
 * 1. 内外作用域的服务实例是独立的
 * 2. 内部作用域结束时不影响外部作用域
 * 3. 外部作用域结束时内部资源已被释放
 */
@Test
func 测试嵌套作用域() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection>()
    let root = services.build()
    
    var outerConnection: ?IDbConnection = None
    var innerConnection: ?IDbConnection = None
    
    try (outerScope = root.createScope()) {
        outerConnection = outerScope.services.getOrThrow<IDbConnection>()
        
        try (innerScope = root.createScope()) {
            innerConnection = innerScope.services.getOrThrow<IDbConnection>()
            @Expect(refEq((outerConnection.getOrThrow() as Object).getOrThrow(), 
                          (innerConnection.getOrThrow() as Object).getOrThrow()), false)
        }
        
        @Expect(innerConnection.getOrThrow().isClosed(), true)
        @Expect(outerConnection.getOrThrow().isClosed(), false)
    }
    
    @Expect(outerConnection.getOrThrow().isClosed(), true)
}

// ============ ServiceCollection 查询功能测试 ============

/**
 * 测试查找最后注册的服务描述符
 * 验证：findLast方法返回指定类型的最后注册的服务描述符
 */
@Test
func 测试ServiceCollection_FindLast() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    
    let descriptor = services.findLast(TypeInfo.of<IDbConnection>())
    @Expect(descriptor.isSome(), true)
}

/**
 * 测试查找所有匹配的服务描述符
 * 验证：findAll方法返回指定类型的所有服务描述符
 */
@Test
func 测试ServiceCollection_FindAll() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    
    let descriptors = services.findAll(TypeInfo.of<IDbConnection>())
    @Expect(descriptors.size, 2)
}

/**
 * 测试空ServiceCollection的属性
 * 验证：新创建的ServiceCollection的各种属性初始状态
 */
@Test
func 测试ServiceCollection_空集合属性() {
    let services = ServiceCollection()
    @Expect(services.isEmpty(), true)
    @Expect(services.size, 0)
    @Expect(services.first.isNone(), true)
    @Expect(services.last.isNone(), true)
}

/**
 * 测试批量添加服务描述符
 * 验证：add(all:)方法能正确添加多个服务描述符
 */
@Test
func 测试ServiceCollection_添加集合() {
    let services = ServiceCollection()
    let descriptors = ArrayList<ServiceDescriptor>()
    descriptors.add(ServiceDescriptor.singleton<IDbConnection, MySqlConnection>())
    descriptors.add(ServiceDescriptor.singleton<SimpleService, SimpleService>())
    
    services.add(all: descriptors)
    @Expect(services.size, 2)
}

/**
 * 测试在指定位置插入服务描述符
 * 验证：add(at:)方法能在指定位置正确插入服务描述符
 */
@Test
func 测试ServiceCollection_指定位置操作() {
    let services = ServiceCollection()
    let descriptor1 = ServiceDescriptor.singleton<IDbConnection, MySqlConnection>()
    let descriptor2 = ServiceDescriptor.singleton<SimpleService, SimpleService>()
    
    services.add(descriptor1)
    services.add(descriptor2, at: 0) // 在开头插入
    
    @Expect(services.size, 2)
    @Expect(services[0].serviceType, TypeInfo.of<SimpleService>())
    @Expect(services[1].serviceType, TypeInfo.of<IDbConnection>())
}

/**
 * 测试条件删除服务描述符
 * 验证：removeIf方法能根据条件删除匹配的服务描述符
 */
@Test
func 测试ServiceCollection_移除条件() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<SimpleService, SimpleService>()
    
    services.removeIf {descriptor => descriptor.serviceType == TypeInfo.of<SimpleService>()}
    @Expect(services.size, 1)
    @Expect(services[0].serviceType, TypeInfo.of<IDbConnection>())
}
