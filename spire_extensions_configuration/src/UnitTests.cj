package spire_extensions_configuration

import std.convert.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*



@Test
func 测试配置读取_环境变量() {
    let configuration = ConfigurationManager()
        .addEnvVars("aspire_")
        .build()

    @Expect(configuration.getValue<String>("host_name").getOrThrow(), "www.soulsoft.com")
}

@Test
func 测试配置读取_命令行参数() {
    let configuration = ConfigurationManager()
        .addCmdArgs("--host-name=www.soulsoft.com")
        .build()

    @Expect(configuration.getValue<String>("host-name").getOrThrow(), "www.soulsoft.com")
}

@Test
func 测试配置读取_Json() {
    let json = ###"
    {
        "name": "spire", 
        "like": [1,2,3], 
        "logging": {
            "default": "Info"
        }
    }
    "###
    let configuration = ConfigurationManager()
        .addJsonString(json)
        .build()

    @Expect(configuration.getValue<String>("name").getOrThrow(), "spire")
}

@Test
func 测试配置读取_Json_Array() {
    let json = ###"
    {
        "name": "spire", 
        "like": [1,2,3], 
        "logging": {
            "default": "Info"
        }
    }
    "###
    let configuration = ConfigurationManager()
        .addJsonString(json)
        .build()
    let list = ArrayList<Int64>()
    for (pattern in configuration.getSection("like").getChildren()) {
        list.add(Int64.parse(pattern.value.getOrThrow()))
    }
    @Expect(list |> collectArray, [1,2,3])
}

@Test
func 测试配置读取_Json_Section() {
    let json = ###"
    {
        "name": "spire", 
        "like": [1,2,3], 
        "logging": {
            "default": "Info"
        }
    }
    "###
    let configuration = ConfigurationManager()
        .addJsonString(json)
        .build()
    let list = ArrayList<String>()
    for (pattern in configuration.getSection("logging").getChildren()) {
        list.add(pattern.value.getOrThrow())
    }
    @Expect(list |> collectArray, ["Info"])
}