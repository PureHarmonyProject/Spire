package spire_web_http.unittests.basic

import std.unittest.*
import std.unittest.testmacro.*
import spire_web_http.*
import spire_web_http.unittests.*
import std.collection.*

/**
 * QueryString构造函数测试
 * 测试QueryString的构造函数和基本属性
 */
@Test
func QueryString构造函数测试() {
    // 测试非空查询字符串
    let query1 = QueryString("name=test&age=25")
    @Expect(query1.value, "name=test&age=25")
    @Expect(query1.hasValue, true)
    
    // 测试空查询字符串
    let query2 = QueryString("")
    @Expect(query2.value, "")
    @Expect(query2.hasValue, false)
    
    // 测试单参数查询字符串
    let query3 = QueryString("id=123")
    @Expect(query3.value, "id=123")
    @Expect(query3.hasValue, true)
    
    // 测试复杂查询字符串
    let query4 = QueryString("search=keyword&page=1&limit=10&sort=name&order=asc")
    @Expect(query4.value, "search=keyword&page=1&limit=10&sort=name&order=asc")
    @Expect(query4.hasValue, true)
}

/**
 * QueryString相等性测试
 * 测试QueryString的相等性比较
 */
@Test
func QueryString相等性测试() {
    let query1 = QueryString("name=test&age=25")
    let query2 = QueryString("name=test&age=25")
    let query3 = QueryString("name=test&age=30")
    let query4 = QueryString("")
    
    // 测试相等性
    @Expect(query1 == query2, true)
    @Expect(query1 == query3, false)
    @Expect(query1 == query4, false)
    
    // 测试与字符串的相等性
    @Expect(query1 == "name=test&age=25", true)
    @Expect(query1 == "name=test&age=30", false)
    @Expect(query1 == "", false)
    
    // 测试空查询字符串的相等性
    @Expect(query4 == "", true)
    @Expect(query4 == "name=test&age=25", false)
}

/**
 * QueryString hasValue属性测试
 * 测试hasValue属性的各种情况
 */
@Test
func QueryStringHasValue属性测试() {
    // 测试有值的情况
    @Expect(QueryString("name=test").hasValue, true)
    @Expect(QueryString("id=123").hasValue, true)
    @Expect(QueryString("page=1&limit=10").hasValue, true)
    @Expect(QueryString("non-empty").hasValue, true)
    @Expect(QueryString("?").hasValue, true)
    @Expect(QueryString("=").hasValue, true)
    
    // 测试无值的情况
    @Expect(QueryString("").hasValue, false)
    
    // 测试只有空格的情况
    @Expect(QueryString("   ").hasValue, true)
    @Expect(QueryString("  ").hasValue, true)
    @Expect(QueryString(" ").hasValue, true)
}

/**
 * QueryString toString方法测试
 * 测试toString方法的输出
 */
@Test
func QueryStringToString方法测试() {
    let query1 = QueryString("name=test&age=25")
    let query2 = QueryString("")
    let query3 = QueryString("id=123")
    
    @Expect(query1.toString(), "name=test&age=25")
    @Expect(query2.toString(), "")
    @Expect(query3.toString(), "id=123")
}

/**
 * QueryString特殊字符测试
 * 测试包含特殊字符的查询字符串
 */
@Test
func QueryString特殊字符测试() {
    let specialQueries = [
        "name=test+user",
        "search=hello%20world",
        "filter=active&sort=name%20desc",
        "query=test%3Fvalue",
        "path=/api/users%2F123",
        "email=test%40example.com",
        "price=100%24",
        "unicode=%E4%B8%AD%E6%96%87"
    ]
    
    for (queryStr in specialQueries) {
        let query = QueryString(queryStr)
        @Expect(query.value, queryStr)
        @Expect(query.hasValue, true)
        @Expect(query.toString(), queryStr)
    }
}

/**
 * QueryString Unicode字符测试
 * 测试包含Unicode字符的查询字符串
 */
@Test
func QueryStringUnicode字符测试() {
    let unicodeQueries = [
        "name=测试用户",
        "search=关键词",
        "query=日本語",
        "filter=한글",
        "param=русский",
        "value=العربية",
        "text=café",
        "term=naïve"
    ]
    
    for (queryStr in unicodeQueries) {
        let query = QueryString(queryStr)
        @Expect(query.value, queryStr)
        @Expect(query.hasValue, true)
        @Expect(query.toString(), queryStr)
    }
}


