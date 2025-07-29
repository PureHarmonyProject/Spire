/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1Integer <: ASN1PrimitiveValue {
    protected var value: BigInt = BigInt(0)

    public init(value: Int64) {
        super(INTEGER)
        this.value = BigInt(value)
        this.valueBytes = this.value.toBytes()
    }

    public init(value: BigInt) {
        super(INTEGER)
        this.value = value
        this.valueBytes = this.value.toBytes()
    }

    public init(value: BigInt, valueBytes: Array<Byte>) {
        super(INTEGER, valueBytes)
        this.value = value
    }

    public override func getValue(): Any {
        return value
    }

    public func valueHash(): Int64 {
        return value.toInt64(overflowHandling: OverflowStrategy.Wrapping).hashCode()
    }
}

public class IntegerParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public override func parse(_: ASN1Tag, value: Array<Byte>): ASN1Object {
        var bigint: BigInt = BigInt(value)
        return ASN1Integer(bigint, value)
    }
}

public class IntegerSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public override func serializedLength(asn1Object: ASN1Object): Int64 {
        var object: ASN1Integer = (asn1Object as ASN1Integer).getOrThrow()
        return object.valueBytes.size
    }

    public override func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit {
        var object: ASN1Integer = (asn1Object as ASN1Integer).getOrThrow()
        stream.write(object.valueBytes)
    }
}
