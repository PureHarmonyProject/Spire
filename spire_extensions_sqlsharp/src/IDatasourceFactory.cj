package spire_extensions_sqlsharp

import std.database.sql.*

public interface IDatasourceFactory <: Resource {
    func create(name: String, connectionString: String): Datasource
}
