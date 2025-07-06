package aspire_web_cors

import std.collection.*

public class CorsResult {
    public var varyByOrigin = false
    public var isOriginAllowed = false
    public var isPreflightRequest = false
    public var supportsCredentials = false
    public var allowedOrigin: ?String = None
    public var preflightMaxAge: ?Duration = None
    public var allowedMethods :List<String> = ArrayList<String>()
    public var allowedHeaders :List<String> = ArrayList<String>()
    public var allowedExposedHeaders :List<String> = ArrayList<String>()
}