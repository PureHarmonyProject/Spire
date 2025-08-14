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
    
    builder.services.addSingleton<IUserService, UserService>()
    
    builder.services.addControllers()
        .addApplicationPart("MyApp", [TypeInfo.of<UserController>()])

    let host = builder.build()

    host.useEndpoints { endpoints =>
        endpoints.mapControllers()
    }

    let endTime = DateTime.now()
    let durationMs = (endTime - startTime).toMilliseconds()
    
    logo() 
    println("🚀 Spire Web MVC Application")
    println("   Version: 1.0.0")
    println("   Started in ${durationMs}ms")
    println("   Server: http://localhost:5000")
    println("")

    host.run()
}











func logo() {
    // 打印 Spire ASCII 艺术标志
    println("""
    ╔══════════════════════════════════════════════════╗
    ║                                                  ║
    ║   ███████╗  ██████╗   ██╗   ██████╗    ███████╗  ║
    ║   ██╔════╝  ██╔══██╗  ██║   ██╔══██╗   ██╔════╝  ║
    ║   ███████╗  ██████╔╝  ██║   ██████╔╝   █████╗    ║
    ║   ╚════██║  ██╔═══╝   ██║   ██╔══██╗   ██╔══╝    ║
    ║   ███████║  ██║       ██║   ██║  ██║   ███████╗  ║
    ║   ╚══════╝  ╚═╝       ╚═╝   ╚═╝  ╚═╝   ╚══════╝  ║
    ║                 Spire Web V1.0.0                 ║
    ╚══════════════════════════════════════════════════╝                               
    """)
}