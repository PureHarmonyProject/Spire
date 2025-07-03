# aspire_extensions_configuration

配置管理（Configuration）库，用于加载和解析 JSON 配置文件（appsettings.json）、环境变量、命令行参数等，并可以自定义配资源。

## 创建配置

``` cangjie
let configuration = ConfigurationManager()
    .addMemory([("data", "cangjie")])
    .build()
configuration["data"] |> println    
``` 

## 添加json配置

``` cangjie
let json = ###"
    {
        "name": "aspire", 
        "like": [1,2,3], 
        "logging": {
            "default": "Info"
        }
    }
    "###

let configuration = ConfigurationManager()
    .addJsonString(json)
    .build()
```

> 也可以调用`addJsonFile`来添加json配置文件

## 添加命令行配置

``` cangjie
main(args: Array<String>) {
    let configuration = ConfigurationManager()
        .addCmdVars(args)
        .build()
    configuration["hostName"] |> println      
    return 0    
}
```
> 编译之后通过./main host-name=www.soulsoft.com来输入参数    
> 命令行参数不区分大小写，如果希望下一个字符大写开头，使用`-`分割。如：`host-name`即`hostName`

## 添加环境变量配置

``` cangjie
main() {
    let configuration = ConfigurationManager()
        //添加"ASPIRE_"开头的环境变量
        .addEnvVars("ASPIRE")
        .build()
    //键名不包含"ASPIRE"    
    configuration["hostName"] |> println  
    return 0    
}
```

> 环境变量同样不区分大小写，如果希望下一个字符大写开头，使用`_`分割。如：`ASPIRE-HOST-NAME`即`hostName`

## 读取配置

``` cangjie
let configuration = ConfigurationManager()
    .addMemory([("age", "20"), ("name", "cangjie")])
    .build()

let name1 = configuration["name"] 
let name2 = configuration.getValue<String>("name")  

let age1 = configuration["age"]
let age2 = configuration.getValue<Int64>("age")  
```

## 读取节块

``` cangjie
let json = ###"
{
    "logging": {
        "default": "Info",
        "aspire_extensions_hosting": "Error"
    }
}
"###
let configuration = ConfigurationManager()
    .addJsonString(json)
    .build()
for (pattern in configuration.getSection("logging").getChildren()) {
    "${pattern.key} = ${pattern.value}"
}
```

## 读取数组


``` cangjie
let json = ###"
{
    "like": [1,2,3]
}
"###
let configuration = ConfigurationManager()
    .addJsonString(json)
    .build()
for (pattern in configuration.getSection("like").getChildren()) {
    "${pattern.value}"
}
```