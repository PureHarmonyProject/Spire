// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.
package aspire_extensions_logging

type LoggerFilter = (providerName: String, categoryName: String, level: LogLevel) -> Bool