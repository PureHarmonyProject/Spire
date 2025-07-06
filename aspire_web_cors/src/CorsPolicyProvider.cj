package aspire_web_cors

import aspire_web_http.*
import aspire_extensions_options.*

class CorsPolicyProvider <: ICorsPolicyProvider {
    private let _options: CorsOptions

    public init(options: IOptions<CorsOptions>) {
        _options = options.value
    }

    public func getPolicy(context: HttpContext, policyName: ?String): ?CorsPolicy {
        let name = policyName ?? _options.defaultPolicyName

        if (let Some(policy) <- _options.policyMap.get(name)) {
            return policy
        }

        return None
    }
}
