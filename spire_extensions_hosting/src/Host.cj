// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_hosting

import std.env.*
import std.sync.*
import std.process.*
import std.collection.*

public class Host <: IHost {
    private let _logger: ILogger
    private let _counter = SyncCounter(1)
    private let _lifetime: HostLifetime
    private let _services: IServiceProvider
    private let _environment: IHostEnvironment
    private let _configuration: IConfiguration
    private let _hostedServices: Array<IHostedService>

    init(services: IServiceProvider, lifetime: HostLifetime) {
        _services = services
        _lifetime = lifetime
        _environment = services.getOrThrow<IHostEnvironment>()
        _configuration = services.getOrThrow<IConfiguration>()
        _hostedServices = _services.getAll<IHostedService>()
        _logger = services.getOrThrow<ILoggerFactory>().createLogger("spire.hosting.lifetime")
    }

    public func run() {
        start()
        stop()
    }

    public func start() {
        logging()        
        startHostedServices()
        _lifetime.started()
        atExit{
            stop()
        }
        _counter.waitUntilZero()
    }

    public func stop() {
        _lifetime.stopping()
        stopHostedServices()
        _lifetime.stopped()
        closeResources()
        _counter.dec()
    }

    private func startHostedServices() {
        for (pattern in _hostedServices) {
            pattern.start()
        }
    }

    private func stopHostedServices() {
        for (pattern in _hostedServices) {
            try {
                pattern.stop()
            } catch (_: Exception) {
            }
        }
    }

    private func closeResources() {
        if (let resource: Resource <- _services) {
            try {
                resource.close()
            } catch (_: Exception) {
            }
        }
    }

    public prop logger: ILogger {
        get() {
            _logger
        }
    }

    public prop lifetime: IHostLifetime {
        get() {
            _lifetime
        }
    }

    public prop services: IServiceProvider {
        get() {
            _services
        }
    }

    public prop appServices: IServiceProvider {
        get() {
            _services
        }
    }

    public prop environment: IHostEnvironment {
        get() {
            _environment
        }
    }

    public prop configuration: IConfiguration {
        get() {
            _configuration
        }
    }

    public static func createBuilder(args: Array<String>): HostBuilder {
        let environment = configureEnvironment(args)
        let configuration = configureConfiguration(args, environment)
        let logging = configureLogging(configuration)
        return HostBuilder(logging, environment, configuration)
    }

    private static func configureEnvironment(args: Array<String>): IHostEnvironment {
        let configuration = ConfigurationManager()
        configuration.addEnvVars("spire_")
        configuration.addCmdArgs(args)
        let environmentName = configuration["environment"] ?? Environments.Production
        let contentRootPath = configuration["contentRootPath"] ?? getWorkingDirectory().toString()
        let applicationName = configuration["applicationName"] ?? String.empty
        return HostEnvironment(environmentName, contentRootPath, applicationName)
    }

    private static func configureConfiguration(args: Array<String>, environment: IHostEnvironment) {
        let configuration = ConfigurationManager()
        configuration.addEnvVars("spire_")
        configuration.addCmdArgs(args)
        configuration.addJsonFile("./appsettings.json", optional: true)
        configuration.addJsonFile("./appsettings.${environment.environmentName}.json", optional: true)
        return configuration
    }

    private static func configureLogging(configuration: IConfiguration) {
        let logging = LoggingBuilder()
        logging.addConsole()
        logging.addConfiguration(configuration.getSection("logging"))
    }

    private func logging() {
        _logger.info("Hosting environment: ${_environment.environmentName}")
        _logger.info("Content root path: ${_environment.contentRootPath}")
        _logger.info("Application started. Press Ctrl+C to shut down.")
    }
}