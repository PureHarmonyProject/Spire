package spire_web_mvc.annotations

import spire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpOptions <: HttpMethod {
    public const init() {
        super(HttpMethods.Options, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.Options, template)
    }
}
