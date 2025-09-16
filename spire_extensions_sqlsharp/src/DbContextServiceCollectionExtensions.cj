package spire_extensions_sqlsharp

import sqlsharp.*
import std.reflect.*
import std.database.sql.*
import spire_extensions_options.*
import spire_extensions_injection.*

public interface DbContextServiceCollectionExtensions {
    func addDbContext<TContext>(configure: (DbContextOptionsBuilder) -> Unit): ServiceCollection where TContext <: DbContext
}

extend ServiceCollection <: DbContextServiceCollectionExtensions {
    public func addDbContext<TContext>(configure: (DbContextOptionsBuilder) -> Unit): ServiceCollection where TContext <: DbContext {
        let builder = DbContextOptionsBuilder()
        configure(builder)
        let driver = DriverManager.getDriver("mysql").getOrThrow()
        let datasource = driver.open(builder.connectionString)
        let datasourceName = TypeInfo.of<TContext>().qualifiedName
        this.addSingleton(datasource)
        this.configure<DbContextOptions>(datasourceName) {
            options => options.datasource = datasource
        }
        this.addScoped<TContext, TContext> {
            sp =>
                let options = sp.getOrThrow<IOptionsMonitor<DbContextOptions>>()
                let datasource = options.get(datasourceName)
                return ActivatorUtilities.createInstance<TContext>(sp, datasource)
        }
        return this
    }
}
