package spire_extensions_options.unittests.exception

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import std.reflect.*
import spire_extensions_options.*
import spire_extensions_options.unittests.*

/**
 * 选项验证异常构造函数测试
 * 测试OptionsValidationException的构造函数
 */
@Test
func 选项验证异常构造函数测试() {
    let failures = ["测试验证失败"]
    let exception = OptionsValidationException("TestOptions", TypeInfo.of<TestOptions>(), failures)
    @Expect(exception.message, "测试验证失败")
}

/**
 * 验证选项结果成功测试
 * 测试ValidateOptionsResult的成功结果
 */
@Test
func 验证选项结果成功测试() {
    let result = ValidateOptionsResult.success
    @Expect(result.succeeded, true)
    @Expect(result.failed, false)
    @Expect(result.failures.isNone(), true)
}

/**
 * 验证选项结果失败测试
 * 测试ValidateOptionsResult的失败结果
 */
@Test
func 验证选项结果失败测试() {
    let failures = ArrayList<String>()
    failures.add("失败1")
    failures.add("失败2")
    let result = ValidateOptionsResult.fail(failures)
    @Expect(result.succeeded, false)
    @Expect(result.failed, true)
    @Expect(result.failures.getOrThrow().size, 2)
}

/**
 * 验证选项结果单失败测试
 * 测试ValidateOptionsResult的单失败结果
 */
@Test
func 验证选项结果单失败测试() {
    let result = ValidateOptionsResult.fail("单个失败")
    @Expect(result.succeeded, false)
    @Expect(result.failed, true)
    @Expect(result.failures.getOrThrow().size, 1)
} 