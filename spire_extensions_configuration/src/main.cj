package spire_extensions_configuration

main(args: Array<String>) {
    // 1. 创建并配置管理器
    let builder = ConfigurationManager()
    builder.addEnvVars("spire")      // 读取"spire_"开头的环境变量

    // 2. 构建配置
    let configuration = builder.build()

    // 3. 使用配置
    println(configuration["port"])   // 打印环境变量spire_environment的值
}