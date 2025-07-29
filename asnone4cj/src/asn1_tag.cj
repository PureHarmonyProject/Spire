/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public let ASN1_BOOLEAN: ASN1Tag = ASN1BooleanTag(
    ASN1TagClass.UNIVERSAL(0),
    0x01,
    ASN1Encoding.PRIMITIVE(0x0)
)

public let INTEGER: ASN1Tag = ASN1IntegerTag(ASN1TagClass.UNIVERSAL(0), 0x02, ASN1Encoding.PRIMITIVE(0x0))

public let BIT_STRING: ASN1Tag = ASN1BitStringTag(
    ASN1TagClass.UNIVERSAL(0),
    0x03,
    ASN1Encoding.PRIMITIVE(0x0),
    HashSet<ASN1Encoding>([ASN1Encoding.PRIMITIVE(0x0), ASN1Encoding.CONSTRUCTED(0x20)])
)

public let OCTET_STRING: ASN1Tag = ASN1OctetStringTag(
    ASN1TagClass.UNIVERSAL(0),
    0x04,
    HashSet<ASN1Encoding>([ASN1Encoding.PRIMITIVE(0x0), ASN1Encoding.CONSTRUCTED(0x20)])
)

public let ASN1_NULL_TAG: ASN1Tag = ASN1NullTag(
    ASN1TagClass.UNIVERSAL(0),
    0x05,
    ASN1Encoding.PRIMITIVE(0x0)
)

public let OBJECT_IDENTIFIER: ASN1Tag = ASN1ObjectIdentifierTag(
    ASN1TagClass.UNIVERSAL(0),
    0x06,
    ASN1Encoding.PRIMITIVE(0x0)
)

public let ENUMERATED: ASN1Tag = ASN1EnumeratedTag(
    ASN1TagClass.UNIVERSAL(0),
    0x0A,
    ASN1Encoding.PRIMITIVE(0x0)
)

public let SET: ASN1Tag = ASN1SetTag(
    ASN1TagClass.UNIVERSAL(0),
    0x11,
    ASN1Encoding.CONSTRUCTED(0x20)
)

public let SEQUENCE: ASN1Tag = ASN1SequenceTag(
    ASN1TagClass.UNIVERSAL(0),
    0x10,
    ASN1Encoding.CONSTRUCTED(0x20)
)

let tags: HashMap<Int64, ASN1Tag> = HashMap<Int64, ASN1Tag>(
    [
        (ASN1_BOOLEAN.getTag(), ASN1_BOOLEAN),
        (INTEGER.getTag(), INTEGER),
        (BIT_STRING.getTag(), BIT_STRING),
        (OCTET_STRING.getTag(), OCTET_STRING),
        (ASN1_NULL_TAG.getTag(), ASN1_NULL_TAG),
        (OBJECT_IDENTIFIER.getTag(), OBJECT_IDENTIFIER),
        (ENUMERATED.getTag(), ENUMERATED),
        (SET.getTag(), SET),
        (SEQUENCE.getTag(), SEQUENCE)
    ]
)
public abstract class ASN1Tag {
    private var tag: Int64 = 0
    private var asn1TagClass: ASN1TagClass
    private var supportedEncodings: HashSet<ASN1Encoding> = HashSet<ASN1Encoding>()
    private var asn1Encoding: ASN1Encoding

    public init(asn1TagClass: ASN1TagClass, tag: Int64, supportedEncodings: HashSet<ASN1Encoding>) {
        if (supportedEncodings.contains(ASN1Encoding.PRIMITIVE(0x0))) {
            this.asn1Encoding = ASN1Encoding.PRIMITIVE(0x0)
        } else {
            this.asn1Encoding = ASN1Encoding.CONSTRUCTED(0x20)
        }
        this.asn1TagClass = asn1TagClass
        this.tag = tag
        this.supportedEncodings = supportedEncodings
    }

    public init(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding) {
        this(asn1TagClass, tag, asn1Encoding, HashSet<ASN1Encoding>([asn1Encoding]))
    }

