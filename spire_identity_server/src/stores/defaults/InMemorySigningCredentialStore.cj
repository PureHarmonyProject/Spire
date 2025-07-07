package spire_identity_server.stores.defaults

import spire_identity_tokens.*
import spire_identity_server.stores.*

public class InMemorySigningCredentialStore <: ISigningCredentialStore {
  
    public InMemorySigningCredentialStore(
        private let signingCredentials: SigningCredentials) {
    }

    public func getSigningCredentials(): SigningCredentials {
        signingCredentials
    }
}