package spire_web_mvc.annotations

import spire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpDelete <: HttpMethod {
    public const init() {
        super(HttpMethods.Delete, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.Delete, template)
    }
}
