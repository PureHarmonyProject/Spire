package spire_unnitests.configuration.unittests.integration

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_configuration.*
import spire_unnitests.configuration.unittests.*

/**
 * 配置构建器集成测试
 * 测试ConfigurationBuilder与IgnoreCaseHashMap的集成
 */
@Test
func 配置构建器集成测试() {
    let builder = ConfigurationBuilder()
    
    // 添加JSON配置源
    let jsonConfig = ###"{
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
    childConfig["child:setting"] = "child_value"  // 子配置新增配置项
    childConfig["BASE:SHARED"] = "shared_child"  // 子配置覆盖父配置
    
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

/**
 * 配置节遍历集成测试
 * 测试配置节的遍历功能与不区分大小写处理
 */
@Test
func 配置节遍历集成测试() {
    let config = ConfigurationManager()
    
    let traversalData = HashMap<String, String>()
    traversalData["section1:key1"] = "value1"
    traversalData["section1:key2"] = "value2"
    traversalData["section1:subsection:key3"] = "value3"
    traversalData["section2:key1"] = "value4"
    traversalData["section2:key2"] = "value5"
    traversalData["SECTION3:KEY1"] = "value6"  // 不区分大小写
    traversalData["section3:key2"] = "value7"
    
    config.addMemory(traversalData)
    let root = config.build()
    
    // 获取根级别的子节
    let rootChildren = root.getChildren()
    @Expect(rootChildren.size, 3)  // section1, section2, section3
    
    // 验证子节的键名不区分大小写
    let childKeys = ArrayList<String>()
    for (child in rootChildren) {
        childKeys.add(child.key)
    }
    
    // 验证所有子节都存在
    @Expect(childKeys.contains("section1"), true)
    @Expect(childKeys.contains("section2"), true)
    @Expect(childKeys.contains("section3"), true)
    
    // 测试特定配置节的遍历
    let section1 = root.getSection("section1")
    let section1Children = section1.getChildren()
    @Expect(section1Children.size, 3)  // key1, key2, subsection
    
    // 验证section1的子节
    let section1ChildKeys = ArrayList<String>()
    for (child in section1Children) {
        section1ChildKeys.add(child.key)
    }
    
    @Expect(section1ChildKeys.contains("key1"), true)
    @Expect(section1ChildKeys.contains("key2"), true)
    @Expect(section1ChildKeys.contains("subsection"), true)
    
    // 测试嵌套配置节的遍历
    let subsection = section1.getSection("subsection")
    let subsectionChildren = subsection.getChildren()
    @Expect(subsectionChildren.size, 1)  // key3
    
    let subsectionChild = subsectionChildren |> collectArray
    @Expect(subsectionChild[0].key, "key3")
    @Expect(subsectionChild[0].value, Some("value3"))
}


/**
 * 配置节递归遍历集成测试
 * 测试配置节的递归遍历功能
 */
@Test
func 配置节递归遍历集成测试() {
    let config = ConfigurationManager()
    
    let recursiveData = HashMap<String, String>()
    recursiveData["level1:key1"] = "value1"
    recursiveData["level1:level2:key2"] = "value2"
    recursiveData["level1:level2:level3:key3"] = "value3"
    recursiveData["level1:level2:level3:level4:key4"] = "value4"
    recursiveData["LEVEL1:LEVEL2:LEVEL3:LEVEL4:LEVEL5:KEY5"] = "value5"  // 不区分大小写
    
    config.addMemory(recursiveData)
    let root = config.build()
    
    // 验证特定路径的递归访问
    let level1 = root.getSection("level1")
    let level2 = level1.getSection("level2")
    let level3 = level2.getSection("level3")
    let level4 = level3.getSection("level4")
    let level5 = level4.getSection("level5")
    
    @Expect(level1["key1"], Some("value1"))
    @Expect(level2["key2"], Some("value2"))
    @Expect(level3["key3"], Some("value3"))
    @Expect(level4["key4"], Some("value4"))
    @Expect(level5["key5"], Some("value5"))  // 不区分大小写访问
    @Expect(level5["KEY5"], Some("value5"))
    
    // 验证配置节的遍历功能
    let rootChildren = root.getChildren()
    @Expect(rootChildren.size, 1)  // 只有level1
    
    let level1Children = level1.getChildren()
    @Expect(level1Children.size, 2)  // key1, level2
    
    let level2Children = level2.getChildren()
    @Expect(level2Children.size, 2)  // key2, level3
    
    let level3Children = level3.getChildren()
    @Expect(level3Children.size, 2)  // key3, level4
    
    let level4Children = level4.getChildren()
    @Expect(level4Children.size, 2)  // key4, level5

    let level5Children = level5.getChildren()
    @Expect(level5Children.size, 1)  // key5
}

/**
 * 配置节递归遍历集成测试
 * 测试配置节的递归遍历功能
 */
@Test
func JSON配置节递归遍历集成测试() {
    let config = ConfigurationManager()
    
    let jsonConfig = ###"{
        "level1": {
            "key1": "value1",
            "level2": {
                "key2": "value2",
                "level3": {
                    "key3": "value3",
                    "level4": {
                        "key4": "value4",
                        "level5": {
                            "key5": "value5"
                        }
                    }
                }
            }
        }
    }"###

    config.addJsonString(jsonConfig)
    let root = config.build()
    
    // 验证特定路径的递归访问
    let level1 = root.getSection("level1")
    let level2 = level1.getSection("level2")
    let level3 = level2.getSection("level3")
    let level4 = level3.getSection("level4")
    let level5 = level4.getSection("level5")
    
    @Expect(level1["key1"], Some("value1"))
    @Expect(level2["key2"], Some("value2"))
    @Expect(level3["key3"], Some("value3"))
    @Expect(level4["key4"], Some("value4"))
    @Expect(level5["key5"], Some("value5"))  // 不区分大小写访问
    @Expect(level5["KEY5"], Some("value5"))
    
    // 验证配置节的遍历功能
    let rootChildren = root.getChildren()
    @Expect(rootChildren.size, 1)  // 只有level1
    
    let level1Children = level1.getChildren()
    @Expect(level1Children.size, 2)  // key1, level2
    
    let level2Children = level2.getChildren()
    @Expect(level2Children.size, 2)  // key2, level3
    
    let level3Children = level3.getChildren()
    @Expect(level3Children.size, 2)  // key3, level4
    
    let level4Children = level4.getChildren()
    @Expect(level4Children.size, 2)  // key4, level5

    let level5Children = level5.getChildren()
    @Expect(level5Children.size, 1)  // key5
}

