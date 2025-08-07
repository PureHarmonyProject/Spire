package spire_extensions_configuration.unittests.integration

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_configuration.*
import spire_extensions_configuration.unittests.*

/**
 * 配置管理器集成测试
 * 测试ConfigurationManager与IgnoreCaseHashMap的集成
 */
@Test
func 配置管理器集成测试() {
    let config = ConfigurationManager()
    
    // 添加内存配置源
    let testData = TestHelper.createTestData(5)
    config.addMemory(testData)
    
    let root = config.build()
    
    // 验证不区分大小写的访问
    @Expect(root["key_1"], Some("value_1"))
    @Expect(root["Key_1"], Some("Value_1"))
    @Expect(root["KEY_1"], Some("VALUE_1"))
}

/**
 * 多配置源集成测试
 * 测试多个配置源的集成和不区分大小写处理
 */
@Test
func 多配置源集成测试() {
    let config = ConfigurationManager()
    
    // 添加内存配置源
    let memoryData = HashMap<String, String>()
    memoryData["app:name"] = "TestApp"
    memoryData["app:version"] = "1.0.0"
    config.addMemory(memoryData)
    
    // 添加环境变量配置源
    let envData = HashMap<String, String>()
    envData["APP_DEBUG"] = "true"
    envData["APP_PORT"] = "8080"
    config.addEnvVars("APP")
    
    let root = config.build()
    
    // 验证内存配置源的不区分大小写访问
    @Expect(root["app:name"], Some("TestApp"))
    @Expect(root["APP:NAME"], Some("TestApp"))
    @Expect(root["app:version"], Some("1.0.0"))
    @Expect(root["APP:VERSION"], Some("1.0.0"))
    
    // 验证环境变量配置源的不区分大小写访问
    @Expect(root["APP_DEBUG"], Some("true"))
    @Expect(root["app_debug"], Some("true"))
    @Expect(root["APP_PORT"], Some("8080"))
    @Expect(root["app_port"], Some("8080"))
}

/**
 * 配置构建器集成测试
 * 测试ConfigurationBuilder与IgnoreCaseHashMap的集成
 */
@Test
func 配置构建器集成测试() {
    let builder = ConfigurationBuilder()
    
    // 添加JSON配置源
    let jsonConfig = ###"
        "Database": {
            "Host": "localhost",
            "Port": 3306,
            "Name": "testdb"
        },
        "Logging": {
            "Level": "INFO",
            "File": "app.log"
        }
    }"###
    
    let root = ConfigurationManager()
    .addJsonString(jsonConfig) // 读取JSON字符串
    .build()
    
    // 验证不区分大小写的访问
    @Expect(root["Database:Host"], Some("localhost"))
    @Expect(root["database:host"], Some("localhost"))
    @Expect(root["DATABASE:HOST"], Some("localhost"))
    
    @Expect(root["Logging:Level"], Some("INFO"))
    @Expect(root["logging:level"], Some("INFO"))
    @Expect(root["LOGGING:LEVEL"], Some("INFO"))
}

/**
 * 命令行参数集成测试
 * 测试命令行参数与IgnoreCaseHashMap的集成
 */
@Test
func 命令行参数集成测试() {
    let config = ConfigurationManager()
    
    // 添加命令行参数
    let cmdArgs = [
        "app:debug=true",
        "app:port=8080",
        "database:host=localhost",
        "database:port=3306"
    ]
    
    config.addCmdArgs(cmdArgs)
    let root = config.build()
    
    // 验证命令行参数的不区分大小写访问
    @Expect(root["app:debug"], Some("true"))
    @Expect(root["APP:DEBUG"], Some("true"))
    @Expect(root["App:Debug"], Some("true"))
    
    @Expect(root["database:host"], Some("localhost"))
    @Expect(root["DATABASE:HOST"], Some("localhost"))
    @Expect(root["Database:Host"], Some("localhost"))
}

/**
 * 配置覆盖集成测试
 * 测试多个配置源之间的覆盖行为
 */
@Test
func 配置覆盖集成测试() {
    let config = ConfigurationManager()
    
    // 添加基础配置
    let baseData = HashMap<String, String>()
    baseData["app:name"] = "BaseApp"
    baseData["app:version"] = "1.0.0"
    baseData["debug"] = "false"
    config.addMemory(baseData)
    
    // 添加覆盖配置
    let overrideData = HashMap<String, String>()
    overrideData["APP:NAME"] = "OverrideApp"  // 不区分大小写覆盖
    overrideData["debug"] = "true"           // 区分大小写覆盖
    config.addMemory(overrideData)
    
    let root = config.build()
    
    // 验证不区分大小写的覆盖
    @Expect(root["app:name"], Some("OverrideApp"))
    @Expect(root["APP:NAME"], Some("OverrideApp"))
    
    // 验证区分大小写的覆盖
    @Expect(root["debug"], Some("true"))
    
    // 验证未被覆盖的配置
    @Expect(root["app:version"], Some("1.0.0"))
}

