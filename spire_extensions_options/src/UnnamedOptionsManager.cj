// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// This code has been modified and is maintained by the Soulsoft organization.
// The modifications to this file by Soulsoft are licensed under the MIT license.

package spire_extensions_options

import std.sync.*

public class UnnamedOptionsManager<TOptions> <: IOptions<TOptions> where TOptions <: Object {
    private var _options: ?TOptions = None
    private let _factory: IOptionsFactory<TOptions>
    private let _lock = AtomicOptionReference<Mutex>()

    public init(factory: IOptionsFactory<TOptions>) {
        _factory = factory
    }

    public prop value: TOptions {
        get() {
            if (let Some(options) <- _options) {
                return options
            }
            //延迟锁
            _lock.compareAndSwap(None, Mutex())
            synchronized(_lock.load().getOrThrow()) {
                _options = _options ?? _factory.create(Options.defaultName)
                return _options.getOrThrow()
            }
        }
    }
}
