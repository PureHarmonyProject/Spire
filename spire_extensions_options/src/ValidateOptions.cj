package spire_extensions_options

import spire_extensions_injection.*

public class ValidateOptions<TOptions> <: IValidateOptions<TOptions> where TOptions <: Object {
    ValidateOptions(public let name: ?String, public let services: IServiceProvider,
        public let validation: (TOptions, IServiceProvider) -> Bool, public let failureMessage: String) {
    }

    public func validate(name: ?String, options: TOptions): ValidateOptionsResult {
        if (this.name.isNone() || this.name == name) {
            if (validation(options, services)) {
                return ValidateOptionsResult.success
            }
            return ValidateOptionsResult.fail(failureMessage)
        }

        return ValidateOptionsResult.skip
    }
}
