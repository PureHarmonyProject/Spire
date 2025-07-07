package spire_web_mvc

import spire_web_http.*

public interface IActionResult {
    func invoke(context: HttpContext): Unit
}