/**
 * QueryString测试数据验证测试
 * 使用TestHelper中的测试数据进行验证
 */
@Test
func QueryString测试数据验证测试() {
    let testData = TestHelper.createQueryStringData()
    
    for (queryStr in testData) {
        let query = QueryString(queryStr)
        
        if (queryStr.isEmpty()) {
            @Expect(query.hasValue, false)
        } else {
            @Expect(query.hasValue, true)
        }
        
        @Expect(query.value, queryStr)
        @Expect(query.toString(), queryStr)
        @Expect(query == queryStr, true)
    }
}

/**
 * QueryString常见格式测试
 * 测试常见的查询字符串格式
 */
@Test
func QueryString常见格式测试() {
    let commonQueries = [
        // 基本格式
        "name=test",
        "id=123",
        "page=1",
        
        // 多参数格式
        "name=test&age=25",
        "page=1&limit=10",
        "sort=name&order=asc",
        
        // 复杂格式
        "search=keyword&page=1&limit=10&sort=name&order=asc",
        "filter=active&category=books&price_min=10&price_max=100",
        
        // 特殊格式
        "?name=test",
        "name=test&",
        "&name=test",
        "name=test&&age=25",
        
        // 空值和空白值
        "empty=",
        "blank=+",
        "name=&age=25",
        "param1=value1&param2=&param3=value3"
    ]
    
    for (queryStr in commonQueries) {
        let query = QueryString(queryStr)
        @Expect(query.value, queryStr)
        @Expect(query.toString(), queryStr)
        @Expect(query == queryStr, true)
        
        if (queryStr.isEmpty()) {
            @Expect(query.hasValue, false)
        } else {
            @Expect(query.hasValue, true)
        }
    }
}


/**
 * QueryString编码字符测试
 * 测试包含URL编码字符的查询字符串
 */
@Test
func QueryString编码字符测试() {
    let encodedQueries = [
        "name=John%20Doe",
        "search=hello%20world%21",
        "path=%2Fapi%2Fusers",
        "email=test%40example.com",
        "price=100%24",
        "unicode=%E4%B8%AD%E6%96%87",
        "special=test%3F%26%3D",
        "space=test%20value%20here"
    ]
    
    for (queryStr in encodedQueries) {
        let query = QueryString(queryStr)
        @Expect(query.value, queryStr)
        @Expect(query.hasValue, true)
        @Expect(query.toString(), queryStr)
        @Expect(query == queryStr, true)
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
    let query2 = QueryString("name=test&age=25")
    let query3 = QueryString("name=test&age=30")
    let query4 = QueryString("id=123&action=delete")
    
    // 测试链式相等性
    @Expect(query1 == query2, true)
    @Expect(query1 == query3, false)
    @Expect(query1 == query4, false)
    @Expect(query3 == query4, false)
    
    // 测试与字符串的链式比较
    @Expect(query1 == "name=test&age=25", true)
    @Expect(query3 == "name=test&age=30", true)
    @Expect(query4 == "id=123&action=delete", true)
    @Expect(query1 == "name=test&age=30", false)
}

/**
 * QueryString实际应用测试
 * 测试实际应用中常见的查询字符串场景
 */
@Test
func QueryString实际应用测试() {
    let realWorldQueries = [
        // 搜索和分页
        "q=web+development&page=2&results=10",
        "search=rest+api&sort=relevance&filter=articles",
        
        // API过滤和排序
        "status=active&sort=created_at&order=desc",
        "category=electronics&price_min=100&price_max=1000",
        
        // 用户设置
        "theme=dark&language=zh-CN&timezone=Asia%2FShanghai",
        "notifications=email&newsletter=true",
        
        // 调试和开发
        "debug=true&verbose=1&log_level=debug",
        "test_mode=true&mock_data=true"
    ]
    
    for (queryStr in realWorldQueries) {
        let query = QueryString(queryStr)
        @Expect(query.value, queryStr)
        @Expect(query.hasValue, true)
        @Expect(query.toString(), queryStr)
        @Expect(query == queryStr, true)
    }
}