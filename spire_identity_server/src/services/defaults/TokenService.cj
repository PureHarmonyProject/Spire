package spire_identity_server.services.defaults

import std.time.*
import std.collection.*
import spire_identity_tokens_jwt.*
import spire_identity_server.models.*
import spire_identity_server.services.*

public class TokenService <: ITokenService {
    public TokenService(let keys: IKeyManager) {
    }

    public func create(_: Token): String {
        let signingCredentials = keys.getActiveSigningKeys() |> first
        let handler = JwtSecurityTokenHandler()
        let claims: Collection<(String, Any)> = [("issuer", "spire"), ("scope", "api")]
        let jwtToken = JwtSecurityToken(signingCredentials.getOrThrow(), notBefore: DateTime.now(),
            expires: DateTime.now().addDays(1), claims: claims)
        return handler.writeToken(jwtToken)
    }
}
