package spire_web_http.unittests.boundary

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import spire_web_http.unittests.*
import std.collection.*

/**
 * QueryString边界值测试
 * 测试QueryString的边界情况
 */
@Test
func QueryString边界值测试() {
    // 测试空字符串
    let emptyQuery = QueryString("")
    @Expect(emptyQuery.value, "")
    @Expect(emptyQuery.hasValue, false)
    @Expect(emptyQuery.toString(), "")
    
    // 测试单字符查询字符串
    let singleCharQuery = QueryString("a")
    @Expect(singleCharQuery.value, "a")
    @Expect(singleCharQuery.hasValue, true)
    
    // 测试长查询字符串
    let longQuery = QueryString("param1=value1&param2=value2&param3=value3&param4=value4&param5=value5")
    @Expect(longQuery.hasValue, true)
    @Expect(longQuery.value.size > 0)
}

/**
 * QueryString相等性边界测试
 * 测试相等性比较的边界情况
 */
@Test
func QueryString相等性边界测试() {
    let query1 = QueryString("name=test&age=25")
    let query2 = QueryString("name=test&age=25")
    let query3 = QueryString("name=test&age=30")
    let query4 = QueryString("Name=Test&Age=25")  // 大小写敏感
    let query5 = QueryString("")
    
    // 测试完全相同的查询字符串
    @Expect(query1 == query2, true)
    
    // 测试相似但不同的查询字符串
    @Expect(query1 == query3, false)
    @Expect(query1 == query4, false)
    @Expect(query1 == query5, false)
    
    // 测试与字符串的比较
    @Expect(query1 == "name=test&age=25", true)
    @Expect(query1 == "name=test&age=30", false)
    @Expect(query1 == "Name=Test&Age=25", false)
    @Expect(query5 == "", true)
    @Expect(query5 == "name=test&age=25", false)
}

/**
 * QueryString编码字符测试
 * 测试包含URL编码字符的查询字符串
 */
@Test
func QueryString编码字符测试() {
    // 测试包含URL编码字符的查询字符串
    let encodedQueries = ArrayList<QueryString>()
    encodedQueries.add(QueryString("name=John%20Doe"))
    encodedQueries.add(QueryString("email=john%40example.com"))
    encodedQueries.add(QueryString("search=Hello%20World%21"))
    encodedQueries.add(QueryString("path=%2Fapi%2Fusers"))
    encodedQueries.add(QueryString("special=%21%40%23%24%25"))
    
    // 验证所有编码查询字符串都能正确创建
    @Expect(encodedQueries.size, 5)
    
    for (query in encodedQueries) {
        @Expect(query.hasValue, true)
        @Expect(query.value.size > 0)
    }
}

/**
 * QueryString内存测试
 * 测试QueryString的内存使用情况
 */
@Test
func QueryString内存测试() {
    // 创建多个QueryString实例
    let queries = ArrayList<QueryString>()
    let testStrings = TestHelper.createQueryStringData()
    
    for (str in testStrings) {
        queries.add(QueryString(str))
    }
    
    // 验证所有查询字符串都正确创建
    @Expect(queries.size, testStrings.size)
    
    // 验证每个查询字符串的值
    for (i in 0..queries.size) {
        @Expect(queries[i].value, testStrings[i])
        @Expect(queries[i].toString(), testStrings[i])
    }
}

/**
 * QueryString链式比较测试
 * 测试多个QueryString之间的链式比较
 */
@Test
func QueryString链式比较测试() {
    let query1 = QueryString("name=test&age=25")
    let query2 = QueryString("name=other&age=30")
    let query3 = QueryString("email=test@example.com")
    let query4 = QueryString("")
    
    // 测试链式比较
    @Expect(query1 != query2 && query2 != query3 && query3 != query4, true)
    
    // 测试空查询字符串比较
    @Expect(query4 != query1, true)
    @Expect(query4 != query2, true)
    @Expect(query4 != query3, true)
}

/**
 * QueryString特殊字符边界测试
 * 测试包含特殊字符的查询字符串的边界情况
 */
@Test
func QueryString特殊字符边界测试() {
    // 测试包含各种特殊字符的查询字符串
    let specialQueries = ArrayList<QueryString>()
    specialQueries.add(QueryString("name=test&age=25&active=true"))
    specialQueries.add(QueryString("search=hello world&sort=name&order=asc"))
    specialQueries.add(QueryString("filter[category]=books&filter[price][lt]=100"))
    specialQueries.add(QueryString("fields=id,name,description&include=author"))
    specialQueries.add(QueryString("q=Cangjie Language&limit=10&offset=0"))
    
    // 验证所有特殊查询字符串都能正确创建
    @Expect(specialQueries.size, 5)
    
    for (query in specialQueries) {
        @Expect(query.hasValue, true)
        @Expect(query.value.size > 0)
    }
}

/**
 * QueryStringUnicode边界测试
 * 测试包含Unicode字符的查询字符串的边界情况
 */
@Test
func QueryStringUnicode边界测试() {
    // 测试包含Unicode字符的查询字符串
    let unicodeQueries = ArrayList<QueryString>()
    unicodeQueries.add(QueryString("name=张三&age=25"))
    unicodeQueries.add(QueryString("city=北京&country=中国"))
    unicodeQueries.add(QueryString("product=café&type=naïve"))
    unicodeQueries.add(QueryString("search=Москва&region=Россия"))
    unicodeQueries.add(QueryString("title=Hello World&lang=en"))
    
    // 验证所有Unicode查询字符串都能正确创建
    @Expect(unicodeQueries.size, 5)
    
    for (query in unicodeQueries) {
        @Expect(query.hasValue, true)
        @Expect(query.value.size > 0)
    }
}