/**
 * 动态配置更新集成测试
 * 测试动态配置更新与遍历功能的结合
 */
@Test
func 动态配置更新集成测试() {
    let config = ConfigurationManager()
    
    let initialData = HashMap<String, String>()
    initialData["dynamic:setting1"] = "initial_value1"
    initialData["dynamic:setting2"] = "initial_value2"
    initialData["dynamic:subsection:setting3"] = "initial_value3"
    
    config.addMemory(initialData)
    let root = config.build()
    
    // 验证初始配置
    let dynamicSection = root.getSection("dynamic")
    @Expect(dynamicSection["setting1"], Some("initial_value1"))
    @Expect(dynamicSection["setting2"], Some("initial_value2"))
    
    let subsection = dynamicSection.getSection("subsection")
    @Expect(subsection["setting3"], Some("initial_value3"))
    
    // 动态更新配置
    root["dynamic:setting1"] = "updated_value1"
    root["DYNAMIC:SETTING2"] = "updated_value2"  // 不区分大小写更新
    root["dynamic:subsection:setting3"] = "updated_value3"
    root["dynamic:subsection:new_setting"] = "new_value"
    
    // 验证更新后的配置
    @Expect(dynamicSection["setting1"], Some("updated_value1"))
    @Expect(dynamicSection["SETTING1"], Some("updated_value1"))  // 不区分大小写访问
    @Expect(dynamicSection["setting2"], Some("updated_value2"))
    @Expect(dynamicSection["SETTING2"], Some("updated_value2"))  // 不区分大小写访问
    
    @Expect(subsection["setting3"], Some("updated_value3"))
    @Expect(subsection["new_setting"], Some("new_value"))
    @Expect(subsection["NEW_SETTING"], Some("new_value"))  // 不区分大小写访问
    
    // 验证遍历功能在更新后仍然正常工作
    let updatedChildren = dynamicSection.getChildren()
    @Expect(updatedChildren.size, 3)  // setting1, setting2, subsection
    
    let subsectionChildren = subsection.getChildren()
    @Expect(subsectionChildren.size, 2)  // setting3, new_setting
}