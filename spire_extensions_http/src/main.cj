package spire_extensions_http

import std.ref.*
import std.runtime.*
import spire_net_http.*
import spire_extensions_injection.*

main(): Int64 {
    let services = ServiceCollection()
    services.addHttpClient()
    services.addHttpClient("dev")
        .setHandlerLifetime(Duration.second * 3)
        .addHttpMessageHandler{Logging1DelegatingHandler()}
    services.configureHttpClientDefaults {
        b => b.addHttpMessageHandler {Logging1DelegatingHandler()}
            .addHttpMessageHandler {Logging2DelegatingHandler()}
            .setHandlerLifetime(Duration.second * 2)
    }
    let provider = services.build()
    let factory = provider.getOrThrow<IHttpClientFactory>()
    test1(factory)
    gc()
    sleep(Duration.second * 20)
    println()
    //test2(factory)
    gc()
    sleep(Duration.second * 20)
    gc()
    sleep(Duration.second * 20)
    return 0
}

private func test1(factory: IHttpClientFactory) {
    let client1 = factory.createClient()
    let client2 = factory.createClient("dev")

    client1.getString("http://127.0.0.1:4523/m1/3694996-3324920-default/test") |> println
    "===================================A==============================="|> println
    client2.getString("http://127.0.0.1:4523/m1/3694996-3324920-default/test") |> println
    
}

private func test2(factory: IHttpClientFactory) {
    let client1 = factory.createClient()
    let client2 = factory.createClient("dev")

    client1.getString("http://127.0.0.1:4523/m1/3694996-3324920-default/test") |> println
    "===================================A==============================="|> println
    client2.getString("http://127.0.0.1:4523/m1/3694996-3324920-default/test") |> println
}


class Student {
    
}

class Logging1DelegatingHandler <: DelegatingHandler {
    public override func send(request: HttpRequestMessage) {
        println("Logging1:start...")
        let response = super.send(request)
        println("Logging1:end...")
        return response
    }

    public override func close(closing: Bool) {
        println("a closed")
        super.close(closing)
    }
}

class Logging2DelegatingHandler <: DelegatingHandler {
    public override func send(request: HttpRequestMessage) {
        println("Logging2:start...")
        let response = super.send(request)
        println("Logging2:end...")
        return response
    }

    public override func close(closing: Bool) {
        println("b closed")
        super.close(closing)
    }
}
