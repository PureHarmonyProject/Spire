/*
 * @Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */
 
package asn1

public abstract class ASN1Serializer {
    protected var encoder: ASN1Encoder

    public init(encoder: ASN1Encoder) {
        this.encoder = encoder
    }

    public func serializedLength(asn1Object: ASN1Object): Int64

    public func serialize(asn1Object: ASN1Object, stream: ASN1OutputStream): Unit
}
