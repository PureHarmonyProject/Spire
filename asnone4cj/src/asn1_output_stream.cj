/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1OutputStream <: OutputStream {
    private var encoder: ASN1Encoder
    protected var output: OutputStream

    public init(encoder: ASN1Encoder, out: OutputStream) {
        this.output = out
        this.encoder = encoder
    }

    public func writeObject(asn1Object: ASN1Object): Unit {
        var tag: ASN1Tag = asn1Object.getTag()
        writeTag(tag)
        var asn1Serializer: ASN1Serializer = asn1Object.getTag().newSerializer(encoder)
        writeLength(asn1Serializer.serializedLength(asn1Object))

        //noinspection unchecked
        asn1Serializer.serialize(asn1Object, this)
    }

    public func write(b: Array<Byte>): Unit {
        output.write(b)
    }

    public func write(b: Int64): Unit {
        var value = b & 255
        output.write([UInt8(value)])
    }

    private func writeLength(length: Int64): Unit {
        if (length < 0x7f) {
            write(length)
        } else {
            var nrBytes: Int64 = lengthBytes(length)
            write(0x80 | nrBytes)
            while (nrBytes > 0) {
                write(length >> ((nrBytes - 1) * 8))
                nrBytes--
            }
        }
    }

    private func lengthBytes(length: Int64): Int64 {
        var l: Int64 = length
        var nrBytes: Int64 = 1
        while (l > 255) {
            nrBytes++
            l >>= 8
        }
        return nrBytes
    }

    private func writeTag(tag: ASN1Tag): Unit {
        var tagByte: Byte = UInt8(tag.getAsn1TagClass().getValue() | tag.getAsn1Encoding().getValue() | tag.getTag())
        write(Int64(tagByte))
    }
}
