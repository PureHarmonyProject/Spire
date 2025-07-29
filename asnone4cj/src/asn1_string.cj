/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public abstract class ASN1String <: ASN1Object & ASN1Primitive & ASN1Constructed {
    protected var valueBytes: Array<Byte> = Array<Byte>()

    public init(tag: ASN1Tag, valueBytes: Array<Byte>) {
        super(tag)
        this.valueBytes = valueBytes
    }

    public func iterator(): Iterator<ASN1Object> {
        if (tag.getAsn1Encoding() == ASN1Encoding.CONSTRUCTED(0x20)) {
            var asn1Sequence: ASN1Sequence = 
                (SEQUENCE.newParser(BERDecoder()).parse(SEQUENCE, valueBytes) as ASN1Sequence).getOrThrow()
            return asn1Sequence.iterator()
        } else {
            return this.iterator()
        }
    }

    public func getValueBytes(): Array<Byte> {
        var copyList: Array<Byte> = Array<Byte>(valueBytes.size, repeat: 0)
        valueBytes.copyTo(copyList, 0, 0, valueBytes.size)
        return copyList
    }

    public func length(): Int64
}
