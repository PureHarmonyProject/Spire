package spire_extensions_sqlsharp

import std.database.sql.*
import std.collection.concurrent.*

public class DatasourceFactory <: IDatasourceFactory {
    private var _isClosed = false
    private let _datasources = ConcurrentHashMap<String, Datasource>()

    public func create(name: String, connectionString: String): Datasource {
        return _datasources.entryView(connectionString) {
            view => if (view.value.isNone()) {
                view.value = createDatasource(name, connectionString)
            }
        }.getOrThrow()
    }

    private func createDatasource(name: String, connectionString: String) {
        let driver = DriverManager.getDriver(name).getOrThrow()
        let datasource = driver.open(connectionString)
        if (driver.preferredPooling) {
            return PooledDatasource(datasource)
        }
        return datasource
    }

    public func isClosed() {
        return _isClosed
    }

    public func close() {
        if (isClosed()) {
            return
        }
        _isClosed = true
        for ((_, datasource) in _datasources) {
            try {
                datasource.close()
            } catch (_: Exception) {
            }
        }
    }
}
