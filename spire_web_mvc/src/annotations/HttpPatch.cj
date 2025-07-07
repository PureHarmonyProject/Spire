package spire_web_mvc.annotations

import spire_web_http.*
import spire_web_mvc.routing.*

@Annotation[target: [MemberFunction]]
public class HttpPatch <: HttpMethod {
    public const init() {
        super(HttpMethods.patch, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.patch, template)
    }
}
