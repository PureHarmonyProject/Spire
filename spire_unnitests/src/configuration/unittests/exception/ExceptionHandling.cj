package spire_unnitests.configuration.unittests.exception

import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_configuration.*
import spire_unnitests.configuration.unittests.*

/**
 * JSON配置源解析异常测试
 * 测试无效JSON字符串的处理
 */
@Test
func JSON配置源解析异常测试() {
    // 测试无效的JSON格式
    let invalidJson = ###"{
        "name": "spire",
        "invalid": {
            "missing": ,
            "unclosed": "value
        }
    }"###

    try {
        let _ = ConfigurationManager().addJsonString(invalidJson).build()
        @Expect(false) // 不应该成功构建
    } catch (e: Exception) {
        @Expect(true) // 期望抛出异常
    }
}

/**
 * JSON配置源空字符串异常测试
 * 测试空JSON字符串的处理
 * 空字符串正确书写方式应当为"{}"
 */
@Test
func JSON配置源空字符串异常测试() {
    // 空字符串正确写法，应当被优雅处理
    try {
        let _ = ConfigurationManager()
            .addJsonString("{}")
            .build()
        @Expect(true) // 空字符串应该被优雅处理
    } catch (e: Exception) {
        @Expect(false) // 不应该抛出异常
    }

    // 空字符串错误写法，应当抛出异常
    try {
        let _ = ConfigurationManager()
            .addJsonString("")
            .build()
        @Expect(false) // 空字符串应该抛出异常
    } catch (e: Exception) {
        @Expect(true) // 应该抛出异常
    }
}

/**
 * 命令行参数格式异常测试
 * 测试无效命令行参数格式的处理
 */
@Test
func 命令行参数格式异常测试() {
    let invalidArgs = [
        "invalid_format", // 没有等号
        "key=value=extra", // 多个等号
        "=value", // 空键
        "EmptyKey=" // 空值
    ]

    try {
        let root = ConfigurationManager().addCmdArgs(invalidArgs).build()

        // 验证无效参数被忽略或正确处理
        @Expect(root["invalid_format"], None)
        @Expect(root["key"], Some("value=extra"))
        @Expect(root[""], Some("value"))
        @Expect(root["EmptyKey"], Some(""))
    } catch (e: Exception) {
        @Expect(false) // 不应该抛出异常
    }
}

/**
 * 配置值类型转换异常测试
 * 测试配置值类型转换过程中的异常
 */
@Test
func 配置值类型转换异常测试() {
    let root = ConfigurationManager()
        .addMemory(
            [
                ("int:valid", "123"),
                ("int:invalid", "abc"),
                ("float:valid", "123.456"),
                ("float:invalid", "abc.def"),
                ("bool:valid", "true"),
                ("bool:invalid", "maybe"),
                ("string:valid", "hello")
            ]
        )
        .build()

    // 测试有效的类型转换
    @Expect(root.getValue<Int64>("int:valid").getOrThrow(), 123)
    @Expect(root.getValue<Float64>("float:valid").getOrThrow(), 123.456)
    @Expect(root.getValue<Bool>("bool:valid").getOrThrow(), true)
    @Expect(root.getValue<String>("string:valid").getOrThrow(), "hello")

    // 测试无效的类型转换
    try {
        @Expect(root.getValue<Int64>("int:invalid"), None)
        @Expect(root.getValue<Float64>("float:invalid"), None)
        @Expect(root.getValue<Bool>("bool:invalid"), None)
    } catch (e: Exception) {
        @Expect(true)
    }

}

/**
 * 空字符串的类型转换异常测试
 * 测试空字符串的类型转换异常
 */
