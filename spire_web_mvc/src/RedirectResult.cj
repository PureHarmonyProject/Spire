package spire_web_mvc

import spire_web_http.*

public class RedirectResult <: IActionResult {
    private let _url: String

    init(url: String) {
        _url = url
    }

    public func invoke(context: HttpContext): Unit {
        context.response.status(StatusCodes.Found)
        context.response.addHeader("location", _url)
    }
}
