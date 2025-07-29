package spire_extensions_options

public interface IValidateOptions<TOptions> where TOptions <: Object {
    func validate(name: ?String, options: TOptions): ValidateOptionsResult
}