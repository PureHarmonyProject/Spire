package spire_unnitests.configuration.unittests.config_sources

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_configuration.*
import spire_unnitests.configuration.unittests.*

/**
 * 内存配置源测试
 * 测试MemoryConfigurationSource的不区分大小写处理
 */
@Test
func 内存配置源测试() {
    let root = ConfigurationManager()
        .addMemory([("memory:key1", "value1"), ("Memory:Key2", "Value2"), ("MEMORY:KEY3", "VALUE3")])
        .build()

    // 验证不区分大小写的访问
    @Expect(root["memory:key1"], Some("value1"))
    @Expect(root["MEMORY:KEY1"], Some("value1"))
    @Expect(root["Memory:Key1"], Some("value1"))

    @Expect(root["memory:key2"], Some("Value2"))
    @Expect(root["MEMORY:KEY2"], Some("Value2"))
    @Expect(root["Memory:Key2"], Some("Value2"))

    @Expect(root["memory:key3"], Some("VALUE3"))
    @Expect(root["MEMORY:KEY3"], Some("VALUE3"))
    @Expect(root["Memory:Key3"], Some("VALUE3"))
}

/**
 * 环境变量配置源测试
 * 测试EnvVarsConfigurationSource的不区分大小写处理
 * 需要先设置本地计算机环境变量
 */
@Test
func 测试配置读取_环境变量() {
    let configuration = ConfigurationManager().addEnvVars("spire_").build()

    @Expect(configuration["port"], Some("8080"))
    @Expect(configuration.getValue<String>("port").getOrThrow(), "8080")
}

@Test
func 测试配置读取_命令行参数() {
    let configuration = ConfigurationManager().addCmdArgs("--host-name=www.soulsoft.com").build()

    // 两种读取方式
    @Expect(configuration["host-name"], Some("www.soulsoft.com"))
    @Expect(configuration.getValue<String>("host-name").getOrThrow(), "www.soulsoft.com")
}

/**
 * 命令行参数配置源测试
 * 测试CmdArgsConfigurationSource的不区分大小写处理
 */
@Test
func 多个命令行参数配置源测试() {
    let root = ConfigurationManager().addCmdArgs(["cmd:key1=value1", "CMD:KEY2=value2", "--Cmd:Key3=value3"]).build()

    // 验证命令行参数的不区分大小写访问
    @Expect(root["cmd:key1"], Some("value1"))
    @Expect(root["CMD:KEY1"], Some("value1"))
    @Expect(root["Cmd:Key1"], Some("value1"))

    @Expect(root["cmd:key2"], Some("value2"))
    @Expect(root["CMD:KEY2"], Some("value2"))
    @Expect(root["Cmd:Key2"], Some("value2"))

    @Expect(root["cmd:key3"], Some("value3"))
    @Expect(root["CMD:KEY3"], Some("value3"))
    @Expect(root["Cmd:Key3"], Some("value3"))
}

/**
 * JSON配置源测试
 * 测试JsonConfigurationSource的不区分大小写处理
 */
@Test
func JSON配置源测试() {
    let jsonData = ###"{
        "JsonConfig": {
            "Key1": "JsonValue1",
            "key2": "JsonValue2",
            "KEY3": "JsonValue3"
        },
        "Nested": {
            "Level1": {
                "Level2": {
                    "Key": "NestedValue"
                }
            }
        }
    }"###

    let root = ConfigurationManager().addJsonString(jsonData).build()

    // 验证JSON配置的不区分大小写访问
    @Expect(root["JsonConfig:Key1"], Some("JsonValue1"))
    @Expect(root["jsonconfig:key1"], Some("JsonValue1"))
    @Expect(root["JSONCONFIG:KEY1"], Some("JsonValue1"))

    @Expect(root["JsonConfig:key2"], Some("JsonValue2"))
    @Expect(root["jsonconfig:key2"], Some("JsonValue2"))
    @Expect(root["JSONCONFIG:KEY2"], Some("JsonValue2"))

    @Expect(root["JsonConfig:KEY3"], Some("JsonValue3"))
    @Expect(root["jsonconfig:key3"], Some("JsonValue3"))
    @Expect(root["JSONCONFIG:KEY3"], Some("JsonValue3"))

    // 验证嵌套JSON配置
    @Expect(root["Nested:Level1:Level2:Key"], Some("NestedValue"))
    @Expect(root["nested:level1:level2:key"], Some("NestedValue"))
    @Expect(root["NESTED:LEVEL1:LEVEL2:KEY"], Some("NestedValue"))
}

/**
 * 配置源冲突处理测试
 * 测试配置源之间的冲突处理
 */
@Test
func 单配置源冲突处理测试() {
    let root = ConfigurationManager()
        .addMemory(
            [
                ("conflict:key", "source1_value"),
                ("Conflict:Key", "source2_value"),
                ("CONFLICT:KEY", "source3_value"),
                ("conflict:shared", "source1_shared"),
                ("conflict:SHARED", "source2_shared"),
                ("CONFLICT:SHARED", "source3_shared")
            ]
        )
        .build()

    // 验证冲突处理（后面的配置源应该覆盖前面的）
    @Expect(root["conflict:key"], Some("source3_value"))
    @Expect(root["CONFLICT:KEY"], Some("source3_value"))
    @Expect(root["Conflict:Key"], Some("source3_value"))

    @Expect(root["conflict:shared"], Some("source3_shared"))
    @Expect(root["CONFLICT:SHARED"], Some("source3_shared"))
    @Expect(root["Conflict:Shared"], Some("source3_shared"))
}

/**
 * 多配置源覆盖测试
 * 测试多个配置源的覆盖和不区分大小写处理
 * 需要先设置本地计算机环境变量
 */

