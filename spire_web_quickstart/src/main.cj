package spire_web_quickstart

main() {
    let builder = WebHost.createBuilder()
    
    builder.services.addRouting()

    let host = builder.build()

    host.useEndpoints{endpoints =>
        endpoints.mapGet("/home/index"){ context => 
            context.response.write("hello1")
        }
        endpoints.mapGet("/home/{action}"){ context => 
            context.response.write("hello2")
        }
    }

    host.run()
    return 0
}