/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public abstract class ASN1Object <: Hashable & Equatable<ASN1Object> & ToString {
    protected var tag: ASN1Tag

    protected init(tag: ASN1Tag) {
        this.tag = tag
    }

    public func getValue(): Any

    public func equals(o: Object): Bool {
        if (refEq(this, o)) {
            return true
        }
        var that: ASN1Object = (o as ASN1Object).getOrThrow()
        if (refEq(this.tag, that)) {
            return true
        }
        return false
    }

    public func hashCode(): Int64 {
        var result: Int64 = tag.getTag()
        return result
    }

    public open func toString(): String {
        return "ASN1Object" + "[" + valueString() + "]"
    }

    protected open func valueString(): String {
        return tag.toString()
    }

    public func getTag(): ASN1Tag {
        return tag
    }

    public operator func ==(that: ASN1Object): Bool {
        return this.equals(that)
    }

    public operator func !=(that: ASN1Object): Bool {
        return !(this == that)
    }
}
