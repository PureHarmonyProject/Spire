package spire_web_quickstart.infrastructure

import std.time.*
import spire_identity_claims.*
import spire_identity_tokens.*
import spire_identity_tokens_jwt.*
import spire_extensions_configuration.*

public class JwtTokenService {
    public JwtTokenService(let configuration: IConfiguration) {
    }
    public func createToken(claims: Collection<Claim>) {
        let securityKey = SymmetricSecurityKey(configuration["authentication:securityKey"].getOrThrow().toArray())
        let jwtHeader = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256))
        let jwtPayload = JwtPayload(issuer: "spire", notBefore: DateTime.now(), expires: DateTime.now().addDays(1),
            claims: claims)
        let jwtTokenHander = JwtSecurityTokenHandler()
        return jwtTokenHander.writeToken(JwtSecurityToken(jwtHeader, jwtPayload))
    }
}
