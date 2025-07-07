package spire_identity_server

import spire_web_http.*
import spire_web_hosting.*
import spire_identity_tokens.*
import spire_extensions_injection.*
import spire_identity_server.endpoints.*

import spire_identity_server.services.*

main(): Int64 {
    let builer = WebHost.createBuilder()
     
    let rsaSecurityKey = RsaSecurityKey(
        publicKey: SecurityKeyHelper.createRSAPublicKeyFromDerFile("rsa256_public.pem"),
        privateKey: SecurityKeyHelper.createRSAPrivateKeyFromDerFile("rsa256_private.pem"))

    builer.services.addIdentityServer({ configureOptions =>
        configureOptions.idp = "spire"
        configureOptions.issuer = "spire"
        configureOptions.issuerUri = "http://localhost:5000"
    })
    .addSigningCredential(SigningCredentials(rsaSecurityKey, SecurityAlgorithms.RsaSha256))
    
    let host = builer.build()
  
    host.use{ _, next => 
        try {
            next()
        }catch (ex: Exception) {
           ex.printStackTrace()
        }
    }
   
    host.useIdentityServer()

    host.run()
    return 0
}
