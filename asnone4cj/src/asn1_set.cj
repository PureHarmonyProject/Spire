/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1Set <: ASN1Object & ASN1Constructed {
    private var objects: HashSet<ASN1Object>
    protected var bytes: Array<Byte> = Array<Byte>()

    public init(objects: HashSet<ASN1Object>, bytes: Array<Byte>) {
        super(SET)
        this.objects = objects
        this.bytes = bytes
    }

    public init(objects: HashSet<ASN1Object>) {
        super(SET)
        this.objects = objects
    }

    public func getValue(): HashSet<ASN1Object> {
        return objects
    }

    public func iterator(): Iterator<ASN1Object> {
        return HashSet<ASN1Object>(objects).iterator()
    }
}

class SetParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public func parse(_: ASN1Tag, value: Array<Byte>): ASN1Object {
        var asn1Objects: HashSet<ASN1Object> = HashSet<ASN1Object>()
        try {
            var stream: ASN1InputStream = ASN1InputStream(decoder, value)
            for (asn1Object in stream) {
                asn1Objects.add(asn1Object)
            }
        } catch (ioe: IOException) {
            throw ASN1ParseException(ioe, "Could not parse ASN.1 SET contents.", Array<ToString>())
        }
        return ASN1Set(asn1Objects, value)
    }
}

class SetSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public func serializedLength(asn1Object: ASN1Object): Int64 {
        var objects: ASN1Set = (asn1Object as ASN1Set).getOrThrow()
        if (objects.bytes.isEmpty()) {
            calculateBytes(objects)
        }
        return objects.bytes.size
    }

    public func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit {
        var objects: ASN1Set = (asn1Object as ASN1Set).getOrThrow()
        if (!objects.bytes.isEmpty()) {
            stream.write(objects.bytes)
        } else {
            for (v in objects) {
                stream.writeObject(v)
            }
        }
    }

    private func calculateBytes(asn1Object: ASN1Set): Unit {
        var outs: ByteBuffer = ByteBuffer()
        var asn1OutputStream: ASN1OutputStream = ASN1OutputStream(encoder, outs)
        for (object in asn1Object) {
            asn1OutputStream.writeObject(object)
        }
        asn1Object.bytes = outs.bytes()
    }
}
