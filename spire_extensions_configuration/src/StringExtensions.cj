package spire_extensions_configuration

extend String {
    func toLowerStr(): String {
        this.toAsciiLower()
    }

    func startsWithIgnoreAsciiCase(prefix: String) {
        this.toLowerStr().startsWith(prefix.toLowerStr())
    }
}
