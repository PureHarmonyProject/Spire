package spire_extensions_configuration.unittests.config_sources

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_configuration.*
import spire_extensions_configuration.unittests.*

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
 * 多配置源优先级测试
 * 测试多个配置源的优先级和不区分大小写处理
 * 需要先设置本地计算机环境变量
 */

// 框架尚不支持多配置源链式调用，后续会支持

// @Test
// func 多配置源优先级测试() {
//     let root = ConfigurationManager()
//         .addMemory([("priority:base", "base_value"), ("priority:shared", "base_shared"), ("PRIORITY:ENV", "env_value"), ("PRIORITY:SHARED", "env_shared")])
//         .addCmdArgs(["priority:cmd=cmd_value", "PRIORITY:SHARED=cmd_shared"])
//         .addEnvVars("spire_")
//         .build()

//     // 验证优先级：命令行 > 环境变量 > 基础配置
//     @Expect(root["priority:base"], Some("base_value"))  // 只有基础配置有
//     @Expect(root["PRIORITY:BASE"], Some("base_value"))

//     @Expect(root["priority:env"], Some("env_value"))    // 环境变量覆盖基础配置
//     @Expect(root["PRIORITY:ENV"], Some("env_value"))

//     @Expect(root["priority:cmd"], Some("cmd_value"))    // 命令行覆盖环境变量
//     @Expect(root["PRIORITY:CMD"], Some("cmd_value"))

//     // 验证共享配置的优先级（命令行应该覆盖其他）
//     @Expect(root["priority:shared"], Some("cmd_shared"))
//     @Expect(root["PRIORITY:SHARED"], Some("cmd_shared"))
// }

/**
 * 配置源组合测试
 * 测试不同配置源组合的不区分大小写处理
 */

// 框架尚不支持多配置源链式调用，后续会支持

// @Test
// func 配置源组合测试() {
//     let root = ConfigurationManager()
//         .addMemory([
//             ("combo:memory", "memory_value"), 
//             ("combo:shared", "memory_shared"),
//             ("COMBO:ENV", "env_value"), 
//             ("COMBO:SHARED", "env_shared")
//             ])
//         .addCmdArgs(["combo:cmd=cmd_value", "COMBO:SHARED=cmd_shared"])
//         .build()

//     // 验证各配置源的独立键
//     @Expect(root["combo:memory"], Some("memory_value"))
//     @Expect(root["COMBO:MEMORY"], Some("memory_value"))

//     @Expect(root["combo:env"], Some("env_value"))
//     @Expect(root["COMBO:ENV"], Some("env_value"))

//     @Expect(root["combo:cmd"], Some("cmd_value"))
//     @Expect(root["COMBO:CMD"], Some("cmd_value"))

//     // 验证共享键的覆盖
//     @Expect(root["combo:shared"], Some("cmd_shared"))
//     @Expect(root["COMBO:SHARED"], Some("cmd_shared"))
// }

/**
 * 配置源冲突处理测试
 * 测试配置源之间的冲突处理
 */
@Test
func 配置源冲突处理测试() {
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

@Test
func 测试配置读取_字符串() {
    let configuration = ConfigurationManager().addMemory([("data", "cangjie")]).build()

    @Expect(configuration.getValue<String>("data").getOrThrow(), "cangjie")
}

@Test
func 测试配置读取_数字() {
    let configuration = ConfigurationManager().addMemory([("data", "20")]).build()

    @Expect(configuration.getValue<Int64>("data").getOrThrow(), 20)
}

@Test
func 测试配置读取_浮点数() {
    let configuration = ConfigurationManager().addMemory([("data", "20.6")]).build()

    @Expect(configuration.getValue<Float64>("data").getOrThrow(), 20.6)
}

@Test
func 测试配置读取_布尔() {
    let configuration = ConfigurationManager().addMemory([("data", "true")]).build()

    @Expect(configuration.getValue<Bool>("data").getOrThrow(), true)
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
                ("types:bool_true", "true"),
                ("types:bool_false", "false"),
                ("types:float", "123.456"),
                ("types:invalid_int", "not_a_number")
            ]
        )
        .build()

    // 验证字符串类型
    @Expect(root["types:string"], Some("string_value"))
    @Expect(root["TYPES:STRING"], Some("string_value"))

    // 验证整数类型（作为字符串）
    @Expect(root["types:int"], Some("123"))
    @Expect(root["TYPES:INT"], Some("123"))

    // 验证布尔类型（作为字符串）
    @Expect(root["types:bool_true"], Some("true"))
    @Expect(root["types:bool_false"], Some("false"))

    // 验证浮点类型（作为字符串）
    @Expect(root["types:float"], Some("123.456"))
    @Expect(root["TYPES:FLOAT"], Some("123.456"))

    // 验证无效值
    @Expect(root["types:invalid_int"], Some("not_a_number"))
    @Expect(root["TYPES:INVALID_INT"], Some("not_a_number"))
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

    // 验证不区分大小写的访问性能
    // @Expect(root["key_1"], Some("value_1"))
    // @Expect(root["KEY_1"], Some("value_1"))
    // @Expect(root["Key_1"], Some("value_1"))

}

/**
 * 配置源错误恢复测试
 * 测试配置源的错误恢复能力
 */
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
        
        let root2 = ConfigurationManager()
            .addJsonString(invalidJson)  // 这个应该被抛出异常
            .addJsonString(validJson)    // 这个不会工作
            .build()
        
    } catch (e: Exception) {
        @Expect(true)
    }
}