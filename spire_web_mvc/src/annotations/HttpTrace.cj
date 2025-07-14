package spire_web_mvc.annotations

import spire_web_http.*
import spire_web_mvc.routing.*

@Annotation[target: [MemberFunction]]
public class HttpTrace <: HttpMethod {
    public const init() {
        super(HttpMethods.Trace, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.Trace, template)
    }
}
