package spire_identity_server

import spire_web_http.*
import spire_identity_server.stores.*
import spire_identity_server.hosting.*

public interface IdentityApplicationExtensions {
    func useIdentityServer(): Unit
}

extend ApplicationBuilder <: IdentityApplicationExtensions {

    public func useIdentityServer(): Unit {
        checkRequiredServices()
        use<IdentityServerMiddleware>()
    }

    private func checkRequiredServices() {
       try(scope = this.applicationServices.createScope()) {
            if (scope.services.getOrDefault<ISigningCredentialStore>().isNone()) {
                throw Exception("Unable to find the required services. Please add all the required services by calling 'IdentityServerBuilder.addSigningCredential' in the application startup code.")
            }
       }
    }
}
