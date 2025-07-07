package spire_identity_server.validation

import spire_identity_server.models.*

public interface IScopeValidator {
    func Validate(scope: String): Resources
}