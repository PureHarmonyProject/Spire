<div align="center">
<h1>asn1-cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v1.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v1.0.0-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-91.8%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>


## 声明

由于目前导入不方便，本人暂时源码引入，项目源地址为：https://gitcode.com/Cangjie-TPC/asnone4cj

## 介绍

asn1-cj 是 ASN.1 编码器和解码器的实现。它支持字节流的 BER 和 DER 编码规则。

### 特性

- 支持 Ber,Der 编码规则
- 支持 Sequence，Set，Tagged 构造类型
- 支持 Boolean，Enumerated，Integer，Null，ObjectIdentifier，PrimitiveValue 原始类型数据
- 支持 BitString，Octet String，String 字符串类型

### 路线

<p align="center">
<img src="./doc/assets/milestone.png" width="100%" >
</p>

## 软件架构

### 源码目录

```shell
.
├── README.md
├── doc
│   ├── assets
│   ├── cjcov
│   ├── design.md
│   └── feature_api.md
├── src
│   └── asn1
└── test
    ├── HLT
    ├── LLT
    └── UT
```

- `doc` 是库的设计文档、提案、库的使用文档、LLT 用例覆盖报告
- `src` 是库源码目录
- `test` 是存放测试用例，包括 HLT 用例、LLT 用例和 UT 用例

### 接口说明

主要是核心类和成员函数说明，详情见 [API](./doc/feature_api.md)

## 使用说明

### 编译

#### stdx环境变量配置

1. 配置本地电脑stdx环境变量,命名是CANGJIE_STDX_PATH
2. stdx使用指导和路径配置：https://gitcode.com/Cangjie/Cangjie-STDX#%E4%BD%BF%E7%94%A8%E6%8C%87%E5%AF%BC
3. 如果变量命名不是CANGJIE_STDX_PATH，修改当前项目cjpm.toml里面的CANGJIE_STDX_PATH修改成自己本地命名参数

#### linux环境编译

编译描述和具体shell命令

${path}修改成用户自己项目本地路径
示例文件在 test/DOC/examples_1.cj 和 test/DOC/examples_2.cj

```shell
git clone https://gitcode.com/Cangjie-TPC/asnone4cj.git;

cd asnone4cj   ---> 切换到项目目录

cjpm build -V   ---> 编译项目
cd target/release/asn1   ---> 切换到编译so目录
cjc  --import-path ${path}/asnone4cj/target/release  -L ${path}/asnone4cj/target/release/asn1 -l asn1  ${path}/asnone4cj/test/DOC/example_1.cj -O0 -Woff all  ---> 编译 test/LLT 用例1
./main   ---> 执行用例1
cjc  --import-path ${path}/asnone4cj/target/release  -L ${path}/asnone4cj/target/release/asn1 -l asn1  ${path}/asnone4cj/test/DOC/example_2.cj -O0 -Woff all  ---> 编译 test/LLT 用例2
./main   ---> 执行用例2
```

#### Window环境编译

编译描述和具体cmd命令

```git bash here
git clone https://gitcode.com/Cangjie-TPC/asnone4cj.git;
```

```cmd
cd asnone4cj
cjpm build -V   ---> 编译项目
cd target/release/asn1
cjc  --import-path ${path}/asnone4cj/target/release  -L ${path}/asnone4cj/target/release/asn1 -l asn1  ${path}/asnone4cj/test/DOC/example_1.cj -O0 -Woff all  ---> 编译 test/LLT 用例1
./main   ---> 执行用例1
cjc  --import-path ${path}/asnone4cj/target/release  -L ${path}/asnone4cj/target/release/asn1 -l asn1  ${path}/asnone4cj/test/DOC/example_2.cj -O0 -Woff all  ---> 编译 test/LLT 用例2
./main   ---> 执行用例2
```

### 功能示例

#### 编码

功能示例描述: Bool类型编码

示例代码如下：

```cangjie
import asn1.*
import std.io.*

main(): Int64 {
    var value3: Array<Byte> = [0x01, 0x01, 0x00]
    var byteArrayStream3: ByteBuffer = ByteBuffer()
    var asn1OutputStream3: ASN1OutputStream = ASN1OutputStream(DEREncoder(), byteArrayStream3)
    asn1OutputStream3.writeObject(ASN1Boolean(false))
    if (byteArrayStream3.bytes() == value3) {
        println("success")
    }

    var value4: Array<Byte> = [0x01, 0x01, 0x01]
    var byteArrayStream4: ByteBuffer = ByteBuffer()
    var asn1OutputStream4: ASN1OutputStream = ASN1OutputStream(DEREncoder(), byteArrayStream4)
    asn1OutputStream4.writeObject(ASN1Boolean(true))
    if (byteArrayStream4.bytes() == value4) {
        println("success")
    }
}
```

执行结果如下：

```shell
success
success
```

#### 解码

功能示例描述: Bool类型解码

示例代码如下：

```cangjie
import asn1.*
import std.io.*

main(): Int64 {
    var value: Array<Byte> = [0x01, 0x01, 0x0]
    var byteArrayStream: ByteBuffer = ByteBuffer()
    byteArrayStream.write(value)
    var asn1InputStream: ASN1InputStream = ASN1InputStream(BERDecoder(), byteArrayStream)
    var asn1Object: ASN1Object = asn1InputStream.readObject()
    if (asn1Object is ASN1Boolean) {
        println("success")
    }
    var object: ASN1Boolean = (asn1Object as ASN1Boolean).getOrThrow()
    var anyValue: Any = object.getValue()
    var boolValue: Bool = (anyValue as Bool).getOrThrow()
    if (!boolValue) {
        println("success")
    }
    if (object.valueHash() == 1237) {
        println("success")
    }

    var value1: Array<Byte> = [0x01, 0x01, 0x01]
    var byteArrayStream1: ByteBuffer = ByteBuffer()
    byteArrayStream1.write(value1)
    var asn1InputStream1: ASN1InputStream = ASN1InputStream(BERDecoder(), byteArrayStream1)
    var asn1Object1: ASN1Object = asn1InputStream1.readObject()
    if (asn1Object1 is ASN1Boolean) {
        println("success")
    }
    var object1: ASN1Boolean = (asn1Object1 as ASN1Boolean).getOrThrow()
    var anyValue1: Any = object1.getValue()
    var boolValue1: Bool = (anyValue1 as Bool).getOrThrow()
    if (boolValue1) {
        println("success")
    }
    if (object1.valueHash() == 1231) {
        println("success")
    }

    return 0
}
```

执行结果如下：

```shell
success
success
success
success
success
success
```

## 开源协议

本项目基于 [Apache License 2.0](./LICENSE) ，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。
