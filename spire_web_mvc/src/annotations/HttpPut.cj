package spire_web_mvc.annotations

import spire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpPut <: HttpMethod {
    public const init() {
        super(HttpMethods.Put, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.Put, template)
    }
}
