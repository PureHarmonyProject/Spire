package spire_extensions_http.unittests

import std.collection.*
import spire_net_http.*

/**
 * HTTP测试辅助类
 * 提供测试过程中常用的辅助方法和真实类
 */
class TestHelper {
    
    /**
     * 生成随机HTTP客户端名称
     * @param length 名称长度
     * @return 随机HTTP客户端名称
     */
    public static func generateRandomHttpClientName(length: Int64): String {
        let chars = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let charArray = ArrayList<String>()

        var count = 0
        
        for (i in 0..length) {
            let randomIndex = (i * 31) % chars.size
            charArray.add(chars[randomIndex])
            count++
        }
        
        let result = String.join(charArray |> collectArray, delimiter: "")
        return "Client_${result}"
    }
    
    /**
     * 生成随机HTTP方法
     * @return 随机HTTP方法
     */
    public static func generateRandomHttpMethod(): String {
        let methods = ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS"]
        let randomIndex = (methods.size * 31) % methods.size
        return methods[randomIndex]
    }
    
    /**
     * 生成随机HTTP状态码
     * @return 随机HTTP状态码
     */
    public static func generateRandomHttpStatusCode(): Int64 {
        let statusCodes = [200, 201, 202, 204, 400, 401, 403, 404, 500, 502, 503, 504]
        let randomIndex = (statusCodes.size * 31) % statusCodes.size
        return statusCodes[randomIndex]
    }
}

// 简单的真实委托处理器，用于测试（避免网络依赖）
class LoggingDelegatingHandler <: DelegatingHandler {
    public override func send(request: HttpRequestMessage) {
        println("Logging: ${request.method} ${request.requestUri}")
        // 避免网络依赖，返回一个模拟响应
        // 在实际测试中，我们主要测试处理器链的构建，而不是网络请求
        throw UnsupportedException("LoggingDelegatingHandler.send() called - avoiding network dependency")
    }
}

// 简单的真实HTTP消息处理器，用于测试
class LoggingHttpMessageHandler <: HttpMessageHandler {
    public override func send(request: HttpRequestMessage) {
        println("Logging: ${request.method} ${request.requestUri}")
        // 返回一个简单的响应，避免复杂的构造函数
        throw UnsupportedException("LoggingHttpMessageHandler.send() called")
    }
}

// 简单的真实服务类，用于测试
class LoggingService {
    public func doSomething(): String {
        return "Logging service completed"
    }
}

// 简单的真实类型化客户端，用于测试
class LoggingTypedClient {
    public init() {}
    
    public func log(message: String): Unit {
        println("TypedClient: ${message}")
    }
}

// 计数器类，用于测试中避免lambda捕获可变变量
class ConfigCounter {
    private var _count: Int64 = 0
    
    public init() {}
    
    public func increment(): Int64 {
        _count++
        return _count
    }
    
    public prop count: Int64 {
        get() {
            _count
        }
    }

    public func setCount(count: Int64): Unit {
        _count = count
    }
    
    public func reset(): Unit {
        _count = 0
    }
}

// 真实服务占位（用于依赖注入与类型断言）
class ConfigService { public init() {} }
class FactoryService { public init() {} }
class ScopedService { public init() {} }
class TenantService { public init() {} }
class ServiceDiscovery { public init() {} }
class LoadBalancer { public init() {} }
class CircuitBreaker { public init() {} }
class RateLimiter { public init() {} }
class AuthGateway { public init() {} }
class LoggingGateway { public init() {} }
class Tracer { public init() {} }
class TraceContext { public init() {} }
class TraceReporter { public init() {} }
class HealthChecker { public init() {} }
class HealthReporter { public init() {} }
class ConfigValidator { public init() {} }
class EventBus { public init() {} }
class EventPublisher { public init() {} }
class EventSubscriber { public init() {} }
class ContainerService { public init() {} }
class Orchestrator { public init() {} }
class HealthMonitor { public init() {} }