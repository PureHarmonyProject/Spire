package aspire_extensions_options

public abstract class Options {
    public static let defaultName = String.empty

    public static func create<TOptions>(options: TOptions): IOptions<TOptions> where  TOptions <: Object {
        return OptionsWrapper<TOptions>(options)
    }
}
