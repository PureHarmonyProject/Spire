// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_formats_asn1

import std.math.*

extend AsnWriter {
    public func popSetOf(tag!: ?Asn1Tag = None) {
        checkUniversalTag(tag, UniversalTagNumber.SetOf)
        popSetOfCore(tag?.asConstructed()?? Asn1Tag.SetOf)
    }

    private func pushSetOfCore(tag: Asn1Tag) {
        return pushTag(tag, UniversalTagNumber.SetOf)
    }

    private func popSetOfCore(tag: Asn1Tag) {
        let sortContents = if (ruleSet == AsnEncodingRules.CER || ruleSet == AsnEncodingRules.DER) {
            popTag()
        }
    }
}
