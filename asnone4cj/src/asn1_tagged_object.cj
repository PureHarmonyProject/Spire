/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1TaggedObject <: ASN1Object & ASN1Constructed {
    public var object: ?ASN1Object
    protected var bytes: Array<Byte>
    private var decoder: ASN1Decoder = BERDecoder()
    public var explicit: Bool = true
    private var tags: ASN1Tag

    public init(tag: ASN1Tag, object: ?ASN1Object, explicit: Bool) {
        super(formatMessage(tag, object, explicit))
        this.object = object
        this.tags = tag
        this.explicit = explicit
        this.bytes = Array<Byte>()
    }

    public init(tag: ASN1Tag, object: ?ASN1Object) {
        this(tag, object, true)
    }

    public init(tag: ASN1Tag, bytes: Array<Byte>, decoder: ASN1Decoder) {
        super(tag)
        this.bytes = bytes
        this.tags = tag
        this.decoder = decoder
        object = Option<ASN1Object>.None
    }

    public func isExplicit(): Bool {
        return explicit
    }

    public func getValue(): ASN1Object {
        return getObject()
    }

    public func getTagNo(): Int64 {
        return tags.getTag()
    }

    public func iterator(): Iterator<ASN1Object> {
        var seq: ASN1Sequence = (getObject(SEQUENCE) as ASN1Sequence).getOrThrow()
        return seq.iterator()
    }

    public func getObject(): ASN1Object {
        match (object) {
            case None =>
                try {
                    var inputStream: ASN1InputStream = ASN1InputStream(decoder, bytes)
                    return inputStream.readObject()
                } catch (asn1ParseException: ASN1ParseException) {
                    let list: Array<ToString> = []
                    throw ASN1ParseException(
                        asn1ParseException,
                        "Unable to parse the explicit Tagged Object with %s, it might be implicit",
                        list
                    )
                } catch (ioe: IOException) {
                    throw ASN1ParseException(ioe, "Could not parse the inputstream", Array<ToString>())
                }
            case Some(v) =>
                v
                return object.getOrThrow()
        }
    }

    public func getObject(tag: ASN1Tag): ASN1Object {
        if (object != None) {
            if (object.getOrThrow().getTag().equals(tag)) {
                return object.getOrThrow()
            }
        } else if (object == None) {
            if (!bytes.isEmpty()) {
                return tag.newParser(decoder).parse(tag, bytes)
            }
        }
        throw ASN1ParseException("Unable to parse the implicit Tagged Object with %s, it is explicit")
    }

    public func toString(): String {
        var b: StringBuilder = StringBuilder()
        b.append("ASN1TaggedObject")
        b.append("[")
        b.append(tag.toString())
        match (object) {
            case Some(v) =>
                (v)
                b.append(",")
                b.append(object.getOrThrow())
            case None => b.append(",<unknown>")
        }
        b.append("]")
        return b.toString()
    }
}

func formatMessage(tag: ASN1Tag, object: ?ASN1Object, explicit: Bool): ASN1Tag {
    if (explicit) {
        return tag.constructed()
    } else {
        return tag.asEncoded(object.getOrThrow().getTag().getAsn1Encoding())
    }
}

class TaggedObjectParser <: ASN1Parser {
    public init(decoder: ASN1Decoder) {
        super(decoder)
    }

    public func parse(asn1Tag: ASN1Tag, value: Array<Byte>): ASN1Object {
        return ASN1TaggedObject(asn1Tag, value, decoder)
    }
}

class TaggedObjectSerializer <: ASN1Serializer {
    public init(encoder: ASN1Encoder) {
        super(encoder)
    }

    public func serializedLength(asn1Object: ASN1Object): Int64 {
        var object: ASN1TaggedObject = (asn1Object as ASN1TaggedObject).getOrThrow()
        if (object.bytes.isEmpty()) {
            calculateBytes(object)
        }
        return object.bytes.size
    }

    public func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit {
        var object: ASN1TaggedObject = (asn1Object as ASN1TaggedObject).getOrThrow()
        if (object.bytes.isEmpty()) {
            calculateBytes(object)
        }
        stream.write(object.bytes)
    }

    private func calculateBytes(asn1Object: ASN1TaggedObject): Unit {
        var object: ASN1Object = asn1Object.object.getOrThrow()
        var out: ByteBuffer = ByteBuffer()
        var asn1OutputStream: ASN1OutputStream = ASN1OutputStream(encoder, out)
        if (asn1Object.explicit) {
            asn1OutputStream.writeObject(object)
        } else {
            object.getTag().newSerializer(encoder).serialize(object, asn1OutputStream)
        }
        asn1Object.bytes = out.bytes()
    }
}
