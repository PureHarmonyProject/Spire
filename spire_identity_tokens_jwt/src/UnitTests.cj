package spire_identity_tokens_jwt

import std.io.*
import std.fs.*
import std.time.*
import stdx.crypto.keys.*
import std.unittest.*
import std.unittest.testmacro.*
import spire_identity_tokens.*

@Test
func 基础测试() {
    let securityKey = SymmetricSecurityKey("SECUZebfRscapBanPymcs5CZEJpEFjSISECUZebfRscapBanPymcs5CZEJpEFjSI".toArray())
    let header = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256))
    let payload = JwtPayload(
        issuer: "spire",
        audience: "cangjie",
        notBefore: DateTime.now(),
        expires: DateTime.now().addMinutes(10),
        claims: [("sub", "1024")]
    )
    var jwtToken = JwtSecurityToken(header, payload)
    let tokenHandler = JwtSecurityTokenHandler()
    let accessToken = tokenHandler.writeToken(jwtToken)

    //验证
    var parameters = TokenValidationParameters()
    parameters.issuerSigningKey = securityKey
    parameters.validIssuer = "spire"
    parameters.validAudience = "cangjie"
    let result = tokenHandler.validateToken(accessToken, parameters)
    if (result.isValid) {
        @Expect(result.identity.hasClaim("sub", "1024"))
    } else {
        @Expect(false)
    }
}