    public init(
        asn1TagClass: ASN1TagClass,
        tag: Int64,
        asn1Encoding: ASN1Encoding,
        supportedEncodings: HashSet<ASN1Encoding>
    ) {
        this.asn1TagClass = asn1TagClass
        this.tag = tag
        this.supportedEncodings = supportedEncodings
        this.asn1Encoding = asn1Encoding
    }

    public func constructed(): ASN1Tag {
        return asEncoded(ASN1Encoding.CONSTRUCTED(0x20))
    }

    public func primitive(): ASN1Tag {
        return asEncoded(ASN1Encoding.PRIMITIVE(0x0))
    }

    public func asEncoded(asn1Encoding: ASN1Encoding): ASN1Tag {
        if (this.asn1Encoding == asn1Encoding) {
            return this
        }
        if (!supportedEncodings.contains(asn1Encoding)) {
            throw IllegalArgumentException("The ASN.1 tag does not support encoding")
        }
        return ASN1AllTag(this.asn1TagClass, this.tag, asn1Encoding, this.supportedEncodings, this)
    }

    public static func application(tag: Int64): ASN1Tag {
        return forTag(ASN1TagClass.APPLICATION(0x40), tag)
    }

    public static func contextSpecific(tag: Int64): ASN1Tag {
        return forTag(ASN1TagClass.CONTEXT_SPECIFIC(0x80), tag)
    }

    public static func forTag(asn1TagClass: ASN1TagClass, tag: Int64): ASN1Tag {
        match (asn1TagClass) {
            case UNIVERSAL(0) =>
                for (asn1Tag in tags.values()) {
                    if (asn1Tag.tag == tag && asn1TagClass.getValue() == asn1Tag.asn1TagClass.getValue()) {
                        return asn1Tag
                    }
                }
                throw ASN1ParseException("Unknown ASN.1 tag")
            case APPLICATION(0x40) | CONTEXT_SPECIFIC(0x80) | PRIVATE(0xc0) =>
                return ASN1TaggedObjectTag(
                    asn1TagClass,
                    tag,
                    HashSet<ASN1Encoding>([ASN1Encoding.PRIMITIVE(0x0), ASN1Encoding.CONSTRUCTED(0x20)])
                )
            case _ => throw ASN1ParseException("Unknown ASN.1 tag")
        }
    }

    public func getTag(): Int64 {
        return tag
    }

    public func getAsn1TagClass(): ASN1TagClass {
        return asn1TagClass
    }

    public func getAsn1Encoding(): ASN1Encoding {
        return asn1Encoding
    }

    public func isConstructed(): Bool {
        return asn1Encoding == ASN1Encoding.CONSTRUCTED(0x20)
    }

    public func newParser(encoder: ASN1Decoder): ASN1Parser

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer

    public func equals(o: Object): Bool {
        if (refEq(this, o)) {
            return true
        }
        var that: ASN1Tag = (o as ASN1Tag).getOrThrow()
        return (getTag() == that.getTag() && asn1Encoding == that.asn1Encoding)
    }

    public func hashCode(): Int32 {
        return hashCodeobjs(asn1TagClass, getTag(), asn1Encoding)
    }

    @OverflowWrapping
    private func hashCodeobjs(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding): Int32 {
        var result: Int32 = 1
        var asn1Tagcode: Int32 = 0
        var asn1Encode: Int32 = 0
        asn1Tagcode = match (asn1TagClass) {
            case UNIVERSAL(0) => 1590550415
            case APPLICATION(0x40) => 1058025095
            case CONTEXT_SPECIFIC(0x80) => 665576141
            case PRIVATE(0xc0) => 1599771323
            case _ =>0
        }
        result = 31 * result + asn1Tagcode
        result = 31 * result + Int32(tag)
        asn1Encode = match (asn1Encoding) {
            case PRIMITIVE(0x0) => 1058025095
            case CONSTRUCTED(0x20) => 665576141
            case _ =>0
        }
        result = 31 * result + asn1Encode
        return result
    }

