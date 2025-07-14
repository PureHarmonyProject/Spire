package spire_web_mvc.annotations

import spire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpGet <: HttpMethod {
    public const init() {
        super(HttpMethods.Get, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.Get, template)
    }
}
