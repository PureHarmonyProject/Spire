// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package aspire_web_healthchecks

class HealthCheckMiddleware <: IMiddleware {
    private let _path: String
    private let _checkService: IHealthCheckService

    init(path: String, checkService: IHealthCheckService) {
        _path = path
        _checkService = checkService
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (context.request.path.value == _path) {
            let report = _checkService.check()
            context.response.write(report.status.toString())
            match (report.status) {
                case HealthStatus.unhealthy => context.response.status(503)
                case _ => context.response.status(200)
            }
        } else {
            next()
        }
    }
}
