package spire_web_quickstart

import std.time.*
import spire_web_routing.matching.*

main() {
    let builder = WebHost.createBuilder()
    builder.services.addAuthentication()
        .addJwtBearer(JwtBearerDefaults.Scheme) {options =>
            //优先从url中读取
            options.events.onMessageReceived = { context =>
                let token = context.request.queryForm.get("token")
                return token
            }
            options.metadataAddress = "https://demo.duendesoftware.com"
            options.saveToken = true//保存token
            options.tokenValidationParameters.authenticationType = "JwtBearer"
            options.tokenValidationParameters.validIssuer = "spire"//发行方
            options.tokenValidationParameters.validateAudience = false//不验证受众
        }
    builder.services.addAuthorizationBuilder()
        .addPolicy("dev") { policy =>
            //必须包含username
            policy.requireClaim("username")
            //基本要求，具体参考源码
            policy.requireAuthenticatedUser()
        }    
    builder.services.addRouting()

    let host = builder.build()

    host.useAuthentication()

    host.useRouting()

    host.useAuthorization()

    host.useEndpoints{endpoints =>
        endpoints.mapGet("home/index"){ context => 
            context.response.write("hello1")
        }.requireAuthorization("dev")

        endpoints.mapGet("connect/token") { context =>
            let securityKey = SymmetricSecurityKey(
                host.configuration["authentication:securityKey"].getOrThrow().toArray())
            let jwtHeader = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256))
            let jwtPayload = JwtPayload(issuer: "spire", notBefore: DateTime.now(), expires: DateTime.now().addDays(1),
                claims: [("sub", "1024")])
            jwtPayload.add("username", "admin")
            let jwtTokenHander = JwtSecurityTokenHandler()
            let accessToken = jwtTokenHander.writeToken(JwtSecurityToken(jwtHeader, jwtPayload))
            context.response.write(accessToken)
        }
    }

    host.run()
    return 0
}