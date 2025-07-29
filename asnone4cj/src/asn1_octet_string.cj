/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1OctetString <: ASN1String {
    public init(bytes: Array<Byte>) {
        super(OCTET_STRING, bytes)
    }

    public init(tag: ASN1Tag, bytes: Array<Byte>) {
        super(tag, bytes)
    }

    public override func getValue(): Any {
        var copyList: Array<Byte> = Array<Byte>(valueBytes.size, repeat: 0)
        valueBytes.copyTo(copyList, 0, 0, this.valueBytes.size)
        return copyList
    }

    public func valueString(): String {
        return valueBytes.toString()
    }

    public func length(): Int64 {
        return valueBytes.size
    }
}

public class OctetStringParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public override func parse(asn1Tag: ASN1Tag, value: Array<Byte>): ASN1Object {
        return ASN1OctetString(asn1Tag, value)
    }
}

public class OctetStringSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public override func serializedLength(asn1Object: ASN1Object): Int64 {
        var object: ASN1OctetString = (asn1Object as ASN1OctetString).getOrThrow()
        return object.valueBytes.size
    }

    public override func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit {
        var object: ASN1OctetString = (asn1Object as ASN1OctetString).getOrThrow()
        stream.write(object.valueBytes)
    }
}
