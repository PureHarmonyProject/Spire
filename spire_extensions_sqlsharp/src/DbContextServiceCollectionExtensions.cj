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
        addDatasourceFactory()
        let builder = DbContextOptionsBuilder(this)
        configure(builder)   
        this.addScoped<TContext, TContext>{sp =>
            ActivatorUtilities.createInstance<TContext>(sp)   
        }   
        return this
    }

    private func addDatasourceFactory() {
        this.tryAddSingleton<IDatasourceFactory, DatasourceFactory>()
    }
}
