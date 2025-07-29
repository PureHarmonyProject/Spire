/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1BitString <: ASN1String {
    public var unusedBits: Int64 = 0
    private var bits: Array<Bool> = Array<Bool>()

    public init(tag: ASN1Tag, bytes: Array<Byte>, unusedBits: Int64) {
        super(tag, bytes)
        this.unusedBits = unusedBits
        this.bits = constructBits()
    }

    public init(bytes: Array<Byte>, unusedBits: Int64) {
        this(BIT_STRING, bytes, unusedBits)
    }

    public init(bits: Array<Bool>) {
        super(BIT_STRING, constructBytes(bits))
        this.bits = bits
        this.unusedBits = 8 - (bits.size % 8)
    }

    @OverflowWrapping
    private static func constructBytes(bits: Array<Bool>): Array<Byte> {
        var length: Int64
        if (bits.size % 8 > 0) {
            length = bits.size / 8 + 1
        } else {
            length = bits.size / 8
        }
        var bytes: Array<Int8> = Array<Int8>(length, repeat: 0)
        for (i in 0..bytes.size) {
            bytes[i] = 0
            for (j in 0..8) {
                var v: Bool = i * 8 + j < bits.size && bits[i * 8 + j]
                if (v) {
                    bytes[i] += 1 << (8 - j - 1)
                } else {
                    bytes[i] += 0 << (8 - j - 1)
                }
            }
        }
        var arr: Array<Byte> = Array<Byte>(bytes.size, repeat: 0)
        for (i in 0..bytes.size) {
            arr[i] = UInt8(Int8(bytes[i]))
        }
        return arr
    }

    private func constructBits(): Array<Bool> {
        var bits: Array<Bool> = Array<Bool>(length(), repeat: false)
        for (i in 0..bits.size) {
            bits[i] = isSet(i)
        }
        return bits
    }

    public override func getValue(): Any {
        var copyList: Array<Bool> = Array<Bool>(this.bits.size, repeat: false)
        bits.copyTo(copyList, 0, 0, this.bits.size)
        return copyList
    }

    public override func valueString(): String {
        return bits.toString()
    }

    @OverflowWrapping
    public func isSet(x: Int64): Bool {
        var toCheck: Int64 = x / 8
        var theByte: Int8 = Int8(UInt8(valueBytes[toCheck]))
        var index: Int64 = x % 8
        var mask: Int64 = 1 << (7 - index)
        var masked: Int64 = theByte.position() & mask
        return masked != 0
    }

    public override func length(): Int64 {
        return (valueBytes.size * 8) - unusedBits
    }
}

public class BitStringParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public override func parse(asn1Tag: ASN1Tag, value: Array<Byte>): ASN1Object {
        if (asn1Tag.isConstructed()) {
            try {
                var stream: ASN1InputStream = ASN1InputStream(decoder, value)
                var baos: ByteBuffer = ByteBuffer()
                var unusedBits: Int64 = 0
                while (stream.lengthData() > 0) {
                    var subTag: ASN1Tag = stream.readTag()
                    Checks.checkState(
                        subTag.getTag() == asn1Tag.getTag(),
                        "Expected an ASN.1 BIT STRING as Constructed object, got",
                        Array<ToString>()
                    )
                    var i: Int64 = stream.readLength()
                    var subValue: Array<Byte> = stream.readValue(i)
                    var subValueNew: Array<Byte> = subValue.slice(1, subValue.size - 1)
                    baos.write(subValueNew)
                    if (stream.lengthData() <= 0) {
                        // Last ASN.1 BitString
                        unusedBits = Int64(subValue[0])
                    }
                }
                return ASN1BitString(asn1Tag, baos.bytes(), unusedBits)
            } catch (exception: Exception) {
                throw ASN1ParseException("Unable to parse Constructed ASN.1 BIT STRING")
            }
        } else {
            var unusedBits: Byte = value[0]
            var bits: Array<Byte> = Array<Byte>(value.size - 1, repeat: 0)
            value.copyTo(bits, 1, 0, value.size - 1)
            return ASN1BitString(asn1Tag, bits, Int64(unusedBits))
        }
    }
}

public class BitStringSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public override func serializedLength(asn1Object: ASN1Object): Int64 {
        var object: ASN1BitString = (asn1Object as ASN1BitString).getOrThrow()
        return object.valueBytes.size + 1
    }

    public override func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit {
        var object: ASN1BitString = (asn1Object as ASN1BitString).getOrThrow()
        stream.write(object.unusedBits)
        stream.write(object.valueBytes)
    }
}
