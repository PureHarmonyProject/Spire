/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1Enumerated <: ASN1PrimitiveValue {
    protected var value: BigInt = BigInt(0)

    public init(value: Int64) {
        super(ENUMERATED)
        this.value = BigInt(value)
    }

    public init(value: BigInt) {
        super(ENUMERATED)
        this.value = value
    }

    public init(value: BigInt, valueBytes: Array<Byte>) {
        super(ENUMERATED, valueBytes)
        this.value = value
    }

    public override func getValue(): Any {
        return value
    }
}

public class EnumeratedParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public override func parse(_: ASN1Tag, value: Array<Byte>): ASN1Object {
        var bigint: BigInt = BigInt(value)
        return ASN1Enumerated(bigint, value)
    }
}

public class EnumeratedSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public override func serializedLength(asn1Object: ASN1Object): Int64 {
        var object: ASN1Enumerated = (asn1Object as ASN1Enumerated).getOrThrow()
        if (object.valueBytes.isEmpty()) {
            calculateBytes(object)
        }
        return object.valueBytes.size
    }

    public override func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit {
        var object: ASN1Enumerated = (asn1Object as ASN1Enumerated).getOrThrow()
        if (object.valueBytes.isEmpty()) {
            calculateBytes(object)
        }
        stream.write(object.valueBytes)
    }

    private func calculateBytes(asn1Object: ASN1Enumerated): Unit {
        asn1Object.valueBytes = asn1Object.value.toBytes()
    }
}
