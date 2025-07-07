package spire_identity_server.services.defaults

import std.collection.*

import spire_identity_tokens.*
import spire_identity_server.stores.*
import spire_identity_server.services.*

public class KeyManager  <: IKeyManager {

    private let _stores: Collection<ISigningCredentialStore>

    public init(stores: Collection<ISigningCredentialStore>){
        _stores = stores
    }

    public func getActiveSigningKeys(): Collection<SigningCredentials> {
        return _stores |> map{f => f.getSigningCredentials()} |> collectArray
    }
}