package spire_extensions_options

public class ValidateOptionsResult {
    public static let skip: ValidateOptionsResult

    public static let success: ValidateOptionsResult

    private ValidateOptionsResult(public let succeeded!: Bool = false, public let skipped!: Bool = false,
        public let failed!: Bool = false, public let failureMessage!: ?String = None,
        public let failures!: ?Collection<String> = None) {
    }

    public static func fail(failureMessage: String) {
        return ValidateOptionsResult(failed: true, failureMessage: failureMessage, failures: [failureMessage])
    }

    public static func fail(failures: Collection<String>) {
        return ValidateOptionsResult(failed: true, failures: failures)
    }

    static init() {
        skip = ValidateOptionsResult(skipped: true)
        success = ValidateOptionsResult(succeeded: true)
    }
}
