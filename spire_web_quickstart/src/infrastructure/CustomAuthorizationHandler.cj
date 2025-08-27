package spire_web_quickstart.infrastructure

import spire_web_routing.*
import spire_web_authorization.*
import spire_extensions_logging.*
import spire_web_mvc.controllers.*

//定义一个要求
public class CustomRequirement <: IAuthorizationRequirement {}

public class CustomAuthorizationHandler <: AuthorizationHandler<CustomRequirement> {
    private let _logger: ILogger
    //你可以注入权限配置服务
    public init(loggerFactory: ILoggerFactory) {
        _logger = loggerFactory.createLogger<CustomAuthorizationHandler>()
    }

    protected func handleRequirement(context: AuthorizationHandlerContext, requirement: CustomRequirement): Unit {
        //获取到资源->终结点
        //如果希望资源是HttpContext，请配置AuthorizationOptions.suppressUseHttpContextAsAuthorizationResource = true
        if (let Some(endpoint) <- context.resource.flatMap {f => f as RouteEndpoint}) {
            //如果希望根据ControllerActionDescriptor进行保护
            //let descriptor = endpoint.metadata.getRequiredMetadata<ControllerActionDescriptor>()
            let username = context.user.findFirstValue("username")
            _logger.info(username ?? "")
            //这里假定是用户名和路由名称的映射，你可以根据自己的需求进行设计
            if (endpoint.routePattern.rawText.contains("logout") && username == "admin") {
                //表示改要求已成功
                context.succeed(requirement)
            }
        }
    }
}
