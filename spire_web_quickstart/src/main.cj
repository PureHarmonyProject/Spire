package spire_web_quickstart

import spire_web_http.*
import spire_web_routing.*
import spire_web_hosting.*
import spire_extensions_injection.*

main() {
    let builder = WebHost.createBuilder()
    
    builder.services.addRouting()

    let host = builder.build()

    host.useEndpoints{ endpoints => 
        endpoints.mapGet("hello"){ context =>
            context.response.write("hello")
        }
    }

    host.run()
    return 0
}