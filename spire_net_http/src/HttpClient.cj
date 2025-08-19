// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_net_http

import std.sync.*
import stdx.encoding.url.*

public class HttpClient <: HttpMessageInvoker {
    private var _baseAddress: ?URL = None
    private let _operationStarted = AtomicBool(false)
    private var _defaultRequestHeaders: ?HttpRequestHeaders = None

    public init() {
        this(HttpClientHandler())
    }

    public init(handler: HttpMessageHandler) {
        super(handler)
    }

    public mut prop baseAddress: ?URL {
        get() {
            _baseAddress
        }
        set(value){
            checkClosedOrStarted()
            _baseAddress = value
        }
    }

    public prop defaultRequestHeaders: HttpRequestHeaders {
        get() {
            if (let Some(defaultRequestHeaders) <- _defaultRequestHeaders) {
                defaultRequestHeaders
            } else {
                _defaultRequestHeaders = HttpRequestHeaders()
                return _defaultRequestHeaders.getOrThrow()
            }
        }
    }

    public func get(requestUri: String) {
        return get(URL.parse(requestUri))
    }

    public func get(requestUri: URL) {
        let request = HttpRequestMessage(HttpMethod.get, requestUri)
        return send(request)
    }

    public func getString(requestUri: String) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsString()
    }

    public func getString(requestUri: URL) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsString()
    }

    public func getByteArray(requestUri: String) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsByteArray()
    }

    public func getByteArray(requestUri: URL) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsByteArray()
    }

    public func getStream(requestUri: String) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsStream()
    }

    public func getStream(requestUri: URL) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsStream()
    }

    public func post(requestUri: String, content: ?HttpContent) {
        return post(URL.parse(requestUri), content)
    }

    public func post(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.post, requestUri)
        request.content = content
        return send(request)
    }

    public func put(requestUri: String, content: ?HttpContent) {
        return put(URL.parse(requestUri), content)
    }

    public func put(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.put, requestUri)
        request.content = content
        return send(request)
    }

    public func delete(requestUri: String, content: ?HttpContent) {
        return delete(URL.parse(requestUri), content)
    }

    public func delete(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.delete, requestUri)
        request.content = content
        return send(request)
    }

    public func send(request: HttpRequestMessage): HttpResponseMessage {
        checkClosed()
        setOperationStarted()
        prepareRequestMessage(request)
        return super.send(request)
    }

    private func prepareRequestMessage(request: HttpRequestMessage) {
        if (baseAddress.isNone() && request.requestUri.isNone()) {
            throw IllegalArgumentException(StringResx.net_http_client_invalid_requesturi)
        }

        if (let Some(requestUri) <- request.requestUri) {
            if (!requestUri.isAbsoluteURL()) {
                if (let Some(baseAddress) <- baseAddress) {
                    request.requestUri = URL.parse(URL.mergePaths(baseAddress.toString(), requestUri.toString()))
                } else {
                    throw IllegalArgumentException(StringResx.net_http_client_invalid_requesturi)
                }
            }
        } else {
            request.requestUri = baseAddress
        }

        if (let Some(defaultRequestHeaders) <- _defaultRequestHeaders) {
            for ((name, values) in defaultRequestHeaders) {
                for (value in values) {
                    request.headers.set(name, value)
                }
            }
        }
    }

    private func setOperationStarted() {
        _operationStarted.compareAndSwap(false, true)
    }

    private func checkClosedOrStarted() {
        checkClosed()
        if (_operationStarted.load()) {
            throw UnsupportedException(StringResx.net_http_operation_started)
        }
    }
}
