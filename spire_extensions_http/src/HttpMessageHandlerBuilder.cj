package spire_extensions_http

import std.reflect.*
import std.collection.*
import spire_net_http.*
import spire_extensions_injection.*

public abstract class HttpMessageHandlerBuilder {
    public mut prop name: ?String
   
    public prop services: IServiceProvider
   
    public mut prop primaryHandler: HttpMessageHandler
   
    public prop additionalHandlers: List<DelegatingHandler>
   
    public func build(): HttpMessageHandler
    
    protected func createHandlerPipeline(primaryHandler: HttpMessageHandler, additionalHandlers: Collection<DelegatingHandler>): HttpMessageHandler {
        let additionalHandlersList = additionalHandlers.toArray()
       
        var next = primaryHandler

        let i = additionalHandlers.size - 1
        while (i >= 0) {
            let handler = additionalHandlersList[i]
            if (handler.innerHandler.isSome()) {
                throw UnsupportedException("The 'innerHandler' property must be null. 'DelegatingHandler' instances provided to 'HttpMessageHandlerBuilder' must not be reused or cached.\r\nHandler: '${ClassTypeInfo.of(handler)}'")
            }

            handler.innerHandler = next
            next = handler
        }
      
        return next
    }
}
