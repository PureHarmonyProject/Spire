// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_identity_tokens

import std.io.*
import std.fs.*

import stdx.crypto.keys.*

public class SecurityKeyHelper {
    public static func readFile(path: String) {
        return File(path, OpenMode.Read) |> readToEnd
    }

    public static func createRSAPublicKeyFromDerFile(path: String) {
        RSAPublicKey.decodeFromPem(String.fromUtf8(readFile(path)))
    }

    public static func createRSAPrivateKeyFromDerFile(path: String) {
        RSAPrivateKey.decodeFromPem(String.fromUtf8(readFile(path)))
    }
}