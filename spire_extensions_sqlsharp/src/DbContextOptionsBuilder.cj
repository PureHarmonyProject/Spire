package spire_extensions_sqlsharp

public class DbContextOptionsBuilder {
    protected var connectionString = String.empty

    public func useMysql(connectionString: String): DbContextOptionsBuilder {
        this.connectionString = connectionString
        return this
    }
}
