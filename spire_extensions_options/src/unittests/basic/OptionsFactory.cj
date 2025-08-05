package spire_extensions_options.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import spire_extensions_options.*
import spire_extensions_injection.*
import spire_extensions_options.unittests.*

/**
 * 选项工厂创建测试
 * 测试OptionsFactory的创建功能
 */
@Test
func 选项工厂创建测试() {
    let configures = ArrayList<IConfigureOptions<TestOptions>>()
    let configureAfters = ArrayList<IConfigureAfterOptions<TestOptions>>()
    let validations = ArrayList<IValidateOptions<TestOptions>>()
    
    let configuresArray = configures |> collectArray
    let configureAftersArray = configureAfters |> collectArray
    let validationsArray = validations |> collectArray
    
    let factory = OptionsFactory<TestOptions>(configuresArray, configureAftersArray, validationsArray)
    @Expect(true)
}

/**
 * 选项工厂配置测试
 * 测试OptionsFactory的配置功能
 */
@Test
func 选项工厂配置测试() {
    let configures = ArrayList<IConfigureOptions<TestOptions>>()
    let configureAfters = ArrayList<IConfigureAfterOptions<TestOptions>>()
    let validations = ArrayList<IValidateOptions<TestOptions>>()
    
    // 创建配置器
    let services = ServiceCollection().build()
    let configure = ConfigureNamedOptions<TestOptions>(None, services, {
        options, _ => options.version = 1
    })
    configures.add(configure)
    
    let configuresArray = configures |> collectArray
    let configureAftersArray = configureAfters |> collectArray
    let validationsArray = validations |> collectArray
    
    let factory = OptionsFactory<TestOptions>(configuresArray, configureAftersArray, validationsArray)
    let options = factory.create("test")
    @Expect(options.version, 1)
}

/**
 * 选项工厂后置配置测试
 * 测试OptionsFactory的后置配置功能
 */
@Test
func 选项工厂后置配置测试() {
    let configures = ArrayList<IConfigureOptions<TestOptions>>()
    let configureAfters = ArrayList<IConfigureAfterOptions<TestOptions>>()
    let validations = ArrayList<IValidateOptions<TestOptions>>()
    
    // 创建配置器
    let services = ServiceCollection().build()
    let configure = ConfigureNamedOptions<TestOptions>(None, services, {
        options, _ => options.version = 1
    })
    
    // 创建后置配置器
    let configureAfter = ConfigureAfterOptions<TestOptions>(None, services, {
        options, _ => options.version = 2
    })
    
    configures.add(configure)
    configureAfters.add(configureAfter)
    
    let configuresArray = configures |> collectArray
    let configureAftersArray = configureAfters |> collectArray
    let validationsArray = validations |> collectArray
    
    let factory = OptionsFactory<TestOptions>(configuresArray, configureAftersArray, validationsArray)
    let options = factory.create("test")
    @Expect(options.version, 2)
}

/**
 * 选项工厂验证成功测试
 * 测试OptionsFactory的验证成功功能
 */
@Test
func 选项工厂验证成功测试() {
    let configures = ArrayList<IConfigureOptions<TestOptions>>()
    let configureAfters = ArrayList<IConfigureAfterOptions<TestOptions>>()
    let validations = ArrayList<IValidateOptions<TestOptions>>()
    
    // 创建配置器
    let services = ServiceCollection().build()
    let configure = ConfigureNamedOptions<TestOptions>(None, services, {
        options, _ => options.version = 2
    })
    
    // 创建验证器
    let validation = ValidateOptions<TestOptions>(None, services, {
        options, _ => return options.version > 1
    }, "版本必须大于1")
    
    configures.add(configure)
    validations.add(validation)
    
    let configuresArray = configures |> collectArray
    let configureAftersArray = configureAfters |> collectArray
    let validationsArray = validations |> collectArray
    
    let factory = OptionsFactory<TestOptions>(configuresArray, configureAftersArray, validationsArray)
    let options = factory.create("test")
    @Expect(options.version, 2)
}

/**
 * 选项工厂验证失败测试
 * 测试OptionsFactory的验证失败功能
 */
@Test
func 选项工厂验证失败测试() {
    let configures = ArrayList<IConfigureOptions<TestOptions>>()
    let configureAfters = ArrayList<IConfigureAfterOptions<TestOptions>>()
    let validations = ArrayList<IValidateOptions<TestOptions>>()
    
    // 创建配置器
    let services = ServiceCollection().build()
    let configure = ConfigureNamedOptions<TestOptions>(None, services, {
        options, _ => options.version = 1
    })
    
    // 创建验证器
    let validation = ValidateOptions<TestOptions>(None, services, {
        options, _ => return options.version > 1
    }, "版本必须大于1")
    
    configures.add(configure)
    validations.add(validation)
    
    let configuresArray = configures |> collectArray
    let configureAftersArray = configureAfters |> collectArray
    let validationsArray = validations |> collectArray
    
    let factory = OptionsFactory<TestOptions>(configuresArray, configureAftersArray, validationsArray)
    try {
        let _ = factory.create("test")
        @Expect(false)
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
}

/**
 * 选项工厂完整生命周期测试
 * 测试OptionsFactory的完整生命周期功能
 */
@Test
func 选项工厂完整生命周期测试() {
    let configures = ArrayList<IConfigureOptions<TestOptions>>()
    let configureAfters = ArrayList<IConfigureAfterOptions<TestOptions>>()
    let validations = ArrayList<IValidateOptions<TestOptions>>()
    
    // 创建多个配置器
    let services = ServiceCollection().build()
    let configure1 = ConfigureNamedOptions<TestOptions>(None, services, {
        options, _ => options.version = 1
    })
    
    let configure2 = ConfigureNamedOptions<TestOptions>(None, services, {
        options, _ => options.version = 2
    })
    
    // 创建后置配置器
    let configureAfter = ConfigureAfterOptions<TestOptions>(None, services, {
        options, _ => options.version = 3
    })
    
    // 创建验证器
    let validation = ValidateOptions<TestOptions>(None, services, {
        options, _ => return options.version > 2
    }, "版本必须大于2")
    
    configures.add(configure1)
    configures.add(configure2)
    configureAfters.add(configureAfter)
    validations.add(validation)
    
    let configuresArray = configures |> collectArray
    let configureAftersArray = configureAfters |> collectArray
    let validationsArray = validations |> collectArray
    
    let factory = OptionsFactory<TestOptions>(configuresArray, configureAftersArray, validationsArray)
    let options = factory.create("test")
    @Expect(options.version, 3)
} 