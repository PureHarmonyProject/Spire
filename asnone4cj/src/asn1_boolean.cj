/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1Boolean <: ASN1PrimitiveValue {
    protected var value: Bool = false

    public init(value: Bool) {
        super(ASN1_BOOLEAN)
        this.value = value
    }

    public init(value: Bool, valueBytes: Array<Byte>) {
        super(ASN1_BOOLEAN, valueBytes)
        this.value = value
    }

    public func getValue(): Any {
        return value
    }

    public func valueHash(): Int64 {
        if (value) {
            return 1231
        } else {
            return 1237
        }
    }
}

public class BooleanParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public override func parse(_: ASN1Tag, value: Array<Byte>): ASN1Object {
        let list: Array<ToString> = [value.size]
        Checks.checkState(value.size == 1, "ASN.1 NULL can not have a value", list)
        return ASN1Boolean(value[0] != 0x0, value)
    }
}

public class BooleanSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public override func serializedLength(_: ASN1Object): Int64 {
        return 1
    }

    public override func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit {
        var object: ASN1Boolean = (asn1Object as ASN1Boolean).getOrThrow()
        if (object.value) {
            stream.write(0x01)
        } else {
            stream.write(0x00)
        }
    }
}
