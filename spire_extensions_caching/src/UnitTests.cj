package spire_extensions_caching

import std.time.*
import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

import spire_extensions_options.*

@Test
func 测试过期时间_滑动() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    //5s失效
    cache.setString("k1", "test", DistributedCacheEntryOptions(slidingExpiration: Duration.second * 5))
    //2s后发起访问
    sleep(Duration.second * 2)
    //重置计时器
    let value1 = cache.getString("k1")
    @Expect(value1.isSome(), true)
    sleep(Duration.second * 3)
    //3s之后在次读取
    let value2 = cache.getString("k1")
    @Expect(value2.isSome(), true)
}

@Test
func 测试过期时间_绝对时间() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    //5s失效
    cache.setString("k1", "test", DistributedCacheEntryOptions(absoluteExpiration: DateTime.now().addSeconds(5)))
    //2s后发起访问
    sleep(Duration.second * 2)
    let value1 = cache.getString("k1")
    @Expect(value1 == "test", true)
    sleep(Duration.second * 4)
    //4s之后在次读取
    let value2 = cache.getString("k1")
    @Expect(value2 == "test", false)
}

@Test
func 测试过期时间_相对时间() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions()))
    //5s失效
    cache.setString("k1", "test", DistributedCacheEntryOptions(absoluteExpirationRelativeToNow: Duration.second * 5))
    //2s后发起访问
    sleep(Duration.second * 2)
    let value1 = cache.getString("k1")
    @Expect(value1 == "test", true)
    sleep(Duration.second * 4)
    //4s之后在次读取
    let value2 = cache.getString("k1")
    @Expect(value2.isSome(), false)
}

@Test
func 测试过期自动销毁() {
    let cache = MemoryDistributedCache(Options.create(DistributedCacheOptions(Duration.second * 1)))
    //5s失效
    cache.setString("k1", "test1", DistributedCacheEntryOptions(absoluteExpirationRelativeToNow: Duration.second * 5))
    cache.setString("k2", "test2", DistributedCacheEntryOptions(absoluteExpirationRelativeToNow: Duration.second * 7))
    cache.setString("k3", "test3", DistributedCacheEntryOptions(absoluteExpirationRelativeToNow: Duration.second * 10))
    @Expect(cache.getEntryCount() == 3, true)
    
    sleep(Duration.second * 6)
    //触发销毁线程
    cache.getString("k3")
    /*================6s后====================*/
    //等待销毁线程执行完毕
    sleep(Duration.second * 1) 
    @Expect(cache.getEntryCount() == 2, true)
    //在次触发销毁
    cache.getString("k3") 

    /*================7s后====================*/
    //等待销毁线程执行完毕
    sleep(Duration.second * 1) 
    @Expect(cache.getEntryCount() == 1, true)
    
    /*================10s后====================*/
    sleep(Duration.second * 2) 
    //在次触发销毁
    cache.getString("k3") 
    sleep(Duration.second * 1) 
    @Expect(cache.getEntryCount() == 0, true)
}