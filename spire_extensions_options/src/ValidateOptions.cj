package spire_extensions_options

public class ValidateOptions<TOptions> <: IValidateOptions<TOptions> where TOptions <: Object {
    ValidateOptions(public let name: ?String, public let validation: (TOptions) -> Bool,
        public let failureMessage: String) {
    }

    public func validate(name: ?String, options: TOptions): ValidateOptionsResult {
        if (this.name.isNone() || this.name == name) {
            if (validation(options)) {
                return ValidateOptionsResult.success
            }
            return ValidateOptionsResult.fail(failureMessage)
        }

        return ValidateOptionsResult.skip
    }
}
