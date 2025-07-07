// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_cors

import spire_web_http.*
import spire_web_routing.*
import spire_extensions_logging.*

public class CorsMiddleware <: IMiddleware {
    private let _logger: ILogger
    private var _policy: ?CorsPolicy = None
    private var _policName: ?String = None
    private let _corsService: ICorsService
    private var _policyProvider: ?ICorsPolicyProvider = None
    private static let corsMiddlewareWithEndpointInvokedValue = Object()
    
    public init(corsService: ICorsService, loggerFactory: ILoggerFactory) {
        _corsService = corsService
        _logger = loggerFactory.createLogger<CorsMiddleware>()
    }

    public init(corsService: ICorsService, loggerFactory: ILoggerFactory, policName: String) {
        _corsService = corsService
        _policName = policName
        _logger = loggerFactory.createLogger<CorsMiddleware>()
    }

    public init(corsService: ICorsService, loggerFactory: ILoggerFactory, policy: CorsPolicy) {
        _policy = policy
        _corsService = corsService
        _logger = loggerFactory.createLogger<CorsMiddleware>()
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        let endpoint = context.getEndpoint()

        if (endpoint.isSome()) {
            context.items["__CorsMiddlewareWithEndpointInvoked"] = corsMiddlewareWithEndpointInvokedValue
        }

        let corsMetadata = endpoint.flatMap{f => f.metadata.getMetadata<ICorsMetadata>()}

        if (corsMetadata.flatMap{f => f is IDisableCorsAttribute} == true) {
            let isOptionsRequest = HttpMethods.isOptions(context.request.method)

            let isCorsPreflightRequest = isOptionsRequest && context.request.headers.get("Access-Control-Request-Method").size > 0

            if (isCorsPreflightRequest) {
                context.response.status(StatusCodes.NoContent)
                return
            }
            return next()
        }

        var corsPolicy = _policy
        var policName = _policName 
        
        if (let Some(corsPolicyMetadata) <- corsMetadata.flatMap{f => f as ICorsPolicyMetadata}) {
            policName = None
            corsPolicy = corsPolicyMetadata.policy
        } else if(let Some(enableCorsAttribute) <- corsMetadata.flatMap{f => f as IEnableCorsAttribute} && enableCorsAttribute.policyName.isSome()) {
            policName = enableCorsAttribute.policyName
            corsPolicy = None
        }

        if (corsPolicy.isNone()) {
            let corsPolicyProvider = context.services.getOrThrow<ICorsPolicyProvider>()
            corsPolicy = corsPolicyProvider.getPolicy(context, policName)
        }

        return evaluateAndApplyPolicy(context, next,corsPolicy)
    }

    private func evaluateAndApplyPolicy(context: HttpContext, next: () -> Unit, corsPolicy: ?CorsPolicy) {
        if (corsPolicy.isNone()) {
            _logger.info("No CORS policy found for the specified request.")
            return next()
        }

        let corsResult = _corsService.evaluatePolicy(context, corsPolicy.getOrThrow())

        if (corsResult.isPreflightRequest) {
            _corsService.applyResul(corsResult, context.response)
            context.response.status(StatusCodes.NoContent)
            return
        }else {
            try {
                _corsService.applyResul(corsResult, context.response)
            } catch (exception: Exception) {
                _logger.warn("Failed to apply CORS Response headers.")
            }
        }
    }
}
