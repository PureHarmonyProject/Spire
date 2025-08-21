package spire_extensions_http

import spire_net_http.*
import spire_extensions_injection.*

main(): Int64 {
    let services = ServiceCollection()
    services.addHttpClient()
    services.addHttpClient("dev")
        .addHttpMessageHandler{Logging1DelegatingHandler()}
    services.configureHttpClientDefaults {
        b => b.addHttpMessageHandler {Logging1DelegatingHandler()}.addHttpMessageHandler {Logging2DelegatingHandler()}
    }
    let provider = services.build()
    let factory = provider.getOrThrow<IHttpClientFactory>()
    let client1 = factory.createClient()
    let client2 = factory.createClient("dev")

    client1.getString("http://127.0.0.1:4523/m1/3694996-3324920-default/test") |> println
    "======================================================================="|> println
    client2.getString("http://127.0.0.1:4523/m1/3694996-3324920-default/test") |> println

    return 0
}

class Logging1DelegatingHandler <: DelegatingHandler {
    public override func send(request: HttpRequestMessage) {
        println("Logging1:start...")
        let response = super.send(request)
        println("Logging1:end...")
        return response
    }
}

class Logging2DelegatingHandler <: DelegatingHandler {
    public override func send(request: HttpRequestMessage) {
        println("Logging2:start...")
        let response = super.send(request)
        println("Logging2:end...")
        return response
    }
}
