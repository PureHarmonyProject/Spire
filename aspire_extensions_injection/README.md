# aspire_extensions_injection
依赖注入（DI）框架，用于管理应用程序中的 依赖对象的创建和生命周期。提供了模块化、可扩展的方式来管理组件依赖。

## 生命周期

| 周期                                               | 说明                                                     |
|---------------------------------------------------|----------------------------------------------------------|
| **Singleton**                                     | 单例：一个根容器及其子容器，只创建一个实列                   |
| **Scoped**                                        | 作用域：同一个作用域只创建一个实列，生命周期由业务定义        |
| **Transient**                                     | 瞬时：每次解析都是一个新的实列                              |

## 服务注册

``` cangjie
//创建服务描述集合
let services = ServiceCollection()

//1. 注册单列
services.addSingleton(DbContext())

//2. 服务类型和实现类型
services.addSingleton<IDbConnection, MySqlConnection>()

//3. 尝试注册，如果IDbConnection服务已注册将不在注册
services.tryAddSingleton<IDbConnection, MySqlConnection>()

//4. 通过工厂模式注册：该方式性能最佳，可以规避反射
services.addSingleton<DbContext, DbContext>{ sp => 
    let connection = sp.getOrThrow<IDbConnection>()
    return DbContext(connection)
}

//5. 如果DbContext依赖项很多可以通过ActivatorUtilities来注册
services.addSingleton<DbContext, DbContext>{ sp => 
    return ActivatorUtilities.createInstance<DbContext>(sp)
}

//6. 通过TypeInfo的方式注册
services.addSingleton(TypeInfo.of<DbContext>(), TypeInfo.of<DbContext>())
```

> 由于cangjie不支持泛型重载导致必须指定服务类型和实现类型，你可以通过`扩展+新名称`的方式来规避    
>  `Singleton`改成`Scoped`或`Transient`可以注册不同的生命周期

## 服务解析

* 解析服务自身

``` cangjie
let services = ServiceCollection()

//构建服务提供程序
let provider = services.build()

//解析服务自身
let providerSelf = provder.getOrThrow<IServiceProvider>()
``` 

* 解析多实现

* 解析服务自身

``` cangjie
let services = ServiceCollection()
services.addSingleton<IDbConnection, MsSqlConnection>()
services.addSingleton<IDbConnection, MySqlConnection>()
//构建服务提供程序
let provider = services.build()
//解析IDbConnection注册的所有实现
let connections = provder.getAll<IDbConnection>()
``` 

* 创建作用域

``` cangjie
let services = ServiceCollection()
services.addScoped<IDbConnection, MsSqlConnection>()
//构建服务提供程序
let provider = services.build()
try(scope = provider.createScope()) {
    let connection = scope.services.getOrThrow<IDbConnection>()
}
```
> try语句块执行结束，将释放由该作用域解析的所有非单例的服务    
> 如果服务实现了`Resouce`接口，那么将执行该服务的close方法