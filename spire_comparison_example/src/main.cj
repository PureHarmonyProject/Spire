package spire_comparison_example

import std.time.*
import spire_web_hosting.*
import spire_web_routing.*
import spire_extensions_injection.*

main() {
    let startTime = DateTime.now()
    
    let builder = WebHost.createBuilder()
    builder.services.addRouting()
    
    let host = builder.build()
    
    let endTime = DateTime.now()
    let durationMs = (endTime - startTime).toMilliseconds()
    
    println("Spire Web MVC application started successfully!")
    println("Startup time: ${durationMs}ms")
    
    host.run()
}