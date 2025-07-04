package aspire_identity_tokens_jwt

import std.fs.*
import std.io.*
import std.time.*
import std.collection.*
import stdx.crypto.digest.*
import stdx.crypto.x509.*
import stdx.crypto.keys.*
import stdx.encoding.hex.*
import aspire_identity_tokens.*

// main(): Int64 {
//     //let securityKey = SymmetricSecurityKey("SECUZebfRscapBanPymcs5CZEJpEFjSISECUZebfRscapBanPymcs5CZEJpEFjSI".toArray())
//     //println(String.fromUtf8(readToEnd(File("ec256-private.pem", OpenMode.Read))))
//     let pem = RSAPrivateKey.decodeFromPem(String.fromUtf8(readToEnd(File("ec256-private.pem", OpenMode.Read))))
//     let securityKey = RsaSecurityKey(privateKey: pem)
//     let header = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256))
//     let payload = JwtPayload(
//         issuer: "aspire",
//         audience: "cangjie",
//         notBefore: DateTime.now(),
//         expires: DateTime.now(),
//         claims: [("sub", "1024")]
//     )
//     // payload.add("id", 1)
//     // payload.add("id", 2)
//     payload.add("iss", "cangjie")
//     payload.add("iss", "cangjie")
  
//     println(payload.toJsonString())
   
//     var jwtToken = JwtSecurityToken(header, payload)
//     let tokenHandler = JwtSecurityTokenHandler()
//     tokenHandler.writeToken(jwtToken) |> println
//     var parameters = TokenValidationParameters()
//     parameters.issuerSigningKey = securityKey
//     parameters.validIssuer = "cangjie"
//     parameters.validAudience = "cangjie"
//     parameters.requireExpirationTime = false
//     let result = tokenHandler.validateToken(tokenHandler.writeToken(jwtToken), parameters)
//     if (!result.isValid && let Some(ex) <- result.exception) {
//         ex.printStackTrace()
//     }
//     if (result.isValid) {
//         for (pattern in result.subject.claims) {
//             println("${pattern.name}=${pattern.value}")
//         }
//     }
//     return 0
// }

main() {

let token = 'ewogICJhbGciOiAiSFMyNTYiLAogICJ0eXAiOiAiSldUIgp9.ewogICJzdWIiOiAiMTAyNCIsCiAgImlzcyI6ICJhc3BpcmUiLAogICJhdWQiOiAiY2FuZ2ppZSIsCiAgIm5iZiI6IDE3NTE2MjEwMzcsCiAgImV4cCI6IDE3NTE2MjQ2MzcKfQ.O3ZoMwRd4ysH52w4DYyIxc2a21TiMz8GnzWNk612fa0'
let securityKey = SymmetricSecurityKey("vIBUnd5LbR3WWddFn6D6c0YUXm8v7BA2vog4CLFInYmDM6RZJHg7E0Jqagomh".toArray())
var parameters = TokenValidationParameters()
parameters.issuerSigningKey = securityKey
parameters.validIssuer = "aspire"
parameters.validAudience = "cangjie"
parameters.requireExpirationTime = true

let tokenHandler = JwtSecurityTokenHandler()
let result = tokenHandler.validateToken(token, parameters)
if (!result.isValid && let Some(ex) <- result.exception) {
    ex.printStackTrace()
}else {
    "验证成功" |> println
}
    return 0
}