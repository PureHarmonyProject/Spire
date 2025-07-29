/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public abstract class ASN1Parser {
    protected var decoder: ASN1Decoder

    public init(decoder: ASN1Decoder) {
        this.decoder = decoder
    }

    public func parse(asn1Tag: ASN1Tag, value: Array<Byte>): ASN1Object
}
