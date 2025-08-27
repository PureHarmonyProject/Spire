package spire_web_mvc.annotations

import spire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpHead <: HttpMethod {
       public const init() {
        super(HttpMethods.Head, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.Head, template)
    }
}
