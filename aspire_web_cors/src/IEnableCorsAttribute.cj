package aspire_web_cors

import aspire_web_http.*

public interface IEnableCorsAttribute <: ICorsMetadata {
    prop policyName: ?String
}