@Test
func 空字符串的类型转换异常测试() {
    let root = ConfigurationManager()
        .addMemory([("string:empty", "")])
        .build()

    // 测试空字符串的类型转换
    @Expect(root.getValue<String>("string:empty").getOrThrow(), "") // 空字符串应当被转换为空字符串
    // 空字符串转换为其他类型应当抛出异常
    try {
        @Expect(root.getValue<Int64>("string:empty"), None)
    } catch (e: Exception) {
        @Expect(true)
    }

    // 测试空字符串转换为浮点数应当抛出异常
    try {
        @Expect(root.getValue<Float64>("string:empty"), None)
    } catch (e: Exception) {
        @Expect(true)
    }

    // 测试空字符串转换为布尔值应当抛出异常
    try {
        @Expect(root.getValue<Bool>("string:empty"), None)
    } catch (e: Exception) {
        @Expect(true)
    }      
}

/**
 * 配置键访问异常测试
 * 测试访问不存在或无效配置键的处理
 */
@Test
func 配置键访问异常测试() {
    let root = ConfigurationManager()
        .addMemory(
            [
                ("valid:key", "value"),
                ("", "empty_key_value"),
                ("key:with:colons", "colon_value")
            ]
        )
        .build()

    // 测试访问不存在的键
    @Expect(root["nonexistent:key"], None)
    @Expect(root["VALID:KEY"], Some("value")) // 不区分大小写
    @Expect(root[""], Some("empty_key_value"))
    @Expect(root["key:with:colons"], Some("colon_value"))

    // 测试访问嵌套不存在的键
    @Expect(root["valid:nonexistent"], None)
    @Expect(root["valid:key:nested"], None)
}

/**
 * 配置节访问异常测试
 * 测试配置节访问过程中的异常
 */
@Test
func 配置节访问异常测试() {
    let root = ConfigurationManager()
        .addMemory(
            [
                ("section:key1", "value1"),
                ("section:key2", "value2"),
                ("section:nested:key", "nested_value")
            ]
        )
        .build()

    // 测试获取存在的节
    let section = root.getSection("section")
    @Expect(section["key1"], Some("value1"))
    @Expect(section["key2"], Some("value2"))

    // 测试获取不存在的节
    let nonexistentSection = root.getSection("nonexistent")
    @Expect(nonexistentSection["any_key"], None)

    // 测试获取嵌套节
    let nestedSection = root.getSection("section:nested")
    @Expect(nestedSection["key"], Some("nested_value"))
}

/**
 * 多配置源冲突异常测试
 * 测试多个配置源之间的冲突处理
 */
@Test
func 多配置源冲突异常测试() {
    let root = ConfigurationManager()
        .addMemory(
            [
                ("conflict:key", "memory_value"),
                ("conflict:shared", "memory_shared")
            ]
        )
        .addCmdArgs(
            [
                "conflict:key=cmd_value",
                "conflict:cmd_only=cmd_only_value"
            ]
        )
        .addJsonString(
            ###"{
            "conflict": {
                "key": "json_value",
                "json_only": "json_only_value"
            }
        }"###)
        .build()

    // 验证冲突处理（后面的配置源覆盖前面的）
    @Expect(root["conflict:key"], Some("json_value"))
    @Expect(root["conflict:shared"], Some("memory_shared"))
    @Expect(root["conflict:cmd_only"], Some("cmd_only_value"))
    @Expect(root["conflict:json_only"], Some("json_only_value"))
}

/**
 * 配置值设置异常测试
 * 测试配置值设置过程中的异常
 */
@Test
func 配置值设置异常测试() {
    let root = ConfigurationManager().addMemory([("original:key", "original_value")]).build()

    // 测试设置新值
    root["new:key"] = "new_value"
    @Expect(root["new:key"], Some("new_value"))

    // 测试覆盖现有值
    root["original:key"] = "updated_value"
    @Expect(root["original:key"], Some("updated_value"))

    // 测试设置null值
    root["null:key"] = None
    @Expect(root["null:key"], None)

    // 测试设置空字符串
    root["empty:key"] = ""
    @Expect(root["empty:key"], Some(""))
}
