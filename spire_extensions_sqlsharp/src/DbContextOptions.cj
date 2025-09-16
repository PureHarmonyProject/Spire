package spire_extensions_sqlsharp

import std.database.sql.*

public class DbContextOptions {
    public var datasource: ?Datasource = None
    public var connectionString: String = String.empty
}
