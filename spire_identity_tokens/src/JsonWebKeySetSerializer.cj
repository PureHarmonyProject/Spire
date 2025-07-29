package spire_identity_tokens

import std.io.*
import stdx.encoding.json.*

public class JsonWebKeySetSerializer {
    public static func read(json: String, jsonWebKeySet: JsonWebKeySet) {
        let jsonObj = JsonValue.fromStr(json).asObject()
        if (let Some(keys) <- jsonObj.get("keys").flatMap {f => f.asArray()}) {
            for (pattern in keys.getItems()) {
                let jsonWebKey = JsonWebKey()
                JsonWebKeySerializer.read(pattern, jsonWebKey)
                jsonWebKeySet.keys.add(jsonWebKey)
            }
        }
    }

    public static func write(jsonWebKeySet: JsonWebKeySet) {
        let keys = JsonArray()
        for (pattern in jsonWebKeySet.keys) {
            keys.add(JsonObject.fromStr(JsonWebKeySerializer.write(pattern)))
        }
        let jsonObj = JsonObject()
        jsonObj.put("keys", keys)
        return jsonObj.toJsonString()
    }
}