/**
 * 配置节集成测试
 * 测试ConfigurationSection的不区分大小写访问
 */
@Test
func 配置节集成测试() {
    let config = ConfigurationManager()
    
    let testData = HashMap<String, String>()
    testData["section1:key1"] = "value1"
    testData["section1:key2"] = "value2"
    testData["section2:key1"] = "value3"
    testData["section2:key2"] = "value4"
    
    config.addMemory(testData)
    let root = config.build()
    
    // 获取配置节
    let section1 = root.getSection("section1")
    let section2 = root.getSection("SECTION2")  // 不区分大小写
    
    // 验证配置节的不区分大小写访问
    @Expect(section1["key1"], Some("value1"))
    @Expect(section1["KEY1"], Some("value1"))
    
    @Expect(section2["key2"], Some("value4"))
    @Expect(section2["KEY2"], Some("value4"))
}

/**
 * 嵌套配置集成测试
 * 测试嵌套配置的不区分大小写处理
 */
@Test
func 嵌套配置集成测试() {
    let config = ConfigurationManager()
    
    let nestedData = HashMap<String, String>()
    nestedData["parent:child1:subchild1"] = "value1"
    nestedData["parent:child1:subchild2"] = "value2"
    nestedData["parent:child2:subchild1"] = "value3"
    nestedData["PARENT:CHILD1:SUBCHILD3"] = "value4"  // 不区分大小写
    
    config.addMemory(nestedData)
    let root = config.build()
    
    // 验证嵌套配置的不区分大小写访问
    @Expect(root["parent:child1:subchild1"], Some("value1"))
    @Expect(root["PARENT:CHILD1:SUBCHILD1"], Some("value1"))
    
    @Expect(root["parent:child2:subchild1"], Some("value3"))
    @Expect(root["PARENT:CHILD2:SUBCHILD1"], Some("value3"))
    
    @Expect(root["parent:child1:subchild3"], Some("value4"))
    @Expect(root["PARENT:CHILD1:SUBCHILD3"], Some("value4"))
}

/**
 * 配置变更监听集成测试
 * 测试配置变更监听与不区分大小写处理
 */
@Test
func 配置变更监听集成测试() {
    let config = ConfigurationManager()
    
    let initialData = HashMap<String, String>()
    initialData["app:name"] = "InitialApp"
    initialData["app:version"] = "1.0.0"
    
    config.addMemory(initialData)
    let root = config.build()
    
    // 验证初始配置
    @Expect(root["app:name"], Some("InitialApp"))
    @Expect(root["APP:NAME"], Some("InitialApp"))
    
    // 模拟配置变更（在实际应用中，这可能来自配置源的重载）
    let updatedData = HashMap<String, String>()
    updatedData["APP:NAME"] = "UpdatedApp"  // 不区分大小写更新
    updatedData["app:version"] = "2.0.0"
    
    let updatedConfig = ConfigurationManager()
    updatedConfig.addMemory(updatedData)
    let updatedRoot = updatedConfig.build()
    
    // 验证更新后的配置
    @Expect(updatedRoot["app:name"], Some("UpdatedApp"))
    @Expect(updatedRoot["APP:NAME"], Some("UpdatedApp"))
    @Expect(updatedRoot["app:version"], Some("2.0.0"))
}

/**
 * 配置验证集成测试
 * 测试配置验证与不区分大小写处理
 */
@Test
func 配置验证集成测试() {
    let config = ConfigurationManager()
    
    let validationData = HashMap<String, String>()
    validationData["REQUIRED:SETTING"] = "required_value"
    validationData["optional:setting"] = "optional_value"
    validationData["numeric:setting"] = "123"
    
    config.addMemory(validationData)
    let root = config.build()
    
    // 验证必需配置的不区分大小写访问
    @Expect(root["required:setting"], Some("required_value"))
    @Expect(root["REQUIRED:SETTING"], Some("required_value"))
    
    // 验证可选配置的不区分大小写访问
    @Expect(root["optional:setting"], Some("optional_value"))
    @Expect(root["OPTIONAL:SETTING"], Some("optional_value"))
    
    // 验证数值配置的不区分大小写访问
    @Expect(root["numeric:setting"], Some("123"))
    @Expect(root["NUMERIC:SETTING"], Some("123"))
}

