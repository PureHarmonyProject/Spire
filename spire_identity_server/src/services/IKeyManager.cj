package spire_identity_server.services


import spire_identity_tokens.*

public interface IKeyManager {
    func getActiveSigningKeys(): Collection<SigningCredentials>
    func getAllValidationKeys(): Collection<SigningCredentials> {
        []
    }
}
