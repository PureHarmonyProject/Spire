package spire_extensions_http

import std.sync.*
import spire_net_http.*
import spire_extensions_options.*
import std.collection.concurrent.*
import spire_extensions_injection.*

/*
该类是单例的并且线程安全的，需要关注多线创建同名的client导致的并发安全问题
 */
class DefaultHttpClientFactory <: IHttpClientFactory & IHttpMessageHandlerFactory {
    private var _cleanupTimer: ?Timer = None
    private let _cleanupTimerLock = Mutex()
    private let _cleanupActiveLock = Mutex()
    private static let _cleanupInterval = Duration.second * 5

    private let _serviceScopeFactory: IServiceScopeFactory
    private let _optionsMonitor: IOptionsMonitor<HttpClientFactoryOptions>
    private let _activeHandlers = ConcurrentHashMap<String, ActiveHandlerTrackingEntry>()
    private let _expiredHandlers = ConcurrentLinkedQueue<ExpiredHandlerTrackingEntry>()

    public init(serviceScopeFactory: IServiceScopeFactory, optionsMonitor: IOptionsMonitor<HttpClientFactoryOptions>) {
        _serviceScopeFactory = serviceScopeFactory
        _optionsMonitor = optionsMonitor
    }

    public func createClient(name: String): HttpClient {
        let options = _optionsMonitor.get(name)
        let handler = createHandler(name)
        let client = HttpClient(handler, false)
        for (action in options.httpClientActions) {
            action(client)
        }
        return client
    }

    public func createHandler(name: String): HttpMessageHandler {
        //处理器应被设计为线程安全的
        let entry = _activeHandlers
            .entryView(name) {
                view => if (view.value.isNone()) {
                    view.value = createHandlerEntry(name)
                }
            }
            .getOrThrow()
        startHandlerEntryTimer(entry)
        return entry.handler
    }

    private func createHandlerEntry(name: String): ActiveHandlerTrackingEntry {
        let scope = _serviceScopeFactory.createScope()
        let options = _optionsMonitor.get(name)
        try {
            let builder = scope.services.getOrThrow<HttpMessageHandlerBuilder>()
            builder.name = name
            for (action in options.httpMessageHandlerBuilderActions) {
                action(builder)
            }
            // 转换成支持生命周期跟踪的处理器
            let handler = LifetimeTrackingHttpMessageHandler(builder.build())
            return ActiveHandlerTrackingEntry(name, options.handlerLifetime, scope, handler)
        } catch (ex: Exception) {
            scope.close()
            throw ex
        }
    }

    /*
    启动活动项关联的定时器
     */
    private func startHandlerEntryTimer(entry: ActiveHandlerTrackingEntry) {
        entry.startExpiryTimer {
            expiryTimerTick(entry)
        }
    }

    /*
    活动项关联的定时器执行的任务
     */
    private func expiryTimerTick(active: ActiveHandlerTrackingEntry) {
        _activeHandlers.remove(active.name)
        let expired = ExpiredHandlerTrackingEntry(active)
        _expiredHandlers.add(expired)
        //启动清理线程
        startCleanupTimer()
    }

    /*
    启动垃圾回收定时器
     */
    public func startCleanupTimer(): Unit {
        //如果同时触发，那么丢弃
        synchronized(_cleanupTimerLock) {
            if (_cleanupTimer.isNone()) {
                _cleanupTimer = Timer.once(_cleanupInterval, cleanupTimerTick)
            }
        }
    }

    /*
    停止垃圾回收定时器
     */
    public func stopCleanupTimer() {
        synchronized(_cleanupTimerLock) {
            _cleanupTimer = None
        }
    }

    /*
    垃圾回收定时器执行的任务
     */
    private func cleanupTimerTick() {
        //停止定时器
        stopCleanupTimer()

        //如果由于上个清理任务未完成，那么安排下次清理   
        if (!_cleanupActiveLock.tryLock()) {
            startCleanupTimer()
        }

        try {
            let initialCount = _expiredHandlers.size
            for (_ in 0..initialCount) {
                let entry = _expiredHandlers.remove().getOrThrow()
                if (entry.canDispose) {
                    try {
                        entry.innerHandler?.close()
                        entry.scope.close()
                    } catch (ex: Exception) {
                        ex.printStackTrace()
                    }
                } else {
                    _expiredHandlers.add(entry)
                }
            }
        } finally {
            _cleanupActiveLock.unlock()
        }

        if (!_expiredHandlers.isEmpty()) {
            println(_expiredHandlers.size)
            startCleanupTimer()
        }
    }
}
