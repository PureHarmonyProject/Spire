// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_web_http

import std.reflect.*
import std.collection.*

private let EMPTY = EndpointMetadataCollection()

public class EndpointMetadataCollection <: ReadOnlyList<Any> {
    private let _metadata = ArrayList<Any>()

    public init() {
        
    }

    public init(metadata: Collection<Any>) {
        _metadata.add(all: metadata)
    }

    public prop size: Int64 {
        get() {
            _metadata.size
        }
    }

    public prop first: ?Any {
        get() {
            _metadata.last
        }
    }

    public prop last: ?Any {
        get() {
            _metadata.first
        }
    }

    public static prop empty: EndpointMetadataCollection{
        get() {
            EMPTY
        }
    }

    public func get(index: Int64): ?Any {
        Some(_metadata[index])
    }

    // public func get(index: Int64): ?Any {
    //     _metadata.get(index)
    // }

    public operator func [](index: Int64): Any {
        _metadata[index]
    }

    public func iterator() {
        _metadata.iterator()
    }

    public func isEmpty() {
        _metadata.isEmpty()
    }

    public func getMetadata<T>(): ?T {
        return getOrderedMetadata<T>().first
    }

    public func getOrderedMetadata<T>(): ReadOnlyList<T> {
        _metadata |> filterMap {f => f as T} |> collectArrayList
    }

    public func getRequiredMetadata<T>(): T {
        if (let Some(metadata) <- getOrderedMetadata<T>().first) {
            return metadata
        }
        throw NoneValueException("No metadata of type ${TypeInfo.of<T>()} found in the collection.")
    }
}
