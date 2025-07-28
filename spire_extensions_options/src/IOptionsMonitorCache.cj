package spire_extensions_options

public interface IOptionsMonitorCache<TOptions> where TOptions <: Object {
    func getOrAdd(name: String, createOptions: () -> TOptions): TOptions
}
