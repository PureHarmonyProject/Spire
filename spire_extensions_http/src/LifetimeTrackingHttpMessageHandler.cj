package spire_extensions_http

import spire_net_http.*

class LifetimeTrackingHttpMessageHandler <: DelegatingHandler {
    init(innerHandler: HttpMessageHandler) {
        super(innerHandler)
    }

    protected override func close(_: Bool) {
        //其生命周期由ActiveHandlerTrackingEntry单独跟踪
        //DelegatingHandler中的close会递归释放处理链，因此我们只需要释放头节点和头节点的innerHandler即可
    }
}
