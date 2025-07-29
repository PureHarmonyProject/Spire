/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1ObjectIdentifier <: ASN1PrimitiveValue {
    protected var oid: String

    public init(oid: String) {
        super(OBJECT_IDENTIFIER)
        this.oid = oid
    }

    public init(oid: String, valueBytes: Array<Byte>) {
        super(OBJECT_IDENTIFIER, valueBytes)
        this.oid = oid
    }

    public override func getValue(): Any {
        return oid
    }

    public func valueHash(): Int64 {
        return oid.hashCode()
    }
}

public class ObjectIdentifierParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public override func parse(_: ASN1Tag, value: Array<Byte>): ASN1Object {
        Checks.checkArgument(
            value.size > 0,
            "An ASN.1 OBJECT IDENTIFIER should have at least a one byte value",
            Array<ToString>()
        )
        var byteArrayStream: ByteBuffer = ByteBuffer()

        // 将 buffer 中的数据写入到输出流中，当数据全部成功写入则函数返回
        byteArrayStream.write(value)

        // 返回当前缓冲区总容量
        var dataArr: Array<Byte> = Array<Byte>(1, repeat: 0)
        byteArrayStream.read(dataArr)
        var firstTwo: Byte = dataArr[0]
        var stringBuilder: StringBuilder = StringBuilder()
        stringBuilder.append(firstTwo / 40)
        stringBuilder.append('.')
        stringBuilder.append(firstTwo % 40)
        while (byteArrayStream.remainLength > 0) {
            byteArrayStream.read(dataArr)
            var x: Byte = dataArr[0]
            if (x < 127) {
                stringBuilder.append('.')
                stringBuilder.append(x)
            } else {
                var vInt: Int64 = Int64(x) & 0x7f
                var v: BigInt = BigInt(vInt)
                do {
                    byteArrayStream.read(dataArr)
                    x = dataArr[0]
                    var r: BigInt = v <<7
                    var b: BigInt = BigInt(Int64(x) & 0x7f)
                    var c: BigInt = r + b
                    v = c
                } while (x > 127)
                stringBuilder.append('.')
                stringBuilder.append(v.toInt64(overflowHandling: OverflowStrategy.Wrapping))
            }
        }
        return ASN1ObjectIdentifier(stringBuilder.toString(), value)
    }
}

public class ObjectIdentifierSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public override func serializedLength(asn1Object: ASN1Object): Int64 {
        var object: ASN1ObjectIdentifier = (asn1Object as ASN1ObjectIdentifier).getOrThrow()
        if (object.valueBytes.isEmpty()) {
            calculateBytes(object)
        }
        return object.valueBytes.size
    }

    public override func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit {
        var object: ASN1ObjectIdentifier = (asn1Object as ASN1ObjectIdentifier).getOrThrow()
        if (object.valueBytes.isEmpty()) {
            calculateBytes(object)
        }
        stream.write(object.valueBytes)
    }

    private func calculateBytes(asn1Object: ASN1ObjectIdentifier): Unit {
        var oid: String = asn1Object.oid
        var baos: ByteBuffer = ByteBuffer()
        var stringArr: Array<String> = oid.split(".")
        var first: Int64 = Int64.parse(stringArr[0])
        var second: Int64 = Int64.parse(stringArr[1])
        var number: Int64 = first * 40 + second
        baos.write(BigInt(number).toBytes())
        for (i in 2..stringArr.size) {
            var valueBigNum: BigInt = BigInt.parse(stringArr[i])
            var bigNum: Int64 = valueBigNum.toInt64(overflowHandling: OverflowStrategy.Wrapping)
            if (bigNum > 0 && bigNum < 127) {
                baos.write(valueBigNum.toBytes())
            } else {
                var neededBytes: Int64
                if (valueBigNum.toString(radix: 2).size % 7 > 0) {
                    neededBytes = Int64(valueBigNum.toString(radix: 2).size) / 7 + 1
                } else {
                    neededBytes = Int64(valueBigNum.toString(radix: 2).size) / 7 + 0
                }
                var intI: Int64 = neededBytes - 1
                while (intI >= 0) {
                    var r: BigInt = valueBigNum >> intI * 7
                    var a: Int64 = r.toInt64(overflowHandling: OverflowStrategy.Wrapping)
                    var b: Byte = UInt8(a & 255)
                    b &= 0x7f
                    if (intI > 0) {
                        b |= 0x80
                    }
                    baos.write([b].toArray())
                    intI--
                }
            }
        }
        asn1Object.valueBytes = baos.bytes()
    }
}