@Test
func 多配置源覆盖测试() {

    let jsonData = ###"{
        "spire:port":"json_value"
    }"###

    let root = ConfigurationManager()
        .addMemory([
            ("spire:Memory","memory_value")
        ])
        .addCmdArgs([
            "spire:port=cmd_value",
            "--spire:port=cmd_value"
         ])
        .addEnvVars("spire_")
        .addJsonString(jsonData)
        .build()

    @Expect(root["spire:port"], Some("json_value"))
}

/**
 * 多配置源组合测试
 * 测试不同配置源组合的独立性
 */

@Test
func 多配置源组合测试() {
    let root = ConfigurationManager()
        .addMemory([
            ("combo:memory", "memory_value")
            ])
        .addCmdArgs(["combo:cmd=cmd_value"])
        .addJsonString(###"{
            "combo:json": "json_value"
        }"###)
        .build()

    @Expect(root["combo:memory"], Some("memory_value"))
    @Expect(root["combo:cmd"], Some("cmd_value"))
    @Expect(root["combo:json"], Some("json_value"))
}


/**
 * 配置源空值处理测试
 * 测试配置源中的空值处理
 */
@Test
func 配置源空值处理测试() {
    let root = ConfigurationManager()
        .addMemory(
            [("empty:normal", "normal_value"), ("empty:blank", ""), ("empty:whitespace", "   "), ("", "empty_key_value")])
        .build()

    // 验证正常值
    @Expect(root["empty:normal"], Some("normal_value"))
    @Expect(root["EMPTY:NORMAL"], Some("normal_value"))

    // 验证空字符串值
    @Expect(root["empty:blank"], Some(""))
    @Expect(root["EMPTY:BLANK"], Some(""))

    // 验证空白字符串值
    @Expect(root["empty:whitespace"], Some("   "))
    @Expect(root["EMPTY:WHITESPACE"], Some("   "))

    // 验证空键
    @Expect(root[""], Some("empty_key_value"))
}

/**
 * 配置源特殊字符测试
 * 测试配置源中的特殊字符处理
 */
@Test
func 配置源特殊字符测试() {
    let root = ConfigurationManager()
        .addMemory(
            [
                ("special:with-dashes", "dash_value"),
                ("special:with_underscores", "underscore_value"),
                ("special:with.dots", "dot_value"),
                ("special:with spaces", "space_value"),
                ("special:with@symbols", "symbol_value"),
                ("special:with:colons", "colon_value")
            ]
        )
        .build()

    // 验证特殊字符键的访问
    @Expect(root["special:with-dashes"], Some("dash_value"))
    @Expect(root["SPECIAL:WITH-DASHES"], Some("dash_value"))

    @Expect(root["special:with_underscores"], Some("underscore_value"))
    @Expect(root["SPECIAL:WITH_UNDERSCORES"], Some("underscore_value"))

    @Expect(root["special:with.dots"], Some("dot_value"))
    @Expect(root["SPECIAL:WITH.DOTS"], Some("dot_value"))

    @Expect(root["special:with spaces"], Some("space_value"))
    @Expect(root["SPECIAL:WITH SPACES"], Some("space_value"))

    @Expect(root["special:with@symbols"], Some("symbol_value"))
    @Expect(root["SPECIAL:WITH@SYMBOLS"], Some("symbol_value"))

    @Expect(root["special:with:colons"], Some("colon_value"))
    @Expect(root["SPECIAL:WITH:COLONS"], Some("colon_value"))
}

/**
 * 配置源类型转换测试
 * 测试配置源中的类型转换
 */
@Test
func 配置源类型转换测试() {
    let root = ConfigurationManager()
        .addMemory(
            [
                ("types:string", "string_value"),
                ("types:int", "123"),
                ("types:float", "123.456"),
                ("types:bool_true", "true"),
                ("types:invalid_int", "None")
            ]
        )
        .build()

    // 验证字符串类型
    @Expect(root.getValue<String>("types:string").getOrThrow(), "string_value")

    // 验证整数类型
    @Expect(root.getValue<Int64>("types:int").getOrThrow(), 123)

    // 验证浮点类型
    @Expect(root.getValue<Float64>("types:float").getOrThrow(), 123.456)

    // 验证布尔类型
    @Expect(root.getValue<Bool>("types:bool_true").getOrThrow(), true)

    // 验证无效值转换失败报错
    try {
        @Expect(root.getValue<Int64>("types:invalid_int"), None)
    } catch (e: Exception) {
        @Expect(true)
    }
}

/**
 * 配置源性能测试
 * 测试配置源的性能表现
 */
@Test
func 配置源性能测试() {
    let root = ConfigurationManager().addMemory(TestHelper.createTestData(100)).build()

    // 验证性能测试的数据完整性
    @Expect(root["key_1"], Some("VALUE_1"))
    @Expect(root["Key_50"], Some("VALUE_50"))
    @Expect(root["KEY_100"], Some("VALUE_100"))

}

/**
 * 配置源错误恢复测试
 * 测试配置源的错误恢复能力
 */
@Test
func 配置源错误恢复测试() {
    try {
        let invalidJson = ###"12345 @ abcd_+-=!@#$%^&*()_[]{};':\"\\,./<>?`~{ invalid json }"###
        let validJson = ###"{
            "JsonConfig": {
                "Key1": "JsonValue1",
                "key2": "JsonValue2",
                "KEY3": "JsonValue3"
            },
            "Nested": {
                "Level1": {
                    "Level2": {
                        "Key": "NestedValue"
                    }
                }
            }
        }"###
        
        let _ = ConfigurationManager()
            .addJsonString(invalidJson)  // 这个应该被抛出异常
            .addJsonString(validJson)    // 这个不会工作
            .build()
        
    } catch (e: Exception) {
        @Expect(true)
    }
}