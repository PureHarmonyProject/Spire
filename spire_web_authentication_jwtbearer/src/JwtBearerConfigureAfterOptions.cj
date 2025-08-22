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
            } else if(!(options.metadataAddress.isEmpty() && options.authority.isEmpty())) {
                if (options.metadataAddress.isEmpty() && !options.authority.isEmpty()) {
                    options.metadataAddress = options.authority
                    if (!options.metadataAddress.endsWith("/"))
                    {
                        options.metadataAddress += "/"
                    }

                    options.metadataAddress += ".well-known/openid-configuration"
                }

                if (options.requireHttpsMetadata && !options.metadataAddress.toAsciiLower().startsWith("https://")) {
                    throw IllegalArgumentException("The MetadataAddress or Authority must use HTTPS unless disabled for development by setting RequireHttpsMetadata=false.")
                }

                let documentRetriever = HttpDocumentRetriever(requireHttps: options.requireHttpsMetadata)
                let configurationManager = ConfigurationManager<OpenIdConnectConfiguration>(options.metadataAddress, documentRetriever, OpenIdConnectConfigurationRetriever())
                options.configurationManager = configurationManager
            }
        }
    }
}