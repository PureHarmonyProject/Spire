package spire_extensions_sqlsharp

import std.database.sql.*
import stdx.encoding.url.*
import spire_extensions_options.*
import spire_extensions_injection.*

public class DbContextOptionsBuilder {
    private let options = DbContextOptions()
    public let services: ServiceCollection

    init(services: ServiceCollection) {
        this.services = services
    }

    public func useMysql(connectionString: String) {
        services.configure<DbContextOptions>(connectionString) { options =>
        }         
    }
}
