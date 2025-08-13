package spire_comparison_example

import spire_web_http.*
import spire_web_hosting.*
import spire_web_routing.*
import spire_extensions_injection.*
import spire_web_mvc.*
import std.reflect.*
import std.time.*

main() {
    let startTime = DateTime.now()
    let builder = WebHost.createBuilder()
    
    builder.services.addControllers()
        .addApplicationPart("default", TypeInfo.of<UserController>())

    let host = builder.build()

    host.useEndpoints { endpoints =>
        endpoints.mapControllers()
    }

    let endTime = DateTime.now()
    let durationMs = (endTime - startTime).toMilliseconds()
    
    println("Spire Web MVC application started successfully!")
    println("Startup time: ${durationMs}ms")

    host.run()
}