    public func toString(): String {
        var sb: StringBuilder = StringBuilder()
        sb.append("ASN1Tag[")
        match (asn1TagClass) {
            case UNIVERSAL(0) => sb.append("UNIVERSAL")
            case APPLICATION(0x40) => sb.append("APPLICATION")
            case CONTEXT_SPECIFIC(0x80) => sb.append("CONTEXT_SPECIFIC")
            case PRIVATE(0xc0) => sb.append("PRIVATE")
            case _ =>sb.append("")
        }
        sb.append(",")
        match (asn1Encoding) {
            case PRIMITIVE(0x0) => sb.append("PRIMITIVE")
            case CONSTRUCTED(0x20) => sb.append("CONSTRUCTED")
            case _ =>sb.append("")
        }
        sb.append(",")
        sb.append(tag)
        sb.append(']')
        return sb.toString()
    }
}

public class ASN1BooleanTag <: ASN1Tag {
    public init(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding) {
        super(asn1TagClass, tag, asn1Encoding)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return BooleanParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return BooleanSerializer(encoder)
    }
}

public class ASN1IntegerTag <: ASN1Tag {
    public init(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding) {
        super(asn1TagClass, tag, asn1Encoding)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return IntegerParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return IntegerSerializer(encoder)
    }
}

public class ASN1BitStringTag <: ASN1Tag {
    public init(
        asn1TagClass: ASN1TagClass,
        tag: Int64,
        asn1Encoding: ASN1Encoding,
        supportedEncodings: HashSet<ASN1Encoding>
    ) {
        super(asn1TagClass, tag, asn1Encoding, supportedEncodings)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return BitStringParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return BitStringSerializer(encoder)
    }
}

public class ASN1OctetStringTag <: ASN1Tag {
    public init(
        asn1TagClass: ASN1TagClass,
        tag: Int64,
        supportedEncodings: HashSet<ASN1Encoding>
    ) {
        super(asn1TagClass, tag, supportedEncodings)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return OctetStringParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return OctetStringSerializer(encoder)
    }
}

public class ASN1NullTag <: ASN1Tag {
    public init(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding) {
        super(asn1TagClass, tag, asn1Encoding)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return NullParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return NullSerializer(encoder)
    }
}

public class ASN1ObjectIdentifierTag <: ASN1Tag {
    public init(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding) {
        super(asn1TagClass, tag, asn1Encoding)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return ObjectIdentifierParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return ObjectIdentifierSerializer(encoder)
    }
}

public class ASN1EnumeratedTag <: ASN1Tag {
    public init(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding) {
        super(asn1TagClass, tag, asn1Encoding)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return EnumeratedParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return EnumeratedSerializer(encoder)
    }
}

public class ASN1SetTag <: ASN1Tag {
    public init(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding) {
        super(asn1TagClass, tag, asn1Encoding)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return SetParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return SetSerializer(encoder)
    }
}

public class ASN1SequenceTag <: ASN1Tag {
    public init(asn1TagClass: ASN1TagClass, tag: Int64, asn1Encoding: ASN1Encoding) {
        super(asn1TagClass, tag, asn1Encoding)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return SeqParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return SeqSerializer(encoder)
    }
}

public class ASN1TaggedObjectTag <: ASN1Tag {
    public init(asn1TagClass: ASN1TagClass, tag: Int64, supportedEncodings: HashSet<ASN1Encoding>) {
        super(asn1TagClass, tag, supportedEncodings)
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        return TaggedObjectParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        return TaggedObjectSerializer(encoder)
    }
}

public class ASN1AllTag <: ASN1Tag {
    private var asn1Tag: ASN1Tag
    public init(
        asn1TagClass: ASN1TagClass,
        tag: Int64,
        asn1Encoding: ASN1Encoding,
        supportedEncodings: HashSet<ASN1Encoding>,
        asn1Tag: ASN1Tag
    ) {
        super(asn1TagClass, tag, asn1Encoding, supportedEncodings)
        this.asn1Tag = asn1Tag
    }

    public func newParser(decoder: ASN1Decoder): ASN1Parser {
        asn1Tag.newParser(decoder)
    }

    public func newSerializer(encoder: ASN1Encoder): ASN1Serializer {
        asn1Tag.newSerializer(encoder)
    }
}
