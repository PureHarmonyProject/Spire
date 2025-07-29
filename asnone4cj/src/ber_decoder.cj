/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

let dataArr : Array<Byte>= Array<Byte>(1, repeat: 0)

public open class BERDecoder <: ASN1Decoder {
    public override func readTag(inputStream: InputStream): ASN1Tag {
        try {
            dataArr[0] = 0
            inputStream.read(dataArr)
            let byte: Byte = dataArr[0]
            let asn1TagClass: ASN1TagClass = ASN1TagClass.parseClass(byte)
            let asn1Encoding: ASN1Encoding = ASN1Encoding.parseEncoding(byte)
            let tag: Int64 = Int64(byte) & 0x1f
            if (tag <= 0x1e) {
                return ASN1Tag.forTag(asn1TagClass, tag).asEncoded(asn1Encoding)
            } else {
                var iTag: Int64 = 0
                inputStream.read(dataArr)
                var read: Byte = dataArr[0]
                if ((read & 0x7f) == 0) {
                    throw ASN1ParseException("corrupted stream - invalid high tag number found")
                }
                while ((read >= 0) && ((read & 0x80) != 0)) {
                    iTag |= (Int64(read) & 0x7f)
                    iTag <<= 7
                    inputStream.read(dataArr)
                    read = dataArr[0]
                }
                if (read < 0) {
                    throw ASN1ParseException("EOF found inside tag value.")
                }
                iTag |= (Int64(read) & 0x7f)
                return ASN1Tag.forTag(asn1TagClass, iTag).asEncoded(asn1Encoding)
            }
        } catch (ioe: IOException) {
            let list: Array<ToString> = [ioe.toString()]
            throw ASN1ParseException("Unable to parse ASN.1 tag", list)
        }
    }

    public override func readLength(inputStream: InputStream): Int64 {
        try {
            dataArr[0] = 0
            inputStream.read(dataArr)
            var firstByte: Byte = dataArr[0]
            if (firstByte <= 0x7f) {
                return Int64(firstByte)
            }
            let nrBytes: Int64 = Int64(firstByte) & 0x7f
            var longLength: Int64 = 0
            for (_ in 0..nrBytes) {
                longLength = longLength << 8
                inputStream.read(dataArr)
                firstByte = dataArr[0]
                longLength += Int64(firstByte)
            }
            if (longLength == 0) {
                throw ASN1ParseException("The indefinite length form is not (yet) supported!")
            }
            return longLength
        } catch (ioe: IOException) {
            let list: Array<ToString> = [ioe.toString()]
            throw ASN1ParseException("Unable to read the length of the ASN.1 object.", list)
        }
    }

    public override func readValue(length: Int64, inputStream: InputStream): Array<Byte> {
        if (length <= 0) {
            return Array<Byte>()
        }
        try {
            let value: Array<Byte> = Array<Byte>(length, repeat: 0)
            inputStream.read(value)
            return value
        } catch (ioe: IOException) {
            let list: Array<ToString> = [ioe.toString()]
            throw ASN1ParseException("Unable to read the value of the ASN.1 object", list)
        }
    }
}
