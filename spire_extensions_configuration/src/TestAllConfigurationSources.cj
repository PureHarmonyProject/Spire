// 测试所有配置源的不区分大小写访问
package spire_extensions_configuration

import std.env.*
import std.collection.*

func testAllConfigurationSources() {
    println("=== 测试所有配置源的不区分大小写访问 ===")
    
    // 1. 测试环境变量配置源
    testEnvVarsConfiguration()
    
    // 2. 测试命令行配置源
    testCmdArgsConfiguration()
    
    // 3. 测试JSON配置源
    testJsonConfiguration()
    
    // 4. 测试内存配置源
    testMemoryConfiguration()
    
    println("=== 所有配置源测试完成 ===")
}

func testEnvVarsConfiguration() {
    println("=== 测试不区分大小写的配置访问 ===")
    
    // 创建配置管理器
    let config = ConfigurationManager()
    
    // 添加环境变量配置源
    config.addEnvVars("spire")
    
    // 构建配置
    let root = config.build()
    
    // 测试不区分大小写的访问
    println("测试各种访问方式:")
    
    // 原始格式 (应该能工作)
    if (let Some(port) <- root["config:port"]) {
        println("config:port = ${port}")
    } else {
        println("config:port 未找到")
    }
    
    // 大写格式 (应该也能工作)
    if (let Some(port) <- root["CONFIG:PORT"]) {
        println("CONFIG:PORT = ${port}")
    } else {
        println("CONFIG:PORT 未找到")
    }
    
    // 混合格式 (应该也能工作)
    if (let Some(port) <- root["Config:Port"]) {
        println("Config:Port = ${port}")
    } else {
        println("Config:Port 未找到")
    }
    
    // 测试数据库连接字符串
    if (let Some(connStr) <- root["database:connection"]) {
        println("database:connection_string = ${connStr}")
    } else {
        println("database:connection_string 未找到")
    }
    
    if (let Some(connStr) <- root["DATABASE:CONNECTION"]) {
        println("DATABASE:CONNECTION_STRING = ${connStr}")
    } else {
        println("DATABASE:CONNECTION_STRING 未找到")
    }
    
    println("=== 测试完成 ===")
}

func testCmdArgsConfiguration() {
    println("\n--- 测试命令行配置源 ---")
    
    let config = ConfigurationManager()
    
    // 添加命令行参数：--config:port=8080 --database:connection=localhost
    let args = ["--config:port=8080", "--database:connection=localhost"]
    config.addCmdArgs(args)
    
    let root = config.build()
    
    // 测试不区分大小写的访问
    println("命令行参数测试:")
    
    // 原始格式
    if (let Some(port) <- root["config:port"]) {
        println("config:port = ${port}")
    } else {
        println("config:port 未找到")
    }
    
    // 大写格式
    if (let Some(port) <- root["CONFIG:PORT"]) {
        println("CONFIG:PORT = ${port}")
    } else {
        println("CONFIG:PORT 未找到")
    }
    
    // 混合格式
    if (let Some(port) <- root["Config:Port"]) {
        println("Config:Port = ${port}")
    } else {
        println("Config:Port 未找到")
    }
}

func testJsonConfiguration() {
    println("\n--- 测试JSON配置源 ---")
    
    let config = ConfigurationManager()
    
    // JSON配置
    let json = """
    {
        "Config": {
            "Port": "3000",
            "Host": "localhost"
        },
        "Database": {
            "Connection": "server=localhost;database=test"
        }
    }
    """
    
    config.addJsonString(json)
    let root = config.build()
    
    // 测试不区分大小写的访问
    println("JSON配置测试:")
    
    // 注意：JSON配置的键会被转换为 config:port 格式
    if (let Some(port) <- root["config:port"]) {
        println("config:port = ${port}")
    } else {
        println("config:port 未找到")
    }
    
    if (let Some(port) <- root["CONFIG:PORT"]) {
        println("CONFIG:PORT = ${port}")
    } else {
        println("CONFIG:PORT 未找到")
    }
}

func testMemoryConfiguration() {
    println("\n--- 测试内存配置源 ---")
    
    let config = ConfigurationManager()
    
    // 内存配置数据
    let values = [
        ("Config:Port", "9000"),
        ("Database:Connection", "memory-db-connection")
    ]
    
    config.addMemory(values)
    let root = config.build()
    
    // 测试不区分大小写的访问
    println("内存配置测试:")
    
    if (let Some(port) <- root["config:port"]) {
        println("config:port = ${port}")
    } else {
        println("config:port 未找到")
    }
    
    if (let Some(port) <- root["CONFIG:PORT"]) {
        println("CONFIG:PORT = ${port}")
    } else {
        println("CONFIG:PORT 未找到")
    }
    
    if (let Some(port) <- root["Config:Port"]) {
        println("Config:Port = ${port}")
    } else {
        println("Config:Port 未找到")
    }
}

main() {
    testAllConfigurationSources()
}