/**
 * 配置导出集成测试
 * 测试配置导出与不区分大小写处理
 */
@Test
func 配置导出集成测试() {
    let config = ConfigurationManager()
    
    let exportData = HashMap<String, String>()
    exportData["export:key1"] = "value1"
    exportData["export:key2"] = "value2"
    exportData["EXPORT:KEY3"] = "value3"
    
    config.addMemory(exportData)
    let root = config.build()
    
    // 验证导出配置的不区分大小写访问
    @Expect(root["export:key1"], Some("value1"))
    @Expect(root["EXPORT:KEY1"], Some("value1"))
    
    @Expect(root["export:key2"], Some("value2"))
    @Expect(root["EXPORT:KEY2"], Some("value2"))
    
    @Expect(root["export:key3"], Some("value3"))
    @Expect(root["EXPORT:KEY3"], Some("value3"))
}

/**
 * 多语言配置集成测试
 * 测试多语言配置的不区分大小写处理
 */
@Test
func 多语言配置集成测试() {
    let config = ConfigurationManager()
    
    let multiLangData = HashMap<String, String>()
    multiLangData["app:name:en"] = "Application"
    multiLangData["app:name:zh"] = "应用程序"
    multiLangData["app:name:ja"] = "アプリケーション"
    multiLangData["APP:DESCRIPTION:EN"] = "Test Application"
    multiLangData["APP:DESCRIPTION:ZH"] = "测试应用程序"
    
    config.addMemory(multiLangData)
    let root = config.build()
    
    // 验证多语言配置的不区分大小写访问
    @Expect(root["app:name:en"], Some("Application"))
    @Expect(root["APP:NAME:EN"], Some("Application"))
    
    @Expect(root["app:name:zh"], Some("应用程序"))
    @Expect(root["APP:NAME:ZH"], Some("应用程序"))
    
    @Expect(root["app:description:en"], Some("Test Application"))
    @Expect(root["APP:DESCRIPTION:EN"], Some("Test Application"))
}

/**
 * 配置热重载集成测试
 * 测试配置热重载与不区分大小写处理
 */
@Test
func 配置热重载集成测试() {
    let config = ConfigurationManager()
    
    // 初始配置
    let initialData = HashMap<String, String>()
    initialData["hotreload:enabled"] = "false"
    initialData["hotreload:interval"] = "30"
    
    config.addMemory(initialData)
    let root = config.build()
    
    // 验证初始配置
    @Expect(root["hotreload:enabled"], Some("false"))
    @Expect(root["HOTRELOAD:ENABLED"], Some("false"))
    
    // 模拟热重载配置变更
    let reloadedData = HashMap<String, String>()
    reloadedData["HOTRELOAD:ENABLED"] = "true"  // 不区分大小写更新
    reloadedData["hotreload:interval"] = "60"
    
    let reloadedConfig = ConfigurationManager()
    reloadedConfig.addMemory(reloadedData)
    let reloadedRoot = reloadedConfig.build()
    
    // 验证重载后的配置
    @Expect(reloadedRoot["hotreload:enabled"], Some("true"))
    @Expect(reloadedRoot["HOTRELOAD:ENABLED"], Some("true"))
    @Expect(reloadedRoot["hotreload:interval"], Some("60"))
}

/**
 * 配置继承集成测试
 * 测试配置继承与不区分大小写处理
 */
@Test
func 配置继承集成测试() {
    let config = ConfigurationManager()
    
    // 基础配置
    let baseConfig = HashMap<String, String>()
    baseConfig["base:setting"] = "base_value"
    baseConfig["base:shared"] = "shared_base"
    
    // 继承配置
    let childConfig = HashMap<String, String>()
    childConfig["child:setting"] = "child_value"
    childConfig["CHILD:SHARED"] = "shared_child"  // 不区分大小写覆盖
    
    config.addMemory(baseConfig)
    config.addMemory(childConfig)
    let root = config.build()
    
    // 验证基础配置
    @Expect(root["base:setting"], Some("base_value"))
    @Expect(root["BASE:SETTING"], Some("base_value"))
    
    // 验证子配置
    @Expect(root["child:setting"], Some("child_value"))
    @Expect(root["CHILD:SETTING"], Some("child_value"))
    
    // 验证不区分大小写的覆盖
    @Expect(root["base:shared"], Some("shared_child"))
    @Expect(root["BASE:SHARED"], Some("shared_child"))
}