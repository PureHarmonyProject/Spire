# spire_net_http

提供用于处理基于 HTTP（或 HTTPS）协议网络通信的库。它包含了处理 HTTP 请求与响应所需的类和工具，最常用的核心类是 HttpClient，并且提供aop能力的支持

# dependencies

无

# quickstart

```cangjie
package spire_net_http

import stdx.net.http.*
import stdx.encoding.url.*

main() {
    //创建调用链
    let handler = LoggingHandler(AuthHandler(HttpClientHandler()))
    let client = HttpClient(handler)
    client.getString("https://www.baidu.com/?tn=68018901_16_pg") |> println
    return 0
}

/*处理日志记录*/
public class LoggingHandler <: DelegatingHandler {
    public init(innerHandler: HttpMessageHandler){
        super(innerHandler)
    }

    public override func send(request: HttpRequestMessage) {
        println("LoggingHandler:start")
        let response = super.send(request)
        println("LoggingHandler:ended")
        return response
    }
}

/*处理身份认证*/
public class AuthHandler <: DelegatingHandler {
    public init(innerHandler: HttpMessageHandler){
        super(innerHandler)
    }

    public override func send(request: HttpRequestMessage) {
        println("AuthHandler:start")
        let response = super.send(request)
        println("AuthHandler:ended")
        return response
    }
}
```

# multipart/form-data

``` cangjie
let content = MultipartFormDataContent()
content.add(StringContent("ff1"), "P1")
content.add(StringContent("ff1"), "P2")
content.add(ByteArrayContent("ff".toArray()), "P3", "ff.txt")
let client = HttpClient()
client.address = URL.parse("https://localhost:7064")
client.post("/upload", content)
```