/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public enum ASN1Encoding <: Hashable & Equatable<ASN1Encoding> {
    | PRIMITIVE(Byte)
    | CONSTRUCTED(Byte)

    public func getValue(): Int64 {
        match (this) {
            case PRIMITIVE(v) =>
                if (v != 0) {
                    throw Exception("PRIMITIVE value should be 0x00")
                } else {
                    return Int64(v)
                }
            case CONSTRUCTED(v) =>
                if (v != 0x20) {
                    throw Exception("CONSTRUCTED value should be 0x20")
                } else {
                    return Int64(v)
                }
        }
    }

    public static func parseEncoding(tagByte: Byte): ASN1Encoding {
        if ((tagByte & 0x20) == 0) {
            return PRIMITIVE(0x0)
        } else {
            return CONSTRUCTED(0x20)
        }
    }

    public func hashCode(): Int64 {
        return match (this) {
            case PRIMITIVE(0x0) => (0x0).hashCode()
            case CONSTRUCTED(0x20) => (0x20).hashCode()
            case _ => throw Exception("error")
        }
    }

    public operator func ==(that: ASN1Encoding): Bool {
        match ((this, that)) {
            case (PRIMITIVE(0x0), PRIMITIVE(0x0)) => true
            case (CONSTRUCTED(0x20), CONSTRUCTED(0x20)) => true
            case _ => false
        }
    }

    public operator func !=(that: ASN1Encoding): Bool {
        return !(this == that)
    }
}
