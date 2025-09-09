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

    public init(handler: HttpMessageHandler, closeHandler: Bool) {
        super(handler, closeHandler)
    }

    public mut prop baseAddress: ?URL {
        get() {
            _baseAddress
        }
        set(value) {
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
        let resolvedUri = resolveRequestUri(requestUri)
        return get(resolvedUri)
    }

    public func get(requestUri: URL) {
        let request = HttpRequestMessage(HttpMethod.Get, requestUri)
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
        let resolvedUri = resolveRequestUri(requestUri)
        return post(resolvedUri, content)
    }

    public func post(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.Post, requestUri)
        request.content = content
        return send(request)
    }

    public func put(requestUri: String, content: ?HttpContent) {
        let resolvedUri = resolveRequestUri(requestUri)
        return put(resolvedUri, content)
    }

    public func put(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.Put, requestUri)
        request.content = content
        return send(request)
    }

    public func delete(requestUri: String, content: ?HttpContent) {
        let resolvedUri = resolveRequestUri(requestUri)
        return delete(resolvedUri, content)
    }

    public func delete(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.Delete, requestUri)
        request.content = content
        return send(request)
    }

    public func send(request: HttpRequestMessage): HttpResponseMessage {
        checkClosed()
        setOperationStarted()
        prepareRequestMessage(request)
        return super.send(request)
    }

    // 解析相对URI请求，与 baseAddress 合并返回绝对URI
    private func resolveRequestUri(requestUri: String): URL {
        let parsedUri = URL.parse(requestUri)
        if (!parsedUri.isAbsoluteURL()) {
            if (let Some(baseAddress) <- baseAddress) {
                let baseStr = baseAddress.toString()
                let mergedPath = if (requestUri.startsWith("/")) {
                    baseStr + requestUri
                } else {
                    baseStr + "/" + requestUri
                }
                let resolvedUri = URL.parse(mergedPath)
                return resolvedUri
            } else {
                throw IllegalArgumentException(StringResx.net_http_client_invalid_requesturi)
            }
        }
        return parsedUri
    }

    private func prepareRequestMessage(request: HttpRequestMessage) {
        if (baseAddress.isNone() && request.requestUri.isNone()) {
            throw IllegalArgumentException(StringResx.net_http_client_invalid_requesturi)
        }

        if (let Some(requestUri) <- request.requestUri) {
            // 如果 URI 是相对路径，调用封装好的方法解析
            if (!requestUri.isAbsoluteURL()) {
                request.requestUri = resolveRequestUri(requestUri.toString())
            }
        } else {
            // 如果 requestUri 为空，使用 baseAddress
            request.requestUri = baseAddress
        }

        // 设置默认请求头
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
