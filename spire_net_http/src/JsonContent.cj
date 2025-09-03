package spire_net_http

import std.io.*
import stdx.encoding.json.*
import stdx.serialization.serialization.*

public class JsonContent <: HttpContent {
    private let body: InputStream

    private init(json: String) {
        body = ByteBuffer(json.toArray())
        headers.add(HeaderNames.ContentType, "application/json; charset=utf-8")
    }

    public static func create<T>(data: T) where T <: Serializable<T> {
        let json = data.serialize().toJson().toJsonString()
        return JsonContent(json)
    }

    public static func create(json: String) {
        return JsonContent(json)
    }

    public func readAsStream(): InputStream {
        return body
    }
}
