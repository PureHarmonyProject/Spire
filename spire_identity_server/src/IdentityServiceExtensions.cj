package spire_identity_server

import spire_extensions_options.*
import spire_extensions_injection.*

import spire_identity_server.options.*
import spire_identity_server.services.*

public interface IdentityServiceExtensions {
    func addIdentityServer(): IdentityServerBuilder {
        addIdentityServer({_=>})
    }
    func addIdentityServer(configureOptions: (IdentityServerOptions)->Unit): IdentityServerBuilder
    func addIdentityServerBuilder(configureOptions: (IdentityServerOptions)->Unit): IdentityServerBuilder
}

extend ServiceCollection <: IdentityServiceExtensions {

    public func addIdentityServer(configureOptions: (IdentityServerOptions)->Unit) {
        return addIdentityServerBuilder(configureOptions)
            .addDefaultEndpoints()
            .AddPluggableServices()
    }

    public func addIdentityServerBuilder(configureOptions: (IdentityServerOptions)->Unit) : IdentityServerBuilder {
        this.configure(configureOptions)
        addSingleton<IdentityServerOptions>{sp => sp.getOrThrow<IOptions<IdentityServerOptions>>().value}
        return IdentityServerBuilder(this)
    }
}