package spire_extensions_http

import std.sync.*
import spire_extensions_injection.*

type TimerCallback = () -> Unit

class ActiveHandlerTrackingEntry {
    private let _operationStarted = AtomicBool(false)

    ActiveHandlerTrackingEntry(let name: String, let lefetime: Duration, let scope: IServiceScope,
        let handler: LifetimeTrackingHttpMessageHandler) {
    }

    public func startExpiryTimer(callback: TimerCallback) {
        if (lefetime == Duration.Zero) {
            return
        }

        if (_operationStarted.load()) {
            return
        }

        startExpiryTimerSlow(callback)
    }

    private func startExpiryTimerSlow(callback: TimerCallback) {            
        if (_operationStarted.compareAndSwap(false, true)) {           
            Timer.once(lefetime, callback)
        }
    }
}
