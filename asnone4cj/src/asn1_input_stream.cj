/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public class ASN1InputStream <: InputStream & Iterable<ASN1Object> {
    protected var input: InputStream

    private var decoder: ASN1Decoder

    public var lengths: Int64

    public init(decoder: ASN1Decoder, wrapped: InputStream) {
        this.input = wrapped
        this.lengths = match (wrapped as Seekable) {
            case Some(v) => v.remainLength
            case None => -1
        }
        this.decoder = decoder
    }

    public init(decoder: ASN1Decoder, value: Array<Byte>) {
        var byteStream = ByteBuffer()
        byteStream.write(value)
        this.input = byteStream
        this.lengths = byteStream.length
        this.decoder = decoder
    }

    public func readObject(): ASN1Object {
        try {
            if(lengthData() <= 0){
                throw NoneValueException()
            }
            var tag: ASN1Tag = decoder.readTag(this)
            var length: Int64 = decoder.readLength(this)
            var value: Array<Byte> = decoder.readValue(length, this)
            var parse: ASN1Object = tag.newParser(decoder).parse(tag, value)
            return parse
        } catch (pe: ASN1ParseException) {
            throw pe
        } catch (pe: NoneValueException) {
            throw pe
        } catch (e: Exception) {
            throw ASN1ParseException("Cannot parse ASN.1 object from stream")
        }
    }

    public func readValue(length: Int64): Array<Byte> {
        return decoder.readValue(length, this)
    }

    public override func iterator(): Iterator<ASN1Object> {
        return IteratorASN1Object(this)
    }

    public func readTag(): ASN1Tag {
        return decoder.readTag(this)
    }

    public func readLength(): Int64 {
        return decoder.readLength(this)
    }

    public override func read(buffer: Array<Byte>): Int64 {
        return this.input.read(buffer)
    }

    protected func lengthData(): Int64 {
        return match (input as Seekable) {
            case Some(v) => v.remainLength
            case None => -1
        }
    }
}

class IteratorASN1Object <: Iterator<ASN1Object> {
    private var stream: ASN1InputStream

    init(stream: ASN1InputStream) {
        this.stream = stream
    }

    public func next(): Option<ASN1Object> {
        try {
            return stream.readObject()
        } catch (e: NoneValueException) {
            return None
        } catch (e: Exception) {
            throw Exception(e.message)
        }
    }
}
