// 测试不区分大小写的配置访问
package spire_extensions_configuration

import std.env.*
import std.collection.*

// 模拟环境变量
func setTestEnvironmentVariables() {
    // 设置测试环境变量
    // 在实际环境中，这些变量会在系统级别设置
    // spire_config_port=8088
    // spire_config_host=localhost
    // spire_database_connection_string=server=localhost;database=test
}

func testCaseInsensitiveAccess() {
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

main() {
    setTestEnvironmentVariables()
    testCaseInsensitiveAccess()
}