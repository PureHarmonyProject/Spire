// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_authentication_jwtbearer

import spire_identity_protocols.*
import spire_web_authentication.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_identity_protocols_oidc.*

public interface JwtBearerBuilderExtensions {
    func addJwtBearer(authenticateScheme: String, displayName: Option<String>, configureOptions: (JwtBearerOptions) -> Unit): AuthenticationBuilder

    func addJwtBearer(authenticateScheme: String, configureOptions: (JwtBearerOptions) -> Unit): AuthenticationBuilder {
        addJwtBearer(authenticateScheme, None, configureOptions)
    }

    func addJwtBearer(configureOptions: (JwtBearerOptions) -> Unit): AuthenticationBuilder {
        addJwtBearer(JwtBearerDefaults.Scheme, None, configureOptions)
    }
}

extend AuthenticationBuilder <: JwtBearerBuilderExtensions {
    public func addJwtBearer(authenticateScheme: String, displayName: Option<String>, configureOptions: (JwtBearerOptions) -> Unit): AuthenticationBuilder {
        services.configureAfter<JwtBearerOptions>{configureOptions =>
            if (configureOptions.configurationManager.isNone()) {
                //如果有配资源
                if (let Some(configuration) <- configureOptions.configuration) {
                    configureOptions.configurationManager = StaticConfigurationManager<OpenIdConnectConfiguration>(configuration)
                }else {
                    //否则从认证中心下载
                    let address: String = if (!configureOptions.metadataAddress.isEmpty()) {
                        configureOptions.metadataAddress
                    }else if(let Some(authority) <- configureOptions.authority) {
                        "${authority}/.well-known/openid-configuration"
                    }else {
                        throw NoneValueException("Please configure either 'authority' or 'metadataAddress'.")
                    }
                    let documentRetriever = HttpDocumentRetriever(requireHttps: configureOptions.requireHttpsMetadata)
                    let configurationRetriever = OpenIdConnectConfigurationRetriever()
                    configureOptions.configurationManager = ConfigurationManager<OpenIdConnectConfiguration>(address, documentRetriever, configurationRetriever)
                }
            }
        }
        this.addScheme<JwtBearerOptions, JwtBearerHandler>(authenticateScheme, displayName, configureOptions)
    }
}