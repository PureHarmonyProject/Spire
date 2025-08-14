package spire_comparison_example

public class ValidationResult {
    public let isValid: Bool
    public let errors: Array<String>
    
    public init(isValid: Bool, errors: Array<String>) {
        this.isValid = isValid
        this.errors = errors
    }
}