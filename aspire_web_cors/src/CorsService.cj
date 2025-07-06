package aspire_web_cors

import std.collection.*
import aspire_web_http.*
import aspire_extensions_options.*

class CorsService <: ICorsService{

    private let _options: CorsOptions

    public init(options: IOptions<CorsOptions>) {
        _options = options.value
    }

    public func evaluatePolicy(context: HttpContext, policy: CorsPolicy): CorsResult {
        if (policy.allowAnyOrigin && policy.supportsCredentials) {
            throw IllegalArgumentException("The CORS protocol does not allow specifying a wildcard (any) origin and credentials at the same time. Configure the CORS policy by listing individual origins if credentials needs to be supported.")
        }

        let requestHeaders = context.request.headers
        let origin = requestHeaders.getFirst("Origin")

        let isOptionsRequest = HttpMethods.isOptions(context.request.method)
        let isPreflightRequest = isOptionsRequest && requestHeaders.get("Access-Control-Request-Method").size > 0

        let corsResult = CorsResult()
        corsResult.isPreflightRequest = isPreflightRequest
        corsResult.isOriginAllowed = isOriginAllowed(policy, (origin ?? String.empty))

        if (isPreflightRequest) {
            evaluatePreflightRequest(context, policy, corsResult);
        }else {
            evaluateRequest(context, policy, corsResult);
        }
        return corsResult
    }
    
    public func applyResul(result: CorsResult, response: HttpResponse): Unit {

    }
    
    private func isOriginAllowed(policy: CorsPolicy, origin: String) {
        if (origin.isEmpty()) {
            return false
        }
        
        if (policy.allowAnyOrigin || policy.isOriginAllowed(origin)) {
            return true   
        }
        
        return false
    }

    private func evaluatePreflightRequest(context: HttpContext, policy: CorsPolicy, result: CorsResult) {
        populateResult(context, policy, result)
    }
   
    private func evaluateRequest(context: HttpContext, policy: CorsPolicy, result: CorsResult) {
        populateResult(context, policy, result)
    }

    private func populateResult(context: HttpContext, policy: CorsPolicy, result: CorsResult) {
        let headers = context.request.headers

        if (policy.allowAnyOrigin) {
            result.allowedOrigin = CorsConstants.AnyOrigin
            result.varyByOrigin = policy.supportsCredentials
        }else {
            let origin = headers.getFirst("Origin")
            result.allowedOrigin = origin
            result.varyByOrigin = policy.origins.size > 1 || !policy.isDefaultIsOriginAllowed
        }

        result.supportsCredentials = policy.supportsCredentials
        result.preflightMaxAge = policy.preflightMaxAge

        addHeaderValues(result.allowedExposedHeaders, policy.exposedHeaders)

        let allowedMethods: List<String> = if (policy.allowAnyMethod) {
            if (result.isPreflightRequest) {
                headers.get("Access-Control-Request-Method") |> collectArrayList
            }else {
                ArrayList<String>([context.request.method])
            }
        }else {
            policy.methods
        }
        addHeaderValues(result.allowedMethods, allowedMethods)
       
        let allowedHeaders = if (policy.allowAnyHeader) {
            headers.get("Access-Control-Request-Headers") |> collectArrayList
        }else {
            policy.headers
        }
        addHeaderValues(result.allowedHeaders, allowedHeaders)
    }

    private func addHeaderValues(target: List<String>, headerValues: List<String>) {
        if (headerValues.size == 0) {
            return
        }

        for (item in headerValues) {
            target.add(item)
        }
    }
}