/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1Null <: ASN1PrimitiveValue {
    private let NULL_BYTES: Array<Byte> = []

    public init() {
        super(ASN1_NULL_TAG, NULL_BYTES)
    }

    public override func getValue(): Any {
        return Option<Unit>.None
    }

    public func valueHash(): Int64 {
        return 0
    }
}

public class NullParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public override func parse(_: ASN1Tag, value: Array<Byte>): ASN1Object {
        Checks.checkState(value.size == 0, "ASN.1 NULL can not have a value", Array<ToString>())
        return ASN1Null()
    }
}

public class NullSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public override func serializedLength(_: ASN1Object): Int64 {
        return 0
    }

    public override func serialize(_: ASN1Object, _: ASN1OutputStream): Unit {
        // No-op, no data
    }
}
