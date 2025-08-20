package spire_extensions_http

public interface IHttpMessageHandlerBuilderFilter {
    func configure(next: (HttpMessageHandlerBuilder) -> Unit): (HttpMessageHandlerBuilder) -> Unit
}
