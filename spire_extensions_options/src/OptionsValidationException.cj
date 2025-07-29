package spire_extensions_options

import std.reflect.*

public class OptionsValidationException <: Exception {
    public OptionsValidationException(public let optionsName: String, public let optionsType: TypeInfo,
        let failureMessages: Array<String>) {
        super(String.join(failureMessages, delimiter: "; "))
    }
}
