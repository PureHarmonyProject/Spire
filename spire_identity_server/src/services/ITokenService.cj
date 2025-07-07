package spire_identity_server.services

import spire_identity_server.models.*

public interface ITokenService {
    func create(token: Token): String
}