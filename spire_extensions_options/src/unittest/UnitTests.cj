package spire_extensions_options.unittest

import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import spire_extensions_options.*
import std.collection.concurrent.*
import spire_extensions_injection.*

class TestOptions {
    public var version = 0
}

@Test
func 基础测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
}

@Test
func 测试选项是否单列以及委托是否只执行一次() {
    let counter = ArrayList<Int64>()
    let services = ServiceCollection()
    services.configure<TestOptions>(
        {
            configureOptions =>
            configureOptions.version = 1
            counter.add(1)
        }
    )
    let provider = services.build()
    let options1 = provider.getOrThrow<IOptions<TestOptions>>()
    let options2 = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(refEq(options1.value, options2.value), true)
    @Expect(counter.size, 1)
}

@Test
func 测试选项是否单列以及委托是否只执行一次_并发() {
    let counter = ConcurrentLinkedQueue<Int64>()
    let services = ServiceCollection()
    services.configure<TestOptions> {
        configureOptions =>
        configureOptions.version = 1
        counter.add(1)
    }
    let provider = services.build()
    let tasks = ArrayList<Future<TestOptions>>()
    for (_ in 1..1001) {
        let options = provider.getOrThrow<IOptions<TestOptions>>()
        _ = options.value
    }
    for (pattern in tasks) {
        pattern.get()
    }
    @Expect(counter.size == 1, true)
}

@Test
func 测试命名选项和非命名选项是否干扰() {
    let services = ServiceCollection()

    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })
    services.configure<TestOptions>("tenant1", {
        configureOptions => configureOptions.version = 2
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    let tenant1 = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    @Expect(options.value.version, 1)
    @Expect(tenant1.get("tenant1").version, 2)
    //必须非同一引用
    @Expect(refEq(options.value, tenant1.get("tenant1")), false)
}

@Test
func 测试Configure和ConfigureAfter() {
    let services = ServiceCollection()

    services.configureAfter<TestOptions>({
        configureOptions => configureOptions.version = 2
    })

    services.configure<TestOptions>({
        configureOptions => configureOptions.version = 1
    })

    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
}

@Test
func 测试选项非命名验证_失败情况() {
    let services = ServiceCollection()

    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version > 2
        }
    let provider = services.build()
    try {
        let _ = provider.getOrThrow<IOptions<TestOptions>>()
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
}

@Test
func 测试选项非命名验证_成功情况() {
    let services = ServiceCollection()

    services
        .addOptions<TestOptions>()
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version == 2
        }
    let provider = services.build()
    try {
        let options = provider.getOrThrow<IOptions<TestOptions>>()
        @Expect(options.value.version, 2)
    } catch (ex: Exception) {
        @Expect(false)
    }
}


@Test
func 测试选项命名验证_失败情况() {
    let services = ServiceCollection()

    services.addOptions<TestOptions>("t1")
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version > 2
        }
    let provider = services.build()
    try {
        let _ = provider.getOrThrow<IOptionsMonitor<TestOptions>>().get("t1")
        let _ = provider.getOrThrow<IOptionsMonitor<TestOptions>>().get("t2")
    } catch (ex: OptionsValidationException) {
        @Expect(true)
    } catch (ex: Exception) {
        @Expect(false)
    }
}

@Test
func 测试命名选项验证_成功情况() {
    let services = ServiceCollection()
    services.addOptions<TestOptions>("t1")
        .configure {
            configureOptions => configureOptions.version = 1
        }
        .validate {
            options => return options.version == 1
        }
     services.addOptions<TestOptions>("t2")
        .configure {
            configureOptions => configureOptions.version = 2
        }
        .validate {
            options => return options.version == 2
        }        
    let provider = services.build()
    try {
        let options1 = provider.getOrThrow<IOptionsMonitor<TestOptions>>().get("t1")
        let options2 = provider.getOrThrow<IOptionsMonitor<TestOptions>>().get("t2")
        @Expect(options1.version, 1)
        @Expect(options2.version, 2)
    } catch (ex: Exception) {
        @Expect(false)
    }
}