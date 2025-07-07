package spire_identity_server.stores

import spire_identity_tokens.*

public interface ISigningCredentialStore {
    func getSigningCredentials(): SigningCredentials
}