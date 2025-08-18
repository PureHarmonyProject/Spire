package spire_extensions_http

import std.reflect.*
import std.collection.*

class HttpClientMappingRegistry {
    public let namedClientRegistrations = HashMap<String, TypeInfo>()
}