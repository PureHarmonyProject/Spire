package spire_web_authentication_jwtbearer

import spire_identity_protocols.*
import spire_web_authentication.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_identity_protocols_oidc.*

public class JwtBearerConfigureAfterOptions <: IConfigureAfterOptions<JwtBearerOptions> {
    public func configureAfter(_: ?String, options: JwtBearerOptions): Unit {
        if (options.configurationManager.isNone()) {
            //如果有配资源
            if (let Some(configuration) <- options.configuration) {
                options.configurationManager = StaticConfigurationManager<OpenIdConnectConfiguration>(configuration)
            } else {
                //否则从认证中心下载
                let address: String = if (!options.metadataAddress.isEmpty()) {
                    options.metadataAddress
                } else if (let Some(authority) <- options.authority) {
                    "${authority}/.well-known/openid-configuration"
                } else {
                    throw NoneValueException("Please configure either 'authority' or 'metadataAddress'.")
                }
                let documentRetriever = HttpDocumentRetriever(requireHttps: options.requireHttpsMetadata)
                let configurationRetriever = OpenIdConnectConfigurationRetriever()
                options.configurationManager = ConfigurationManager<OpenIdConnectConfiguration>(address,
                    documentRetriever, configurationRetriever)
            }
        }
    }
}
