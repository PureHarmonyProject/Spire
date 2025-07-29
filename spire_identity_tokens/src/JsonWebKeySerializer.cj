package spire_identity_tokens

import std.io.*
import stdx.encoding.json.*

public class JsonWebKeySerializer {
    public static func read(jsonValue: JsonValue, jsonWebKey: JsonWebKey) {
        let jsonObj = jsonValue.asObject()
        jsonWebKey.e = jsonObj.get("e").flatMap {f => f.asString().toString()}
        jsonWebKey.k = jsonObj.get("k").flatMap {f => f.asString().toString()}
        jsonWebKey.n = jsonObj.get("n").flatMap {f => f.asString().toString()}
        jsonWebKey.d = jsonObj.get("d").flatMap {f => f.asString().toString()}
        jsonWebKey.x = jsonObj.get("x").flatMap {f => f.asString().toString()}
        jsonWebKey.y = jsonObj.get("y").flatMap {f => f.asString().toString()}
        jsonWebKey.p = jsonObj.get("p").flatMap {f => f.asString().toString()}
        jsonWebKey.q = jsonObj.get("q").flatMap {f => f.asString().toString()}
        jsonWebKey.qi = jsonObj.get("qi").flatMap {f => f.asString().toString()}
        jsonWebKey.dp = jsonObj.get("dp").flatMap {f => f.asString().toString()}
        jsonWebKey.dq = jsonObj.get("dq").flatMap {f => f.asString().toString()}
        jsonWebKey.kid = jsonObj.get("kid").flatMap {f => f.asString().toString()}
        jsonWebKey.x5c = jsonObj.get("x5c").flatMap {f => f.asString().toString()}
        jsonWebKey.x5t = jsonObj.get("x5t").flatMap {f => f.asString().toString()}
        jsonWebKey.x5u = jsonObj.get("x5u").flatMap {f => f.asString().toString()}
        jsonWebKey.crv = jsonObj.get("crv").flatMap {f => f.asString().toString()}
        jsonWebKey.kty = jsonObj.get("kty").flatMap {f => f.asString().toString()}
        jsonWebKey.use = jsonObj.get("use").flatMap {f => f.asString().toString()}
        jsonWebKey.alg = jsonObj.get("alg").flatMap {f => f.asString().toString()}
        jsonWebKey.x5tS256 = jsonObj.get("x5tS256").flatMap {f => f.asString().toString()}
    }

    public static func read(json: String, jsonWebKey: JsonWebKey): Unit {
        read(JsonValue.fromStr(json), jsonWebKey)
    }

    public static func write(jsonWebKey: JsonWebKey): String {
        let obj = JsonObject()
        if (let Some(e) <- jsonWebKey.e) {
            obj.put("e", JsonString(e))
        }
        if (let Some(k) <- jsonWebKey.k) {
            obj.put("k", JsonString(k))
        }
        if (let Some(n) <- jsonWebKey.n) {
            obj.put("n", JsonString(n))
        }
        if (let Some(d) <- jsonWebKey.d) {
            obj.put("d", JsonString(d))
        }
        if (let Some(x) <- jsonWebKey.x) {
            obj.put("x", JsonString(x))
        }
        if (let Some(y) <- jsonWebKey.y) {
            obj.put("y", JsonString(y))
        }
        if (let Some(p) <- jsonWebKey.p) {
            obj.put("p", JsonString(p))
        }
        if (let Some(q) <- jsonWebKey.q) {
            obj.put("q", JsonString(q))
        }
        if (let Some(qi) <- jsonWebKey.qi) {
            obj.put("qi", JsonString(qi))
        }
        if (let Some(dp) <- jsonWebKey.dp) {
            obj.put("dp", JsonString(dp))
        }
        if (let Some(dq) <- jsonWebKey.dq) {
            obj.put("dq", JsonString(dq))
        }
        if (let Some(kid) <- jsonWebKey.kid) {
            obj.put("kid", JsonString(kid))
        }
        if (let Some(x5c) <- jsonWebKey.x5c) {
            obj.put("x5c", JsonString(x5c))
        }
        if (let Some(x5t) <- jsonWebKey.x5t) {
            obj.put("x5t", JsonString(x5t))
        }
        if (let Some(x5u) <- jsonWebKey.x5u) {
            obj.put("x5u", JsonString(x5u))
        }
        if (let Some(crv) <- jsonWebKey.crv) {
            obj.put("crv", JsonString(crv))
        }
        if (let Some(kty) <- jsonWebKey.kty) {
            obj.put("kty", JsonString(kty))
        }
        if (let Some(use) <- jsonWebKey.use) {
            obj.put("use", JsonString(use))
        }
        if (let Some(alg) <- jsonWebKey.alg) {
            obj.put("alg", JsonString(alg))
        }
        if (let Some(x5tS256) <- jsonWebKey.x5tS256) {
            obj.put("x5tS256", JsonString(x5tS256))
        }
        return obj.toJsonString()
    }
}
