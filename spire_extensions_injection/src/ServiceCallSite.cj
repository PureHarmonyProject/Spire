package spire_extensions_injection

import std.sync.*
import std.reflect.*

/*
图纸
 */
abstract class ServiceCallSite {
    private var _lock: ?Mutex = None
    private let _hasLock = AtomicBool(false)
    private let _kind: CallSiteKind //图纸类型
    private var _value: ?Object = None //生成的产物
    private let _cache: CallSiteResultCache //存放的位置

    protected init(kind: CallSiteKind, cache: CallSiteResultCache) {
        _kind = kind
        _cache = cache
    }

    public prop kind: CallSiteKind {
        get() {
            _kind
        }
    }

    public mut prop value: ?Object {
        get() {
            _value
        }
        set(value) {
            _value = value
        }
    }

    public prop cache: CallSiteResultCache {
        get() {
            _cache
        }
    }

    public prop lock: Mutex {
        get() {
            if (_hasLock.compareAndSwap(false, true)) {
                _lock = Mutex()
            }
            return _lock.getOrThrow()
        }
    }

    public prop serviceType: TypeInfo

    public prop implementationType: ?TypeInfo
}
