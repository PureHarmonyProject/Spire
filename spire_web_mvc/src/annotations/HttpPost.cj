package spire_web_mvc.annotations

import spire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpPost <: HttpMethod {
    public const init() {
        super(HttpMethods.Post, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.Post, template)
    }
}
