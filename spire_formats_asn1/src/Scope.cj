// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_formats_asn1

public class Scope <: Resource {
    private let _depth: ?Int64
    private let _writer: AsnWriter
    private var _isClosed = false
    private let _frame: ?StackFrame

    internal init(writer: AsnWriter) {
        _writer = writer
        _frame = _writer._nestingStack.flatMap {f => f.peek()}
        _depth = _writer._nestingStack.flatMap {f => f.size}
    }

    public func isClosed() {
        _isClosed
    }

    public func close(): Unit {
        if (isClosed()) {
            return
        }

        if (_writer._nestingStack.flatMap {f => f.size} == 0) {
            return
        }

        if (let (Some(a), Some(b)) <- (_writer._nestingStack.flatMap{f =>f.peek()}, _frame) && a == b) {
            match (_frame.flatMap{f => f.itemType}) {
                case Some(UniversalTagNumber.SetOf) => 
                    _writer.popSetOf(_frame.tag)
            }
        }

        _isClosed = true
    }
}
